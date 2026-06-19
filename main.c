#include "stm8s.h"
#include "stm8s_gpio.h"
#include "stm8s_spi.h"
#include "stm8s_clk.h"
#include "wizchip_conf.h"
#include "socket.h"

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

#define W5500_CS_PORT  GPIOA
#define W5500_CS_PIN   GPIO_PIN_3

#define W5500_RST_PORT GPIOE
#define W5500_RST_PIN  GPIO_PIN_5

uint8_t txsize[8]={2,0,0,0,0,0,0,0};
uint8_t rxsize[8]={2,0,0,0,0,0,0,0};

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

////////////////////////////////////////////////////
void main(void)
{
    uint16_t len;

    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);

    SPI_Config();

    W5500_Reset();

    W5500_Init();

    while(1)
    {
        switch(getSn_SR(SOCK_TCPS))
        {
        case SOCK_CLOSED:

            socket(SOCK_TCPS,
                   Sn_MR_TCP,
                   TCP_PORT,
                   0);

            break;

        case SOCK_INIT:

            listen(SOCK_TCPS);

            break;

        case SOCK_ESTABLISHED:

            if(getSn_IR(SOCK_TCPS)&Sn_IR_CON)
            {
                setSn_IR(SOCK_TCPS,Sn_IR_CON);
            }

            len=getSn_RX_RSR(SOCK_TCPS);

            if(len>0)
            {
                if(len>sizeof(rxbuf))
                    len=sizeof(rxbuf);

                recv(SOCK_TCPS,rxbuf,len);

                if(rxbuf[0]=='h' &&
                   rxbuf[1]=='e' &&
                   rxbuf[2]=='l' &&
                   rxbuf[3]=='l' &&
                   rxbuf[4]=='o')
                {
                    send(SOCK_TCPS,
                         (uint8_t*)"HELLO RECEIVED\r\n",
                         16);
                }
            }

            break;

        case SOCK_CLOSE_WAIT:

            disconnect(SOCK_TCPS);

            break;
        }
    }
}