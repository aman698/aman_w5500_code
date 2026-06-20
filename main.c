#include "stm8s.h"
#include "stm8s_gpio.h"
#include "stm8s_spi.h"
#include "stm8s_clk.h"
#include "wizchip_conf.h"
#include "socket.h"
#include <string.h>   // ADD THIS
/* Hardware Reset Input */
#define HARDRST_PORT    GPIOB
#define HARDRST_PIN     GPIO_PIN_7

/* W5500 SPI Pins */
#define W5500_SCK_PORT  GPIOC
#define W5500_SCK_PIN   GPIO_PIN_5

#define W5500_MOSI_PORT GPIOC
#define W5500_MOSI_PIN  GPIO_PIN_6

#define W5500_MISO_PORT GPIOC
#define W5500_MISO_PIN  GPIO_PIN_7

/* W5500 Chip Select */
#define W5500_CS_PORT   GPIOA
#define W5500_CS_PIN    GPIO_PIN_3

/* W5500 Reset */
#define W5500_RST_PORT  GPIOE
#define W5500_RST_PIN   GPIO_PIN_5

/* W5500 Interrupt */
#define W5500_INT_PORT  GPIOF
#define W5500_INT_PIN   GPIO_PIN_4

#define SOCK_TCPS      0
#define TCP_PORT       5000


uint8_t txsize[8]={8,8,0,0,0,0,0,0};
uint8_t rxsize[8]={8,8,0,0,0,0,0,0};
uint8_t changed = 0;
uint8_t rxbuf[32];

wiz_NetInfo netinfo=
{
    {0x00,0x08,0xDC,0x11,0x22,0x33}, //MAC
    {192,168,100,111},               //IP
    {255,255,255,0},                 //MASK
    {192,168,100,1},                 //GW
    {8,8,8,8},                       //DNS
    NETINFO_STATIC
};

void delay_ms(uint16_t ms)
{
    uint16_t i,j;

    for(i=0;i<ms;i++)
    {
        for(j=0;j<500;j++);
    }
}

////////////////////////////////////////////////////
void wizchip_select(void)
{
    GPIO_WriteLow(W5500_CS_PORT,W5500_CS_PIN);
}

void wizchip_deselect(void)
{
    GPIO_WriteHigh(W5500_CS_PORT,W5500_CS_PIN);
}

////////////////////////////////////////////////////
void spi_writebyte(uint8_t wb)
{
    SPI_SendData(wb);

    while(SPI_GetFlagStatus(SPI_FLAG_TXE)==RESET);

    while(SPI_GetFlagStatus(SPI_FLAG_RXNE)==RESET);

    SPI_ReceiveData();
}

uint8_t spi_readbyte(void)
{
    SPI_SendData(0xFF);

    while(SPI_GetFlagStatus(SPI_FLAG_RXNE)==RESET);

    return SPI_ReceiveData();
}

