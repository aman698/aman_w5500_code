   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               _txsize:
  16  0000 02            	dc.b	2
  17  0001 00            	dc.b	0
  18  0002 00            	dc.b	0
  19  0003 00            	dc.b	0
  20  0004 00            	dc.b	0
  21  0005 00            	dc.b	0
  22  0006 00            	dc.b	0
  23  0007 00            	dc.b	0
  24  0008               _rxsize:
  25  0008 02            	dc.b	2
  26  0009 00            	dc.b	0
  27  000a 00            	dc.b	0
  28  000b 00            	dc.b	0
  29  000c 00            	dc.b	0
  30  000d 00            	dc.b	0
  31  000e 00            	dc.b	0
  32  000f 00            	dc.b	0
  33  0010               _netinfo:
  34  0010 00            	dc.b	0
  35  0011 08            	dc.b	8
  36  0012 dc            	dc.b	220
  37  0013 11            	dc.b	17
  38  0014 22            	dc.b	34
  39  0015 33            	dc.b	51
  40  0016 c0            	dc.b	192
  41  0017 a8            	dc.b	168
  42  0018 64            	dc.b	100
  43  0019 6f            	dc.b	111
  44  001a ff            	dc.b	255
  45  001b ff            	dc.b	255
  46  001c ff            	dc.b	255
  47  001d 00            	dc.b	0
  48  001e c0            	dc.b	192
  49  001f a8            	dc.b	168
  50  0020 64            	dc.b	100
  51  0021 01            	dc.b	1
  52  0022 08            	dc.b	8
  53  0023 08            	dc.b	8
  54  0024 08            	dc.b	8
  55  0025 08            	dc.b	8
  56  0026 01            	dc.b	1
 114                     ; 58 void delay_ms(uint16_t ms)
 114                     ; 59 {
 116                     	switch	.text
 117  0000               _delay_ms:
 119  0000 89            	pushw	x
 120  0001 5204          	subw	sp,#4
 121       00000004      OFST:	set	4
 124                     ; 62     for(i=0;i<ms;i++)
 126  0003 5f            	clrw	x
 127  0004 1f01          	ldw	(OFST-3,sp),x
 130  0006 2018          	jra	L34
 131  0008               L73:
 132                     ; 64         for(j=0;j<500;j++);
 134  0008 5f            	clrw	x
 135  0009 1f03          	ldw	(OFST-1,sp),x
 137  000b               L74:
 141  000b 1e03          	ldw	x,(OFST-1,sp)
 142  000d 1c0001        	addw	x,#1
 143  0010 1f03          	ldw	(OFST-1,sp),x
 147  0012 1e03          	ldw	x,(OFST-1,sp)
 148  0014 a301f4        	cpw	x,#500
 149  0017 25f2          	jrult	L74
 150                     ; 62     for(i=0;i<ms;i++)
 152  0019 1e01          	ldw	x,(OFST-3,sp)
 153  001b 1c0001        	addw	x,#1
 154  001e 1f01          	ldw	(OFST-3,sp),x
 156  0020               L34:
 159  0020 1e01          	ldw	x,(OFST-3,sp)
 160  0022 1305          	cpw	x,(OFST+1,sp)
 161  0024 25e2          	jrult	L73
 162                     ; 66 }
 165  0026 5b06          	addw	sp,#6
 166  0028 81            	ret
 190                     ; 69 void wizchip_select(void)
 190                     ; 70 {
 191                     	switch	.text
 192  0029               _wizchip_select:
 196                     ; 71     GPIO_WriteLow(W5500_CS_PORT,W5500_CS_PIN);
 198  0029 4b08          	push	#8
 199  002b ae5000        	ldw	x,#20480
 200  002e cd0000        	call	_GPIO_WriteLow
 202  0031 84            	pop	a
 203                     ; 72 }
 206  0032 81            	ret
 230                     ; 74 void wizchip_deselect(void)
 230                     ; 75 {
 231                     	switch	.text
 232  0033               _wizchip_deselect:
 236                     ; 76     GPIO_WriteHigh(W5500_CS_PORT,W5500_CS_PIN);
 238  0033 4b08          	push	#8
 239  0035 ae5000        	ldw	x,#20480
 240  0038 cd0000        	call	_GPIO_WriteHigh
 242  003b 84            	pop	a
 243                     ; 77 }
 246  003c 81            	ret
 283                     ; 80 void spi_writebyte(uint8_t wb)
 283                     ; 81 {
 284                     	switch	.text
 285  003d               _spi_writebyte:
 289                     ; 82     SPI_SendData(wb);
 291  003d cd0000        	call	_SPI_SendData
 294  0040               L511:
 295                     ; 84     while(SPI_GetFlagStatus(SPI_FLAG_TXE)==RESET);
 297  0040 a602          	ld	a,#2
 298  0042 cd0000        	call	_SPI_GetFlagStatus
 300  0045 4d            	tnz	a
 301  0046 27f8          	jreq	L511
 303  0048               L321:
 304                     ; 86     while(SPI_GetFlagStatus(SPI_FLAG_RXNE)==RESET);
 306  0048 a601          	ld	a,#1
 307  004a cd0000        	call	_SPI_GetFlagStatus
 309  004d 4d            	tnz	a
 310  004e 27f8          	jreq	L321
 311                     ; 88     SPI_ReceiveData();
 313  0050 cd0000        	call	_SPI_ReceiveData
 315                     ; 89 }
 318  0053 81            	ret
 344                     ; 91 uint8_t spi_readbyte(void)
 344                     ; 92 {
 345                     	switch	.text
 346  0054               _spi_readbyte:
 350                     ; 93     SPI_SendData(0xFF);
 352  0054 a6ff          	ld	a,#255
 353  0056 cd0000        	call	_SPI_SendData
 356  0059               L141:
 357                     ; 95     while(SPI_GetFlagStatus(SPI_FLAG_RXNE)==RESET);
 359  0059 a601          	ld	a,#1
 360  005b cd0000        	call	_SPI_GetFlagStatus
 362  005e 4d            	tnz	a
 363  005f 27f8          	jreq	L141
 364                     ; 97     return SPI_ReceiveData();
 366  0061 cd0000        	call	_SPI_ReceiveData
 370  0064 81            	ret
 397                     ; 101 void SPI_Config(void)
 397                     ; 102 {
 398                     	switch	.text
 399  0065               _SPI_Config:
 403                     ; 103     GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_HIGH_FAST);
 405  0065 4bf0          	push	#240
 406  0067 4b20          	push	#32
 407  0069 ae500a        	ldw	x,#20490
 408  006c cd0000        	call	_GPIO_Init
 410  006f 85            	popw	x
 411                     ; 104     GPIO_Init(GPIOC,GPIO_PIN_6,GPIO_MODE_OUT_PP_HIGH_FAST);
 413  0070 4bf0          	push	#240
 414  0072 4b40          	push	#64
 415  0074 ae500a        	ldw	x,#20490
 416  0077 cd0000        	call	_GPIO_Init
 418  007a 85            	popw	x
 419                     ; 105     GPIO_Init(GPIOC,GPIO_PIN_7,GPIO_MODE_IN_FL_NO_IT);
 421  007b 4b00          	push	#0
 422  007d 4b80          	push	#128
 423  007f ae500a        	ldw	x,#20490
 424  0082 cd0000        	call	_GPIO_Init
 426  0085 85            	popw	x
 427                     ; 107     GPIO_Init(W5500_CS_PORT,W5500_CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
 429  0086 4bf0          	push	#240
 430  0088 4b08          	push	#8
 431  008a ae5000        	ldw	x,#20480
 432  008d cd0000        	call	_GPIO_Init
 434  0090 85            	popw	x
 435                     ; 109     SPI_DeInit();
 437  0091 cd0000        	call	_SPI_DeInit
 439                     ; 111     SPI_Init(
 439                     ; 112         SPI_FIRSTBIT_MSB,
 439                     ; 113         SPI_BAUDRATEPRESCALER_4,
 439                     ; 114         SPI_MODE_MASTER,
 439                     ; 115         SPI_CLOCKPOLARITY_LOW,
 439                     ; 116         SPI_CLOCKPHASE_1EDGE,
 439                     ; 117         SPI_DATADIRECTION_2LINES_FULLDUPLEX,
 439                     ; 118         SPI_NSS_SOFT,
 439                     ; 119         0x07);
 441  0094 4b07          	push	#7
 442  0096 4b02          	push	#2
 443  0098 4b00          	push	#0
 444  009a 4b00          	push	#0
 445  009c 4b00          	push	#0
 446  009e 4b04          	push	#4
 447  00a0 ae0008        	ldw	x,#8
 448  00a3 cd0000        	call	_SPI_Init
 450  00a6 5b06          	addw	sp,#6
 451                     ; 121     SPI_Cmd(ENABLE);
 453  00a8 a601          	ld	a,#1
 454  00aa cd0000        	call	_SPI_Cmd
 456                     ; 122 }
 459  00ad 81            	ret
 486                     ; 125 void W5500_Reset(void)
 486                     ; 126 {
 487                     	switch	.text
 488  00ae               _W5500_Reset:
 492                     ; 127     GPIO_Init(W5500_RST_PORT,
 492                     ; 128               W5500_RST_PIN,
 492                     ; 129               GPIO_MODE_OUT_PP_HIGH_FAST);
 494  00ae 4bf0          	push	#240
 495  00b0 4b20          	push	#32
 496  00b2 ae5014        	ldw	x,#20500
 497  00b5 cd0000        	call	_GPIO_Init
 499  00b8 85            	popw	x
 500                     ; 131     GPIO_WriteLow(W5500_RST_PORT,W5500_RST_PIN);
 502  00b9 4b20          	push	#32
 503  00bb ae5014        	ldw	x,#20500
 504  00be cd0000        	call	_GPIO_WriteLow
 506  00c1 84            	pop	a
 507                     ; 133     delay_ms(50);
 509  00c2 ae0032        	ldw	x,#50
 510  00c5 cd0000        	call	_delay_ms
 512                     ; 135     GPIO_WriteHigh(W5500_RST_PORT,W5500_RST_PIN);
 514  00c8 4b20          	push	#32
 515  00ca ae5014        	ldw	x,#20500
 516  00cd cd0000        	call	_GPIO_WriteHigh
 518  00d0 84            	pop	a
 519                     ; 137     delay_ms(200);
 521  00d1 ae00c8        	ldw	x,#200
 522  00d4 cd0000        	call	_delay_ms
 524                     ; 138 }
 527  00d7 81            	ret
 565                     ; 141 void W5500_Init(void)
 565                     ; 142 {
 566                     	switch	.text
 567  00d8               _W5500_Init:
 571                     ; 143     reg_wizchip_cs_cbfunc(wizchip_select,wizchip_deselect);
 573  00d8 ae0033        	ldw	x,#_wizchip_deselect
 574  00db 89            	pushw	x
 575  00dc ae0029        	ldw	x,#_wizchip_select
 576  00df cd0000        	call	_reg_wizchip_cs_cbfunc
 578  00e2 85            	popw	x
 579                     ; 145     reg_wizchip_spi_cbfunc(spi_readbyte,
 579                     ; 146                            spi_writebyte);
 581  00e3 ae003d        	ldw	x,#_spi_writebyte
 582  00e6 89            	pushw	x
 583  00e7 ae0054        	ldw	x,#_spi_readbyte
 584  00ea cd0000        	call	_reg_wizchip_spi_cbfunc
 586  00ed 85            	popw	x
 587                     ; 148     wizchip_init(txsize,rxsize);
 589  00ee ae0008        	ldw	x,#_rxsize
 590  00f1 89            	pushw	x
 591  00f2 ae0000        	ldw	x,#_txsize
 592  00f5 cd0000        	call	_wizchip_init
 594  00f8 85            	popw	x
 595                     ; 150     wizchip_setnetinfo(&netinfo);
 597  00f9 ae0010        	ldw	x,#_netinfo
 598  00fc cd0000        	call	_wizchip_setnetinfo
 600                     ; 151 }
 603  00ff 81            	ret
 627                     ; 152 void GPIO_Config(void)
 627                     ; 153 {
 628                     	switch	.text
 629  0100               _GPIO_Config:
 633                     ; 155     GPIO_Init(GPIOB, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // R1
 635  0100 4be0          	push	#224
 636  0102 4b08          	push	#8
 637  0104 ae5005        	ldw	x,#20485
 638  0107 cd0000        	call	_GPIO_Init
 640  010a 85            	popw	x
 641                     ; 156     GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // R2
 643  010b 4be0          	push	#224
 644  010d 4b04          	push	#4
 645  010f ae5005        	ldw	x,#20485
 646  0112 cd0000        	call	_GPIO_Init
 648  0115 85            	popw	x
 649                     ; 157     GPIO_Init(GPIOB, GPIO_PIN_1, GPIO_MODE_OUT_PP_LOW_FAST); // R3
 651  0116 4be0          	push	#224
 652  0118 4b02          	push	#2
 653  011a ae5005        	ldw	x,#20485
 654  011d cd0000        	call	_GPIO_Init
 656  0120 85            	popw	x
 657                     ; 158     GPIO_Init(GPIOB, GPIO_PIN_0, GPIO_MODE_OUT_PP_LOW_FAST); // R4
 659  0121 4be0          	push	#224
 660  0123 4b01          	push	#1
 661  0125 ae5005        	ldw	x,#20485
 662  0128 cd0000        	call	_GPIO_Init
 664  012b 85            	popw	x
 665                     ; 159     GPIO_Init(GPIOC, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // R5
 667  012c 4be0          	push	#224
 668  012e 4b08          	push	#8
 669  0130 ae500a        	ldw	x,#20490
 670  0133 cd0000        	call	_GPIO_Init
 672  0136 85            	popw	x
 673                     ; 160     GPIO_Init(GPIOC, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST); // R6
 675  0137 4be0          	push	#224
 676  0139 4b10          	push	#16
 677  013b ae500a        	ldw	x,#20490
 678  013e cd0000        	call	_GPIO_Init
 680  0141 85            	popw	x
 681                     ; 163     GPIO_Init(GPIOD, GPIO_PIN_2, GPIO_MODE_IN_PU_NO_IT); // DI1
 683  0142 4b40          	push	#64
 684  0144 4b04          	push	#4
 685  0146 ae500f        	ldw	x,#20495
 686  0149 cd0000        	call	_GPIO_Init
 688  014c 85            	popw	x
 689                     ; 164     GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_IN_PU_NO_IT); // DI2
 691  014d 4b40          	push	#64
 692  014f 4b08          	push	#8
 693  0151 ae500f        	ldw	x,#20495
 694  0154 cd0000        	call	_GPIO_Init
 696  0157 85            	popw	x
 697                     ; 165     GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_IN_PU_NO_IT); // DI3
 699  0158 4b40          	push	#64
 700  015a 4b10          	push	#16
 701  015c ae500f        	ldw	x,#20495
 702  015f cd0000        	call	_GPIO_Init
 704  0162 85            	popw	x
 705                     ; 166     GPIO_Init(GPIOD, GPIO_PIN_7, GPIO_MODE_IN_PU_NO_IT); // DI4
 707  0163 4b40          	push	#64
 708  0165 4b80          	push	#128
 709  0167 ae500f        	ldw	x,#20495
 710  016a cd0000        	call	_GPIO_Init
 712  016d 85            	popw	x
 713                     ; 167 }
 716  016e 81            	ret
 797                     ; 168 void main(void)
 797                     ; 169 {
 798                     	switch	.text
 799  016f               _main:
 801  016f 520a          	subw	sp,#10
 802       0000000a      OFST:	set	10
 805                     ; 172     uint8_t send_enable = 0;
 807  0171 0f0a          	clr	(OFST+0,sp)
 809                     ; 175     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
 811  0173 4f            	clr	a
 812  0174 cd0000        	call	_CLK_HSIPrescalerConfig
 814                     ; 177     SPI_Config();
 816  0177 cd0065        	call	_SPI_Config
 818                     ; 178     GPIO_Config();
 820  017a ad84          	call	_GPIO_Config
 822                     ; 180     W5500_Reset();
 824  017c cd00ae        	call	_W5500_Reset
 826                     ; 181     W5500_Init();
 828  017f cd00d8        	call	_W5500_Init
 830  0182               L152:
 831                     ; 185         switch(getSn_SR(SOCK_TCPS))
 833  0182 ae0308        	ldw	x,#776
 834  0185 89            	pushw	x
 835  0186 ae0000        	ldw	x,#0
 836  0189 89            	pushw	x
 837  018a cd0000        	call	_WIZCHIP_READ
 839  018d 5b04          	addw	sp,#4
 841                     ; 318             break;
 842  018f 4d            	tnz	a
 843  0190 2729          	jreq	L502
 844  0192 a013          	sub	a,#19
 845  0194 273b          	jreq	L702
 846  0196 a004          	sub	a,#4
 847  0198 273d          	jreq	L112
 848  019a 4a            	dec	a
 849  019b 2603          	jrne	L05
 850  019d cc04a8        	jp	L512
 851  01a0               L05:
 852  01a0 a002          	sub	a,#2
 853  01a2 2603          	jrne	L25
 854  01a4 cc04a8        	jp	L512
 855  01a7               L25:
 856  01a7 4a            	dec	a
 857  01a8 2603          	jrne	L45
 858  01aa cc04a8        	jp	L512
 859  01ad               L45:
 860  01ad 4a            	dec	a
 861  01ae 2603          	jrne	L65
 862  01b0 cc049a        	jp	L312
 863  01b3               L65:
 864  01b3 4a            	dec	a
 865  01b4 2603          	jrne	L06
 866  01b6 cc04a8        	jp	L512
 867  01b9               L06:
 868  01b9 20c7          	jra	L152
 869  01bb               L502:
 870                     ; 187         case SOCK_CLOSED:
 870                     ; 188 
 870                     ; 189             close(SOCK_TCPS);
 872  01bb 4f            	clr	a
 873  01bc cd0000        	call	_close
 875                     ; 190             socket(SOCK_TCPS, Sn_MR_TCP, TCP_PORT, 0);
 877  01bf 4b00          	push	#0
 878  01c1 ae1388        	ldw	x,#5000
 879  01c4 89            	pushw	x
 880  01c5 ae0001        	ldw	x,#1
 881  01c8 cd0000        	call	_socket
 883  01cb 5b03          	addw	sp,#3
 884                     ; 192             send_enable = 0;
 886  01cd 0f0a          	clr	(OFST+0,sp)
 888                     ; 194             break;
 890  01cf 20b1          	jra	L152
 891  01d1               L702:
 892                     ; 196         case SOCK_INIT:
 892                     ; 197 
 892                     ; 198             listen(SOCK_TCPS);
 894  01d1 4f            	clr	a
 895  01d2 cd0000        	call	_listen
 897                     ; 200             break;
 899  01d5 20ab          	jra	L152
 900  01d7               L112:
 901                     ; 202         case SOCK_ESTABLISHED:
 901                     ; 203 
 901                     ; 204             if(getSn_IR(SOCK_TCPS) & Sn_IR_CON)
 903  01d7 ae0208        	ldw	x,#520
 904  01da 89            	pushw	x
 905  01db ae0000        	ldw	x,#0
 906  01de 89            	pushw	x
 907  01df cd0000        	call	_WIZCHIP_READ
 909  01e2 5b04          	addw	sp,#4
 910  01e4 a41f          	and	a,#31
 911  01e6 a501          	bcp	a,#1
 912  01e8 270f          	jreq	L162
 913                     ; 206                 setSn_IR(SOCK_TCPS, Sn_IR_CON);
 915  01ea 4b01          	push	#1
 916  01ec ae0208        	ldw	x,#520
 917  01ef 89            	pushw	x
 918  01f0 ae0000        	ldw	x,#0
 919  01f3 89            	pushw	x
 920  01f4 cd0000        	call	_WIZCHIP_WRITE
 922  01f7 5b05          	addw	sp,#5
 923  01f9               L162:
 924                     ; 210             len = getSn_RX_RSR(SOCK_TCPS);
 926  01f9 4f            	clr	a
 927  01fa cd0000        	call	_getSn_RX_RSR
 929  01fd 1f01          	ldw	(OFST-9,sp),x
 931                     ; 212             if(len > 0)
 933  01ff 1e01          	ldw	x,(OFST-9,sp)
 934  0201 2603          	jrne	L26
 935  0203 cc040d        	jp	L362
 936  0206               L26:
 937                     ; 214                 if(len > sizeof(rxbuf))
 939  0206 1e01          	ldw	x,(OFST-9,sp)
 940  0208 a30021        	cpw	x,#33
 941  020b 2505          	jrult	L562
 942                     ; 215                     len = sizeof(rxbuf);
 944  020d ae0020        	ldw	x,#32
 945  0210 1f01          	ldw	(OFST-9,sp),x
 947  0212               L562:
 948                     ; 217                 for(i = 0; i < sizeof(rxbuf); i++)
 950  0212 0f03          	clr	(OFST-7,sp)
 952  0214               L762:
 953                     ; 218                     rxbuf[i] = 0;
 955  0214 7b03          	ld	a,(OFST-7,sp)
 956  0216 5f            	clrw	x
 957  0217 97            	ld	xl,a
 958  0218 6f00          	clr	(_rxbuf,x)
 959                     ; 217                 for(i = 0; i < sizeof(rxbuf); i++)
 961  021a 0c03          	inc	(OFST-7,sp)
 965  021c 7b03          	ld	a,(OFST-7,sp)
 966  021e a120          	cp	a,#32
 967  0220 25f2          	jrult	L762
 968                     ; 220                 recv(SOCK_TCPS, rxbuf, len);
 970  0222 1e01          	ldw	x,(OFST-9,sp)
 971  0224 89            	pushw	x
 972  0225 ae0000        	ldw	x,#_rxbuf
 973  0228 89            	pushw	x
 974  0229 4f            	clr	a
 975  022a cd0000        	call	_recv
 977  022d 5b04          	addw	sp,#4
 978                     ; 223                 if(rxbuf[0]=='o' && rxbuf[1]=='k' && rxbuf[2]=='k')
 980  022f b600          	ld	a,_rxbuf
 981  0231 a16f          	cp	a,#111
 982  0233 2612          	jrne	L572
 984  0235 b601          	ld	a,_rxbuf+1
 985  0237 a16b          	cp	a,#107
 986  0239 260c          	jrne	L572
 988  023b b602          	ld	a,_rxbuf+2
 989  023d a16b          	cp	a,#107
 990  023f 2606          	jrne	L572
 991                     ; 225                     send_enable = 0;
 993  0241 0f0a          	clr	(OFST+0,sp)
 996  0243 ac0d040d      	jpf	L362
 997  0247               L572:
 998                     ; 229                 else if(rxbuf[0]=='o' && rxbuf[1]=='k')
1000  0247 b600          	ld	a,_rxbuf
1001  0249 a16f          	cp	a,#111
1002  024b 260e          	jrne	L103
1004  024d b601          	ld	a,_rxbuf+1
1005  024f a16b          	cp	a,#107
1006  0251 2608          	jrne	L103
1007                     ; 231                     send_enable = 1;
1009  0253 a601          	ld	a,#1
1010  0255 6b0a          	ld	(OFST+0,sp),a
1013  0257 ac0d040d      	jpf	L362
1014  025b               L103:
1015                     ; 235                 else if(rxbuf[0]=='R' && rxbuf[1]=='1' && rxbuf[2]==',' && rxbuf[3]=='1')
1017  025b b600          	ld	a,_rxbuf
1018  025d a152          	cp	a,#82
1019  025f 261f          	jrne	L503
1021  0261 b601          	ld	a,_rxbuf+1
1022  0263 a131          	cp	a,#49
1023  0265 2619          	jrne	L503
1025  0267 b602          	ld	a,_rxbuf+2
1026  0269 a12c          	cp	a,#44
1027  026b 2613          	jrne	L503
1029  026d b603          	ld	a,_rxbuf+3
1030  026f a131          	cp	a,#49
1031  0271 260d          	jrne	L503
1032                     ; 236                     GPIO_WriteHigh(GPIOB, GPIO_PIN_3);
1034  0273 4b08          	push	#8
1035  0275 ae5005        	ldw	x,#20485
1036  0278 cd0000        	call	_GPIO_WriteHigh
1038  027b 84            	pop	a
1040  027c ac0d040d      	jpf	L362
1041  0280               L503:
1042                     ; 238                 else if(rxbuf[0]=='R' && rxbuf[1]=='1' && rxbuf[2]==',' && rxbuf[3]=='0')
1044  0280 b600          	ld	a,_rxbuf
1045  0282 a152          	cp	a,#82
1046  0284 261f          	jrne	L113
1048  0286 b601          	ld	a,_rxbuf+1
1049  0288 a131          	cp	a,#49
1050  028a 2619          	jrne	L113
1052  028c b602          	ld	a,_rxbuf+2
1053  028e a12c          	cp	a,#44
1054  0290 2613          	jrne	L113
1056  0292 b603          	ld	a,_rxbuf+3
1057  0294 a130          	cp	a,#48
1058  0296 260d          	jrne	L113
1059                     ; 239                     GPIO_WriteLow(GPIOB, GPIO_PIN_3);
1061  0298 4b08          	push	#8
1062  029a ae5005        	ldw	x,#20485
1063  029d cd0000        	call	_GPIO_WriteLow
1065  02a0 84            	pop	a
1067  02a1 ac0d040d      	jpf	L362
1068  02a5               L113:
1069                     ; 242                 else if(rxbuf[0]=='R' && rxbuf[1]=='2' && rxbuf[2]==',' && rxbuf[3]=='1')
1071  02a5 b600          	ld	a,_rxbuf
1072  02a7 a152          	cp	a,#82
1073  02a9 261f          	jrne	L513
1075  02ab b601          	ld	a,_rxbuf+1
1076  02ad a132          	cp	a,#50
1077  02af 2619          	jrne	L513
1079  02b1 b602          	ld	a,_rxbuf+2
1080  02b3 a12c          	cp	a,#44
1081  02b5 2613          	jrne	L513
1083  02b7 b603          	ld	a,_rxbuf+3
1084  02b9 a131          	cp	a,#49
1085  02bb 260d          	jrne	L513
1086                     ; 243                     GPIO_WriteHigh(GPIOB, GPIO_PIN_2);
1088  02bd 4b04          	push	#4
1089  02bf ae5005        	ldw	x,#20485
1090  02c2 cd0000        	call	_GPIO_WriteHigh
1092  02c5 84            	pop	a
1094  02c6 ac0d040d      	jpf	L362
1095  02ca               L513:
1096                     ; 245                 else if(rxbuf[0]=='R' && rxbuf[1]=='2' && rxbuf[2]==',' && rxbuf[3]=='0')
1098  02ca b600          	ld	a,_rxbuf
1099  02cc a152          	cp	a,#82
1100  02ce 261f          	jrne	L123
1102  02d0 b601          	ld	a,_rxbuf+1
1103  02d2 a132          	cp	a,#50
1104  02d4 2619          	jrne	L123
1106  02d6 b602          	ld	a,_rxbuf+2
1107  02d8 a12c          	cp	a,#44
1108  02da 2613          	jrne	L123
1110  02dc b603          	ld	a,_rxbuf+3
1111  02de a130          	cp	a,#48
1112  02e0 260d          	jrne	L123
1113                     ; 246                     GPIO_WriteLow(GPIOB, GPIO_PIN_2);
1115  02e2 4b04          	push	#4
1116  02e4 ae5005        	ldw	x,#20485
1117  02e7 cd0000        	call	_GPIO_WriteLow
1119  02ea 84            	pop	a
1121  02eb ac0d040d      	jpf	L362
1122  02ef               L123:
1123                     ; 249                 else if(rxbuf[0]=='R' && rxbuf[1]=='3' && rxbuf[2]==',' && rxbuf[3]=='1')
1125  02ef b600          	ld	a,_rxbuf
1126  02f1 a152          	cp	a,#82
1127  02f3 261f          	jrne	L523
1129  02f5 b601          	ld	a,_rxbuf+1
1130  02f7 a133          	cp	a,#51
1131  02f9 2619          	jrne	L523
1133  02fb b602          	ld	a,_rxbuf+2
1134  02fd a12c          	cp	a,#44
1135  02ff 2613          	jrne	L523
1137  0301 b603          	ld	a,_rxbuf+3
1138  0303 a131          	cp	a,#49
1139  0305 260d          	jrne	L523
1140                     ; 250                     GPIO_WriteHigh(GPIOB, GPIO_PIN_1);
1142  0307 4b02          	push	#2
1143  0309 ae5005        	ldw	x,#20485
1144  030c cd0000        	call	_GPIO_WriteHigh
1146  030f 84            	pop	a
1148  0310 ac0d040d      	jpf	L362
1149  0314               L523:
1150                     ; 252                 else if(rxbuf[0]=='R' && rxbuf[1]=='3' && rxbuf[2]==',' && rxbuf[3]=='0')
1152  0314 b600          	ld	a,_rxbuf
1153  0316 a152          	cp	a,#82
1154  0318 261f          	jrne	L133
1156  031a b601          	ld	a,_rxbuf+1
1157  031c a133          	cp	a,#51
1158  031e 2619          	jrne	L133
1160  0320 b602          	ld	a,_rxbuf+2
1161  0322 a12c          	cp	a,#44
1162  0324 2613          	jrne	L133
1164  0326 b603          	ld	a,_rxbuf+3
1165  0328 a130          	cp	a,#48
1166  032a 260d          	jrne	L133
1167                     ; 253                     GPIO_WriteLow(GPIOB, GPIO_PIN_1);
1169  032c 4b02          	push	#2
1170  032e ae5005        	ldw	x,#20485
1171  0331 cd0000        	call	_GPIO_WriteLow
1173  0334 84            	pop	a
1175  0335 ac0d040d      	jpf	L362
1176  0339               L133:
1177                     ; 256                 else if(rxbuf[0]=='R' && rxbuf[1]=='4' && rxbuf[2]==',' && rxbuf[3]=='1')
1179  0339 b600          	ld	a,_rxbuf
1180  033b a152          	cp	a,#82
1181  033d 261f          	jrne	L533
1183  033f b601          	ld	a,_rxbuf+1
1184  0341 a134          	cp	a,#52
1185  0343 2619          	jrne	L533
1187  0345 b602          	ld	a,_rxbuf+2
1188  0347 a12c          	cp	a,#44
1189  0349 2613          	jrne	L533
1191  034b b603          	ld	a,_rxbuf+3
1192  034d a131          	cp	a,#49
1193  034f 260d          	jrne	L533
1194                     ; 257                     GPIO_WriteHigh(GPIOB, GPIO_PIN_0);
1196  0351 4b01          	push	#1
1197  0353 ae5005        	ldw	x,#20485
1198  0356 cd0000        	call	_GPIO_WriteHigh
1200  0359 84            	pop	a
1202  035a ac0d040d      	jpf	L362
1203  035e               L533:
1204                     ; 259                 else if(rxbuf[0]=='R' && rxbuf[1]=='4' && rxbuf[2]==',' && rxbuf[3]=='0')
1206  035e b600          	ld	a,_rxbuf
1207  0360 a152          	cp	a,#82
1208  0362 261f          	jrne	L143
1210  0364 b601          	ld	a,_rxbuf+1
1211  0366 a134          	cp	a,#52
1212  0368 2619          	jrne	L143
1214  036a b602          	ld	a,_rxbuf+2
1215  036c a12c          	cp	a,#44
1216  036e 2613          	jrne	L143
1218  0370 b603          	ld	a,_rxbuf+3
1219  0372 a130          	cp	a,#48
1220  0374 260d          	jrne	L143
1221                     ; 260                     GPIO_WriteLow(GPIOB, GPIO_PIN_0);
1223  0376 4b01          	push	#1
1224  0378 ae5005        	ldw	x,#20485
1225  037b cd0000        	call	_GPIO_WriteLow
1227  037e 84            	pop	a
1229  037f ac0d040d      	jpf	L362
1230  0383               L143:
1231                     ; 263                 else if(rxbuf[0]=='R' && rxbuf[1]=='5' && rxbuf[2]==',' && rxbuf[3]=='1')
1233  0383 b600          	ld	a,_rxbuf
1234  0385 a152          	cp	a,#82
1235  0387 261d          	jrne	L543
1237  0389 b601          	ld	a,_rxbuf+1
1238  038b a135          	cp	a,#53
1239  038d 2617          	jrne	L543
1241  038f b602          	ld	a,_rxbuf+2
1242  0391 a12c          	cp	a,#44
1243  0393 2611          	jrne	L543
1245  0395 b603          	ld	a,_rxbuf+3
1246  0397 a131          	cp	a,#49
1247  0399 260b          	jrne	L543
1248                     ; 264                     GPIO_WriteHigh(GPIOC, GPIO_PIN_3);
1250  039b 4b08          	push	#8
1251  039d ae500a        	ldw	x,#20490
1252  03a0 cd0000        	call	_GPIO_WriteHigh
1254  03a3 84            	pop	a
1256  03a4 2067          	jra	L362
1257  03a6               L543:
1258                     ; 266                 else if(rxbuf[0]=='R' && rxbuf[1]=='5' && rxbuf[2]==',' && rxbuf[3]=='0')
1260  03a6 b600          	ld	a,_rxbuf
1261  03a8 a152          	cp	a,#82
1262  03aa 261d          	jrne	L153
1264  03ac b601          	ld	a,_rxbuf+1
1265  03ae a135          	cp	a,#53
1266  03b0 2617          	jrne	L153
1268  03b2 b602          	ld	a,_rxbuf+2
1269  03b4 a12c          	cp	a,#44
1270  03b6 2611          	jrne	L153
1272  03b8 b603          	ld	a,_rxbuf+3
1273  03ba a130          	cp	a,#48
1274  03bc 260b          	jrne	L153
1275                     ; 267                     GPIO_WriteLow(GPIOC, GPIO_PIN_3);
1277  03be 4b08          	push	#8
1278  03c0 ae500a        	ldw	x,#20490
1279  03c3 cd0000        	call	_GPIO_WriteLow
1281  03c6 84            	pop	a
1283  03c7 2044          	jra	L362
1284  03c9               L153:
1285                     ; 270                 else if(rxbuf[0]=='R' && rxbuf[1]=='6' && rxbuf[2]==',' && rxbuf[3]=='1')
1287  03c9 b600          	ld	a,_rxbuf
1288  03cb a152          	cp	a,#82
1289  03cd 261d          	jrne	L553
1291  03cf b601          	ld	a,_rxbuf+1
1292  03d1 a136          	cp	a,#54
1293  03d3 2617          	jrne	L553
1295  03d5 b602          	ld	a,_rxbuf+2
1296  03d7 a12c          	cp	a,#44
1297  03d9 2611          	jrne	L553
1299  03db b603          	ld	a,_rxbuf+3
1300  03dd a131          	cp	a,#49
1301  03df 260b          	jrne	L553
1302                     ; 271                     GPIO_WriteHigh(GPIOC, GPIO_PIN_4);
1304  03e1 4b10          	push	#16
1305  03e3 ae500a        	ldw	x,#20490
1306  03e6 cd0000        	call	_GPIO_WriteHigh
1308  03e9 84            	pop	a
1310  03ea 2021          	jra	L362
1311  03ec               L553:
1312                     ; 273                 else if(rxbuf[0]=='R' && rxbuf[1]=='6' && rxbuf[2]==',' && rxbuf[3]=='0')
1314  03ec b600          	ld	a,_rxbuf
1315  03ee a152          	cp	a,#82
1316  03f0 261b          	jrne	L362
1318  03f2 b601          	ld	a,_rxbuf+1
1319  03f4 a136          	cp	a,#54
1320  03f6 2615          	jrne	L362
1322  03f8 b602          	ld	a,_rxbuf+2
1323  03fa a12c          	cp	a,#44
1324  03fc 260f          	jrne	L362
1326  03fe b603          	ld	a,_rxbuf+3
1327  0400 a130          	cp	a,#48
1328  0402 2609          	jrne	L362
1329                     ; 274                     GPIO_WriteLow(GPIOC, GPIO_PIN_4);
1331  0404 4b10          	push	#16
1332  0406 ae500a        	ldw	x,#20490
1333  0409 cd0000        	call	_GPIO_WriteLow
1335  040c 84            	pop	a
1336  040d               L362:
1337                     ; 278             if(send_enable)
1339  040d 0d0a          	tnz	(OFST+0,sp)
1340  040f 2603          	jrne	L46
1341  0411 cc0182        	jp	L152
1342  0414               L46:
1343                     ; 280                 txbuf[0] = (GPIO_ReadInputPin(GPIOD, GPIO_PIN_2)==RESET)?'1':'0';
1345  0414 4b04          	push	#4
1346  0416 ae500f        	ldw	x,#20495
1347  0419 cd0000        	call	_GPIO_ReadInputPin
1349  041c 5b01          	addw	sp,#1
1350  041e 4d            	tnz	a
1351  041f 2604          	jrne	L03
1352  0421 a631          	ld	a,#49
1353  0423 2002          	jra	L23
1354  0425               L03:
1355  0425 a630          	ld	a,#48
1356  0427               L23:
1357  0427 6b04          	ld	(OFST-6,sp),a
1359                     ; 281                 txbuf[1] = (GPIO_ReadInputPin(GPIOD, GPIO_PIN_3)==RESET)?'1':'0';
1361  0429 4b08          	push	#8
1362  042b ae500f        	ldw	x,#20495
1363  042e cd0000        	call	_GPIO_ReadInputPin
1365  0431 5b01          	addw	sp,#1
1366  0433 4d            	tnz	a
1367  0434 2604          	jrne	L43
1368  0436 a631          	ld	a,#49
1369  0438 2002          	jra	L63
1370  043a               L43:
1371  043a a630          	ld	a,#48
1372  043c               L63:
1373  043c 6b05          	ld	(OFST-5,sp),a
1375                     ; 282                 txbuf[2] = (GPIO_ReadInputPin(GPIOD, GPIO_PIN_4)==RESET)?'1':'0';
1377  043e 4b10          	push	#16
1378  0440 ae500f        	ldw	x,#20495
1379  0443 cd0000        	call	_GPIO_ReadInputPin
1381  0446 5b01          	addw	sp,#1
1382  0448 4d            	tnz	a
1383  0449 2604          	jrne	L04
1384  044b a631          	ld	a,#49
1385  044d 2002          	jra	L24
1386  044f               L04:
1387  044f a630          	ld	a,#48
1388  0451               L24:
1389  0451 6b06          	ld	(OFST-4,sp),a
1391                     ; 283                 txbuf[3] = (GPIO_ReadInputPin(GPIOD, GPIO_PIN_7)==RESET)?'1':'0';
1393  0453 4b80          	push	#128
1394  0455 ae500f        	ldw	x,#20495
1395  0458 cd0000        	call	_GPIO_ReadInputPin
1397  045b 5b01          	addw	sp,#1
1398  045d 4d            	tnz	a
1399  045e 2604          	jrne	L44
1400  0460 a631          	ld	a,#49
1401  0462 2002          	jra	L64
1402  0464               L44:
1403  0464 a630          	ld	a,#48
1404  0466               L64:
1405  0466 6b07          	ld	(OFST-3,sp),a
1407                     ; 285                 txbuf[4] = '\r';
1409  0468 a60d          	ld	a,#13
1410  046a 6b08          	ld	(OFST-2,sp),a
1412                     ; 286                 txbuf[5] = '\n';
1414  046c a60a          	ld	a,#10
1415  046e 6b09          	ld	(OFST-1,sp),a
1417                     ; 288                 if(send(SOCK_TCPS, txbuf, 6) <= 0)
1419  0470 9c            	rvf
1420  0471 ae0006        	ldw	x,#6
1421  0474 89            	pushw	x
1422  0475 96            	ldw	x,sp
1423  0476 1c0006        	addw	x,#OFST-4
1424  0479 89            	pushw	x
1425  047a 4f            	clr	a
1426  047b cd0000        	call	_send
1428  047e 9c            	rvf
1429  047f 5b04          	addw	sp,#4
1430  0481 cd0000        	call	c_lrzmp
1432  0484 2c0a          	jrsgt	L563
1433                     ; 290                     disconnect(SOCK_TCPS);
1435  0486 4f            	clr	a
1436  0487 cd0000        	call	_disconnect
1438                     ; 291                     close(SOCK_TCPS);
1440  048a 4f            	clr	a
1441  048b cd0000        	call	_close
1443                     ; 292                     send_enable = 0;
1445  048e 0f0a          	clr	(OFST+0,sp)
1447  0490               L563:
1448                     ; 295                 delay_ms(500);
1450  0490 ae01f4        	ldw	x,#500
1451  0493 cd0000        	call	_delay_ms
1453  0496 ac820182      	jpf	L152
1454  049a               L312:
1455                     ; 300         case SOCK_CLOSE_WAIT:
1455                     ; 301 
1455                     ; 302             disconnect(SOCK_TCPS);
1457  049a 4f            	clr	a
1458  049b cd0000        	call	_disconnect
1460                     ; 303             close(SOCK_TCPS);
1462  049e 4f            	clr	a
1463  049f cd0000        	call	_close
1465                     ; 305             send_enable = 0;
1467  04a2 0f0a          	clr	(OFST+0,sp)
1469                     ; 307             break;
1471  04a4 ac820182      	jpf	L152
1472  04a8               L512:
1473                     ; 309         case SOCK_FIN_WAIT:
1473                     ; 310         case SOCK_CLOSING:
1473                     ; 311         case SOCK_TIME_WAIT:
1473                     ; 312         case SOCK_LAST_ACK:
1473                     ; 313 
1473                     ; 314             close(SOCK_TCPS);
1475  04a8 4f            	clr	a
1476  04a9 cd0000        	call	_close
1478                     ; 316             send_enable = 0;
1480  04ac 0f0a          	clr	(OFST+0,sp)
1482                     ; 318             break;
1484  04ae ac820182      	jpf	L152
1485  04b2               L752:
1487  04b2 ac820182      	jpf	L152
1629                     	xdef	_main
1630                     	xdef	_GPIO_Config
1631                     	xdef	_W5500_Init
1632                     	xdef	_W5500_Reset
1633                     	xdef	_SPI_Config
1634                     	xdef	_spi_readbyte
1635                     	xdef	_spi_writebyte
1636                     	xdef	_wizchip_deselect
1637                     	xdef	_wizchip_select
1638                     	xdef	_delay_ms
1639                     	xdef	_netinfo
1640                     	switch	.ubsct
1641  0000               _rxbuf:
1642  0000 000000000000  	ds.b	32
1643                     	xdef	_rxbuf
1644                     	xdef	_rxsize
1645                     	xdef	_txsize
1646                     	xref	_recv
1647                     	xref	_send
1648                     	xref	_disconnect
1649                     	xref	_listen
1650                     	xref	_close
1651                     	xref	_socket
1652                     	xref	_wizchip_setnetinfo
1653                     	xref	_wizchip_init
1654                     	xref	_reg_wizchip_spi_cbfunc
1655                     	xref	_reg_wizchip_cs_cbfunc
1656                     	xref	_getSn_RX_RSR
1657                     	xref	_WIZCHIP_WRITE
1658                     	xref	_WIZCHIP_READ
1659                     	xref	_CLK_HSIPrescalerConfig
1660                     	xref	_SPI_GetFlagStatus
1661                     	xref	_SPI_ReceiveData
1662                     	xref	_SPI_SendData
1663                     	xref	_SPI_Cmd
1664                     	xref	_SPI_Init
1665                     	xref	_SPI_DeInit
1666                     	xref	_GPIO_ReadInputPin
1667                     	xref	_GPIO_WriteLow
1668                     	xref	_GPIO_WriteHigh
1669                     	xref	_GPIO_Init
1689                     	xref	c_lrzmp
1690                     	end
