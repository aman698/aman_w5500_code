   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               _txsize:
  16  0000 08            	dc.b	8
  17  0001 08            	dc.b	8
  18  0002 00            	dc.b	0
  19  0003 00            	dc.b	0
  20  0004 00            	dc.b	0
  21  0005 00            	dc.b	0
  22  0006 00            	dc.b	0
  23  0007 00            	dc.b	0
  24  0008               _rxsize:
  25  0008 08            	dc.b	8
  26  0009 08            	dc.b	8
  27  000a 00            	dc.b	0
  28  000b 00            	dc.b	0
  29  000c 00            	dc.b	0
  30  000d 00            	dc.b	0
  31  000e 00            	dc.b	0
  32  000f 00            	dc.b	0
  33  0010               _changed:
  34  0010 00            	dc.b	0
  35  0011               _netinfo:
  36  0011 00            	dc.b	0
  37  0012 08            	dc.b	8
  38  0013 dc            	dc.b	220
  39  0014 11            	dc.b	17
  40  0015 22            	dc.b	34
  41  0016 33            	dc.b	51
  42  0017 c0            	dc.b	192
  43  0018 a8            	dc.b	168
  44  0019 64            	dc.b	100
  45  001a 6f            	dc.b	111
  46  001b ff            	dc.b	255
  47  001c ff            	dc.b	255
  48  001d ff            	dc.b	255
  49  001e 00            	dc.b	0
  50  001f c0            	dc.b	192
  51  0020 a8            	dc.b	168
  52  0021 64            	dc.b	100
  53  0022 01            	dc.b	1
  54  0023 08            	dc.b	8
  55  0024 08            	dc.b	8
  56  0025 08            	dc.b	8
  57  0026 08            	dc.b	8
  58  0027 01            	dc.b	1
 116                     ; 53 void delay_ms(uint16_t ms)
 116                     ; 54 {
 118                     	switch	.text
 119  0000               _delay_ms:
 121  0000 89            	pushw	x
 122  0001 5204          	subw	sp,#4
 123       00000004      OFST:	set	4
 126                     ; 57     for(i=0;i<ms;i++)
 128  0003 5f            	clrw	x
 129  0004 1f01          	ldw	(OFST-3,sp),x
 132  0006 2018          	jra	L34
 133  0008               L73:
 134                     ; 59         for(j=0;j<500;j++);
 136  0008 5f            	clrw	x
 137  0009 1f03          	ldw	(OFST-1,sp),x
 139  000b               L74:
 143  000b 1e03          	ldw	x,(OFST-1,sp)
 144  000d 1c0001        	addw	x,#1
 145  0010 1f03          	ldw	(OFST-1,sp),x
 149  0012 1e03          	ldw	x,(OFST-1,sp)
 150  0014 a301f4        	cpw	x,#500
 151  0017 25f2          	jrult	L74
 152                     ; 57     for(i=0;i<ms;i++)
 154  0019 1e01          	ldw	x,(OFST-3,sp)
 155  001b 1c0001        	addw	x,#1
 156  001e 1f01          	ldw	(OFST-3,sp),x
 158  0020               L34:
 161  0020 1e01          	ldw	x,(OFST-3,sp)
 162  0022 1305          	cpw	x,(OFST+1,sp)
 163  0024 25e2          	jrult	L73
 164                     ; 61 }
 167  0026 5b06          	addw	sp,#6
 168  0028 81            	ret
 192                     ; 64 void wizchip_select(void)
 192                     ; 65 {
 193                     	switch	.text
 194  0029               _wizchip_select:
 198                     ; 66     GPIO_WriteLow(W5500_CS_PORT,W5500_CS_PIN);
 200  0029 4b08          	push	#8
 201  002b ae5000        	ldw	x,#20480
 202  002e cd0000        	call	_GPIO_WriteLow
 204  0031 84            	pop	a
 205                     ; 67 }
 208  0032 81            	ret
 232                     ; 69 void wizchip_deselect(void)
 232                     ; 70 {
 233                     	switch	.text
 234  0033               _wizchip_deselect:
 238                     ; 71     GPIO_WriteHigh(W5500_CS_PORT,W5500_CS_PIN);
 240  0033 4b08          	push	#8
 241  0035 ae5000        	ldw	x,#20480
 242  0038 cd0000        	call	_GPIO_WriteHigh
 244  003b 84            	pop	a
 245                     ; 72 }
 248  003c 81            	ret
 285                     ; 75 void spi_writebyte(uint8_t wb)
 285                     ; 76 {
 286                     	switch	.text
 287  003d               _spi_writebyte:
 291                     ; 77     SPI_SendData(wb);
 293  003d cd0000        	call	_SPI_SendData
 296  0040               L511:
 297                     ; 79     while(SPI_GetFlagStatus(SPI_FLAG_TXE)==RESET);
 299  0040 a602          	ld	a,#2
 300  0042 cd0000        	call	_SPI_GetFlagStatus
 302  0045 4d            	tnz	a
 303  0046 27f8          	jreq	L511
 305  0048               L321:
 306                     ; 81     while(SPI_GetFlagStatus(SPI_FLAG_RXNE)==RESET);
 308  0048 a601          	ld	a,#1
 309  004a cd0000        	call	_SPI_GetFlagStatus
 311  004d 4d            	tnz	a
 312  004e 27f8          	jreq	L321
 313                     ; 83     SPI_ReceiveData();
 315  0050 cd0000        	call	_SPI_ReceiveData
 317                     ; 84 }
 320  0053 81            	ret
 346                     ; 86 uint8_t spi_readbyte(void)
 346                     ; 87 {
 347                     	switch	.text
 348  0054               _spi_readbyte:
 352                     ; 88     SPI_SendData(0xFF);
 354  0054 a6ff          	ld	a,#255
 355  0056 cd0000        	call	_SPI_SendData
 358  0059               L141:
 359                     ; 90     while(SPI_GetFlagStatus(SPI_FLAG_RXNE)==RESET);
 361  0059 a601          	ld	a,#1
 362  005b cd0000        	call	_SPI_GetFlagStatus
 364  005e 4d            	tnz	a
 365  005f 27f8          	jreq	L141
 366                     ; 92     return SPI_ReceiveData();
 368  0061 cd0000        	call	_SPI_ReceiveData
 372  0064 81            	ret
 399                     ; 96 void SPI_Config(void)
 399                     ; 97 {
 400                     	switch	.text
 401  0065               _SPI_Config:
 405                     ; 98     GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_HIGH_FAST);
 407  0065 4bf0          	push	#240
 408  0067 4b20          	push	#32
 409  0069 ae500a        	ldw	x,#20490
 410  006c cd0000        	call	_GPIO_Init
 412  006f 85            	popw	x
 413                     ; 99     GPIO_Init(GPIOC,GPIO_PIN_6,GPIO_MODE_OUT_PP_HIGH_FAST);
 415  0070 4bf0          	push	#240
 416  0072 4b40          	push	#64
 417  0074 ae500a        	ldw	x,#20490
 418  0077 cd0000        	call	_GPIO_Init
 420  007a 85            	popw	x
 421                     ; 100     GPIO_Init(GPIOC,GPIO_PIN_7,GPIO_MODE_IN_FL_NO_IT);
 423  007b 4b00          	push	#0
 424  007d 4b80          	push	#128
 425  007f ae500a        	ldw	x,#20490
 426  0082 cd0000        	call	_GPIO_Init
 428  0085 85            	popw	x
 429                     ; 102     GPIO_Init(W5500_CS_PORT,W5500_CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
 431  0086 4bf0          	push	#240
 432  0088 4b08          	push	#8
 433  008a ae5000        	ldw	x,#20480
 434  008d cd0000        	call	_GPIO_Init
 436  0090 85            	popw	x
 437                     ; 104     SPI_DeInit();
 439  0091 cd0000        	call	_SPI_DeInit
 441                     ; 106     SPI_Init(
 441                     ; 107         SPI_FIRSTBIT_MSB,
 441                     ; 108         SPI_BAUDRATEPRESCALER_4,
 441                     ; 109         SPI_MODE_MASTER,
 441                     ; 110         SPI_CLOCKPOLARITY_LOW,
 441                     ; 111         SPI_CLOCKPHASE_1EDGE,
 441                     ; 112         SPI_DATADIRECTION_2LINES_FULLDUPLEX,
 441                     ; 113         SPI_NSS_SOFT,
 441                     ; 114         0x07);
 443  0094 4b07          	push	#7
 444  0096 4b02          	push	#2
 445  0098 4b00          	push	#0
 446  009a 4b00          	push	#0
 447  009c 4b00          	push	#0
 448  009e 4b04          	push	#4
 449  00a0 ae0008        	ldw	x,#8
 450  00a3 cd0000        	call	_SPI_Init
 452  00a6 5b06          	addw	sp,#6
 453                     ; 116     SPI_Cmd(ENABLE);
 455  00a8 a601          	ld	a,#1
 456  00aa cd0000        	call	_SPI_Cmd
 458                     ; 117 }
 461  00ad 81            	ret
 488                     ; 120 void W5500_Reset(void)
 488                     ; 121 {
 489                     	switch	.text
 490  00ae               _W5500_Reset:
 494                     ; 122     GPIO_Init(W5500_RST_PORT,
 494                     ; 123               W5500_RST_PIN,
 494                     ; 124               GPIO_MODE_OUT_PP_HIGH_FAST);
 496  00ae 4bf0          	push	#240
 497  00b0 4b20          	push	#32
 498  00b2 ae5014        	ldw	x,#20500
 499  00b5 cd0000        	call	_GPIO_Init
 501  00b8 85            	popw	x
 502                     ; 126     GPIO_WriteLow(W5500_RST_PORT,W5500_RST_PIN);
 504  00b9 4b20          	push	#32
 505  00bb ae5014        	ldw	x,#20500
 506  00be cd0000        	call	_GPIO_WriteLow
 508  00c1 84            	pop	a
 509                     ; 128     delay_ms(50);
 511  00c2 ae0032        	ldw	x,#50
 512  00c5 cd0000        	call	_delay_ms
 514                     ; 130     GPIO_WriteHigh(W5500_RST_PORT,W5500_RST_PIN);
 516  00c8 4b20          	push	#32
 517  00ca ae5014        	ldw	x,#20500
 518  00cd cd0000        	call	_GPIO_WriteHigh
 520  00d0 84            	pop	a
 521                     ; 132     delay_ms(200);
 523  00d1 ae00c8        	ldw	x,#200
 524  00d4 cd0000        	call	_delay_ms
 526                     ; 133 }
 529  00d7 81            	ret
 567                     ; 136 void W5500_Init(void)
 567                     ; 137 {
 568                     	switch	.text
 569  00d8               _W5500_Init:
 573                     ; 138     reg_wizchip_cs_cbfunc(wizchip_select,wizchip_deselect);
 575  00d8 ae0033        	ldw	x,#_wizchip_deselect
 576  00db 89            	pushw	x
 577  00dc ae0029        	ldw	x,#_wizchip_select
 578  00df cd0000        	call	_reg_wizchip_cs_cbfunc
 580  00e2 85            	popw	x
 581                     ; 140     reg_wizchip_spi_cbfunc(spi_readbyte,
 581                     ; 141                            spi_writebyte);
 583  00e3 ae003d        	ldw	x,#_spi_writebyte
 584  00e6 89            	pushw	x
 585  00e7 ae0054        	ldw	x,#_spi_readbyte
 586  00ea cd0000        	call	_reg_wizchip_spi_cbfunc
 588  00ed 85            	popw	x
 589                     ; 143     wizchip_init(txsize,rxsize);
 591  00ee ae0008        	ldw	x,#_rxsize
 592  00f1 89            	pushw	x
 593  00f2 ae0000        	ldw	x,#_txsize
 594  00f5 cd0000        	call	_wizchip_init
 596  00f8 85            	popw	x
 597                     ; 145     wizchip_setnetinfo(&netinfo);
 599  00f9 ae0011        	ldw	x,#_netinfo
 600  00fc cd0000        	call	_wizchip_setnetinfo
 602                     ; 146 }
 605  00ff 81            	ret
 629                     ; 147 void GPIO_Config(void)
 629                     ; 148 {
 630                     	switch	.text
 631  0100               _GPIO_Config:
 635                     ; 150     GPIO_Init(GPIOB, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // R1
 637  0100 4be0          	push	#224
 638  0102 4b08          	push	#8
 639  0104 ae5005        	ldw	x,#20485
 640  0107 cd0000        	call	_GPIO_Init
 642  010a 85            	popw	x
 643                     ; 151     GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // R2
 645  010b 4be0          	push	#224
 646  010d 4b04          	push	#4
 647  010f ae5005        	ldw	x,#20485
 648  0112 cd0000        	call	_GPIO_Init
 650  0115 85            	popw	x
 651                     ; 152     GPIO_Init(GPIOB, GPIO_PIN_1, GPIO_MODE_OUT_PP_LOW_FAST); // R3
 653  0116 4be0          	push	#224
 654  0118 4b02          	push	#2
 655  011a ae5005        	ldw	x,#20485
 656  011d cd0000        	call	_GPIO_Init
 658  0120 85            	popw	x
 659                     ; 153     GPIO_Init(GPIOB, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST); // R4
 661  0121 4be0          	push	#224
 662  0123 4b01          	push	#1
 663  0125 ae5005        	ldw	x,#20485
 664  0128 cd0000        	call	_GPIO_Init
 666  012b 85            	popw	x
 667                     ; 154     GPIO_Init(GPIOC, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // R5
 669  012c 4be0          	push	#224
 670  012e 4b08          	push	#8
 671  0130 ae500a        	ldw	x,#20490
 672  0133 cd0000        	call	_GPIO_Init
 674  0136 85            	popw	x
 675                     ; 155     GPIO_Init(GPIOC, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST); // R6
 677  0137 4be0          	push	#224
 678  0139 4b10          	push	#16
 679  013b ae500a        	ldw	x,#20490
 680  013e cd0000        	call	_GPIO_Init
 682  0141 85            	popw	x
 683                     ; 158     GPIO_Init(GPIOD, GPIO_PIN_2, GPIO_MODE_IN_PU_NO_IT); // DI1
 685  0142 4b40          	push	#64
 686  0144 4b04          	push	#4
 687  0146 ae500f        	ldw	x,#20495
 688  0149 cd0000        	call	_GPIO_Init
 690  014c 85            	popw	x
 691                     ; 159     GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_IN_PU_NO_IT); // DI2
 693  014d 4b40          	push	#64
 694  014f 4b08          	push	#8
 695  0151 ae500f        	ldw	x,#20495
 696  0154 cd0000        	call	_GPIO_Init
 698  0157 85            	popw	x
 699                     ; 160     GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_IN_PU_NO_IT); // DI3
 701  0158 4b40          	push	#64
 702  015a 4b10          	push	#16
 703  015c ae500f        	ldw	x,#20495
 704  015f cd0000        	call	_GPIO_Init
 706  0162 85            	popw	x
 707                     ; 161     GPIO_Init(GPIOD, GPIO_PIN_7, GPIO_MODE_IN_PU_NO_IT); // DI4
 709  0163 4b40          	push	#64
 710  0165 4b80          	push	#128
 711  0167 ae500f        	ldw	x,#20495
 712  016a cd0000        	call	_GPIO_Init
 714  016d 85            	popw	x
 715                     ; 162 }
 718  016e 81            	ret
 721                     .const:	section	.text
 722  0000               L502_prev_state:
 723  0000 30            	dc.b	48
 724  0001 30            	dc.b	48
 725  0002 30            	dc.b	48
 726  0003 30            	dc.b	48
 826                     ; 163 void main(void)
 826                     ; 164 {
 827                     	switch	.text
 828  016f               _main:
 830  016f 5213          	subw	sp,#19
 831       00000013      OFST:	set	19
 834                     ; 169     uint8_t prev_state[4] = {'0','0','0','0'};
 836  0171 96            	ldw	x,sp
 837  0172 1c0006        	addw	x,#OFST-13
 838  0175 90ae0000      	ldw	y,#L502_prev_state
 839  0179 a604          	ld	a,#4
 840  017b cd0000        	call	c_xymov
 842                     ; 172     uint16_t send_timer = 0;
 844  017e 5f            	clrw	x
 845  017f 1f02          	ldw	(OFST-17,sp),x
 847                     ; 174     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
 849  0181 4f            	clr	a
 850  0182 cd0000        	call	_CLK_HSIPrescalerConfig
 852                     ; 176     SPI_Config();
 854  0185 cd0065        	call	_SPI_Config
 856                     ; 177     GPIO_Config();
 858  0188 cd0100        	call	_GPIO_Config
 860                     ; 179     W5500_Reset();
 862  018b cd00ae        	call	_W5500_Reset
 864                     ; 180     W5500_Init();
 866  018e cd00d8        	call	_W5500_Init
 868  0191               L103:
 869                     ; 184         switch(getSn_SR(SOCK_TCPS))
 871  0191 ae0308        	ldw	x,#776
 872  0194 89            	pushw	x
 873  0195 ae0000        	ldw	x,#0
 874  0198 89            	pushw	x
 875  0199 cd0000        	call	_WIZCHIP_READ
 877  019c 5b04          	addw	sp,#4
 879                     ; 338         default:
 879                     ; 339             break;
 880  019e 4d            	tnz	a
 881  019f 2729          	jreq	L702
 882  01a1 a013          	sub	a,#19
 883  01a3 273f          	jreq	L112
 884  01a5 a004          	sub	a,#4
 885  01a7 2741          	jreq	L312
 886  01a9 4a            	dec	a
 887  01aa 2603          	jrne	L67
 888  01ac cc04b0        	jp	L332
 889  01af               L67:
 890  01af a002          	sub	a,#2
 891  01b1 2603          	jrne	L001
 892  01b3 cc04b0        	jp	L332
 893  01b6               L001:
 894  01b6 4a            	dec	a
 895  01b7 2603          	jrne	L201
 896  01b9 cc04b0        	jp	L332
 897  01bc               L201:
 898  01bc 4a            	dec	a
 899  01bd 2603          	jrne	L401
 900  01bf cc04a8        	jp	L132
 901  01c2               L401:
 902  01c2 4a            	dec	a
 903  01c3 2603          	jrne	L601
 904  01c5 cc04b0        	jp	L332
 905  01c8               L601:
 906  01c8 20c7          	jra	L103
 907  01ca               L702:
 908                     ; 186         case SOCK_CLOSED:
 908                     ; 187             close(SOCK_TCPS);
 910  01ca 4f            	clr	a
 911  01cb cd0000        	call	_close
 913                     ; 188             socket(SOCK_TCPS, Sn_MR_TCP, TCP_PORT, 0);
 915  01ce 4b00          	push	#0
 916  01d0 ae1388        	ldw	x,#5000
 917  01d3 89            	pushw	x
 918  01d4 ae0001        	ldw	x,#1
 919  01d7 cd0000        	call	_socket
 921  01da 5b03          	addw	sp,#3
 922                     ; 189             delay_ms(100);
 924  01dc ae0064        	ldw	x,#100
 925  01df cd0000        	call	_delay_ms
 927                     ; 190             break;
 929  01e2 20ad          	jra	L103
 930  01e4               L112:
 931                     ; 192         case SOCK_INIT:
 931                     ; 193             listen(SOCK_TCPS);
 933  01e4 4f            	clr	a
 934  01e5 cd0000        	call	_listen
 936                     ; 194             break;
 938  01e8 20a7          	jra	L103
 939  01ea               L312:
 940                     ; 196         case SOCK_ESTABLISHED:
 940                     ; 197 
 940                     ; 198             /* ✅ Connection event */
 940                     ; 199             if(getSn_IR(SOCK_TCPS) & Sn_IR_CON)
 942  01ea ae0208        	ldw	x,#520
 943  01ed 89            	pushw	x
 944  01ee ae0000        	ldw	x,#0
 945  01f1 89            	pushw	x
 946  01f2 cd0000        	call	_WIZCHIP_READ
 948  01f5 5b04          	addw	sp,#4
 949  01f7 a41f          	and	a,#31
 950  01f9 a501          	bcp	a,#1
 951  01fb 2603          	jrne	L011
 952  01fd cc0293        	jp	L113
 953  0200               L011:
 954                     ; 201                 setSn_IR(SOCK_TCPS, Sn_IR_CON);
 956  0200 4b01          	push	#1
 957  0202 ae0208        	ldw	x,#520
 958  0205 89            	pushw	x
 959  0206 ae0000        	ldw	x,#0
 960  0209 89            	pushw	x
 961  020a cd0000        	call	_WIZCHIP_WRITE
 963  020d 5b05          	addw	sp,#5
 964                     ; 203                 prev_state[0]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_2)==RESET)?'1':'0';
 966  020f 4b04          	push	#4
 967  0211 ae500f        	ldw	x,#20495
 968  0214 cd0000        	call	_GPIO_ReadInputPin
 970  0217 5b01          	addw	sp,#1
 971  0219 4d            	tnz	a
 972  021a 2604          	jrne	L03
 973  021c a631          	ld	a,#49
 974  021e 2002          	jra	L23
 975  0220               L03:
 976  0220 a630          	ld	a,#48
 977  0222               L23:
 978  0222 6b06          	ld	(OFST-13,sp),a
 980                     ; 204                 prev_state[1]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_3)==RESET)?'1':'0';
 982  0224 4b08          	push	#8
 983  0226 ae500f        	ldw	x,#20495
 984  0229 cd0000        	call	_GPIO_ReadInputPin
 986  022c 5b01          	addw	sp,#1
 987  022e 4d            	tnz	a
 988  022f 2604          	jrne	L43
 989  0231 a631          	ld	a,#49
 990  0233 2002          	jra	L63
 991  0235               L43:
 992  0235 a630          	ld	a,#48
 993  0237               L63:
 994  0237 6b07          	ld	(OFST-12,sp),a
 996                     ; 205                 prev_state[2]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_4)==RESET)?'1':'0';
 998  0239 4b10          	push	#16
 999  023b ae500f        	ldw	x,#20495