////////////////////////////////////////////////////
void SPI_Config(void)
{
    GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(GPIOC,GPIO_PIN_6,GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(GPIOC,GPIO_PIN_7,GPIO_MODE_IN_FL_NO_IT);

    GPIO_Init(W5500_CS_PORT,W5500_CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);

    SPI_DeInit();

    SPI_Init(
        SPI_FIRSTBIT_MSB,
        SPI_BAUDRATEPRESCALER_4,
        SPI_MODE_MASTER,
        SPI_CLOCKPOLARITY_LOW,
        SPI_CLOCKPHASE_1EDGE,
        SPI_DATADIRECTION_2LINES_FULLDUPLEX,
        SPI_NSS_SOFT,
        0x07);

    SPI_Cmd(ENABLE);
}

////////////////////////////////////////////////////
void W5500_Reset(void)
{
    GPIO_Init(W5500_RST_PORT,
              W5500_RST_PIN,
              GPIO_MODE_OUT_PP_HIGH_FAST);

    GPIO_WriteLow(W5500_RST_PORT,W5500_RST_PIN);

    delay_ms(50);

    GPIO_WriteHigh(W5500_RST_PORT,W5500_RST_PIN);

    delay_ms(200);
}

////////////////////////////////////////////////////
void W5500_Init(void)
{
    reg_wizchip_cs_cbfunc(wizchip_select,wizchip_deselect);

    reg_wizchip_spi_cbfunc(spi_readbyte,
                           spi_writebyte);

    wizchip_init(txsize,rxsize);

    wizchip_setnetinfo(&netinfo);
}
void GPIO_Config(void)
{
        /* Relay Outputs */
    GPIO_Init(GPIOB, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // R1
    GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // R2
    GPIO_Init(GPIOB, GPIO_PIN_1, GPIO_MODE_OUT_PP_LOW_FAST); // R3
    GPIO_Init(GPIOB, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST); // R4
    GPIO_Init(GPIOC, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // R5
    GPIO_Init(GPIOC, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST); // R6

    /* Inputs with pullups */
    GPIO_Init(GPIOD, GPIO_PIN_2, GPIO_MODE_IN_PU_NO_IT); // DI1
    GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_IN_PU_NO_IT); // DI2
    GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_IN_PU_NO_IT); // DI3
    GPIO_Init(GPIOD, GPIO_PIN_7, GPIO_MODE_IN_PU_NO_IT); // DI4
}
void main(void)
{
    uint16_t len;
    uint8_t txbuf[6];

    uint8_t curr_state[4];
    uint8_t prev_state[4] = {'0','0','0','0'};
    uint8_t changed;

    uint16_t send_timer = 0;

    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);

    SPI_Config();
    GPIO_Config();

    W5500_Reset();
    W5500_Init();

    while(1)
    {
        switch(getSn_SR(SOCK_TCPS))
        {
        case SOCK_CLOSED:
            close(SOCK_TCPS);
            socket(SOCK_TCPS, Sn_MR_TCP, TCP_PORT, 0);
            delay_ms(100);
            break;

        case SOCK_INIT:
            listen(SOCK_TCPS);
            break;

        case SOCK_ESTABLISHED:

            /* ✅ Connection event */
            if(getSn_IR(SOCK_TCPS) & Sn_IR_CON)
            {
                setSn_IR(SOCK_TCPS, Sn_IR_CON);

                prev_state[0]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_2)==RESET)?'1':'0';
                prev_state[1]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_3)==RESET)?'1':'0';
                prev_state[2]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_4)==RESET)?'1':'0';
                prev_state[3]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_7)==RESET)?'1':'0';

                txbuf[0]=prev_state[0];
                txbuf[1]=prev_state[1];
                txbuf[2]=prev_state[2];
                txbuf[3]=prev_state[3];
                txbuf[4]='\r';
                txbuf[5]='\n';

                if(getSn_TX_FSR(SOCK_TCPS) >= 12)
                    send(SOCK_TCPS, txbuf, 6);
            }

            /* ✅ RECEIVE COMMAND */
            len = getSn_RX_RSR(SOCK_TCPS);

            if(len >= 4)
            {
                if(len > sizeof(rxbuf)-1)
                    len = sizeof(rxbuf)-1;

                recv(SOCK_TCPS, rxbuf, len);

                if(rxbuf[0]=='R' && rxbuf[2]==',')
                {
                    switch(rxbuf[1])
                    {
                        case '1':
                            if(rxbuf[3]=='1') GPIO_WriteHigh(GPIOB,GPIO_PIN_3);
                            else GPIO_WriteLow(GPIOB,GPIO_PIN_3);
                            break;

                        case '2':
                            if(rxbuf[3]=='1') GPIO_WriteHigh(GPIOB,GPIO_PIN_2);
                            else GPIO_WriteLow(GPIOB,GPIO_PIN_2);
                            break;

                        case '3':
                            if(rxbuf[3]=='1') GPIO_WriteHigh(GPIOB,GPIO_PIN_1);
                            else GPIO_WriteLow(GPIOB,GPIO_PIN_1);
                            break;

                        case '4':
                            if(rxbuf[3]=='1') GPIO_WriteHigh(GPIOB,GPIO_PIN_0);
                            else GPIO_WriteLow(GPIOB,GPIO_PIN_0);
                            break;

                        case '5':
                            if(rxbuf[3]=='1') GPIO_WriteHigh(GPIOC,GPIO_PIN_3);
                            else GPIO_WriteLow(GPIOC,GPIO_PIN_3);
                            break;

                        case '6':
                            if(rxbuf[3]=='1') GPIO_WriteHigh(GPIOC,GPIO_PIN_4);
                            else GPIO_WriteLow(GPIOC,GPIO_PIN_4);
                            break;
                    }
                }
            }

            /* ✅ READ INPUT */
            curr_state[0]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_2)==RESET)?'1':'0';
            curr_state[1]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_3)==RESET)?'1':'0';
            curr_state[2]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_4)==RESET)?'1':'0';
            curr_state[3]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_7)==RESET)?'1':'0';

            changed =
                (curr_state[0]!=prev_state[0]) ||
                (curr_state[1]!=prev_state[1]) ||
                (curr_state[2]!=prev_state[2]) ||
                (curr_state[3]!=prev_state[3]);

            /* ✅ TIMER FOR 300ms STREAM */
            send_timer++;

            if(send_timer >= 30)   // ~300ms (10ms loop delay below)
            {
                send_timer = 0;

                txbuf[0]=curr_state[0];
                txbuf[1]=curr_state[1];
                txbuf[2]=curr_state[2];
                txbuf[3]=curr_state[3];
                txbuf[4]='\r';
                txbuf[5]='\n';

                if(getSn_TX_FSR(SOCK_TCPS) >= 12)
                {
                    if(send(SOCK_TCPS, txbuf, 6) <= 0)
                    {
                        disconnect(SOCK_TCPS);
                        break;
                    }
                }
            }

            /* ✅ TRIGGER (instant send) */
            if(changed)
            {
                txbuf[0]=curr_state[0];
                txbuf[1]=curr_state[1];
                txbuf[2]=curr_state[2];
                txbuf[3]=curr_state[3];
                txbuf[4]='\r';
                txbuf[5]='\n';

                if(getSn_TX_FSR(SOCK_TCPS) >= 12)
                {
                    send(SOCK_TCPS, txbuf, 6);
                }

                prev_state[0]=curr_state[0];
                prev_state[1]=curr_state[1];
                prev_state[2]=curr_state[2];
                prev_state[3]=curr_state[3];
            }

            delay_ms(10);   // ✅ keeps loop stable

            break;

        case SOCK_CLOSE_WAIT:
            disconnect(SOCK_TCPS);
            break;

        case SOCK_FIN_WAIT:
        case SOCK_CLOSING:
        case SOCK_TIME_WAIT:
        case SOCK_LAST_ACK:
            close(SOCK_TCPS);
            break;

        default:
            break;
        }
    }
}