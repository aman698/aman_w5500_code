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
 926                     ; 163 void main(void)
 926                     ; 164 {
 927                     	switch	.text
 928  016f               _main:
 930  016f 5215          	subw	sp,#21
 931       00000015      OFST:	set	21
 934                     ; 170     uint8_t prev_state[4] = {'0','0','0','0'};
 936  0171 96            	ldw	x,sp
 937  0172 1c0006        	addw	x,#OFST-15
 938  0175 90ae0000      	ldw	y,#L502_prev_state
 939  0179 a604          	ld	a,#4
 940  017b cd0000        	call	c_xymov
 942                     ; 173     uint16_t send_timer = 0;
 944  017e 5f            	clrw	x
 945  017f 1f03          	ldw	(OFST-18,sp),x
 947                     ; 175     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
 949  0181 4f            	clr	a
 950  0182 cd0000        	call	_CLK_HSIPrescalerConfig
 952                     ; 177     SPI_Config();
 954  0185 cd0065        	call	_SPI_Config
 956                     ; 178     GPIO_Config();
 958  0188 cd0100        	call	_GPIO_Config
 960                     ; 180     W5500_Reset();
 962  018b cd00ae        	call	_W5500_Reset
 964                     ; 181     W5500_Init();
 966  018e cd00d8        	call	_W5500_Init
 968  0191               L753:
 969                     ; 185         switch(getSn_SR(SOCK_TCPS))
 971  0191 ae0308        	ldw	x,#776
 972  0194 89            	pushw	x
 973  0195 ae0000        	ldw	x,#0
 974  0198 89            	pushw	x
 975  0199 cd0000        	call	_WIZCHIP_READ
 977  019c 5b04          	addw	sp,#4
 979                     ; 331         default:
 979                     ; 332             break;
 980  019e 4d            	tnz	a
 981  019f 2729          	jreq	L702
 982  01a1 a013          	sub	a,#19
 983  01a3 273f          	jreq	L112
 984  01a5 a004          	sub	a,#4
 985  01a7 2741          	jreq	L312
 986  01a9 4a            	dec	a
 987  01aa 2603          	jrne	L67
 988  01ac cc046f        	jp	L332
 989  01af               L67:
 990  01af a002          	sub	a,#2
 991  01b1 2603          	jrne	L001
 992  01b3 cc046f        	jp	L332
 993  01b6               L001:
 994  01b6 4a            	dec	a
 995  01b7 2603          	jrne	L201
 996  01b9 cc046f        	jp	L332
 997  01bc               L201:
 998  01bc 4a            	dec	a
 999  01bd 2603          	jrne	L401
1000  01bf cc0467        	jp	L132
1001  01c2               L401:
1002  01c2 4a            	dec	a
1003  01c3 2603          	jrne	L601
1004  01c5 cc046f        	jp	L332
1005  01c8               L601:
1006  01c8 20c7          	jra	L753
1007  01ca               L702:
1008                     ; 189         case SOCK_CLOSED:
1008                     ; 190             close(SOCK_TCPS);
1010  01ca 4f            	clr	a
1011  01cb cd0000        	call	_close
1013                     ; 191             socket(SOCK_TCPS, Sn_MR_TCP, TCP_PORT, 0);
1015  01ce 4b00          	push	#0
1016  01d0 ae1388        	ldw	x,#5000
1017  01d3 89            	pushw	x
1018  01d4 ae0001        	ldw	x,#1
1019  01d7 cd0000        	call	_socket
1021  01da 5b03          	addw	sp,#3
1022                     ; 192             delay_ms(100);
1024  01dc ae0064        	ldw	x,#100
1025  01df cd0000        	call	_delay_ms
1027                     ; 193             break;
1029  01e2 20ad          	jra	L753
1030  01e4               L112:
1031                     ; 196         case SOCK_INIT:
1031                     ; 197             listen(SOCK_TCPS);
1033  01e4 4f            	clr	a
1034  01e5 cd0000        	call	_listen
1036                     ; 198             break;
1038  01e8 20a7          	jra	L753
1039  01ea               L312:
1040                     ; 201         case SOCK_ESTABLISHED:
1040                     ; 202 
1040                     ; 203             /* ✅ connection event */
1040                     ; 204             if(getSn_IR(SOCK_TCPS) & Sn_IR_CON)
1042  01ea ae0208        	ldw	x,#520
1043  01ed 89            	pushw	x
1044  01ee ae0000        	ldw	x,#0
1045  01f1 89            	pushw	x
1046  01f2 cd0000        	call	_WIZCHIP_READ
1048  01f5 5b04          	addw	sp,#4
1049  01f7 a41f          	and	a,#31
1050  01f9 a501          	bcp	a,#1
1051  01fb 2603          	jrne	L011
1052  01fd cc02ad        	jp	L763
1053  0200               L011:
1054                     ; 206                 setSn_IR(SOCK_TCPS, Sn_IR_CON);
1056  0200 4b01          	push	#1
1057  0202 ae0208        	ldw	x,#520
1058  0205 89            	pushw	x
1059  0206 ae0000        	ldw	x,#0
1060  0209 89            	pushw	x
1061  020a cd0000        	call	_WIZCHIP_WRITE
1063  020d 5b05          	addw	sp,#5
1064                     ; 208                 curr_state[0]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_2)==RESET)?'1':'0';
1066  020f 4b04          	push	#4
1067  0211 ae500f        	ldw	x,#20495
1068  0214 cd0000        	call	_GPIO_ReadInputPin
1070  0217 5b01          	addw	sp,#1
1071  0219 4d            	tnz	a
1072  021a 2604          	jrne	L03
1073  021c a631          	ld	a,#49
1074  021e 2002          	jra	L23
1075  0220               L03:
1076  0220 a630          	ld	a,#48
1077  0222               L23:
1078  0222 6b12          	ld	(OFST-3,sp),a
1080                     ; 209                 curr_state[1]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_3)==RESET)?'1':'0';
1082  0224 4b08          	push	#8
1083  0226 ae500f        	ldw	x,#20495
1084  0229 cd0000        	call	_GPIO_ReadInputPin
1086  022c 5b01          	addw	sp,#1
1087  022e 4d            	tnz	a
1088  022f 2604          	jrne	L43
1089  0231 a631          	ld	a,#49
1090  0233 2002          	jra	L63
1091  0235               L43:
1092  0235 a630          	ld	a,#48
1093  0237               L63:
1094  0237 6b13          	ld	(OFST-2,sp),a
1096                     ; 210                 curr_state[2]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_4)==RESET)?'1':'0';
1098  0239 4b10          	push	#16
1099  023b ae500f        	ldw	x,#20495
1100  023e cd0000        	call	_GPIO_ReadInputPin
1102  0241 5b01          	addw	sp,#1
1103  0243 4d            	tnz	a
1104  0244 2604          	jrne	L04
1105  0246 a631          	ld	a,#49
1106  0248 2002          	jra	L24
1107  024a               L04:
1108  024a a630          	ld	a,#48
1109  024c               L24:
1110  024c 6b14          	ld	(OFST-1,sp),a
1112                     ; 211                 curr_state[3]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_7)==RESET)?'1':'0';
1114  024e 4b80          	push	#128
1115  0250 ae500f        	ldw	x,#20495
1116  0253 cd0000        	call	_GPIO_ReadInputPin
1118  0256 5b01          	addw	sp,#1
1119  0258 4d            	tnz	a
1120  0259 2604          	jrne	L44
1121  025b a631          	ld	a,#49
1122  025d 2002          	jra	L64
1123  025f               L44:
1124  025f a630          	ld	a,#48
1125  0261               L64:
1126  0261 6b15          	ld	(OFST+0,sp),a
1128                     ; 213                 txbuf[0]=curr_state[0];
1130  0263 7b12          	ld	a,(OFST-3,sp)
1131  0265 6b0a          	ld	(OFST-11,sp),a
1133                     ; 214                 txbuf[1]=curr_state[1];
1135  0267 7b13          	ld	a,(OFST-2,sp)
1136  0269 6b0b          	ld	(OFST-10,sp),a
1138                     ; 215                 txbuf[2]=curr_state[2];
1140  026b 7b14          	ld	a,(OFST-1,sp)
1141  026d 6b0c          	ld	(OFST-9,sp),a
1143                     ; 216                 txbuf[3]=curr_state[3];
1145  026f 7b15          	ld	a,(OFST+0,sp)
1146  0271 6b0d          	ld	(OFST-8,sp),a
1148                     ; 217                 txbuf[4]='\r';
1150  0273 a60d          	ld	a,#13
1151  0275 6b0e          	ld	(OFST-7,sp),a
1153                     ; 218                 txbuf[5]='\n';
1155  0277 a60a          	ld	a,#10
1156  0279 6b0f          	ld	(OFST-6,sp),a
1158                     ; 220                 free = getSn_TX_FSR(SOCK_TCPS);
1160  027b 4f            	clr	a
1161  027c cd0000        	call	_getSn_TX_FSR
1163  027f 1f10          	ldw	(OFST-5,sp),x
1165                     ; 222                 if(free >= 16)
1167  0281 1e10          	ldw	x,(OFST-5,sp)
1168  0283 a30010        	cpw	x,#16
1169  0286 2515          	jrult	L173
1170                     ; 224                     send(SOCK_TCPS, txbuf, 6);
1172  0288 ae0006        	ldw	x,#6
1173  028b 89            	pushw	x
1174  028c 96            	ldw	x,sp
1175  028d 1c000c        	addw	x,#OFST-9
1176  0290 89            	pushw	x
1177  0291 4f            	clr	a
1178  0292 cd0000        	call	_send
1180  0295 5b04          	addw	sp,#4
1181                     ; 225                     delay_ms(5);   // ✅ buffer flush
1183  0297 ae0005        	ldw	x,#5
1184  029a cd0000        	call	_delay_ms
1186  029d               L173:
1187                     ; 228                 prev_state[0]=curr_state[0];
1189  029d 7b12          	ld	a,(OFST-3,sp)
1190  029f 6b06          	ld	(OFST-15,sp),a
1192                     ; 229                 prev_state[1]=curr_state[1];
1194  02a1 7b13          	ld	a,(OFST-2,sp)
1195  02a3 6b07          	ld	(OFST-14,sp),a
1197                     ; 230                 prev_state[2]=curr_state[2];
1199  02a5 7b14          	ld	a,(OFST-1,sp)
1200  02a7 6b08          	ld	(OFST-13,sp),a
1202                     ; 231                 prev_state[3]=curr_state[3];
1204  02a9 7b15          	ld	a,(OFST+0,sp)
1205  02ab 6b09          	ld	(OFST-12,sp),a
1207  02ad               L763:
1208                     ; 235             len = getSn_RX_RSR(SOCK_TCPS);
1210  02ad 4f            	clr	a
1211  02ae cd0000        	call	_getSn_RX_RSR
1213  02b1 1f10          	ldw	(OFST-5,sp),x
1215                     ; 237             if(len >= 4)
1217  02b3 1e10          	ldw	x,(OFST-5,sp)
1218  02b5 a30004        	cpw	x,#4
1219  02b8 2403          	jruge	L211
1220  02ba cc036b        	jp	L373
1221  02bd               L211:
1222                     ; 239                 if(len > sizeof(rxbuf)-1)
1224  02bd 1e10          	ldw	x,(OFST-5,sp)
1225  02bf a30020        	cpw	x,#32
1226  02c2 2505          	jrult	L573
1227                     ; 240                     len = sizeof(rxbuf)-1;
1229  02c4 ae001f        	ldw	x,#31
1230  02c7 1f10          	ldw	(OFST-5,sp),x
1232  02c9               L573:
1233                     ; 242                 recv(SOCK_TCPS, rxbuf, len);
1235  02c9 1e10          	ldw	x,(OFST-5,sp)
1236  02cb 89            	pushw	x
1237  02cc ae0000        	ldw	x,#_rxbuf
1238  02cf 89            	pushw	x
1239  02d0 4f            	clr	a
1240  02d1 cd0000        	call	_recv
1242  02d4 5b04          	addw	sp,#4
1243                     ; 244                 if(rxbuf[0]=='R' && rxbuf[2]==',')
1245  02d6 b600          	ld	a,_rxbuf
1246  02d8 a152          	cp	a,#82
1247  02da 2703          	jreq	L411
1248  02dc cc036b        	jp	L373
1249  02df               L411:
1251  02df b602          	ld	a,_rxbuf+2
1252  02e1 a12c          	cp	a,#44
1253  02e3 2703          	jreq	L611
1254  02e5 cc036b        	jp	L373
1255  02e8               L611:
1256                     ; 246                     uint8_t relay = rxbuf[1]-'0';
1258  02e8 b601          	ld	a,_rxbuf+1
1259  02ea a030          	sub	a,#48
1260  02ec 6b01          	ld	(OFST-20,sp),a
1262                     ; 247                     uint8_t state = rxbuf[3]-'0';
1264  02ee b603          	ld	a,_rxbuf+3
1265  02f0 a030          	sub	a,#48
1266  02f2 6b02          	ld	(OFST-19,sp),a
1268                     ; 249                     GPIO_TypeDef* port = 0;
1270  02f4 5f            	clrw	x
1271  02f5 1f10          	ldw	(OFST-5,sp),x
1273                     ; 250                     uint8_t pin = 0;
1275  02f7 0f05          	clr	(OFST-16,sp)
1277                     ; 252                     switch(relay)
1279  02f9 7b01          	ld	a,(OFST-20,sp)
1281                     ; 259                         case 6: port=GPIOC; pin=GPIO_PIN_4; break;
1282  02fb 4a            	dec	a
1283  02fc 2711          	jreq	L512
1284  02fe 4a            	dec	a
1285  02ff 2719          	jreq	L712
1286  0301 4a            	dec	a
1287  0302 2721          	jreq	L122
1288  0304 4a            	dec	a
1289  0305 2729          	jreq	L322
1290  0307 4a            	dec	a
1291  0308 2731          	jreq	L522
1292  030a 4a            	dec	a
1293  030b 2739          	jreq	L722
1294  030d 2040          	jra	L304
1295  030f               L512:
1296                     ; 254                         case 1: port=GPIOB; pin=GPIO_PIN_3; break;
1298  030f ae5005        	ldw	x,#20485
1299  0312 1f10          	ldw	(OFST-5,sp),x
1303  0314 a608          	ld	a,#8
1304  0316 6b05          	ld	(OFST-16,sp),a
1308  0318 2035          	jra	L304
1309  031a               L712:
1310                     ; 255                         case 2: port=GPIOB; pin=GPIO_PIN_2; break;
1312  031a ae5005        	ldw	x,#20485
1313  031d 1f10          	ldw	(OFST-5,sp),x
1317  031f a604          	ld	a,#4
1318  0321 6b05          	ld	(OFST-16,sp),a
1322  0323 202a          	jra	L304
1323  0325               L122:
1324                     ; 256                         case 3: port=GPIOB; pin=GPIO_PIN_1; break;
1326  0325 ae5005        	ldw	x,#20485
1327  0328 1f10          	ldw	(OFST-5,sp),x
1331  032a a602          	ld	a,#2
1332  032c 6b05          	ld	(OFST-16,sp),a
1336  032e 201f          	jra	L304
1337  0330               L322:
1338                     ; 257                         case 4: port=GPIOB; pin=GPIO_PIN_0; break;
1340  0330 ae5005        	ldw	x,#20485
1341  0333 1f10          	ldw	(OFST-5,sp),x
1345  0335 a601          	ld	a,#1
1346  0337 6b05          	ld	(OFST-16,sp),a
1350  0339 2014          	jra	L304
1351  033b               L522:
1352                     ; 258                         case 5: port=GPIOC; pin=GPIO_PIN_3; break;
1354  033b ae500a        	ldw	x,#20490
1355  033e 1f10          	ldw	(OFST-5,sp),x
1359  0340 a608          	ld	a,#8
1360  0342 6b05          	ld	(OFST-16,sp),a
1364  0344 2009          	jra	L304
1365  0346               L722:
1366                     ; 259                         case 6: port=GPIOC; pin=GPIO_PIN_4; break;
1368  0346 ae500a        	ldw	x,#20490
1369  0349 1f10          	ldw	(OFST-5,sp),x
1373  034b a610          	ld	a,#16
1374  034d 6b05          	ld	(OFST-16,sp),a
1378  034f               L304:
1379                     ; 262                     if(port)
1381  034f 1e10          	ldw	x,(OFST-5,sp)
1382  0351 2718          	jreq	L373
1383                     ; 264                         if(state) GPIO_WriteHigh(port, pin);
1385  0353 0d02          	tnz	(OFST-19,sp)
1386  0355 270b          	jreq	L704
1389  0357 7b05          	ld	a,(OFST-16,sp)
1390  0359 88            	push	a
1391  035a 1e11          	ldw	x,(OFST-4,sp)
1392  035c cd0000        	call	_GPIO_WriteHigh
1394  035f 84            	pop	a
1396  0360 2009          	jra	L373
1397  0362               L704:
1398                     ; 265                         else      GPIO_WriteLow(port, pin);
1400  0362 7b05          	ld	a,(OFST-16,sp)
1401  0364 88            	push	a
1402  0365 1e11          	ldw	x,(OFST-4,sp)
1403  0367 cd0000        	call	_GPIO_WriteLow
1405  036a 84            	pop	a
1406  036b               L373:
1407                     ; 271             send_timer++;
1409  036b 1e03          	ldw	x,(OFST-18,sp)
1410  036d 1c0001        	addw	x,#1
1411  0370 1f03          	ldw	(OFST-18,sp),x
1413                     ; 273             curr_state[0]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_2)==RESET)?'1':'0';
1415  0372 4b04          	push	#4
1416  0374 ae500f        	ldw	x,#20495
1417  0377 cd0000        	call	_GPIO_ReadInputPin
1419  037a 5b01          	addw	sp,#1
1420  037c 4d            	tnz	a
1421  037d 2604          	jrne	L05
1422  037f a631          	ld	a,#49
1423  0381 2002          	jra	L25
1424  0383               L05:
1425  0383 a630          	ld	a,#48
1426  0385               L25:
1427  0385 6b12          	ld	(OFST-3,sp),a
1429                     ; 274             curr_state[1]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_3)==RESET)?'1':'0';
1431  0387 4b08          	push	#8
1432  0389 ae500f        	ldw	x,#20495
1433  038c cd0000        	call	_GPIO_ReadInputPin
1435  038f 5b01          	addw	sp,#1
1436  0391 4d            	tnz	a
1437  0392 2604          	jrne	L45
1438  0394 a631          	ld	a,#49
1439  0396 2002          	jra	L65
1440  0398               L45:
1441  0398 a630          	ld	a,#48
1442  039a               L65:
1443  039a 6b13          	ld	(OFST-2,sp),a
1445                     ; 275             curr_state[2]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_4)==RESET)?'1':'0';
1447  039c 4b10          	push	#16
1448  039e ae500f        	ldw	x,#20495
1449  03a1 cd0000        	call	_GPIO_ReadInputPin
1451  03a4 5b01          	addw	sp,#1
1452  03a6 4d            	tnz	a
1453  03a7 2604          	jrne	L06
1454  03a9 a631          	ld	a,#49
1455  03ab 2002          	jra	L26
1456  03ad               L06:
1457  03ad a630          	ld	a,#48
1458  03af               L26:
1459  03af 6b14          	ld	(OFST-1,sp),a
1461                     ; 276             curr_state[3]=(GPIO_ReadInputPin(GPIOD,GPIO_PIN_7)==RESET)?'1':'0';
1463  03b1 4b80          	push	#128
1464  03b3 ae500f        	ldw	x,#20495
1465  03b6 cd0000        	call	_GPIO_ReadInputPin
1467  03b9 5b01          	addw	sp,#1
1468  03bb 4d            	tnz	a
1469  03bc 2604          	jrne	L46
1470  03be a631          	ld	a,#49
1471  03c0 2002          	jra	L66
1472  03c2               L46:
1473  03c2 a630          	ld	a,#48
1474  03c4               L66:
1475  03c4 6b15          	ld	(OFST+0,sp),a
1477                     ; 278             changed =
1477                     ; 279                 (curr_state[0] != prev_state[0]) ||
1477                     ; 280                 (curr_state[1] != prev_state[1]) ||
1477                     ; 281                 (curr_state[2] != prev_state[2]) ||
1477                     ; 282                 (curr_state[3] != prev_state[3]);
1479  03c6 7b12          	ld	a,(OFST-3,sp)
1480  03c8 1106          	cp	a,(OFST-15,sp)
1481  03ca 2612          	jrne	L27
1482  03cc 7b13          	ld	a,(OFST-2,sp)
1483  03ce 1107          	cp	a,(OFST-14,sp)
1484  03d0 260c          	jrne	L27
1485  03d2 7b14          	ld	a,(OFST-1,sp)
1486  03d4 1108          	cp	a,(OFST-13,sp)
1487  03d6 2606          	jrne	L27
1488  03d8 7b15          	ld	a,(OFST+0,sp)
1489  03da 1109          	cp	a,(OFST-12,sp)
1490  03dc 2704          	jreq	L07
1491  03de               L27:
1492  03de a601          	ld	a,#1
1493  03e0 2001          	jra	L47
1494  03e2               L07:
1495  03e2 4f            	clr	a
1496  03e3               L47:
1497  03e3 6b05          	ld	(OFST-16,sp),a
1499                     ; 284             if(changed || send_timer >= 100)   // ~1 sec
1501  03e5 0d05          	tnz	(OFST-16,sp)
1502  03e7 260a          	jrne	L514
1504  03e9 1e03          	ldw	x,(OFST-18,sp)
1505  03eb a30064        	cpw	x,#100
1506  03ee 2403          	jruge	L021
1507  03f0 cc0191        	jp	L753
1508  03f3               L021:
1509  03f3               L514:
1510                     ; 286                 send_timer = 0;
1512  03f3 5f            	clrw	x
1513  03f4 1f03          	ldw	(OFST-18,sp),x
1515                     ; 288                 if(getSn_SR(SOCK_TCPS) != SOCK_ESTABLISHED)
1517  03f6 ae0308        	ldw	x,#776
1518  03f9 89            	pushw	x
1519  03fa ae0000        	ldw	x,#0
1520  03fd 89            	pushw	x
1521  03fe cd0000        	call	_WIZCHIP_READ
1523  0401 5b04          	addw	sp,#4
1524  0403 a117          	cp	a,#23
1525  0405 2703          	jreq	L221
1526  0407 cc0191        	jp	L753
1527  040a               L221:
1528                     ; 289                     break;
1530                     ; 291                 txbuf[0]=curr_state[0];
1532  040a 7b12          	ld	a,(OFST-3,sp)
1533  040c 6b0a          	ld	(OFST-11,sp),a
1535                     ; 292                 txbuf[1]=curr_state[1];
1537  040e 7b13          	ld	a,(OFST-2,sp)
1538  0410 6b0b          	ld	(OFST-10,sp),a
1540                     ; 293                 txbuf[2]=curr_state[2];
1542  0412 7b14          	ld	a,(OFST-1,sp)
1543  0414 6b0c          	ld	(OFST-9,sp),a
1545                     ; 294                 txbuf[3]=curr_state[3];
1547  0416 7b15          	ld	a,(OFST+0,sp)
1548  0418 6b0d          	ld	(OFST-8,sp),a
1550                     ; 295                 txbuf[4]='\r';
1552  041a a60d          	ld	a,#13
1553  041c 6b0e          	ld	(OFST-7,sp),a
1555                     ; 296                 txbuf[5]='\n';
1557  041e a60a          	ld	a,#10
1558  0420 6b0f          	ld	(OFST-6,sp),a
1560                     ; 298                 free = getSn_TX_FSR(SOCK_TCPS);
1562  0422 4f            	clr	a
1563  0423 cd0000        	call	_getSn_TX_FSR
1565  0426 1f10          	ldw	(OFST-5,sp),x
1567                     ; 300                 if(free >= 16)   // ✅ stronger safety
1569  0428 1e10          	ldw	x,(OFST-5,sp)
1570  042a a30010        	cpw	x,#16
1571  042d 2524          	jrult	L124
1572                     ; 302                     if(send(SOCK_TCPS, txbuf, 6) <= 0)
1574  042f 9c            	rvf
1575  0430 ae0006        	ldw	x,#6
1576  0433 89            	pushw	x
1577  0434 96            	ldw	x,sp
1578  0435 1c000c        	addw	x,#OFST-9
1579  0438 89            	pushw	x
1580  0439 4f            	clr	a
1581  043a cd0000        	call	_send
1583  043d 9c            	rvf
1584  043e 5b04          	addw	sp,#4
1585  0440 cd0000        	call	c_lrzmp
1587  0443 2c08          	jrsgt	L324
1588                     ; 304                         disconnect(SOCK_TCPS);   // ✅ safe recovery
1590  0445 4f            	clr	a
1591  0446 cd0000        	call	_disconnect
1593                     ; 305                         break;
1595  0449 ac910191      	jpf	L753
1596  044d               L324:
1597                     ; 308                     delay_ms(5);   // ✅ IMPORTANT
1599  044d ae0005        	ldw	x,#5
1600  0450 cd0000        	call	_delay_ms
1602  0453               L124:
1603                     ; 311                 prev_state[0]=curr_state[0];
1605  0453 7b12          	ld	a,(OFST-3,sp)
1606  0455 6b06          	ld	(OFST-15,sp),a
1608                     ; 312                 prev_state[1]=curr_state[1];
1610  0457 7b13          	ld	a,(OFST-2,sp)
1611  0459 6b07          	ld	(OFST-14,sp),a
1613                     ; 313                 prev_state[2]=curr_state[2];
1615  045b 7b14          	ld	a,(OFST-1,sp)
1616  045d 6b08          	ld	(OFST-13,sp),a
1618                     ; 314                 prev_state[3]=curr_state[3];
1620  045f 7b15          	ld	a,(OFST+0,sp)
1621  0461 6b09          	ld	(OFST-12,sp),a
1623  0463 ac910191      	jpf	L753
1624  0467               L132:
1625                     ; 320         case SOCK_CLOSE_WAIT:
1625                     ; 321             disconnect(SOCK_TCPS);
1627  0467 4f            	clr	a
1628  0468 cd0000        	call	_disconnect
1630                     ; 322             break;
1632  046b ac910191      	jpf	L753
1633  046f               L332:
1634                     ; 324         case SOCK_FIN_WAIT:
1634                     ; 325         case SOCK_CLOSING:
1634                     ; 326         case SOCK_TIME_WAIT:
1634                     ; 327         case SOCK_LAST_ACK:
1634                     ; 328             close(SOCK_TCPS);
1636  046f 4f            	clr	a
1637  0470 cd0000        	call	_close
1639                     ; 329             break;
1641  0473 ac910191      	jpf	L753
1642  0477               L532:
1643                     ; 331         default:
1643                     ; 332             break;
1645  0477 ac910191      	jpf	L753
1646  047b               L563:
1648  047b ac910191      	jpf	L753
1799                     	xdef	_main
1800                     	xdef	_GPIO_Config
1801                     	xdef	_W5500_Init
1802                     	xdef	_W5500_Reset
1803                     	xdef	_SPI_Config
1804                     	xdef	_spi_readbyte
1805                     	xdef	_spi_writebyte
1806                     	xdef	_wizchip_deselect
1807                     	xdef	_wizchip_select
1808                     	xdef	_delay_ms
1809                     	xdef	_netinfo
1810                     	switch	.ubsct
1811  0000               _rxbuf:
1812  0000 000000000000  	ds.b	32
1813                     	xdef	_rxbuf
1814                     	xdef	_changed
1815                     	xdef	_rxsize
1816                     	xdef	_txsize
1817                     	xref	_recv
1818                     	xref	_send
1819                     	xref	_disconnect
1820                     	xref	_listen
1821                     	xref	_close
1822                     	xref	_socket
1823                     	xref	_wizchip_setnetinfo
1824                     	xref	_wizchip_init
1825                     	xref	_reg_wizchip_spi_cbfunc
1826                     	xref	_reg_wizchip_cs_cbfunc
1827                     	xref	_getSn_RX_RSR
1828                     	xref	_getSn_TX_FSR
1829                     	xref	_WIZCHIP_WRITE
1830                     	xref	_WIZCHIP_READ
1831                     	xref	_CLK_HSIPrescalerConfig
1832                     	xref	_SPI_GetFlagStatus
1833                     	xref	_SPI_ReceiveData
1834                     	xref	_SPI_SendData
1835                     	xref	_SPI_Cmd
1836                     	xref	_SPI_Init
1837                     	xref	_SPI_DeInit
1838                     	xref	_GPIO_ReadInputPin
1839                     	xref	_GPIO_WriteLow
1840                     	xref	_GPIO_WriteHigh
1841                     	xref	_GPIO_Init
1842                     	xref.b	c_x
1862                     	xref	c_lrzmp
1863                     	xref	c_xymov
1864                     	end
