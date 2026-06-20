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
 796                     ; 168 void main(void)
 796                     ; 169 {
 797                     	switch	.text
 798  016f               _main:
 800  016f 520a          	subw	sp,#10
 801       0000000a      OFST:	set	10
 804                     ; 172     uint8_t send_enable = 0;
 806  0171 0f03          	clr	(OFST-7,sp)
 808                     ; 175     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
 810  0173 4f            	clr	a
 811  0174 cd0000        	call	_CLK_HSIPrescalerConfig
 813                     ; 177     SPI_Config();
 815  0177 cd0065        	call	_SPI_Config
 817                     ; 178     GPIO_Config();
 819  017a ad84          	call	_GPIO_Config
 821                     ; 180     W5500_Reset();
 823  017c cd00ae        	call	_W5500_Reset
 825                     ; 181     W5500_Init();
 827  017f cd00d8        	call	_W5500_Init
 829  0182               L742:
 830                     ; 185         switch(getSn_SR(SOCK_TCPS))
 832  0182 ae0308        	ldw	x,#776
 833  0185 89            	pushw	x
 834  0186 ae0000        	ldw	x,#0
 835  0189 89            	pushw	x
 836  018a cd0000        	call	_WIZCHIP_READ
 838  018d 5b04          	addw	sp,#4
 840                     ; 296             break;
 841  018f 4d            	tnz	a
 842  0190 2711          	jreq	L502
 843  0192 a013          	sub	a,#19
 844  0194 271f          	jreq	L702
 845  0196 a004          	sub	a,#4
 846  0198 2721          	jreq	L112
 847  019a a005          	sub	a,#5
 848  019c 2603          	jrne	L05
 849  019e cc046d        	jp	L312
 850  01a1               L05:
 851  01a1 20df          	jra	L742
 852  01a3               L502:
 853                     ; 187         case SOCK_CLOSED:
 853                     ; 188 
 853                     ; 189             socket(SOCK_TCPS, Sn_MR_TCP, TCP_PORT, 0);
 855  01a3 4b00          	push	#0
 856  01a5 ae1388        	ldw	x,#5000
 857  01a8 89            	pushw	x
 858  01a9 ae0001        	ldw	x,#1
 859  01ac cd0000        	call	_socket
 861  01af 5b03          	addw	sp,#3
 862                     ; 190             send_enable = 0;
 864  01b1 0f03          	clr	(OFST-7,sp)
 866                     ; 192             break;
 868  01b3 20cd          	jra	L742
 869  01b5               L702:
 870                     ; 194         case SOCK_INIT:
 870                     ; 195 
 870                     ; 196             listen(SOCK_TCPS);
 872  01b5 4f            	clr	a
 873  01b6 cd0000        	call	_listen
 875                     ; 198             break;
 877  01b9 20c7          	jra	L742
 878  01bb               L112:
 879                     ; 200         case SOCK_ESTABLISHED:
 879                     ; 201 
 879                     ; 202             if(getSn_IR(SOCK_TCPS) & Sn_IR_CON)
 881  01bb ae0208        	ldw	x,#520
 882  01be 89            	pushw	x
 883  01bf ae0000        	ldw	x,#0
 884  01c2 89            	pushw	x
 885  01c3 cd0000        	call	_WIZCHIP_READ
 887  01c6 5b04          	addw	sp,#4
 888  01c8 a41f          	and	a,#31
 889  01ca a501          	bcp	a,#1
 890  01cc 270f          	jreq	L752
 891                     ; 204                 setSn_IR(SOCK_TCPS, Sn_IR_CON);
 893  01ce 4b01          	push	#1
 894  01d0 ae0208        	ldw	x,#520
 895  01d3 89            	pushw	x
 896  01d4 ae0000        	ldw	x,#0
 897  01d7 89            	pushw	x
 898  01d8 cd0000        	call	_WIZCHIP_WRITE
 900  01db 5b05          	addw	sp,#5
 901  01dd               L752:
 902                     ; 207             len = getSn_RX_RSR(SOCK_TCPS);
 904  01dd 4f            	clr	a
 905  01de cd0000        	call	_getSn_RX_RSR
 907  01e1 1f01          	ldw	(OFST-9,sp),x
 909                     ; 209             if(len > 0)
 911  01e3 1e01          	ldw	x,(OFST-9,sp)
 912  01e5 2603          	jrne	L25
 913  01e7 cc03f1        	jp	L162
 914  01ea               L25:
 915                     ; 211                 if(len > sizeof(rxbuf))
 917  01ea 1e01          	ldw	x,(OFST-9,sp)
 918  01ec a30021        	cpw	x,#33
 919  01ef 2505          	jrult	L362
 920                     ; 212                     len = sizeof(rxbuf);
 922  01f1 ae0020        	ldw	x,#32
 923  01f4 1f01          	ldw	(OFST-9,sp),x
 925  01f6               L362:
 926                     ; 214                 for(i = 0; i < sizeof(rxbuf); i++)
 928  01f6 0f04          	clr	(OFST-6,sp)
 930  01f8               L562:
 931                     ; 215                     rxbuf[i] = 0;
 933  01f8 7b04          	ld	a,(OFST-6,sp)
 934  01fa 5f            	clrw	x
 935  01fb 97            	ld	xl,a
 936  01fc 6f00          	clr	(_rxbuf,x)
 937                     ; 214                 for(i = 0; i < sizeof(rxbuf); i++)
 939  01fe 0c04          	inc	(OFST-6,sp)
 943  0200 7b04          	ld	a,(OFST-6,sp)
 944  0202 a120          	cp	a,#32
 945  0204 25f2          	jrult	L562
 946                     ; 217                 recv(SOCK_TCPS, rxbuf, len);
 948  0206 1e01          	ldw	x,(OFST-9,sp)
 949  0208 89            	pushw	x
 950  0209 ae0000        	ldw	x,#_rxbuf
 951  020c 89            	pushw	x
 952  020d 4f            	clr	a
 953  020e cd0000        	call	_recv
 955  0211 5b04          	addw	sp,#4
 956                     ; 220                 if(rxbuf[0]=='o' && rxbuf[1]=='k' && rxbuf[2]=='k')
 958  0213 b600          	ld	a,_rxbuf
 959  0215 a16f          	cp	a,#111
 960  0217 2612          	jrne	L372
 962  0219 b601          	ld	a,_rxbuf+1
 963  021b a16b          	cp	a,#107
 964  021d 260c          	jrne	L372
 966  021f b602          	ld	a,_rxbuf+2
 967  0221 a16b          	cp	a,#107
 968  0223 2606          	jrne	L372
 969                     ; 222                     send_enable = 0;
 971  0225 0f03          	clr	(OFST-7,sp)
 974  0227 acf103f1      	jpf	L162
 975  022b               L372:
 976                     ; 226                 else if(rxbuf[0]=='o' && rxbuf[1]=='k')
 978  022b b600          	ld	a,_rxbuf
 979  022d a16f          	cp	a,#111
 980  022f 260e          	jrne	L772
 982  0231 b601          	ld	a,_rxbuf+1
 983  0233 a16b          	cp	a,#107
 984  0235 2608          	jrne	L772
 985                     ; 228                     send_enable = 1;
 987  0237 a601          	ld	a,#1
 988  0239 6b03          	ld	(OFST-7,sp),a
 991  023b acf103f1      	jpf	L162
 992  023f               L772:
 993                     ; 232                 else if(rxbuf[0]=='R' && rxbuf[1]=='1' && rxbuf[2]==',' && rxbuf[3]=='1')
 995  023f b600          	ld	a,_rxbuf
 996  0241 a152          	cp	a,#82
 997  0243 261f          	jrne	L303
 999  0245 b601          	ld	a,_rxbuf+1
1000  0247 a131          	cp	a,#49
1001  0249 2619          	jrne	L303
1003  024b b602          	ld	a,_rxbuf+2
1004  024d a12c          	cp	a,#44
1005  024f 2613          	jrne	L303
1007  0251 b603          	ld	a,_rxbuf+3
1008  0253 a131          	cp	a,#49
1009  0255 260d          	jrne	L303
1010                     ; 233                     GPIO_WriteHigh(GPIOB, GPIO_PIN_3);
1012  0257 4b08          	push	#8
1013  0259 ae5005        	ldw	x,#20485
1014  025c cd0000        	call	_GPIO_WriteHigh
1016  025f 84            	pop	a
1018  0260 acf103f1      	jpf	L162
1019  0264               L303:
1020                     ; 235                 else if(rxbuf[0]=='R' && rxbuf[1]=='1' && rxbuf[2]==',' && rxbuf[3]=='0')
1022  0264 b600          	ld	a,_rxbuf
1023  0266 a152          	cp	a,#82
1024  0268 261f          	jrne	L703
1026  026a b601          	ld	a,_rxbuf+1
1027  026c a131          	cp	a,#49
1028  026e 2619          	jrne	L703
1030  0270 b602          	ld	a,_rxbuf+2
1031  0272 a12c          	cp	a,#44
1032  0274 2613          	jrne	L703
1034  0276 b603          	ld	a,_rxbuf+3
1035  0278 a130          	cp	a,#48
1036  027a 260d          	jrne	L703
1037                     ; 236                     GPIO_WriteLow(GPIOB, GPIO_PIN_3);
1039  027c 4b08          	push	#8
1040  027e ae5005        	ldw	x,#20485
1041  0281 cd0000        	call	_GPIO_WriteLow
1043  0284 84            	pop	a
1045  0285 acf103f1      	jpf	L162
1046  0289               L703:
1047                     ; 239                 else if(rxbuf[0]=='R' && rxbuf[1]=='2' && rxbuf[2]==',' && rxbuf[3]=='1')
1049  0289 b600          	ld	a,_rxbuf
1050  028b a152          	cp	a,#82
1051  028d 261f          	jrne	L313
1053  028f b601          	ld	a,_rxbuf+1
1054  0291 a132          	cp	a,#50
1055  0293 2619          	jrne	L313
1057  0295 b602          	ld	a,_rxbuf+2
1058  0297 a12c          	cp	a,#44
1059  0299 2613          	jrne	L313
1061  029b b603          	ld	a,_rxbuf+3
1062  029d a131          	cp	a,#49
1063  029f 260d          	jrne	L313
1064                     ; 240                     GPIO_WriteHigh(GPIOB, GPIO_PIN_2);
1066  02a1 4b04          	push	#4
1067  02a3 ae5005        	ldw	x,#20485
1068  02a6 cd0000        	call	_GPIO_WriteHigh
1070  02a9 84            	pop	a
1072  02aa acf103f1      	jpf	L162
1073  02ae               L313:
1074                     ; 242                 else if(rxbuf[0]=='R' && rxbuf[1]=='2' && rxbuf[2]==',' && rxbuf[3]=='0')
1076  02ae b600          	ld	a,_rxbuf
1077  02b0 a152          	cp	a,#82
1078  02b2 261f          	jrne	L713
1080  02b4 b601          	ld	a,_rxbuf+1
1081  02b6 a132          	cp	a,#50
1082  02b8 2619          	jrne	L713
1084  02ba b602          	ld	a,_rxbuf+2
1085  02bc a12c          	cp	a,#44
1086  02be 2613          	jrne	L713
1088  02c0 b603          	ld	a,_rxbuf+3
1089  02c2 a130          	cp	a,#48
1090  02c4 260d          	jrne	L713
1091                     ; 243                     GPIO_WriteLow(GPIOB, GPIO_PIN_2);
1093  02c6 4b04          	push	#4
1094  02c8 ae5005        	ldw	x,#20485
1095  02cb cd0000        	call	_GPIO_WriteLow
1097  02ce 84            	pop	a
1099  02cf acf103f1      	jpf	L162
1100  02d3               L713:
1101                     ; 246                 else if(rxbuf[0]=='R' && rxbuf[1]=='3' && rxbuf[2]==',' && rxbuf[3]=='1')
1103  02d3 b600          	ld	a,_rxbuf
1104  02d5 a152          	cp	a,#82
1105  02d7 261f          	jrne	L323
1107  02d9 b601          	ld	a,_rxbuf+1
1108  02db a133          	cp	a,#51
1109  02dd 2619          	jrne	L323
1111  02df b602          	ld	a,_rxbuf+2
1112  02e1 a12c          	cp	a,#44
1113  02e3 2613          	jrne	L323
1115  02e5 b603          	ld	a,_rxbuf+3
1116  02e7 a131          	cp	a,#49
1117  02e9 260d          	jrne	L323
1118                     ; 247                     GPIO_WriteHigh(GPIOB, GPIO_PIN_1);
1120  02eb 4b02          	push	#2
1121  02ed ae5005        	ldw	x,#20485
1122  02f0 cd0000        	call	_GPIO_WriteHigh
1124  02f3 84            	pop	a
1126  02f4 acf103f1      	jpf	L162
1127  02f8               L323:
1128                     ; 249                 else if(rxbuf[0]=='R' && rxbuf[1]=='3' && rxbuf[2]==',' && rxbuf[3]=='0')
1130  02f8 b600          	ld	a,_rxbuf
1131  02fa a152          	cp	a,#82
1132  02fc 261f          	jrne	L723
1134  02fe b601          	ld	a,_rxbuf+1
1135  0300 a133          	cp	a,#51
1136  0302 2619          	jrne	L723
1138  0304 b602          	ld	a,_rxbuf+2
1139  0306 a12c          	cp	a,#44
1140  0308 2613          	jrne	L723
1142  030a b603          	ld	a,_rxbuf+3
1143  030c a130          	cp	a,#48
1144  030e 260d          	jrne	L723
1145                     ; 250                     GPIO_WriteLow(GPIOB, GPIO_PIN_1);
1147  0310 4b02          	push	#2
1148  0312 ae5005        	ldw	x,#20485
1149  0315 cd0000        	call	_GPIO_WriteLow
1151  0318 84            	pop	a
1153  0319 acf103f1      	jpf	L162
1154  031d               L723:
1155                     ; 253                 else if(rxbuf[0]=='R' && rxbuf[1]=='4' && rxbuf[2]==',' && rxbuf[3]=='1')
1157  031d b600          	ld	a,_rxbuf
1158  031f a152          	cp	a,#82
1159  0321 261f          	jrne	L333
1161  0323 b601          	ld	a,_rxbuf+1
1162  0325 a134          	cp	a,#52
1163  0327 2619          	jrne	L333
1165  0329 b602          	ld	a,_rxbuf+2
1166  032b a12c          	cp	a,#44
1167  032d 2613          	jrne	L333
1169  032f b603          	ld	a,_rxbuf+3
1170  0331 a131          	cp	a,#49
1171  0333 260d          	jrne	L333
1172                     ; 254                     GPIO_WriteHigh(GPIOB, GPIO_PIN_0);
1174  0335 4b01          	push	#1
1175  0337 ae5005        	ldw	x,#20485
1176  033a cd0000        	call	_GPIO_WriteHigh
1178  033d 84            	pop	a
1180  033e acf103f1      	jpf	L162
1181  0342               L333:
1182                     ; 256                 else if(rxbuf[0]=='R' && rxbuf[1]=='4' && rxbuf[2]==',' && rxbuf[3]=='0')
1184  0342 b600          	ld	a,_rxbuf
1185  0344 a152          	cp	a,#82
1186  0346 261f          	jrne	L733
1188  0348 b601          	ld	a,_rxbuf+1
1189  034a a134          	cp	a,#52
1190  034c 2619          	jrne	L733
1192  034e b602          	ld	a,_rxbuf+2
1193  0350 a12c          	cp	a,#44
1194  0352 2613          	jrne	L733
1196  0354 b603          	ld	a,_rxbuf+3
1197  0356 a130          	cp	a,#48
1198  0358 260d          	jrne	L733
1199                     ; 257                     GPIO_WriteLow(GPIOB, GPIO_PIN_0);
1201  035a 4b01          	push	#1
1202  035c ae5005        	ldw	x,#20485
1203  035f cd0000        	call	_GPIO_WriteLow
1205  0362 84            	pop	a
1207  0363 acf103f1      	jpf	L162
1208  0367               L733:
1209                     ; 260                 else if(rxbuf[0]=='R' && rxbuf[1]=='5' && rxbuf[2]==',' && rxbuf[3]=='1')
1211  0367 b600          	ld	a,_rxbuf
1212  0369 a152          	cp	a,#82
1213  036b 261d          	jrne	L343
1215  036d b601          	ld	a,_rxbuf+1
1216  036f a135          	cp	a,#53
1217  0371 2617          	jrne	L343
1219  0373 b602          	ld	a,_rxbuf+2
1220  0375 a12c          	cp	a,#44
1221  0377 2611          	jrne	L343
1223  0379 b603          	ld	a,_rxbuf+3
1224  037b a131          	cp	a,#49
1225  037d 260b          	jrne	L343
1226                     ; 261                     GPIO_WriteHigh(GPIOC, GPIO_PIN_3);
1228  037f 4b08          	push	#8
1229  0381 ae500a        	ldw	x,#20490
1230  0384 cd0000        	call	_GPIO_WriteHigh
1232  0387 84            	pop	a
1234  0388 2067          	jra	L162
1235  038a               L343:
1236                     ; 263                 else if(rxbuf[0]=='R' && rxbuf[1]=='5' && rxbuf[2]==',' && rxbuf[3]=='0')
1238  038a b600          	ld	a,_rxbuf
1239  038c a152          	cp	a,#82
1240  038e 261d          	jrne	L743
1242  0390 b601          	ld	a,_rxbuf+1
1243  0392 a135          	cp	a,#53
1244  0394 2617          	jrne	L743
1246  0396 b602          	ld	a,_rxbuf+2
1247  0398 a12c          	cp	a,#44
1248  039a 2611          	jrne	L743
1250  039c b603          	ld	a,_rxbuf+3
1251  039e a130          	cp	a,#48
1252  03a0 260b          	jrne	L743
1253                     ; 264                     GPIO_WriteLow(GPIOC, GPIO_PIN_3);
1255  03a2 4b08          	push	#8
1256  03a4 ae500a        	ldw	x,#20490
1257  03a7 cd0000        	call	_GPIO_WriteLow
1259  03aa 84            	pop	a
1261  03ab 2044          	jra	L162
1262  03ad               L743:
1263                     ; 267                 else if(rxbuf[0]=='R' && rxbuf[1]=='6' && rxbuf[2]==',' && rxbuf[3]=='1')
1265  03ad b600          	ld	a,_rxbuf
1266  03af a152          	cp	a,#82
1267  03b1 261d          	jrne	L353
1269  03b3 b601          	ld	a,_rxbuf+1
1270  03b5 a136          	cp	a,#54
1271  03b7 2617          	jrne	L353
1273  03b9 b602          	ld	a,_rxbuf+2
1274  03bb a12c          	cp	a,#44
1275  03bd 2611          	jrne	L353
1277  03bf b603          	ld	a,_rxbuf+3
1278  03c1 a131          	cp	a,#49
1279  03c3 260b          	jrne	L353
1280                     ; 268                     GPIO_WriteHigh(GPIOC, GPIO_PIN_4);
1282  03c5 4b10          	push	#16
1283  03c7 ae500a        	ldw	x,#20490
1284  03ca cd0000        	call	_GPIO_WriteHigh
1286  03cd 84            	pop	a
1288  03ce 2021          	jra	L162
1289  03d0               L353:
1290                     ; 270                 else if(rxbuf[0]=='R' && rxbuf[1]=='6' && rxbuf[2]==',' && rxbuf[3]=='0')
1292  03d0 b600          	ld	a,_rxbuf
1293  03d2 a152          	cp	a,#82
1294  03d4 261b          	jrne	L162
1296  03d6 b601          	ld	a,_rxbuf+1
1297  03d8 a136          	cp	a,#54
1298  03da 2615          	jrne	L162
1300  03dc b602          	ld	a,_rxbuf+2
1301  03de a12c          	cp	a,#44
1302  03e0 260f          	jrne	L162
1304  03e2 b603          	ld	a,_rxbuf+3
1305  03e4 a130          	cp	a,#48
1306  03e6 2609          	jrne	L162
1307                     ; 271                     GPIO_WriteLow(GPIOC, GPIO_PIN_4);
1309  03e8 4b10          	push	#16
1310  03ea ae500a        	ldw	x,#20490
1311  03ed cd0000        	call	_GPIO_WriteLow
1313  03f0 84            	pop	a
1314  03f1               L162:
1315                     ; 274             if(send_enable)
1317  03f1 0d03          	tnz	(OFST-7,sp)
1318  03f3 2603          	jrne	L45
1319  03f5 cc0182        	jp	L742
1320  03f8               L45:
1321                     ; 276                 txbuf[0] = (GPIO_ReadInputPin(GPIOD, GPIO_PIN_2)==RESET)?'1':'0';
1323  03f8 4b04          	push	#4
1324  03fa ae500f        	ldw	x,#20495
1325  03fd cd0000        	call	_GPIO_ReadInputPin
1327  0400 5b01          	addw	sp,#1
1328  0402 4d            	tnz	a
1329  0403 2604          	jrne	L03
1330  0405 a631          	ld	a,#49
1331  0407 2002          	jra	L23
1332  0409               L03:
1333  0409 a630          	ld	a,#48
1334  040b               L23:
1335  040b 6b05          	ld	(OFST-5,sp),a
1337                     ; 277                 txbuf[1] = (GPIO_ReadInputPin(GPIOD, GPIO_PIN_3)==RESET)?'1':'0';
1339  040d 4b08          	push	#8
1340  040f ae500f        	ldw	x,#20495
1341  0412 cd0000        	call	_GPIO_ReadInputPin
1343  0415 5b01          	addw	sp,#1
1344  0417 4d            	tnz	a
1345  0418 2604          	jrne	L43
1346  041a a631          	ld	a,#49
1347  041c 2002          	jra	L63
1348  041e               L43:
1349  041e a630          	ld	a,#48
1350  0420               L63:
1351  0420 6b06          	ld	(OFST-4,sp),a
1353                     ; 278                 txbuf[2] = (GPIO_ReadInputPin(GPIOD, GPIO_PIN_4)==RESET)?'1':'0';
1355  0422 4b10          	push	#16
1356  0424 ae500f        	ldw	x,#20495
1357  0427 cd0000        	call	_GPIO_ReadInputPin
1359  042a 5b01          	addw	sp,#1
1360  042c 4d            	tnz	a
1361  042d 2604          	jrne	L04
1362  042f a631          	ld	a,#49
1363  0431 2002          	jra	L24
1364  0433               L04:
1365  0433 a630          	ld	a,#48
1366  0435               L24:
1367  0435 6b07          	ld	(OFST-3,sp),a
1369                     ; 279                 txbuf[3] = (GPIO_ReadInputPin(GPIOD, GPIO_PIN_7)==RESET)?'1':'0';
1371  0437 4b80          	push	#128
1372  0439 ae500f        	ldw	x,#20495
1373  043c cd0000        	call	_GPIO_ReadInputPin
1375  043f 5b01          	addw	sp,#1
1376  0441 4d            	tnz	a
1377  0442 2604          	jrne	L44
1378  0444 a631          	ld	a,#49
1379  0446 2002          	jra	L64
1380  0448               L44:
1381  0448 a630          	ld	a,#48
1382  044a               L64:
1383  044a 6b08          	ld	(OFST-2,sp),a
1385                     ; 281                 txbuf[4] = '\r';
1387  044c a60d          	ld	a,#13
1388  044e 6b09          	ld	(OFST-1,sp),a
1390                     ; 282                 txbuf[5] = '\n';
1392  0450 a60a          	ld	a,#10
1393  0452 6b0a          	ld	(OFST+0,sp),a
1395                     ; 284                 send(SOCK_TCPS, txbuf, 6);
1397  0454 ae0006        	ldw	x,#6
1398  0457 89            	pushw	x
1399  0458 96            	ldw	x,sp
1400  0459 1c0007        	addw	x,#OFST-3
1401  045c 89            	pushw	x
1402  045d 4f            	clr	a
1403  045e cd0000        	call	_send
1405  0461 5b04          	addw	sp,#4
1406                     ; 286                 delay_ms(500);
1408  0463 ae01f4        	ldw	x,#500
1409  0466 cd0000        	call	_delay_ms
1411  0469 ac820182      	jpf	L742
1412  046d               L312:
1413                     ; 291         case SOCK_CLOSE_WAIT:
1413                     ; 292 
1413                     ; 293             disconnect(SOCK_TCPS);
1415  046d 4f            	clr	a
1416  046e cd0000        	call	_disconnect
1418                     ; 294             send_enable = 0;
1420  0471 0f03          	clr	(OFST-7,sp)
1422                     ; 296             break;
1424  0473 ac820182      	jpf	L742
1425  0477               L552:
1427  0477 ac820182      	jpf	L742
1569                     	xdef	_main
1570                     	xdef	_GPIO_Config
1571                     	xdef	_W5500_Init
1572                     	xdef	_W5500_Reset
1573                     	xdef	_SPI_Config
1574                     	xdef	_spi_readbyte
1575                     	xdef	_spi_writebyte
1576                     	xdef	_wizchip_deselect
1577                     	xdef	_wizchip_select
1578                     	xdef	_delay_ms
1579                     	xdef	_netinfo
1580                     	switch	.ubsct
1581  0000               _rxbuf:
1582  0000 000000000000  	ds.b	32
1583                     	xdef	_rxbuf
1584                     	xdef	_rxsize
1585                     	xdef	_txsize
1586                     	xref	_recv
1587                     	xref	_send
1588                     	xref	_disconnect
1589                     	xref	_listen
1590                     	xref	_socket
1591                     	xref	_wizchip_setnetinfo
1592                     	xref	_wizchip_init
1593                     	xref	_reg_wizchip_spi_cbfunc
1594                     	xref	_reg_wizchip_cs_cbfunc
1595                     	xref	_getSn_RX_RSR
1596                     	xref	_WIZCHIP_WRITE
1597                     	xref	_WIZCHIP_READ
1598                     	xref	_CLK_HSIPrescalerConfig
1599                     	xref	_SPI_GetFlagStatus
1600                     	xref	_SPI_ReceiveData
1601                     	xref	_SPI_SendData
1602                     	xref	_SPI_Cmd
1603                     	xref	_SPI_Init
1604                     	xref	_SPI_DeInit
1605                     	xref	_GPIO_ReadInputPin
1606                     	xref	_GPIO_WriteLow
1607                     	xref	_GPIO_WriteHigh
1608                     	xref	_GPIO_Init
1628                     	end