1000  023e cd0000        	call	_GPIO_ReadInputPin
1002  0241 5b01          	addw	sp,#1
1003  0243 4d            	tnz	a
1004  0244 2604          	jrne	L04
1005  0246 a631          	ld	a,#49
1006  0248 2002          	jra	L24
1007  024a               L04:
1008  024a a630          	ld	a,#48
1009  024c               L24:
1010  024c 6b08          	ld	(OFST-11,sp),a
1012                     ; 206                 prev_state[3]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_7)==RESET)?'1':'0';
1014  024e 4b80          	push	#128
1015  0250 ae500f        	ldw	x,#20495
1016  0253 cd0000        	call	_GPIO_ReadInputPin
1018  0256 5b01          	addw	sp,#1
1019  0258 4d            	tnz	a
1020  0259 2604          	jrne	L44
1021  025b a631          	ld	a,#49
1022  025d 2002          	jra	L64
1023  025f               L44:
1024  025f a630          	ld	a,#48
1025  0261               L64:
1026  0261 6b09          	ld	(OFST-10,sp),a
1028                     ; 208                 txbuf[0]=prev_state[0];
1030  0263 7b06          	ld	a,(OFST-13,sp)
1031  0265 6b0e          	ld	(OFST-5,sp),a
1033                     ; 209                 txbuf[1]=prev_state[1];
1035  0267 7b07          	ld	a,(OFST-12,sp)
1036  0269 6b0f          	ld	(OFST-4,sp),a
1038                     ; 210                 txbuf[2]=prev_state[2];
1040  026b 7b08          	ld	a,(OFST-11,sp)
1041  026d 6b10          	ld	(OFST-3,sp),a
1043                     ; 211                 txbuf[3]=prev_state[3];
1045  026f 7b09          	ld	a,(OFST-10,sp)
1046  0271 6b11          	ld	(OFST-2,sp),a
1048                     ; 212                 txbuf[4]='\r';
1050  0273 a60d          	ld	a,#13
1051  0275 6b12          	ld	(OFST-1,sp),a
1053                     ; 213                 txbuf[5]='\n';
1055  0277 a60a          	ld	a,#10
1056  0279 6b13          	ld	(OFST+0,sp),a
1058                     ; 215                 if(getSn_TX_FSR(SOCK_TCPS) >= 12)
1060  027b 4f            	clr	a
1061  027c cd0000        	call	_getSn_TX_FSR
1063  027f a3000c        	cpw	x,#12
1064  0282 250f          	jrult	L113
1065                     ; 216                     send(SOCK_TCPS, txbuf, 6);
1067  0284 ae0006        	ldw	x,#6
1068  0287 89            	pushw	x
1069  0288 96            	ldw	x,sp
1070  0289 1c0010        	addw	x,#OFST-3
1071  028c 89            	pushw	x
1072  028d 4f            	clr	a
1073  028e cd0000        	call	_send
1075  0291 5b04          	addw	sp,#4
1076  0293               L113:
1077                     ; 220             len = getSn_RX_RSR(SOCK_TCPS);
1079  0293 4f            	clr	a
1080  0294 cd0000        	call	_getSn_RX_RSR
1082  0297 1f04          	ldw	(OFST-15,sp),x
1084                     ; 222             if(len >= 4)
1086  0299 1e04          	ldw	x,(OFST-15,sp)
1087  029b a30004        	cpw	x,#4
1088  029e 2403          	jruge	L211
1089  02a0 cc0397        	jp	L513
1090  02a3               L211:
1091                     ; 224                 if(len > sizeof(rxbuf)-1)
1093  02a3 1e04          	ldw	x,(OFST-15,sp)
1094  02a5 a30020        	cpw	x,#32
1095  02a8 2505          	jrult	L713
1096                     ; 225                     len = sizeof(rxbuf)-1;
1098  02aa ae001f        	ldw	x,#31
1099  02ad 1f04          	ldw	(OFST-15,sp),x
1101  02af               L713:
1102                     ; 227                 recv(SOCK_TCPS, rxbuf, len);
1104  02af 1e04          	ldw	x,(OFST-15,sp)
1105  02b1 89            	pushw	x
1106  02b2 ae0000        	ldw	x,#_rxbuf
1107  02b5 89            	pushw	x
1108  02b6 4f            	clr	a
1109  02b7 cd0000        	call	_recv
1111  02ba 5b04          	addw	sp,#4
1112                     ; 229                 if(rxbuf[0]=='R' && rxbuf[2]==',')
1114  02bc b600          	ld	a,_rxbuf
1115  02be a152          	cp	a,#82
1116  02c0 2703          	jreq	L411
1117  02c2 cc0397        	jp	L513
1118  02c5               L411:
1120  02c5 b602          	ld	a,_rxbuf+2
1121  02c7 a12c          	cp	a,#44
1122  02c9 2703          	jreq	L611
1123  02cb cc0397        	jp	L513
1124  02ce               L611:
1125                     ; 231                     switch(rxbuf[1])
1127  02ce b601          	ld	a,_rxbuf+1
1129                     ; 261                             break;
1130  02d0 a031          	sub	a,#49
1131  02d2 2719          	jreq	L512
1132  02d4 4a            	dec	a
1133  02d5 2736          	jreq	L712
1134  02d7 4a            	dec	a
1135  02d8 274f          	jreq	L122
1136  02da 4a            	dec	a
1137  02db 2768          	jreq	L322
1138  02dd 4a            	dec	a
1139  02de 2603cc0361    	jreq	L522
1140  02e3 4a            	dec	a
1141  02e4 2603          	jrne	L021
1142  02e6 cc037d        	jp	L722
1143  02e9               L021:
1144  02e9 ac970397      	jpf	L513
1145  02ed               L512:
1146                     ; 233                         case '1':
1146                     ; 234                             if(rxbuf[3]=='1') GPIO_WriteHigh(GPIOB,GPIO_PIN_3);
1148  02ed b603          	ld	a,_rxbuf+3
1149  02ef a131          	cp	a,#49
1150  02f1 260d          	jrne	L723
1153  02f3 4b08          	push	#8
1154  02f5 ae5005        	ldw	x,#20485
1155  02f8 cd0000        	call	_GPIO_WriteHigh
1157  02fb 84            	pop	a
1159  02fc ac970397      	jpf	L513
1160  0300               L723:
1161                     ; 235                             else GPIO_WriteLow(GPIOB,GPIO_PIN_3);
1163  0300 4b08          	push	#8
1164  0302 ae5005        	ldw	x,#20485
1165  0305 cd0000        	call	_GPIO_WriteLow
1167  0308 84            	pop	a
1168  0309 ac970397      	jpf	L513
1169  030d               L712:
1170                     ; 238                         case '2':
1170                     ; 239                             if(rxbuf[3]=='1') GPIO_WriteHigh(GPIOB,GPIO_PIN_2);
1172  030d b603          	ld	a,_rxbuf+3
1173  030f a131          	cp	a,#49
1174  0311 260b          	jrne	L333
1177  0313 4b04          	push	#4
1178  0315 ae5005        	ldw	x,#20485
1179  0318 cd0000        	call	_GPIO_WriteHigh
1181  031b 84            	pop	a
1183  031c 2079          	jra	L513
1184  031e               L333:
1185                     ; 240                             else GPIO_WriteLow(GPIOB,GPIO_PIN_2);
1187  031e 4b04          	push	#4
1188  0320 ae5005        	ldw	x,#20485
1189  0323 cd0000        	call	_GPIO_WriteLow
1191  0326 84            	pop	a
1192  0327 206e          	jra	L513
1193  0329               L122:
1194                     ; 243                         case '3':
1194                     ; 244                             if(rxbuf[3]=='1') GPIO_WriteHigh(GPIOB,GPIO_PIN_1);
1196  0329 b603          	ld	a,_rxbuf+3
1197  032b a131          	cp	a,#49
1198  032d 260b          	jrne	L733
1201  032f 4b02          	push	#2
1202  0331 ae5005        	ldw	x,#20485
1203  0334 cd0000        	call	_GPIO_WriteHigh
1205  0337 84            	pop	a
1207  0338 205d          	jra	L513
1208  033a               L733:
1209                     ; 245                             else GPIO_WriteLow(GPIOB,GPIO_PIN_1);
1211  033a 4b02          	push	#2
1212  033c ae5005        	ldw	x,#20485
1213  033f cd0000        	call	_GPIO_WriteLow
1215  0342 84            	pop	a
1216  0343 2052          	jra	L513
1217  0345               L322:
1218                     ; 248                         case '4':
1218                     ; 249                             if(rxbuf[3]=='1') GPIO_WriteHigh(GPIOB,GPIO_PIN_0);
1220  0345 b603          	ld	a,_rxbuf+3
1221  0347 a131          	cp	a,#49
1222  0349 260b          	jrne	L343
1225  034b 4b01          	push	#1
1226  034d ae5005        	ldw	x,#20485
1227  0350 cd0000        	call	_GPIO_WriteHigh
1229  0353 84            	pop	a
1231  0354 2041          	jra	L513
1232  0356               L343:
1233                     ; 250                             else GPIO_WriteLow(GPIOB,GPIO_PIN_0);
1235  0356 4b01          	push	#1
1236  0358 ae5005        	ldw	x,#20485
1237  035b cd0000        	call	_GPIO_WriteLow
1239  035e 84            	pop	a
1240  035f 2036          	jra	L513
1241  0361               L522:
1242                     ; 253                         case '5':
1242                     ; 254                             if(rxbuf[3]=='1') GPIO_WriteHigh(GPIOC,GPIO_PIN_3);
1244  0361 b603          	ld	a,_rxbuf+3
1245  0363 a131          	cp	a,#49
1246  0365 260b          	jrne	L743
1249  0367 4b08          	push	#8
1250  0369 ae500a        	ldw	x,#20490
1251  036c cd0000        	call	_GPIO_WriteHigh
1253  036f 84            	pop	a
1255  0370 2025          	jra	L513
1256  0372               L743:
1257                     ; 255                             else GPIO_WriteLow(GPIOC,GPIO_PIN_3);
1259  0372 4b08          	push	#8
1260  0374 ae500a        	ldw	x,#20490
1261  0377 cd0000        	call	_GPIO_WriteLow
1263  037a 84            	pop	a
1264  037b 201a          	jra	L513
1265  037d               L722:
1266                     ; 258                         case '6':
1266                     ; 259                             if(rxbuf[3]=='1') GPIO_WriteHigh(GPIOC,GPIO_PIN_4);
1268  037d b603          	ld	a,_rxbuf+3
1269  037f a131          	cp	a,#49
1270  0381 260b          	jrne	L353
1273  0383 4b10          	push	#16
1274  0385 ae500a        	ldw	x,#20490
1275  0388 cd0000        	call	_GPIO_WriteHigh
1277  038b 84            	pop	a
1279  038c 2009          	jra	L513
1280  038e               L353:
1281                     ; 260                             else GPIO_WriteLow(GPIOC,GPIO_PIN_4);
1283  038e 4b10          	push	#16
1284  0390 ae500a        	ldw	x,#20490
1285  0393 cd0000        	call	_GPIO_WriteLow
1287  0396 84            	pop	a
1288  0397               L523:
1289  0397               L513:
1290                     ; 267             curr_state[0]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_2)==RESET)?'1':'0';
1292  0397 4b04          	push	#4
1293  0399 ae500f        	ldw	x,#20495
1294  039c cd0000        	call	_GPIO_ReadInputPin
1296  039f 5b01          	addw	sp,#1
1297  03a1 4d            	tnz	a
1298  03a2 2604          	jrne	L05
1299  03a4 a631          	ld	a,#49
1300  03a6 2002          	jra	L25
1301  03a8               L05:
1302  03a8 a630          	ld	a,#48
1303  03aa               L25:
1304  03aa 6b0a          	ld	(OFST-9,sp),a
1306                     ; 268             curr_state[1]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_3)==RESET)?'1':'0';
1308  03ac 4b08          	push	#8
1309  03ae ae500f        	ldw	x,#20495
1310  03b1 cd0000        	call	_GPIO_ReadInputPin
1312  03b4 5b01          	addw	sp,#1
1313  03b6 4d            	tnz	a
1314  03b7 2604          	jrne	L45
1315  03b9 a631          	ld	a,#49
1316  03bb 2002          	jra	L65
1317  03bd               L45:
1318  03bd a630          	ld	a,#48
1319  03bf               L65:
1320  03bf 6b0b          	ld	(OFST-8,sp),a
1322                     ; 269             curr_state[2]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_4)==RESET)?'1':'0';
1324  03c1 4b10          	push	#16
1325  03c3 ae500f        	ldw	x,#20495
1326  03c6 cd0000        	call	_GPIO_ReadInputPin
1328  03c9 5b01          	addw	sp,#1
1329  03cb 4d            	tnz	a
1330  03cc 2604          	jrne	L06
1331  03ce a631          	ld	a,#49
1332  03d0 2002          	jra	L26
1333  03d2               L06:
1334  03d2 a630          	ld	a,#48
1335  03d4               L26:
1336  03d4 6b0c          	ld	(OFST-7,sp),a
1338                     ; 270             curr_state[3]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_7)==RESET)?'1':'0';
1340  03d6 4b80          	push	#128
1341  03d8 ae500f        	ldw	x,#20495
1342  03db cd0000        	call	_GPIO_ReadInputPin
1344  03de 5b01          	addw	sp,#1
1345  03e0 4d            	tnz	a
1346  03e1 2604          	jrne	L46
1347  03e3 a631          	ld	a,#49
1348  03e5 2002          	jra	L66
1349  03e7               L46:
1350  03e7 a630          	ld	a,#48
1351  03e9               L66:
1352  03e9 6b0d          	ld	(OFST-6,sp),a
1354                     ; 272             changed =
1354                     ; 273                 (curr_state[0]!=prev_state[0]) ||
1354                     ; 274                 (curr_state[1]!=prev_state[1]) ||
1354                     ; 275                 (curr_state[2]!=prev_state[2]) ||
1354                     ; 276                 (curr_state[3]!=prev_state[3]);
1356  03eb 7b0a          	ld	a,(OFST-9,sp)
1357  03ed 1106          	cp	a,(OFST-13,sp)
1358  03ef 2612          	jrne	L27
1359  03f1 7b0b          	ld	a,(OFST-8,sp)
1360  03f3 1107          	cp	a,(OFST-12,sp)
1361  03f5 260c          	jrne	L27
1362  03f7 7b0c          	ld	a,(OFST-7,sp)
1363  03f9 1108          	cp	a,(OFST-11,sp)
1364  03fb 2606          	jrne	L27
1365  03fd 7b0d          	ld	a,(OFST-6,sp)
1366  03ff 1109          	cp	a,(OFST-10,sp)
1367  0401 2704          	jreq	L07
1368  0403               L27:
1369  0403 a601          	ld	a,#1
1370  0405 2001          	jra	L47
1371  0407               L07:
1372  0407 4f            	clr	a
1373  0408               L47:
1374  0408 6b01          	ld	(OFST-18,sp),a
1376                     ; 279             send_timer++;
1378  040a 1e02          	ldw	x,(OFST-17,sp)
1379  040c 1c0001        	addw	x,#1
1380  040f 1f02          	ldw	(OFST-17,sp),x
1382                     ; 281             if(send_timer >= 30)   // ~300ms (10ms loop delay below)
1384  0411 1e02          	ldw	x,(OFST-17,sp)
1385  0413 a3001e        	cpw	x,#30
1386  0416 2542          	jrult	L753
1387                     ; 283                 send_timer = 0;
1389  0418 5f            	clrw	x
1390  0419 1f02          	ldw	(OFST-17,sp),x
1392                     ; 285                 txbuf[0]=curr_state[0];
1394  041b 7b0a          	ld	a,(OFST-9,sp)
1395  041d 6b0e          	ld	(OFST-5,sp),a
1397                     ; 286                 txbuf[1]=curr_state[1];
1399  041f 7b0b          	ld	a,(OFST-8,sp)
1400  0421 6b0f          	ld	(OFST-4,sp),a
1402                     ; 287                 txbuf[2]=curr_state[2];
1404  0423 7b0c          	ld	a,(OFST-7,sp)
1405  0425 6b10          	ld	(OFST-3,sp),a
1407                     ; 288                 txbuf[3]=curr_state[3];
1409  0427 7b0d          	ld	a,(OFST-6,sp)
1410  0429 6b11          	ld	(OFST-2,sp),a
1412                     ; 289                 txbuf[4]='\r';
1414  042b a60d          	ld	a,#13
1415  042d 6b12          	ld	(OFST-1,sp),a
1417                     ; 290                 txbuf[5]='\n';
1419  042f a60a          	ld	a,#10
1420  0431 6b13          	ld	(OFST+0,sp),a
1422                     ; 292                 if(getSn_TX_FSR(SOCK_TCPS) >= 12)
1424  0433 4f            	clr	a
1425  0434 cd0000        	call	_getSn_TX_FSR
1427  0437 a3000c        	cpw	x,#12
1428  043a 251e          	jrult	L753
1429                     ; 294                     if(send(SOCK_TCPS, txbuf, 6) <= 0)
1431  043c 9c            	rvf
1432  043d ae0006        	ldw	x,#6
1433  0440 89            	pushw	x
1434  0441 96            	ldw	x,sp
1435  0442 1c0010        	addw	x,#OFST-3
1436  0445 89            	pushw	x
1437  0446 4f            	clr	a
1438  0447 cd0000        	call	_send
1440  044a 9c            	rvf
1441  044b 5b04          	addw	sp,#4
1442  044d cd0000        	call	c_lrzmp
1444  0450 2c08          	jrsgt	L753
1445                     ; 296                         disconnect(SOCK_TCPS);
1447  0452 4f            	clr	a
1448  0453 cd0000        	call	_disconnect
1450                     ; 297                         break;
1452  0456 ac910191      	jpf	L103
1453  045a               L753:
1454                     ; 303             if(changed)
1456  045a 0d01          	tnz	(OFST-18,sp)
1457  045c 2740          	jreq	L563
1458                     ; 305                 txbuf[0]=curr_state[0];
1460  045e 7b0a          	ld	a,(OFST-9,sp)
1461  0460 6b0e          	ld	(OFST-5,sp),a
1463                     ; 306                 txbuf[1]=curr_state[1];
1465  0462 7b0b          	ld	a,(OFST-8,sp)
1466  0464 6b0f          	ld	(OFST-4,sp),a
1468                     ; 307                 txbuf[2]=curr_state[2];
1470  0466 7b0c          	ld	a,(OFST-7,sp)
1471  0468 6b10          	ld	(OFST-3,sp),a
1473                     ; 308                 txbuf[3]=curr_state[3];
1475  046a 7b0d          	ld	a,(OFST-6,sp)
1476  046c 6b11          	ld	(OFST-2,sp),a
1478                     ; 309                 txbuf[4]='\r';
1480  046e a60d          	ld	a,#13
1481  0470 6b12          	ld	(OFST-1,sp),a
1483                     ; 310                 txbuf[5]='\n';
1485  0472 a60a          	ld	a,#10
1486  0474 6b13          	ld	(OFST+0,sp),a
1488                     ; 312                 if(getSn_TX_FSR(SOCK_TCPS) >= 12)
1490  0476 4f            	clr	a
1491  0477 cd0000        	call	_getSn_TX_FSR
1493  047a a3000c        	cpw	x,#12
1494  047d 250f          	jrult	L763
1495                     ; 314                     send(SOCK_TCPS, txbuf, 6);
1497  047f ae0006        	ldw	x,#6
1498  0482 89            	pushw	x
1499  0483 96            	ldw	x,sp
1500  0484 1c0010        	addw	x,#OFST-3
1501  0487 89            	pushw	x
1502  0488 4f            	clr	a
1503  0489 cd0000        	call	_send
1505  048c 5b04          	addw	sp,#4
1506  048e               L763:
1507                     ; 317                 prev_state[0]=curr_state[0];
1509  048e 7b0a          	ld	a,(OFST-9,sp)
1510  0490 6b06          	ld	(OFST-13,sp),a
1512                     ; 318                 prev_state[1]=curr_state[1];
1514  0492 7b0b          	ld	a,(OFST-8,sp)
1515  0494 6b07          	ld	(OFST-12,sp),a
1517                     ; 319                 prev_state[2]=curr_state[2];
1519  0496 7b0c          	ld	a,(OFST-7,sp)
1520  0498 6b08          	ld	(OFST-11,sp),a
1522                     ; 320                 prev_state[3]=curr_state[3];
1524  049a 7b0d          	ld	a,(OFST-6,sp)
1525  049c 6b09          	ld	(OFST-10,sp),a
1527  049e               L563:
1528                     ; 323             delay_ms(10);   // ✅ keeps loop stable
1530  049e ae000a        	ldw	x,#10
1531  04a1 cd0000        	call	_delay_ms
1533                     ; 325             break;
1535  04a4 ac910191      	jpf	L103
1536  04a8               L132:
1537                     ; 327         case SOCK_CLOSE_WAIT:
1537                     ; 328             disconnect(SOCK_TCPS);
1539  04a8 4f            	clr	a
1540  04a9 cd0000        	call	_disconnect
1542                     ; 329             break;
1544  04ac ac910191      	jpf	L103
1545  04b0               L332:
1546                     ; 331         case SOCK_FIN_WAIT:
1546                     ; 332         case SOCK_CLOSING:
1546                     ; 333         case SOCK_TIME_WAIT:
1546                     ; 334         case SOCK_LAST_ACK:
1546                     ; 335             close(SOCK_TCPS);
1548  04b0 4f            	clr	a
1549  04b1 cd0000        	call	_close
1551                     ; 336             break;
1553  04b4 ac910191      	jpf	L103
1554  04b8               L532:
1555                     ; 338         default:
1555                     ; 339             break;
1557  04b8 ac910191      	jpf	L103
1558  04bc               L703:
1560  04bc ac910191      	jpf	L103
1711                     	xdef	_main
1712                     	xdef	_GPIO_Config
1713                     	xdef	_W5500_Init
1714                     	xdef	_W5500_Reset
1715                     	xdef	_SPI_Config
1716                     	xdef	_spi_readbyte
1717                     	xdef	_spi_writebyte
1718                     	xdef	_wizchip_deselect
1719                     	xdef	_wizchip_select
1720                     	xdef	_delay_ms
1721                     	xdef	_netinfo
1722                     	switch	.ubsct
1723  0000               _rxbuf:
1724  0000 000000000000  	ds.b	32
1725                     	xdef	_rxbuf
1726                     	xdef	_changed
1727                     	xdef	_rxsize
1728                     	xdef	_txsize
1729                     	xref	_recv
1730                     	xref	_send
1731                     	xref	_disconnect
1732                     	xref	_listen
1733                     	xref	_close
1734                     	xref	_socket
1735                     	xref	_wizchip_setnetinfo
1736                     	xref	_wizchip_init
1737                     	xref	_reg_wizchip_spi_cbfunc
1738                     	xref	_reg_wizchip_cs_cbfunc
1739                     	xref	_getSn_RX_RSR
1740                     	xref	_getSn_TX_FSR
1741                     	xref	_WIZCHIP_WRITE
1742                     	xref	_WIZCHIP_READ
1743                     	xref	_CLK_HSIPrescalerConfig
1744                     	xref	_SPI_GetFlagStatus
1745                     	xref	_SPI_ReceiveData
1746                     	xref	_SPI_SendData
1747                     	xref	_SPI_Cmd
1748                     	xref	_SPI_Init
1749                     	xref	_SPI_DeInit
1750                     	xref	_GPIO_ReadInputPin
1751                     	xref	_GPIO_WriteLow
1752                     	xref	_GPIO_WriteHigh
1753                     	xref	_GPIO_Init
1754                     	xref.b	c_x
1774                     	xref	c_lrzmp
1775                     	xref	c_xymov
1776                     	end
