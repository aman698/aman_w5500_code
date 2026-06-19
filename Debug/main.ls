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
 114                     ; 54 void delay_ms(uint16_t ms)
 114                     ; 55 {
 116                     	switch	.text
 117  0000               _delay_ms:
 119  0000 89            	pushw	x
 120  0001 5204          	subw	sp,#4
 121       00000004      OFST:	set	4
 124                     ; 58     for(i=0;i<ms;i++)
 126  0003 5f            	clrw	x
 127  0004 1f01          	ldw	(OFST-3,sp),x
 130  0006 2018          	jra	L34
 131  0008               L73:
 132                     ; 60         for(j=0;j<500;j++);
 134  0008 5f            	clrw	x
 135  0009 1f03          	ldw	(OFST-1,sp),x
 137  000b               L74:
 141  000b 1e03          	ldw	x,(OFST-1,sp)
 142  000d 1c0001        	addw	x,#1
 143  0010 1f03          	ldw	(OFST-1,sp),x
 147  0012 1e03          	ldw	x,(OFST-1,sp)
 148  0014 a301f4        	cpw	x,#500
 149  0017 25f2          	jrult	L74
 150                     ; 58     for(i=0;i<ms;i++)
 152  0019 1e01          	ldw	x,(OFST-3,sp)
 153  001b 1c0001        	addw	x,#1
 154  001e 1f01          	ldw	(OFST-3,sp),x
 156  0020               L34:
 159  0020 1e01          	ldw	x,(OFST-3,sp)
 160  0022 1305          	cpw	x,(OFST+1,sp)
 161  0024 25e2          	jrult	L73
 162                     ; 62 }
 165  0026 5b06          	addw	sp,#6
 166  0028 81            	ret
 190                     ; 65 void wizchip_select(void)
 190                     ; 66 {
 191                     	switch	.text
 192  0029               _wizchip_select:
 196                     ; 67     GPIO_WriteLow(W5500_CS_PORT,W5500_CS_PIN);
 198  0029 4b08          	push	#8
 199  002b ae5000        	ldw	x,#20480
 200  002e cd0000        	call	_GPIO_WriteLow
 202  0031 84            	pop	a
 203                     ; 68 }
 206  0032 81            	ret
 230                     ; 70 void wizchip_deselect(void)
 230                     ; 71 {
 231                     	switch	.text
 232  0033               _wizchip_deselect:
 236                     ; 72     GPIO_WriteHigh(W5500_CS_PORT,W5500_CS_PIN);
 238  0033 4b08          	push	#8
 239  0035 ae5000        	ldw	x,#20480
 240  0038 cd0000        	call	_GPIO_WriteHigh
 242  003b 84            	pop	a
 243                     ; 73 }
 246  003c 81            	ret
 283                     ; 76 void spi_writebyte(uint8_t wb)
 283                     ; 77 {
 284                     	switch	.text
 285  003d               _spi_writebyte:
 289                     ; 78     SPI_SendData(wb);
 291  003d cd0000        	call	_SPI_SendData
 294  0040               L511:
 295                     ; 80     while(SPI_GetFlagStatus(SPI_FLAG_TXE)==RESET);
 297  0040 a602          	ld	a,#2
 298  0042 cd0000        	call	_SPI_GetFlagStatus
 300  0045 4d            	tnz	a
 301  0046 27f8          	jreq	L511
 303  0048               L321:
 304                     ; 82     while(SPI_GetFlagStatus(SPI_FLAG_RXNE)==RESET);
 306  0048 a601          	ld	a,#1
 307  004a cd0000        	call	_SPI_GetFlagStatus
 309  004d 4d            	tnz	a
 310  004e 27f8          	jreq	L321
 311                     ; 84     SPI_ReceiveData();
 313  0050 cd0000        	call	_SPI_ReceiveData
 315                     ; 85 }
 318  0053 81            	ret
 344                     ; 87 uint8_t spi_readbyte(void)
 344                     ; 88 {
 345                     	switch	.text
 346  0054               _spi_readbyte:
 350                     ; 89     SPI_SendData(0xFF);
 352  0054 a6ff          	ld	a,#255
 353  0056 cd0000        	call	_SPI_SendData
 356  0059               L141:
 357                     ; 91     while(SPI_GetFlagStatus(SPI_FLAG_RXNE)==RESET);
 359  0059 a601          	ld	a,#1
 360  005b cd0000        	call	_SPI_GetFlagStatus
 362  005e 4d            	tnz	a
 363  005f 27f8          	jreq	L141
 364                     ; 93     return SPI_ReceiveData();
 366  0061 cd0000        	call	_SPI_ReceiveData
 370  0064 81            	ret
 397                     ; 97 void SPI_Config(void)
 397                     ; 98 {
 398                     	switch	.text
 399  0065               _SPI_Config:
 403                     ; 99     GPIO_Init(GPIOC,GPIO_PIN_5,GPIO_MODE_OUT_PP_HIGH_FAST);
 405  0065 4bf0          	push	#240
 406  0067 4b20          	push	#32
 407  0069 ae500a        	ldw	x,#20490
 408  006c cd0000        	call	_GPIO_Init
 410  006f 85            	popw	x
 411                     ; 100     GPIO_Init(GPIOC,GPIO_PIN_6,GPIO_MODE_OUT_PP_HIGH_FAST);
 413  0070 4bf0          	push	#240
 414  0072 4b40          	push	#64
 415  0074 ae500a        	ldw	x,#20490
 416  0077 cd0000        	call	_GPIO_Init
 418  007a 85            	popw	x
 419                     ; 101     GPIO_Init(GPIOC,GPIO_PIN_7,GPIO_MODE_IN_FL_NO_IT);
 421  007b 4b00          	push	#0
 422  007d 4b80          	push	#128
 423  007f ae500a        	ldw	x,#20490
 424  0082 cd0000        	call	_GPIO_Init
 426  0085 85            	popw	x
 427                     ; 103     GPIO_Init(W5500_CS_PORT,W5500_CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
 429  0086 4bf0          	push	#240
 430  0088 4b08          	push	#8
 431  008a ae5000        	ldw	x,#20480
 432  008d cd0000        	call	_GPIO_Init
 434  0090 85            	popw	x
 435                     ; 105     SPI_DeInit();
 437  0091 cd0000        	call	_SPI_DeInit
 439                     ; 107     SPI_Init(
 439                     ; 108         SPI_FIRSTBIT_MSB,
 439                     ; 109         SPI_BAUDRATEPRESCALER_4,
 439                     ; 110         SPI_MODE_MASTER,
 439                     ; 111         SPI_CLOCKPOLARITY_LOW,
 439                     ; 112         SPI_CLOCKPHASE_1EDGE,
 439                     ; 113         SPI_DATADIRECTION_2LINES_FULLDUPLEX,
 439                     ; 114         SPI_NSS_SOFT,
 439                     ; 115         0x07);
 441  0094 4b07          	push	#7
 442  0096 4b02          	push	#2
 443  0098 4b00          	push	#0
 444  009a 4b00          	push	#0
 445  009c 4b00          	push	#0
 446  009e 4b04          	push	#4
 447  00a0 ae0008        	ldw	x,#8
 448  00a3 cd0000        	call	_SPI_Init
 450  00a6 5b06          	addw	sp,#6
 451                     ; 117     SPI_Cmd(ENABLE);
 453  00a8 a601          	ld	a,#1
 454  00aa cd0000        	call	_SPI_Cmd
 456                     ; 118 }
 459  00ad 81            	ret
 486                     ; 121 void W5500_Reset(void)
 486                     ; 122 {
 487                     	switch	.text
 488  00ae               _W5500_Reset:
 492                     ; 123     GPIO_Init(W5500_RST_PORT,
 492                     ; 124               W5500_RST_PIN,
 492                     ; 125               GPIO_MODE_OUT_PP_HIGH_FAST);
 494  00ae 4bf0          	push	#240
 495  00b0 4b20          	push	#32
 496  00b2 ae5014        	ldw	x,#20500
 497  00b5 cd0000        	call	_GPIO_Init
 499  00b8 85            	popw	x
 500                     ; 127     GPIO_WriteLow(W5500_RST_PORT,W5500_RST_PIN);
 502  00b9 4b20          	push	#32
 503  00bb ae5014        	ldw	x,#20500
 504  00be cd0000        	call	_GPIO_WriteLow
 506  00c1 84            	pop	a
 507                     ; 129     delay_ms(50);
 509  00c2 ae0032        	ldw	x,#50
 510  00c5 cd0000        	call	_delay_ms
 512                     ; 131     GPIO_WriteHigh(W5500_RST_PORT,W5500_RST_PIN);
 514  00c8 4b20          	push	#32
 515  00ca ae5014        	ldw	x,#20500
 516  00cd cd0000        	call	_GPIO_WriteHigh
 518  00d0 84            	pop	a
 519                     ; 133     delay_ms(200);
 521  00d1 ae00c8        	ldw	x,#200
 522  00d4 cd0000        	call	_delay_ms
 524                     ; 134 }
 527  00d7 81            	ret
 565                     ; 137 void W5500_Init(void)
 565                     ; 138 {
 566                     	switch	.text
 567  00d8               _W5500_Init:
 571                     ; 139     reg_wizchip_cs_cbfunc(wizchip_select,wizchip_deselect);
 573  00d8 ae0033        	ldw	x,#_wizchip_deselect
 574  00db 89            	pushw	x
 575  00dc ae0029        	ldw	x,#_wizchip_select
 576  00df cd0000        	call	_reg_wizchip_cs_cbfunc
 578  00e2 85            	popw	x
 579                     ; 141     reg_wizchip_spi_cbfunc(spi_readbyte,
 579                     ; 142                            spi_writebyte);
 581  00e3 ae003d        	ldw	x,#_spi_writebyte
 582  00e6 89            	pushw	x
 583  00e7 ae0054        	ldw	x,#_spi_readbyte
 584  00ea cd0000        	call	_reg_wizchip_spi_cbfunc
 586  00ed 85            	popw	x
 587                     ; 144     wizchip_init(txsize,rxsize);
 589  00ee ae0008        	ldw	x,#_rxsize
 590  00f1 89            	pushw	x
 591  00f2 ae0000        	ldw	x,#_txsize
 592  00f5 cd0000        	call	_wizchip_init
 594  00f8 85            	popw	x
 595                     ; 146     wizchip_setnetinfo(&netinfo);
 597  00f9 ae0010        	ldw	x,#_netinfo
 598  00fc cd0000        	call	_wizchip_setnetinfo
 600                     ; 147 }
 603  00ff 81            	ret
 650                     ; 150 void main(void)
 650                     ; 151 {
 651                     	switch	.text
 652  0100               _main:
 654  0100 89            	pushw	x
 655       00000002      OFST:	set	2
 658                     ; 154     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
 660  0101 4f            	clr	a
 661  0102 cd0000        	call	_CLK_HSIPrescalerConfig
 663                     ; 156     SPI_Config();
 665  0105 cd0065        	call	_SPI_Config
 667                     ; 158     W5500_Reset();
 669  0108 ada4          	call	_W5500_Reset
 671                     ; 160     W5500_Init();
 673  010a adcc          	call	_W5500_Init
 675  010c               L322:
 676                     ; 164         switch(getSn_SR(SOCK_TCPS))
 678  010c ae0308        	ldw	x,#776
 679  010f 89            	pushw	x
 680  0110 ae0000        	ldw	x,#0
 681  0113 89            	pushw	x
 682  0114 cd0000        	call	_WIZCHIP_READ
 684  0117 5b04          	addw	sp,#4
 686                     ; 215             break;
 687  0119 4d            	tnz	a
 688  011a 2711          	jreq	L571
 689  011c a013          	sub	a,#19
 690  011e 271d          	jreq	L771
 691  0120 a004          	sub	a,#4
 692  0122 271f          	jreq	L102
 693  0124 a005          	sub	a,#5
 694  0126 2603cc01bb    	jreq	L302
 695  012b 20df          	jra	L322
 696  012d               L571:
 697                     ; 166         case SOCK_CLOSED:
 697                     ; 167 
 697                     ; 168             socket(SOCK_TCPS,
 697                     ; 169                    Sn_MR_TCP,
 697                     ; 170                    TCP_PORT,
 697                     ; 171                    0);
 699  012d 4b00          	push	#0
 700  012f ae1388        	ldw	x,#5000
 701  0132 89            	pushw	x
 702  0133 ae0001        	ldw	x,#1
 703  0136 cd0000        	call	_socket
 705  0139 5b03          	addw	sp,#3
 706                     ; 173             break;
 708  013b 20cf          	jra	L322
 709  013d               L771:
 710                     ; 175         case SOCK_INIT:
 710                     ; 176 
 710                     ; 177             listen(SOCK_TCPS);
 712  013d 4f            	clr	a
 713  013e cd0000        	call	_listen
 715                     ; 179             break;
 717  0141 20c9          	jra	L322
 718  0143               L102:
 719                     ; 181         case SOCK_ESTABLISHED:
 719                     ; 182 
 719                     ; 183             if(getSn_IR(SOCK_TCPS)&Sn_IR_CON)
 721  0143 ae0208        	ldw	x,#520
 722  0146 89            	pushw	x
 723  0147 ae0000        	ldw	x,#0
 724  014a 89            	pushw	x
 725  014b cd0000        	call	_WIZCHIP_READ
 727  014e 5b04          	addw	sp,#4
 728  0150 a41f          	and	a,#31
 729  0152 a501          	bcp	a,#1
 730  0154 270f          	jreq	L332
 731                     ; 185                 setSn_IR(SOCK_TCPS,Sn_IR_CON);
 733  0156 4b01          	push	#1
 734  0158 ae0208        	ldw	x,#520
 735  015b 89            	pushw	x
 736  015c ae0000        	ldw	x,#0
 737  015f 89            	pushw	x
 738  0160 cd0000        	call	_WIZCHIP_WRITE
 740  0163 5b05          	addw	sp,#5
 741  0165               L332:
 742                     ; 188             len=getSn_RX_RSR(SOCK_TCPS);
 744  0165 4f            	clr	a
 745  0166 cd0000        	call	_getSn_RX_RSR
 747  0169 1f01          	ldw	(OFST-1,sp),x
 749                     ; 190             if(len>0)
 751  016b 1e01          	ldw	x,(OFST-1,sp)
 752  016d 279d          	jreq	L322
 753                     ; 192                 if(len>sizeof(rxbuf))
 755  016f 1e01          	ldw	x,(OFST-1,sp)
 756  0171 a30021        	cpw	x,#33
 757  0174 2505          	jrult	L732
 758                     ; 193                     len=sizeof(rxbuf);
 760  0176 ae0020        	ldw	x,#32
 761  0179 1f01          	ldw	(OFST-1,sp),x
 763  017b               L732:
 764                     ; 195                 recv(SOCK_TCPS,rxbuf,len);
 766  017b 1e01          	ldw	x,(OFST-1,sp)
 767  017d 89            	pushw	x
 768  017e ae0000        	ldw	x,#_rxbuf
 769  0181 89            	pushw	x
 770  0182 4f            	clr	a
 771  0183 cd0000        	call	_recv
 773  0186 5b04          	addw	sp,#4
 774                     ; 197                 if(rxbuf[0]=='h' &&
 774                     ; 198                    rxbuf[1]=='e' &&
 774                     ; 199                    rxbuf[2]=='l' &&
 774                     ; 200                    rxbuf[3]=='l' &&
 774                     ; 201                    rxbuf[4]=='o')
 776  0188 b600          	ld	a,_rxbuf
 777  018a a168          	cp	a,#104
 778  018c 26b3          	jrne	L322
 780  018e b601          	ld	a,_rxbuf+1
 781  0190 a165          	cp	a,#101
 782  0192 26ad          	jrne	L322
 784  0194 b602          	ld	a,_rxbuf+2
 785  0196 a16c          	cp	a,#108
 786  0198 26a7          	jrne	L322
 788  019a b603          	ld	a,_rxbuf+3
 789  019c a16c          	cp	a,#108
 790  019e 26a1          	jrne	L322
 792  01a0 b604          	ld	a,_rxbuf+4
 793  01a2 a16f          	cp	a,#111
 794  01a4 2703          	jreq	L62
 795  01a6 cc010c        	jp	L322
 796  01a9               L62:
 797                     ; 203                     send(SOCK_TCPS,
 797                     ; 204                          (uint8_t*)"HELLO RECEIVED\r\n",
 797                     ; 205                          16);
 799  01a9 ae0010        	ldw	x,#16
 800  01ac 89            	pushw	x
 801  01ad ae0000        	ldw	x,#L342
 802  01b0 89            	pushw	x
 803  01b1 4f            	clr	a
 804  01b2 cd0000        	call	_send
 806  01b5 5b04          	addw	sp,#4
 807  01b7 ac0c010c      	jpf	L322
 808  01bb               L302:
 809                     ; 211         case SOCK_CLOSE_WAIT:
 809                     ; 212 
 809                     ; 213             disconnect(SOCK_TCPS);
 811  01bb 4f            	clr	a
 812  01bc cd0000        	call	_disconnect
 814                     ; 215             break;
 816  01bf ac0c010c      	jpf	L322
 817  01c3               L132:
 819  01c3 ac0c010c      	jpf	L322
 961                     	xdef	_main
 962                     	xdef	_W5500_Init
 963                     	xdef	_W5500_Reset
 964                     	xdef	_SPI_Config
 965                     	xdef	_spi_readbyte
 966                     	xdef	_spi_writebyte
 967                     	xdef	_wizchip_deselect
 968                     	xdef	_wizchip_select
 969                     	xdef	_delay_ms
 970                     	xdef	_netinfo
 971                     	switch	.ubsct
 972  0000               _rxbuf:
 973  0000 000000000000  	ds.b	32
 974                     	xdef	_rxbuf
 975                     	xdef	_rxsize
 976                     	xdef	_txsize
 977                     	xref	_recv
 978                     	xref	_send
 979                     	xref	_disconnect
 980                     	xref	_listen
 981                     	xref	_socket
 982                     	xref	_wizchip_setnetinfo
 983                     	xref	_wizchip_init
 984                     	xref	_reg_wizchip_spi_cbfunc
 985                     	xref	_reg_wizchip_cs_cbfunc
 986                     	xref	_getSn_RX_RSR
 987                     	xref	_WIZCHIP_WRITE
 988                     	xref	_WIZCHIP_READ
 989                     	xref	_CLK_HSIPrescalerConfig
 990                     	xref	_SPI_GetFlagStatus
 991                     	xref	_SPI_ReceiveData
 992                     	xref	_SPI_SendData
 993                     	xref	_SPI_Cmd
 994                     	xref	_SPI_Init
 995                     	xref	_SPI_DeInit
 996                     	xref	_GPIO_WriteLow
 997                     	xref	_GPIO_WriteHigh
 998                     	xref	_GPIO_Init
 999                     .const:	section	.text
1000  0000               L342:
1001  0000 48454c4c4f20  	dc.b	"HELLO RECEIVED",13
1002  000f 0a00          	dc.b	10,0
1022                     	end
