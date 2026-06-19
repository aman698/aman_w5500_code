   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               L3_sock_any_port:
  16  0000 c000          	dc.w	-16384
  17  0002               L5_sock_io_mode:
  18  0002 0000          	dc.w	0
  19  0004               L7_sock_is_sending:
  20  0004 0000          	dc.w	0
  21  0006               L11_sock_remained_size:
  22  0006 0000          	dc.w	0
  23  0008 000000000000  	ds.b	14
  24  0016               _sock_pack_info:
  25  0016 00            	dc.b	0
  26  0017 000000000000  	ds.b	7
 111                     ; 21 int8_t socket(uint8_t sn, uint8_t protocol, uint16_t port, uint8_t flag) {
 113                     	switch	.text
 114  0000               _socket:
 116  0000 89            	pushw	x
 117  0001 5204          	subw	sp,#4
 118       00000004      OFST:	set	4
 121                     ; 22     CHECK_SOCKNUM();
 123  0003 7b05          	ld	a,(OFST+1,sp)
 124  0005 a108          	cp	a,#8
 125  0007 2504          	jrult	L77
 128  0009 a6ff          	ld	a,#255
 130  000b 200e          	jra	L22
 131  000d               L77:
 132                     ; 23     switch(protocol) {
 134  000d 7b06          	ld	a,(OFST+2,sp)
 136                     ; 33         default:
 136                     ; 34             return SOCKERR_SOCKMODE;
 137  000f 4a            	dec	a
 138  0010 270c          	jreq	L31
 139  0012 4a            	dec	a
 140  0013 272c          	jreq	L301
 141  0015 a002          	sub	a,#2
 142  0017 2728          	jreq	L301
 143  0019               L71:
 146  0019 a6fb          	ld	a,#251
 148  001b               L22:
 150  001b 5b06          	addw	sp,#6
 151  001d 81            	ret
 152  001e               L31:
 153                     ; 27                 getSIPR((uint8_t*)&taddr);
 155  001e ae0004        	ldw	x,#4
 156  0021 89            	pushw	x
 157  0022 96            	ldw	x,sp
 158  0023 1c0003        	addw	x,#OFST-1
 159  0026 89            	pushw	x
 160  0027 ae0f00        	ldw	x,#3840
 161  002a 89            	pushw	x
 162  002b ae0000        	ldw	x,#0
 163  002e 89            	pushw	x
 164  002f cd0000        	call	_WIZCHIP_READ_BUF
 166  0032 5b08          	addw	sp,#8
 167                     ; 28                 if(taddr == 0) return SOCKERR_SOCKINIT;
 169  0034 96            	ldw	x,sp
 170  0035 1c0001        	addw	x,#OFST-3
 171  0038 cd0000        	call	c_lzmp
 173  003b 2604          	jrne	L301
 176  003d a6fd          	ld	a,#253
 178  003f 20da          	jra	L22
 179  0041               L51:
 180                     ; 30         case Sn_MR_UDP:
 180                     ; 31         case Sn_MR_MACRAW:
 180                     ; 32             break;
 182  0041               L301:
 183                     ; 36     if((flag & 0x04) != 0) return SOCKERR_SOCKFLAG; // Invalid flag for W5500
 185  0041 7b0b          	ld	a,(OFST+7,sp)
 186  0043 a504          	bcp	a,#4
 187  0045 2704          	jreq	L701
 190  0047 a6fa          	ld	a,#250
 192  0049 20d0          	jra	L22
 193  004b               L701:
 194                     ; 38     if(flag != 0) {
 196  004b 0d0b          	tnz	(OFST+7,sp)
 197  004d 2734          	jreq	L111
 198                     ; 39         switch(protocol) {
 200  004f 7b06          	ld	a,(OFST+2,sp)
 202                     ; 51             default:
 202                     ; 52                 break;
 203  0051 4a            	dec	a
 204  0052 2705          	jreq	L12
 205  0054 4a            	dec	a
 206  0055 270c          	jreq	L32
 207  0057 202a          	jra	L111
 208  0059               L12:
 209                     ; 40             case Sn_MR_TCP:
 209                     ; 41                 if((flag & (SF_TCP_NODELAY|SF_IO_NONBLOCK))==0) return SOCKERR_SOCKFLAG;
 211  0059 7b0b          	ld	a,(OFST+7,sp)
 212  005b a521          	bcp	a,#33
 213  005d 2624          	jrne	L111
 216  005f a6fa          	ld	a,#250
 218  0061 20b8          	jra	L22
 219  0063               L32:
 220                     ; 43             case Sn_MR_UDP:
 220                     ; 44                 if(flag & SF_IGMP_VER2) {
 222  0063 7b0b          	ld	a,(OFST+7,sp)
 223  0065 a520          	bcp	a,#32
 224  0067 270a          	jreq	L121
 225                     ; 45                     if((flag & SF_MULTI_ENABLE)==0) return SOCKERR_SOCKFLAG;
 227  0069 7b0b          	ld	a,(OFST+7,sp)
 228  006b a580          	bcp	a,#128
 229  006d 2604          	jrne	L121
 232  006f a6fa          	ld	a,#250
 234  0071 20a8          	jra	L22
 235  0073               L121:
 236                     ; 47                 if(flag & SF_UNI_BLOCK) {
 238  0073 7b0b          	ld	a,(OFST+7,sp)
 239  0075 a510          	bcp	a,#16
 240  0077 270a          	jreq	L111
 241                     ; 48                     if((flag & SF_MULTI_ENABLE) == 0) return SOCKERR_SOCKFLAG;
 243  0079 7b0b          	ld	a,(OFST+7,sp)
 244  007b a580          	bcp	a,#128
 245  007d 2604          	jrne	L111
 248  007f a6fa          	ld	a,#250
 250  0081 2098          	jra	L22
 251  0083               L52:
 252                     ; 51             default:
 252                     ; 52                 break;
 254  0083               L511:
 255  0083               L111:
 256                     ; 55     close(sn);
 258  0083 7b05          	ld	a,(OFST+1,sp)
 259  0085 cd01ae        	call	_close
 261                     ; 56     setSn_MR(sn, (protocol | (flag & 0xF0)));
 263  0088 7b0b          	ld	a,(OFST+7,sp)
 264  008a a4f0          	and	a,#240
 265  008c 1a06          	or	a,(OFST+2,sp)
 266  008e 88            	push	a
 267  008f 7b06          	ld	a,(OFST+2,sp)
 268  0091 97            	ld	xl,a
 269  0092 a604          	ld	a,#4
 270  0094 42            	mul	x,a
 271  0095 58            	sllw	x
 272  0096 58            	sllw	x
 273  0097 58            	sllw	x
 274  0098 1c0008        	addw	x,#8
 275  009b cd0000        	call	c_itolx
 277  009e be02          	ldw	x,c_lreg+2
 278  00a0 89            	pushw	x
 279  00a1 be00          	ldw	x,c_lreg
 280  00a3 89            	pushw	x
 281  00a4 cd0000        	call	_WIZCHIP_WRITE
 283  00a7 5b05          	addw	sp,#5
 284                     ; 57     if(!port) {
 286  00a9 1e09          	ldw	x,(OFST+5,sp)
 287  00ab 2618          	jrne	L131
 288                     ; 58         port = sock_any_port++;
 290  00ad be00          	ldw	x,L3_sock_any_port
 291  00af 1c0001        	addw	x,#1
 292  00b2 bf00          	ldw	L3_sock_any_port,x
 293  00b4 1d0001        	subw	x,#1
 294  00b7 1f09          	ldw	(OFST+5,sp),x
 295                     ; 59         if(sock_any_port == 0xFFF0) sock_any_port = SOCK_ANY_PORT_NUM;
 297  00b9 be00          	ldw	x,L3_sock_any_port
 298  00bb a3fff0        	cpw	x,#65520
 299  00be 2605          	jrne	L131
 302  00c0 aec000        	ldw	x,#49152
 303  00c3 bf00          	ldw	L3_sock_any_port,x
 304  00c5               L131:
 305                     ; 61     setSn_PORT(sn, port);
 307  00c5 7b09          	ld	a,(OFST+5,sp)
 308  00c7 88            	push	a
 309  00c8 7b06          	ld	a,(OFST+2,sp)
 310  00ca 97            	ld	xl,a
 311  00cb a604          	ld	a,#4
 312  00cd 42            	mul	x,a
 313  00ce 58            	sllw	x
 314  00cf 58            	sllw	x
 315  00d0 58            	sllw	x
 316  00d1 1c0408        	addw	x,#1032
 317  00d4 cd0000        	call	c_itolx
 319  00d7 be02          	ldw	x,c_lreg+2
 320  00d9 89            	pushw	x
 321  00da be00          	ldw	x,c_lreg
 322  00dc 89            	pushw	x
 323  00dd cd0000        	call	_WIZCHIP_WRITE
 325  00e0 5b05          	addw	sp,#5
 328  00e2 7b0a          	ld	a,(OFST+6,sp)
 329  00e4 88            	push	a
 330  00e5 7b06          	ld	a,(OFST+2,sp)
 331  00e7 97            	ld	xl,a
 332  00e8 a604          	ld	a,#4
 333  00ea 42            	mul	x,a
 334  00eb 58            	sllw	x
 335  00ec 58            	sllw	x
 336  00ed 58            	sllw	x
 337  00ee 1c0508        	addw	x,#1288
 338  00f1 cd0000        	call	c_itolx
 340  00f4 be02          	ldw	x,c_lreg+2
 341  00f6 89            	pushw	x
 342  00f7 be00          	ldw	x,c_lreg
 343  00f9 89            	pushw	x
 344  00fa cd0000        	call	_WIZCHIP_WRITE
 346  00fd 5b05          	addw	sp,#5
 347                     ; 62     setSn_CR(sn, Sn_CR_OPEN);
 350  00ff 4b01          	push	#1
 351  0101 7b06          	ld	a,(OFST+2,sp)
 352  0103 97            	ld	xl,a
 353  0104 a604          	ld	a,#4
 354  0106 42            	mul	x,a
 355  0107 58            	sllw	x
 356  0108 58            	sllw	x
 357  0109 58            	sllw	x
 358  010a 1c0108        	addw	x,#264
 359  010d cd0000        	call	c_itolx
 361  0110 be02          	ldw	x,c_lreg+2
 362  0112 89            	pushw	x
 363  0113 be00          	ldw	x,c_lreg
 364  0115 89            	pushw	x
 365  0116 cd0000        	call	_WIZCHIP_WRITE
 367  0119 5b05          	addw	sp,#5
 369  011b               L731:
 370                     ; 63     while(getSn_CR(sn));
 372  011b 7b05          	ld	a,(OFST+1,sp)
 373  011d 97            	ld	xl,a
 374  011e a604          	ld	a,#4
 375  0120 42            	mul	x,a
 376  0121 58            	sllw	x
 377  0122 58            	sllw	x
 378  0123 58            	sllw	x
 379  0124 1c0108        	addw	x,#264
 380  0127 cd0000        	call	c_itolx
 382  012a be02          	ldw	x,c_lreg+2
 383  012c 89            	pushw	x
 384  012d be00          	ldw	x,c_lreg
 385  012f 89            	pushw	x
 386  0130 cd0000        	call	_WIZCHIP_READ
 388  0133 5b04          	addw	sp,#4
 389  0135 4d            	tnz	a
 390  0136 26e3          	jrne	L731
 391                     ; 64     sock_io_mode &= ~(1 << sn);
 393  0138 ae0001        	ldw	x,#1
 394  013b 7b05          	ld	a,(OFST+1,sp)
 395  013d 4d            	tnz	a
 396  013e 2704          	jreq	L6
 397  0140               L01:
 398  0140 58            	sllw	x
 399  0141 4a            	dec	a
 400  0142 26fc          	jrne	L01
 401  0144               L6:
 402  0144 53            	cplw	x
 403  0145 01            	rrwa	x,a
 404  0146 b403          	and	a,L5_sock_io_mode+1
 405  0148 01            	rrwa	x,a
 406  0149 b402          	and	a,L5_sock_io_mode
 407  014b 01            	rrwa	x,a
 408  014c bf02          	ldw	L5_sock_io_mode,x
 409                     ; 65     sock_io_mode |= ((flag & SF_IO_NONBLOCK) << sn);
 411  014e 7b0b          	ld	a,(OFST+7,sp)
 412  0150 a401          	and	a,#1
 413  0152 5f            	clrw	x
 414  0153 97            	ld	xl,a
 415  0154 7b05          	ld	a,(OFST+1,sp)
 416  0156 4d            	tnz	a
 417  0157 2704          	jreq	L21
 418  0159               L41:
 419  0159 58            	sllw	x
 420  015a 4a            	dec	a
 421  015b 26fc          	jrne	L41
 422  015d               L21:
 423  015d 01            	rrwa	x,a
 424  015e ba03          	or	a,L5_sock_io_mode+1
 425  0160 01            	rrwa	x,a
 426  0161 ba02          	or	a,L5_sock_io_mode
 427  0163 01            	rrwa	x,a
 428  0164 bf02          	ldw	L5_sock_io_mode,x
 429                     ; 66     sock_is_sending &= ~(1 << sn);
 431  0166 ae0001        	ldw	x,#1
 432  0169 7b05          	ld	a,(OFST+1,sp)
 433  016b 4d            	tnz	a
 434  016c 2704          	jreq	L61
 435  016e               L02:
 436  016e 58            	sllw	x
 437  016f 4a            	dec	a
 438  0170 26fc          	jrne	L02
 439  0172               L61:
 440  0172 53            	cplw	x
 441  0173 01            	rrwa	x,a
 442  0174 b405          	and	a,L7_sock_is_sending+1
 443  0176 01            	rrwa	x,a
 444  0177 b404          	and	a,L7_sock_is_sending
 445  0179 01            	rrwa	x,a
 446  017a bf04          	ldw	L7_sock_is_sending,x
 447                     ; 67     sock_remained_size[sn] = 0;
 449  017c 7b05          	ld	a,(OFST+1,sp)
 450  017e 5f            	clrw	x
 451  017f 97            	ld	xl,a
 452  0180 58            	sllw	x
 453  0181 905f          	clrw	y
 454  0183 ef06          	ldw	(L11_sock_remained_size,x),y
 455                     ; 68     sock_pack_info[sn] = 0;
 457  0185 7b05          	ld	a,(OFST+1,sp)
 458  0187 5f            	clrw	x
 459  0188 97            	ld	xl,a
 460  0189 6f16          	clr	(_sock_pack_info,x)
 462  018b               L741:
 463                     ; 69     while(getSn_SR(sn) == SOCK_CLOSED);
 465  018b 7b05          	ld	a,(OFST+1,sp)
 466  018d 97            	ld	xl,a
 467  018e a604          	ld	a,#4
 468  0190 42            	mul	x,a
 469  0191 58            	sllw	x
 470  0192 58            	sllw	x
 471  0193 58            	sllw	x
 472  0194 1c0308        	addw	x,#776
 473  0197 cd0000        	call	c_itolx
 475  019a be02          	ldw	x,c_lreg+2
 476  019c 89            	pushw	x
 477  019d be00          	ldw	x,c_lreg
 478  019f 89            	pushw	x
 479  01a0 cd0000        	call	_WIZCHIP_READ
 481  01a3 5b04          	addw	sp,#4
 482  01a5 4d            	tnz	a
 483  01a6 27e3          	jreq	L741
 484                     ; 70     return (int8_t)sn;
 486  01a8 7b05          	ld	a,(OFST+1,sp)
 488  01aa ac1b001b      	jpf	L22
 528                     ; 73 int8_t close(uint8_t sn) {
 529                     	switch	.text
 530  01ae               _close:
 532  01ae 88            	push	a
 533       00000000      OFST:	set	0
 536                     ; 74     CHECK_SOCKNUM();
 538  01af 7b01          	ld	a,(OFST+1,sp)
 539  01b1 a108          	cp	a,#8
 540  01b3 2505          	jrult	L571
 543  01b5 a6ff          	ld	a,#255
 546  01b7 5b01          	addw	sp,#1
 547  01b9 81            	ret
 548  01ba               L571:
 549                     ; 75     setSn_CR(sn, Sn_CR_CLOSE);
 551  01ba 4b10          	push	#16
 552  01bc 7b02          	ld	a,(OFST+2,sp)
 553  01be 97            	ld	xl,a
 554  01bf a604          	ld	a,#4
 555  01c1 42            	mul	x,a
 556  01c2 58            	sllw	x
 557  01c3 58            	sllw	x
 558  01c4 58            	sllw	x
 559  01c5 1c0108        	addw	x,#264
 560  01c8 cd0000        	call	c_itolx
 562  01cb be02          	ldw	x,c_lreg+2
 563  01cd 89            	pushw	x
 564  01ce be00          	ldw	x,c_lreg
 565  01d0 89            	pushw	x
 566  01d1 cd0000        	call	_WIZCHIP_WRITE
 568  01d4 5b05          	addw	sp,#5
 570  01d6               L102:
 571                     ; 76     while(getSn_CR(sn));
 573  01d6 7b01          	ld	a,(OFST+1,sp)
 574  01d8 97            	ld	xl,a
 575  01d9 a604          	ld	a,#4
 576  01db 42            	mul	x,a
 577  01dc 58            	sllw	x
 578  01dd 58            	sllw	x
 579  01de 58            	sllw	x
 580  01df 1c0108        	addw	x,#264
 581  01e2 cd0000        	call	c_itolx
 583  01e5 be02          	ldw	x,c_lreg+2
 584  01e7 89            	pushw	x
 585  01e8 be00          	ldw	x,c_lreg
 586  01ea 89            	pushw	x
 587  01eb cd0000        	call	_WIZCHIP_READ
 589  01ee 5b04          	addw	sp,#4
 590  01f0 4d            	tnz	a
 591  01f1 26e3          	jrne	L102
 592                     ; 77     setSn_IR(sn, 0xFF);
 594  01f3 4b1f          	push	#31
 595  01f5 7b02          	ld	a,(OFST+2,sp)
 596  01f7 97            	ld	xl,a
 597  01f8 a604          	ld	a,#4
 598  01fa 42            	mul	x,a
 599  01fb 58            	sllw	x
 600  01fc 58            	sllw	x
 601  01fd 58            	sllw	x
 602  01fe 1c0208        	addw	x,#520
 603  0201 cd0000        	call	c_itolx
 605  0204 be02          	ldw	x,c_lreg+2
 606  0206 89            	pushw	x
 607  0207 be00          	ldw	x,c_lreg
 608  0209 89            	pushw	x
 609  020a cd0000        	call	_WIZCHIP_WRITE
 611  020d 5b05          	addw	sp,#5
 612                     ; 78     sock_io_mode &= ~(1 << sn);
 614  020f ae0001        	ldw	x,#1
 615  0212 7b01          	ld	a,(OFST+1,sp)
 616  0214 4d            	tnz	a
 617  0215 2704          	jreq	L62
 618  0217               L03:
 619  0217 58            	sllw	x
 620  0218 4a            	dec	a
 621  0219 26fc          	jrne	L03
 622  021b               L62:
 623  021b 53            	cplw	x
 624  021c 01            	rrwa	x,a
 625  021d b403          	and	a,L5_sock_io_mode+1
 626  021f 01            	rrwa	x,a
 627  0220 b402          	and	a,L5_sock_io_mode
 628  0222 01            	rrwa	x,a
 629  0223 bf02          	ldw	L5_sock_io_mode,x
 630                     ; 79     sock_is_sending &= ~(1 << sn);
 632  0225 ae0001        	ldw	x,#1
 633  0228 7b01          	ld	a,(OFST+1,sp)
 634  022a 4d            	tnz	a
 635  022b 2704          	jreq	L23
 636  022d               L43:
 637  022d 58            	sllw	x
 638  022e 4a            	dec	a
 639  022f 26fc          	jrne	L43
 640  0231               L23:
 641  0231 53            	cplw	x
 642  0232 01            	rrwa	x,a
 643  0233 b405          	and	a,L7_sock_is_sending+1
 644  0235 01            	rrwa	x,a
 645  0236 b404          	and	a,L7_sock_is_sending
 646  0238 01            	rrwa	x,a
 647  0239 bf04          	ldw	L7_sock_is_sending,x
 648                     ; 80     sock_remained_size[sn] = 0;
 650  023b 7b01          	ld	a,(OFST+1,sp)
 651  023d 5f            	clrw	x
 652  023e 97            	ld	xl,a
 653  023f 58            	sllw	x
 654  0240 905f          	clrw	y
 655  0242 ef06          	ldw	(L11_sock_remained_size,x),y
 656                     ; 81     sock_pack_info[sn] = 0;
 658  0244 7b01          	ld	a,(OFST+1,sp)
 659  0246 5f            	clrw	x
 660  0247 97            	ld	xl,a
 661  0248 6f16          	clr	(_sock_pack_info,x)
 663  024a               L112:
 664                     ; 82     while(getSn_SR(sn) != SOCK_CLOSED);
 666  024a 7b01          	ld	a,(OFST+1,sp)
 667  024c 97            	ld	xl,a
 668  024d a604          	ld	a,#4
 669  024f 42            	mul	x,a
 670  0250 58            	sllw	x
 671  0251 58            	sllw	x
 672  0252 58            	sllw	x
 673  0253 1c0308        	addw	x,#776
 674  0256 cd0000        	call	c_itolx
 676  0259 be02          	ldw	x,c_lreg+2
 677  025b 89            	pushw	x
 678  025c be00          	ldw	x,c_lreg
 679  025e 89            	pushw	x
 680  025f cd0000        	call	_WIZCHIP_READ
 682  0262 5b04          	addw	sp,#4
 683  0264 4d            	tnz	a
 684  0265 26e3          	jrne	L112
 685                     ; 83     return SOCK_OK;
 687  0267 a601          	ld	a,#1
 690  0269 5b01          	addw	sp,#1
 691  026b 81            	ret
 728                     ; 86 int8_t listen(uint8_t sn) {
 729                     	switch	.text
 730  026c               _listen:
 732  026c 88            	push	a
 733       00000000      OFST:	set	0
 736                     ; 87     CHECK_SOCKNUM();
 738  026d 7b01          	ld	a,(OFST+1,sp)
 739  026f a108          	cp	a,#8
 740  0271 2505          	jrult	L142
 743  0273 a6ff          	ld	a,#255
 746  0275 5b01          	addw	sp,#1
 747  0277 81            	ret
 748  0278               L142:
 749                     ; 88     CHECK_SOCKMODE(Sn_MR_TCP);
 751  0278 7b01          	ld	a,(OFST+1,sp)
 752  027a 97            	ld	xl,a
 753  027b a604          	ld	a,#4
 754  027d 42            	mul	x,a
 755  027e 58            	sllw	x
 756  027f 58            	sllw	x
 757  0280 58            	sllw	x
 758  0281 1c0008        	addw	x,#8
 759  0284 cd0000        	call	c_itolx
 761  0287 be02          	ldw	x,c_lreg+2
 762  0289 89            	pushw	x
 763  028a be00          	ldw	x,c_lreg
 764  028c 89            	pushw	x
 765  028d cd0000        	call	_WIZCHIP_READ
 767  0290 5b04          	addw	sp,#4
 768  0292 a40f          	and	a,#15
 769  0294 a101          	cp	a,#1
 770  0296 2705          	jreq	L742
 773  0298 a6fb          	ld	a,#251
 776  029a 5b01          	addw	sp,#1
 777  029c 81            	ret
 778  029d               L742:
 779                     ; 89     CHECK_SOCKINIT();
 781  029d 7b01          	ld	a,(OFST+1,sp)
 782  029f 97            	ld	xl,a
 783  02a0 a604          	ld	a,#4
 784  02a2 42            	mul	x,a
 785  02a3 58            	sllw	x
 786  02a4 58            	sllw	x
 787  02a5 58            	sllw	x
 788  02a6 1c0308        	addw	x,#776
 789  02a9 cd0000        	call	c_itolx
 791  02ac be02          	ldw	x,c_lreg+2
 792  02ae 89            	pushw	x
 793  02af be00          	ldw	x,c_lreg
 794  02b1 89            	pushw	x
 795  02b2 cd0000        	call	_WIZCHIP_READ
 797  02b5 5b04          	addw	sp,#4
 798  02b7 a113          	cp	a,#19
 799  02b9 2705          	jreq	L352
 802  02bb a6fd          	ld	a,#253
 805  02bd 5b01          	addw	sp,#1
 806  02bf 81            	ret
 807  02c0               L352:
 808                     ; 90     setSn_CR(sn, Sn_CR_LISTEN);
 810  02c0 4b02          	push	#2
 811  02c2 7b02          	ld	a,(OFST+2,sp)
 812  02c4 97            	ld	xl,a
 813  02c5 a604          	ld	a,#4
 814  02c7 42            	mul	x,a
 815  02c8 58            	sllw	x
 816  02c9 58            	sllw	x
 817  02ca 58            	sllw	x
 818  02cb 1c0108        	addw	x,#264
 819  02ce cd0000        	call	c_itolx
 821  02d1 be02          	ldw	x,c_lreg+2
 822  02d3 89            	pushw	x
 823  02d4 be00          	ldw	x,c_lreg
 824  02d6 89            	pushw	x
 825  02d7 cd0000        	call	_WIZCHIP_WRITE
 827  02da 5b05          	addw	sp,#5
 829  02dc               L752:
 830                     ; 91     while(getSn_CR(sn));
 832  02dc 7b01          	ld	a,(OFST+1,sp)
 833  02de 97            	ld	xl,a
 834  02df a604          	ld	a,#4
 835  02e1 42            	mul	x,a
 836  02e2 58            	sllw	x
 837  02e3 58            	sllw	x
 838  02e4 58            	sllw	x
 839  02e5 1c0108        	addw	x,#264
 840  02e8 cd0000        	call	c_itolx
 842  02eb be02          	ldw	x,c_lreg+2
 843  02ed 89            	pushw	x
 844  02ee be00          	ldw	x,c_lreg
 845  02f0 89            	pushw	x
 846  02f1 cd0000        	call	_WIZCHIP_READ
 848  02f4 5b04          	addw	sp,#4
 849  02f6 4d            	tnz	a
 850  02f7 26e3          	jrne	L752
 852  02f9 200a          	jra	L562
 853  02fb               L362:
 854                     ; 93         close(sn);
 856  02fb 7b01          	ld	a,(OFST+1,sp)
 857  02fd cd01ae        	call	_close
 859                     ; 94         return SOCKERR_SOCKCLOSED;
 861  0300 a6fc          	ld	a,#252
 864  0302 5b01          	addw	sp,#1
 865  0304 81            	ret
 866  0305               L562:
 867                     ; 92     while(getSn_SR(sn) != SOCK_LISTEN) {
 869  0305 7b01          	ld	a,(OFST+1,sp)
 870  0307 97            	ld	xl,a
 871  0308 a604          	ld	a,#4
 872  030a 42            	mul	x,a
 873  030b 58            	sllw	x
 874  030c 58            	sllw	x
 875  030d 58            	sllw	x
 876  030e 1c0308        	addw	x,#776
 877  0311 cd0000        	call	c_itolx
 879  0314 be02          	ldw	x,c_lreg+2
 880  0316 89            	pushw	x
 881  0317 be00          	ldw	x,c_lreg
 882  0319 89            	pushw	x
 883  031a cd0000        	call	_WIZCHIP_READ
 885  031d 5b04          	addw	sp,#4
 886  031f a114          	cp	a,#20
 887  0321 26d8          	jrne	L362
 888                     ; 96     return SOCK_OK;
 890  0323 a601          	ld	a,#1
 893  0325 5b01          	addw	sp,#1
 894  0327 81            	ret
 933                     ; 100 int8_t disconnect(uint8_t sn)
 933                     ; 101 {
 934                     	switch	.text
 935  0328               _disconnect:
 937  0328 88            	push	a
 938       00000000      OFST:	set	0
 941                     ; 102    CHECK_SOCKNUM();
 943  0329 7b01          	ld	a,(OFST+1,sp)
 944  032b a108          	cp	a,#8
 945  032d 2505          	jrult	L513
 948  032f a6ff          	ld	a,#255
 951  0331 5b01          	addw	sp,#1
 952  0333 81            	ret
 953  0334               L513:
 954                     ; 103    CHECK_SOCKMODE(Sn_MR_TCP);
 956  0334 7b01          	ld	a,(OFST+1,sp)
 957  0336 97            	ld	xl,a
 958  0337 a604          	ld	a,#4
 959  0339 42            	mul	x,a
 960  033a 58            	sllw	x
 961  033b 58            	sllw	x
 962  033c 58            	sllw	x
 963  033d 1c0008        	addw	x,#8
 964  0340 cd0000        	call	c_itolx
 966  0343 be02          	ldw	x,c_lreg+2
 967  0345 89            	pushw	x
 968  0346 be00          	ldw	x,c_lreg
 969  0348 89            	pushw	x
 970  0349 cd0000        	call	_WIZCHIP_READ
 972  034c 5b04          	addw	sp,#4
 973  034e a40f          	and	a,#15
 974  0350 a101          	cp	a,#1
 975  0352 2705          	jreq	L123
 978  0354 a6fb          	ld	a,#251
 981  0356 5b01          	addw	sp,#1
 982  0358 81            	ret
 983  0359               L123:
 984                     ; 104 	setSn_CR(sn,Sn_CR_DISCON);
 986  0359 4b08          	push	#8
 987  035b 7b02          	ld	a,(OFST+2,sp)
 988  035d 97            	ld	xl,a
 989  035e a604          	ld	a,#4
 990  0360 42            	mul	x,a
 991  0361 58            	sllw	x
 992  0362 58            	sllw	x
 993  0363 58            	sllw	x
 994  0364 1c0108        	addw	x,#264
 995  0367 cd0000        	call	c_itolx
 997  036a be02          	ldw	x,c_lreg+2
 998  036c 89            	pushw	x
 999  036d be00          	ldw	x,c_lreg
1000  036f 89            	pushw	x
1001  0370 cd0000        	call	_WIZCHIP_WRITE
1003  0373 5b05          	addw	sp,#5
1005  0375               L523:
1006                     ; 106 	while(getSn_CR(sn));
1008  0375 7b01          	ld	a,(OFST+1,sp)
1009  0377 97            	ld	xl,a
1010  0378 a604          	ld	a,#4
1011  037a 42            	mul	x,a
1012  037b 58            	sllw	x
1013  037c 58            	sllw	x
1014  037d 58            	sllw	x
1015  037e 1c0108        	addw	x,#264
1016  0381 cd0000        	call	c_itolx
1018  0384 be02          	ldw	x,c_lreg+2
1019  0386 89            	pushw	x
1020  0387 be00          	ldw	x,c_lreg
1021  0389 89            	pushw	x
1022  038a cd0000        	call	_WIZCHIP_READ
1024  038d 5b04          	addw	sp,#4
1025  038f 4d            	tnz	a
1026  0390 26e3          	jrne	L523
1027                     ; 107 	sock_is_sending &= ~(1<<sn);
1029  0392 ae0001        	ldw	x,#1
1030  0395 7b01          	ld	a,(OFST+1,sp)
1031  0397 4d            	tnz	a
1032  0398 2704          	jreq	L24
1033  039a               L44:
1034  039a 58            	sllw	x
1035  039b 4a            	dec	a
1036  039c 26fc          	jrne	L44
1037  039e               L24:
1038  039e 53            	cplw	x
1039  039f 01            	rrwa	x,a
1040  03a0 b405          	and	a,L7_sock_is_sending+1
1041  03a2 01            	rrwa	x,a
1042  03a3 b404          	and	a,L7_sock_is_sending
1043  03a5 01            	rrwa	x,a
1044  03a6 bf04          	ldw	L7_sock_is_sending,x
1045                     ; 108    if(sock_io_mode & (1<<sn)) return SOCK_BUSY;
1047  03a8 ae0001        	ldw	x,#1
1048  03ab 7b01          	ld	a,(OFST+1,sp)
1049  03ad 4d            	tnz	a
1050  03ae 2704          	jreq	L64
1051  03b0               L05:
1052  03b0 58            	sllw	x
1053  03b1 4a            	dec	a
1054  03b2 26fc          	jrne	L05
1055  03b4               L64:
1056  03b4 01            	rrwa	x,a
1057  03b5 b403          	and	a,L5_sock_io_mode+1
1058  03b7 01            	rrwa	x,a
1059  03b8 b402          	and	a,L5_sock_io_mode
1060  03ba 01            	rrwa	x,a
1061  03bb a30000        	cpw	x,#0
1062  03be 272e          	jreq	L533
1065  03c0 4f            	clr	a
1068  03c1 5b01          	addw	sp,#1
1069  03c3 81            	ret
1070  03c4               L333:
1071                     ; 111 	   if(getSn_IR(sn) & Sn_IR_TIMEOUT)
1073  03c4 7b01          	ld	a,(OFST+1,sp)
1074  03c6 97            	ld	xl,a
1075  03c7 a604          	ld	a,#4
1076  03c9 42            	mul	x,a
1077  03ca 58            	sllw	x
1078  03cb 58            	sllw	x
1079  03cc 58            	sllw	x
1080  03cd 1c0208        	addw	x,#520
1081  03d0 cd0000        	call	c_itolx
1083  03d3 be02          	ldw	x,c_lreg+2
1084  03d5 89            	pushw	x
1085  03d6 be00          	ldw	x,c_lreg
1086  03d8 89            	pushw	x
1087  03d9 cd0000        	call	_WIZCHIP_READ
1089  03dc 5b04          	addw	sp,#4
1090  03de a41f          	and	a,#31
1091  03e0 a508          	bcp	a,#8
1092  03e2 270a          	jreq	L533
1093                     ; 113 	      close(sn);
1095  03e4 7b01          	ld	a,(OFST+1,sp)
1096  03e6 cd01ae        	call	_close
1098                     ; 114 	      return SOCKERR_TIMEOUT;
1100  03e9 a6f3          	ld	a,#243
1103  03eb 5b01          	addw	sp,#1
1104  03ed 81            	ret
1105  03ee               L533:
1106                     ; 109 	while(getSn_SR(sn) != SOCK_CLOSED)
1108  03ee 7b01          	ld	a,(OFST+1,sp)
1109  03f0 97            	ld	xl,a
1110  03f1 a604          	ld	a,#4
1111  03f3 42            	mul	x,a
1112  03f4 58            	sllw	x
1113  03f5 58            	sllw	x
1114  03f6 58            	sllw	x
1115  03f7 1c0308        	addw	x,#776
1116  03fa cd0000        	call	c_itolx
1118  03fd be02          	ldw	x,c_lreg+2
1119  03ff 89            	pushw	x
1120  0400 be00          	ldw	x,c_lreg
1121  0402 89            	pushw	x
1122  0403 cd0000        	call	_WIZCHIP_READ
1124  0406 5b04          	addw	sp,#4
1125  0408 4d            	tnz	a
1126  0409 26b9          	jrne	L333
1127                     ; 117 	return SOCK_OK;
1129  040b a601          	ld	a,#1
1132  040d 5b01          	addw	sp,#1
1133  040f 81            	ret
1211                     ; 120 int32_t send(uint8_t sn, uint8_t * buf, uint16_t len)
1211                     ; 121 {
1212                     	switch	.text
1213  0410               _send:
1215  0410 88            	push	a
1216  0411 5203          	subw	sp,#3
1217       00000003      OFST:	set	3
1220                     ; 122    uint8_t tmp=0;
1222                     ; 123    uint16_t freesize=0;
1224                     ; 125    CHECK_SOCKNUM();
1226  0413 7b04          	ld	a,(OFST+1,sp)
1227  0415 a108          	cp	a,#8
1228  0417 250c          	jrult	L704
1231  0419 aeffff        	ldw	x,#65535
1232  041c bf02          	ldw	c_lreg+2,x
1233  041e aeffff        	ldw	x,#-1
1234  0421 bf00          	ldw	c_lreg,x
1236  0423 202a          	jra	L47
1237  0425               L704:
1238                     ; 126    CHECK_SOCKMODE(Sn_MR_TCP);
1240  0425 7b04          	ld	a,(OFST+1,sp)
1241  0427 97            	ld	xl,a
1242  0428 a604          	ld	a,#4
1243  042a 42            	mul	x,a
1244  042b 58            	sllw	x
1245  042c 58            	sllw	x
1246  042d 58            	sllw	x
1247  042e 1c0008        	addw	x,#8
1248  0431 cd0000        	call	c_itolx
1250  0434 be02          	ldw	x,c_lreg+2
1251  0436 89            	pushw	x
1252  0437 be00          	ldw	x,c_lreg
1253  0439 89            	pushw	x
1254  043a cd0000        	call	_WIZCHIP_READ
1256  043d 5b04          	addw	sp,#4
1257  043f a40f          	and	a,#15
1258  0441 a101          	cp	a,#1
1259  0443 270d          	jreq	L514
1262  0445 aefffb        	ldw	x,#65531
1263  0448 bf02          	ldw	c_lreg+2,x
1264  044a aeffff        	ldw	x,#-1
1265  044d bf00          	ldw	c_lreg,x
1267  044f               L47:
1269  044f 5b04          	addw	sp,#4
1270  0451 81            	ret
1271  0452               L514:
1272                     ; 127    CHECK_SOCKDATA();
1274  0452 1e09          	ldw	x,(OFST+6,sp)
1275  0454 260c          	jrne	L124
1278  0456 aefff2        	ldw	x,#65522
1279  0459 bf02          	ldw	c_lreg+2,x
1280  045b aeffff        	ldw	x,#-1
1281  045e bf00          	ldw	c_lreg,x
1283  0460 20ed          	jra	L47
1284  0462               L124:
1285                     ; 128    tmp = getSn_SR(sn);
1287  0462 7b04          	ld	a,(OFST+1,sp)
1288  0464 97            	ld	xl,a
1289  0465 a604          	ld	a,#4
1290  0467 42            	mul	x,a
1291  0468 58            	sllw	x
1292  0469 58            	sllw	x
1293  046a 58            	sllw	x
1294  046b 1c0308        	addw	x,#776
1295  046e cd0000        	call	c_itolx
1297  0471 be02          	ldw	x,c_lreg+2
1298  0473 89            	pushw	x
1299  0474 be00          	ldw	x,c_lreg
1300  0476 89            	pushw	x
1301  0477 cd0000        	call	_WIZCHIP_READ
1303  047a 5b04          	addw	sp,#4
1304  047c 6b03          	ld	(OFST+0,sp),a
1306                     ; 129    if(tmp != SOCK_ESTABLISHED && tmp != SOCK_CLOSE_WAIT) return SOCKERR_SOCKSTATUS;
1308  047e 7b03          	ld	a,(OFST+0,sp)
1309  0480 a117          	cp	a,#23
1310  0482 2712          	jreq	L324
1312  0484 7b03          	ld	a,(OFST+0,sp)
1313  0486 a11c          	cp	a,#28
1314  0488 270c          	jreq	L324
1317  048a aefff9        	ldw	x,#65529
1318  048d bf02          	ldw	c_lreg+2,x
1319  048f aeffff        	ldw	x,#-1
1320  0492 bf00          	ldw	c_lreg,x
1322  0494 20b9          	jra	L47
1323  0496               L324:
1324                     ; 130    if( sock_is_sending & (1<<sn) )
1326  0496 ae0001        	ldw	x,#1
1327  0499 7b04          	ld	a,(OFST+1,sp)
1328  049b 4d            	tnz	a
1329  049c 2704          	jreq	L45
1330  049e               L65:
1331  049e 58            	sllw	x
1332  049f 4a            	dec	a
1333  04a0 26fc          	jrne	L65
1334  04a2               L45:
1335  04a2 01            	rrwa	x,a
1336  04a3 b405          	and	a,L7_sock_is_sending+1
1337  04a5 01            	rrwa	x,a
1338  04a6 b404          	and	a,L7_sock_is_sending
1339  04a8 01            	rrwa	x,a
1340  04a9 a30000        	cpw	x,#0
1341  04ac 2603          	jrne	L67
1342  04ae cc0530        	jp	L524
1343  04b1               L67:
1344                     ; 132       tmp = getSn_IR(sn);
1346  04b1 7b04          	ld	a,(OFST+1,sp)
1347  04b3 97            	ld	xl,a
1348  04b4 a604          	ld	a,#4
1349  04b6 42            	mul	x,a
1350  04b7 58            	sllw	x
1351  04b8 58            	sllw	x
1352  04b9 58            	sllw	x
1353  04ba 1c0208        	addw	x,#520
1354  04bd cd0000        	call	c_itolx
1356  04c0 be02          	ldw	x,c_lreg+2
1357  04c2 89            	pushw	x
1358  04c3 be00          	ldw	x,c_lreg
1359  04c5 89            	pushw	x
1360  04c6 cd0000        	call	_WIZCHIP_READ
1362  04c9 5b04          	addw	sp,#4
1363  04cb a41f          	and	a,#31
1364  04cd 6b03          	ld	(OFST+0,sp),a
1366                     ; 133       if(tmp & Sn_IR_SENDOK)
1368  04cf 7b03          	ld	a,(OFST+0,sp)
1369  04d1 a510          	bcp	a,#16
1370  04d3 2734          	jreq	L724
1371                     ; 135          setSn_IR(sn, Sn_IR_SENDOK);
1373  04d5 4b10          	push	#16
1374  04d7 7b05          	ld	a,(OFST+2,sp)
1375  04d9 97            	ld	xl,a
1376  04da a604          	ld	a,#4
1377  04dc 42            	mul	x,a
1378  04dd 58            	sllw	x
1379  04de 58            	sllw	x
1380  04df 58            	sllw	x
1381  04e0 1c0208        	addw	x,#520
1382  04e3 cd0000        	call	c_itolx
1384  04e6 be02          	ldw	x,c_lreg+2
1385  04e8 89            	pushw	x
1386  04e9 be00          	ldw	x,c_lreg
1387  04eb 89            	pushw	x
1388  04ec cd0000        	call	_WIZCHIP_WRITE
1390  04ef 5b05          	addw	sp,#5
1391                     ; 138          sock_is_sending &= ~(1<<sn);         
1393  04f1 ae0001        	ldw	x,#1
1394  04f4 7b04          	ld	a,(OFST+1,sp)
1395  04f6 4d            	tnz	a
1396  04f7 2704          	jreq	L06
1397  04f9               L26:
1398  04f9 58            	sllw	x
1399  04fa 4a            	dec	a
1400  04fb 26fc          	jrne	L26
1401  04fd               L06:
1402  04fd 53            	cplw	x
1403  04fe 01            	rrwa	x,a
1404  04ff b405          	and	a,L7_sock_is_sending+1
1405  0501 01            	rrwa	x,a
1406  0502 b404          	and	a,L7_sock_is_sending
1407  0504 01            	rrwa	x,a
1408  0505 bf04          	ldw	L7_sock_is_sending,x
1410  0507 2027          	jra	L524
1411  0509               L724:
1412                     ; 140       else if(tmp & Sn_IR_TIMEOUT)
1414  0509 7b03          	ld	a,(OFST+0,sp)
1415  050b a508          	bcp	a,#8
1416  050d 2713          	jreq	L334
1417                     ; 142          close(sn);
1419  050f 7b04          	ld	a,(OFST+1,sp)
1420  0511 cd01ae        	call	_close
1422                     ; 143          return SOCKERR_TIMEOUT;
1424  0514 aefff3        	ldw	x,#65523
1425  0517 bf02          	ldw	c_lreg+2,x
1426  0519 aeffff        	ldw	x,#-1
1427  051c bf00          	ldw	c_lreg,x
1429  051e ac4f044f      	jpf	L47
1430  0522               L334:
1431                     ; 145       else return SOCK_BUSY;
1433  0522 ae0000        	ldw	x,#0
1434  0525 bf02          	ldw	c_lreg+2,x
1435  0527 ae0000        	ldw	x,#0
1436  052a bf00          	ldw	c_lreg,x
1438  052c ac4f044f      	jpf	L47
1439  0530               L524:
1440                     ; 147    freesize = getSn_TxMAX(sn);
1442  0530 7b04          	ld	a,(OFST+1,sp)
1443  0532 97            	ld	xl,a
1444  0533 a604          	ld	a,#4
1445  0535 42            	mul	x,a
1446  0536 58            	sllw	x
1447  0537 58            	sllw	x
1448  0538 58            	sllw	x
1449  0539 1c1f08        	addw	x,#7944
1450  053c cd0000        	call	c_itolx
1452  053f be02          	ldw	x,c_lreg+2
1453  0541 89            	pushw	x
1454  0542 be00          	ldw	x,c_lreg
1455  0544 89            	pushw	x
1456  0545 cd0000        	call	_WIZCHIP_READ
1458  0548 5b04          	addw	sp,#4
1459  054a 5f            	clrw	x
1460  054b 97            	ld	xl,a
1461  054c 4f            	clr	a
1462  054d 02            	rlwa	x,a
1463  054e 58            	sllw	x
1464  054f 58            	sllw	x
1465  0550 1f01          	ldw	(OFST-2,sp),x
1467                     ; 148    if (len > freesize) len = freesize; // check size not to exceed MAX size.
1469  0552 1e09          	ldw	x,(OFST+6,sp)
1470  0554 1301          	cpw	x,(OFST-2,sp)
1471  0556 2304          	jrule	L144
1474  0558 1e01          	ldw	x,(OFST-2,sp)
1475  055a 1f09          	ldw	(OFST+6,sp),x
1476  055c               L144:
1477                     ; 151       freesize = getSn_TX_FSR(sn);
1479  055c 7b04          	ld	a,(OFST+1,sp)
1480  055e cd0000        	call	_getSn_TX_FSR
1482  0561 1f01          	ldw	(OFST-2,sp),x
1484                     ; 152       tmp = getSn_SR(sn);
1486  0563 7b04          	ld	a,(OFST+1,sp)
1487  0565 97            	ld	xl,a
1488  0566 a604          	ld	a,#4
1489  0568 42            	mul	x,a
1490  0569 58            	sllw	x
1491  056a 58            	sllw	x
1492  056b 58            	sllw	x
1493  056c 1c0308        	addw	x,#776
1494  056f cd0000        	call	c_itolx
1496  0572 be02          	ldw	x,c_lreg+2
1497  0574 89            	pushw	x
1498  0575 be00          	ldw	x,c_lreg
1499  0577 89            	pushw	x
1500  0578 cd0000        	call	_WIZCHIP_READ
1502  057b 5b04          	addw	sp,#4
1503  057d 6b03          	ld	(OFST+0,sp),a
1505                     ; 153       if ((tmp != SOCK_ESTABLISHED) && (tmp != SOCK_CLOSE_WAIT))
1507  057f 7b03          	ld	a,(OFST+0,sp)
1508  0581 a117          	cp	a,#23
1509  0583 2719          	jreq	L544
1511  0585 7b03          	ld	a,(OFST+0,sp)
1512  0587 a11c          	cp	a,#28
1513  0589 2713          	jreq	L544
1514                     ; 155          close(sn);
1516  058b 7b04          	ld	a,(OFST+1,sp)
1517  058d cd01ae        	call	_close
1519                     ; 156          return SOCKERR_SOCKSTATUS;
1521  0590 aefff9        	ldw	x,#65529
1522  0593 bf02          	ldw	c_lreg+2,x
1523  0595 aeffff        	ldw	x,#-1
1524  0598 bf00          	ldw	c_lreg,x
1526  059a ac4f044f      	jpf	L47
1527  059e               L544:
1528                     ; 158       if( (sock_io_mode & (1<<sn)) && (len > freesize) ) return SOCK_BUSY;
1530  059e ae0001        	ldw	x,#1
1531  05a1 7b04          	ld	a,(OFST+1,sp)
1532  05a3 4d            	tnz	a
1533  05a4 2704          	jreq	L46
1534  05a6               L66:
1535  05a6 58            	sllw	x
1536  05a7 4a            	dec	a
1537  05a8 26fc          	jrne	L66
1538  05aa               L46:
1539  05aa 01            	rrwa	x,a
1540  05ab b403          	and	a,L5_sock_io_mode+1
1541  05ad 01            	rrwa	x,a
1542  05ae b402          	and	a,L5_sock_io_mode
1543  05b0 01            	rrwa	x,a
1544  05b1 a30000        	cpw	x,#0
1545  05b4 2714          	jreq	L744
1547  05b6 1e09          	ldw	x,(OFST+6,sp)
1548  05b8 1301          	cpw	x,(OFST-2,sp)
1549  05ba 230e          	jrule	L744
1552  05bc ae0000        	ldw	x,#0
1553  05bf bf02          	ldw	c_lreg+2,x
1554  05c1 ae0000        	ldw	x,#0
1555  05c4 bf00          	ldw	c_lreg,x
1557  05c6 ac4f044f      	jpf	L47
1558  05ca               L744:
1559                     ; 159       if(len <= freesize) break;
1561  05ca 1e09          	ldw	x,(OFST+6,sp)
1562  05cc 1301          	cpw	x,(OFST-2,sp)
1563  05ce 228c          	jrugt	L144
1565                     ; 161    wiz_send_data(sn, buf, len);
1567  05d0 1e09          	ldw	x,(OFST+6,sp)
1568  05d2 89            	pushw	x
1569  05d3 1e09          	ldw	x,(OFST+6,sp)
1570  05d5 89            	pushw	x
1571  05d6 7b08          	ld	a,(OFST+5,sp)
1572  05d8 cd0000        	call	_wiz_send_data
1574  05db 5b04          	addw	sp,#4
1575                     ; 163    setSn_CR(sn,Sn_CR_SEND);
1577  05dd 4b20          	push	#32
1578  05df 7b05          	ld	a,(OFST+2,sp)
1579  05e1 97            	ld	xl,a
1580  05e2 a604          	ld	a,#4
1581  05e4 42            	mul	x,a
1582  05e5 58            	sllw	x
1583  05e6 58            	sllw	x
1584  05e7 58            	sllw	x
1585  05e8 1c0108        	addw	x,#264
1586  05eb cd0000        	call	c_itolx
1588  05ee be02          	ldw	x,c_lreg+2
1589  05f0 89            	pushw	x
1590  05f1 be00          	ldw	x,c_lreg
1591  05f3 89            	pushw	x
1592  05f4 cd0000        	call	_WIZCHIP_WRITE
1594  05f7 5b05          	addw	sp,#5
1596  05f9               L554:
1597                     ; 165    while(getSn_CR(sn));
1599  05f9 7b04          	ld	a,(OFST+1,sp)
1600  05fb 97            	ld	xl,a
1601  05fc a604          	ld	a,#4
1602  05fe 42            	mul	x,a
1603  05ff 58            	sllw	x
1604  0600 58            	sllw	x
1605  0601 58            	sllw	x
1606  0602 1c0108        	addw	x,#264
1607  0605 cd0000        	call	c_itolx
1609  0608 be02          	ldw	x,c_lreg+2
1610  060a 89            	pushw	x
1611  060b be00          	ldw	x,c_lreg
1612  060d 89            	pushw	x
1613  060e cd0000        	call	_WIZCHIP_READ
1615  0611 5b04          	addw	sp,#4
1616  0613 4d            	tnz	a
1617  0614 26e3          	jrne	L554
1618                     ; 166    sock_is_sending |= (1 << sn);
1620  0616 ae0001        	ldw	x,#1
1621  0619 7b04          	ld	a,(OFST+1,sp)
1622  061b 4d            	tnz	a
1623  061c 2704          	jreq	L07
1624  061e               L27:
1625  061e 58            	sllw	x
1626  061f 4a            	dec	a
1627  0620 26fc          	jrne	L27
1628  0622               L07:
1629  0622 01            	rrwa	x,a
1630  0623 ba05          	or	a,L7_sock_is_sending+1
1631  0625 01            	rrwa	x,a
1632  0626 ba04          	or	a,L7_sock_is_sending
1633  0628 01            	rrwa	x,a
1634  0629 bf04          	ldw	L7_sock_is_sending,x
1635                     ; 169    return (int32_t)len;
1637  062b 1e09          	ldw	x,(OFST+6,sp)
1638  062d cd0000        	call	c_uitolx
1641  0630 ac4f044f      	jpf	L47
1719                     ; 173 int32_t recv(uint8_t sn, uint8_t * buf, uint16_t len)
1719                     ; 174 {
1720                     	switch	.text
1721  0634               _recv:
1723  0634 88            	push	a
1724  0635 5205          	subw	sp,#5
1725       00000005      OFST:	set	5
1728                     ; 175    uint8_t  tmp = 0;
1730                     ; 176    uint16_t recvsize = 0;
1732                     ; 177    CHECK_SOCKNUM();
1734  0637 7b06          	ld	a,(OFST+1,sp)
1735  0639 a108          	cp	a,#8
1736  063b 250c          	jrult	L525
1739  063d aeffff        	ldw	x,#65535
1740  0640 bf02          	ldw	c_lreg+2,x
1741  0642 aeffff        	ldw	x,#-1
1742  0645 bf00          	ldw	c_lreg,x
1744  0647 202a          	jra	L601
1745  0649               L525:
1746                     ; 178    CHECK_SOCKMODE(Sn_MR_TCP);
1748  0649 7b06          	ld	a,(OFST+1,sp)
1749  064b 97            	ld	xl,a
1750  064c a604          	ld	a,#4
1751  064e 42            	mul	x,a
1752  064f 58            	sllw	x
1753  0650 58            	sllw	x
1754  0651 58            	sllw	x
1755  0652 1c0008        	addw	x,#8
1756  0655 cd0000        	call	c_itolx
1758  0658 be02          	ldw	x,c_lreg+2
1759  065a 89            	pushw	x
1760  065b be00          	ldw	x,c_lreg
1761  065d 89            	pushw	x
1762  065e cd0000        	call	_WIZCHIP_READ
1764  0661 5b04          	addw	sp,#4
1765  0663 a40f          	and	a,#15
1766  0665 a101          	cp	a,#1
1767  0667 270d          	jreq	L335
1770  0669 aefffb        	ldw	x,#65531
1771  066c bf02          	ldw	c_lreg+2,x
1772  066e aeffff        	ldw	x,#-1
1773  0671 bf00          	ldw	c_lreg,x
1775  0673               L601:
1777  0673 5b06          	addw	sp,#6
1778  0675 81            	ret
1779  0676               L335:
1780                     ; 179    CHECK_SOCKDATA();
1782  0676 1e0b          	ldw	x,(OFST+6,sp)
1783  0678 260c          	jrne	L735
1786  067a aefff2        	ldw	x,#65522
1787  067d bf02          	ldw	c_lreg+2,x
1788  067f aeffff        	ldw	x,#-1
1789  0682 bf00          	ldw	c_lreg,x
1791  0684 20ed          	jra	L601
1792  0686               L735:
1793                     ; 181    recvsize = getSn_RxMAX(sn);
1795  0686 7b06          	ld	a,(OFST+1,sp)
1796  0688 97            	ld	xl,a
1797  0689 a604          	ld	a,#4
1798  068b 42            	mul	x,a
1799  068c 58            	sllw	x
1800  068d 58            	sllw	x
1801  068e 58            	sllw	x
1802  068f 1c1e08        	addw	x,#7688
1803  0692 cd0000        	call	c_itolx
1805  0695 be02          	ldw	x,c_lreg+2
1806  0697 89            	pushw	x
1807  0698 be00          	ldw	x,c_lreg
1808  069a 89            	pushw	x
1809  069b cd0000        	call	_WIZCHIP_READ
1811  069e 5b04          	addw	sp,#4
1812  06a0 5f            	clrw	x
1813  06a1 97            	ld	xl,a
1814  06a2 4f            	clr	a
1815  06a3 02            	rlwa	x,a
1816  06a4 58            	sllw	x
1817  06a5 58            	sllw	x
1818  06a6 1f04          	ldw	(OFST-1,sp),x
1820                     ; 182    if(recvsize < len) len = recvsize;
1822  06a8 1e04          	ldw	x,(OFST-1,sp)
1823  06aa 130b          	cpw	x,(OFST+6,sp)
1824  06ac 2404          	jruge	L345
1827  06ae 1e04          	ldw	x,(OFST-1,sp)
1828  06b0 1f0b          	ldw	(OFST+6,sp),x
1829  06b2               L345:
1830                     ; 186          recvsize = getSn_RX_RSR(sn);
1832  06b2 7b06          	ld	a,(OFST+1,sp)
1833  06b4 cd0000        	call	_getSn_RX_RSR
1835  06b7 1f04          	ldw	(OFST-1,sp),x
1837                     ; 187          tmp = getSn_SR(sn);
1839  06b9 7b06          	ld	a,(OFST+1,sp)
1840  06bb 97            	ld	xl,a
1841  06bc a604          	ld	a,#4
1842  06be 42            	mul	x,a
1843  06bf 58            	sllw	x
1844  06c0 58            	sllw	x
1845  06c1 58            	sllw	x
1846  06c2 1c0308        	addw	x,#776
1847  06c5 cd0000        	call	c_itolx
1849  06c8 be02          	ldw	x,c_lreg+2
1850  06ca 89            	pushw	x
1851  06cb be00          	ldw	x,c_lreg
1852  06cd 89            	pushw	x
1853  06ce cd0000        	call	_WIZCHIP_READ
1855  06d1 5b04          	addw	sp,#4
1856  06d3 6b03          	ld	(OFST-2,sp),a
1858                     ; 188          if (tmp != SOCK_ESTABLISHED)
1860  06d5 7b03          	ld	a,(OFST-2,sp)
1861  06d7 a117          	cp	a,#23
1862  06d9 275e          	jreq	L745
1863                     ; 190             if(tmp == SOCK_CLOSE_WAIT)
1865  06db 7b03          	ld	a,(OFST-2,sp)
1866  06dd a11c          	cp	a,#28
1867  06df 2645          	jrne	L155
1868                     ; 192                if(recvsize != 0) break;
1870  06e1 1e04          	ldw	x,(OFST-1,sp)
1871  06e3 2703          	jreq	L011
1872  06e5 cc076a        	jp	L545
1873  06e8               L011:
1876                     ; 193                else if(getSn_TX_FSR(sn) == getSn_TxMAX(sn))
1878  06e8 7b06          	ld	a,(OFST+1,sp)
1879  06ea 97            	ld	xl,a
1880  06eb a604          	ld	a,#4
1881  06ed 42            	mul	x,a
1882  06ee 58            	sllw	x
1883  06ef 58            	sllw	x
1884  06f0 58            	sllw	x
1885  06f1 1c1f08        	addw	x,#7944
1886  06f4 cd0000        	call	c_itolx
1888  06f7 be02          	ldw	x,c_lreg+2
1889  06f9 89            	pushw	x
1890  06fa be00          	ldw	x,c_lreg
1891  06fc 89            	pushw	x
1892  06fd cd0000        	call	_WIZCHIP_READ
1894  0700 5b04          	addw	sp,#4
1895  0702 5f            	clrw	x
1896  0703 97            	ld	xl,a
1897  0704 4f            	clr	a
1898  0705 02            	rlwa	x,a
1899  0706 58            	sllw	x
1900  0707 58            	sllw	x
1901  0708 1f01          	ldw	(OFST-4,sp),x
1903  070a 7b06          	ld	a,(OFST+1,sp)
1904  070c cd0000        	call	_getSn_TX_FSR
1906  070f 1301          	cpw	x,(OFST-4,sp)
1907  0711 2626          	jrne	L745
1908                     ; 195                   close(sn);
1910  0713 7b06          	ld	a,(OFST+1,sp)
1911  0715 cd01ae        	call	_close
1913                     ; 196                   return SOCKERR_SOCKSTATUS;
1915  0718 aefff9        	ldw	x,#65529
1916  071b bf02          	ldw	c_lreg+2,x
1917  071d aeffff        	ldw	x,#-1
1918  0720 bf00          	ldw	c_lreg,x
1920  0722 ac730673      	jpf	L601
1921  0726               L155:
1922                     ; 201                close(sn);
1924  0726 7b06          	ld	a,(OFST+1,sp)
1925  0728 cd01ae        	call	_close
1927                     ; 202                return SOCKERR_SOCKSTATUS;
1929  072b aefff9        	ldw	x,#65529
1930  072e bf02          	ldw	c_lreg+2,x
1931  0730 aeffff        	ldw	x,#-1
1932  0733 bf00          	ldw	c_lreg,x
1934  0735 ac730673      	jpf	L601
1935  0739               L745:
1936                     ; 205          if((sock_io_mode & (1<<sn)) && (recvsize == 0)) return SOCK_BUSY;
1938  0739 ae0001        	ldw	x,#1
1939  073c 7b06          	ld	a,(OFST+1,sp)
1940  073e 4d            	tnz	a
1941  073f 2704          	jreq	L201
1942  0741               L401:
1943  0741 58            	sllw	x
1944  0742 4a            	dec	a
1945  0743 26fc          	jrne	L401
1946  0745               L201:
1947  0745 01            	rrwa	x,a
1948  0746 b403          	and	a,L5_sock_io_mode+1
1949  0748 01            	rrwa	x,a
1950  0749 b402          	and	a,L5_sock_io_mode
1951  074b 01            	rrwa	x,a
1952  074c a30000        	cpw	x,#0
1953  074f 2712          	jreq	L365
1955  0751 1e04          	ldw	x,(OFST-1,sp)
1956  0753 260e          	jrne	L365
1959  0755 ae0000        	ldw	x,#0
1960  0758 bf02          	ldw	c_lreg+2,x
1961  075a ae0000        	ldw	x,#0
1962  075d bf00          	ldw	c_lreg,x
1964  075f ac730673      	jpf	L601
1965  0763               L365:
1966                     ; 206          if(recvsize != 0) break;
1968  0763 1e04          	ldw	x,(OFST-1,sp)
1969  0765 2603          	jrne	L211
1970  0767 cc06b2        	jp	L345
1971  076a               L211:
1973  076a               L545:
1974                     ; 209    if(recvsize < len) len = recvsize;   
1977  076a 1e04          	ldw	x,(OFST-1,sp)
1978  076c 130b          	cpw	x,(OFST+6,sp)
1979  076e 2404          	jruge	L765
1982  0770 1e04          	ldw	x,(OFST-1,sp)
1983  0772 1f0b          	ldw	(OFST+6,sp),x
1984  0774               L765:
1985                     ; 210    wiz_recv_data(sn, buf, len);
1987  0774 1e0b          	ldw	x,(OFST+6,sp)
1988  0776 89            	pushw	x
1989  0777 1e0b          	ldw	x,(OFST+6,sp)
1990  0779 89            	pushw	x
1991  077a 7b0a          	ld	a,(OFST+5,sp)
1992  077c cd0000        	call	_wiz_recv_data
1994  077f 5b04          	addw	sp,#4
1995                     ; 211    setSn_CR(sn,Sn_CR_RECV);
1997  0781 4b40          	push	#64
1998  0783 7b07          	ld	a,(OFST+2,sp)
1999  0785 97            	ld	xl,a
2000  0786 a604          	ld	a,#4
2001  0788 42            	mul	x,a
2002  0789 58            	sllw	x
2003  078a 58            	sllw	x
2004  078b 58            	sllw	x
2005  078c 1c0108        	addw	x,#264
2006  078f cd0000        	call	c_itolx
2008  0792 be02          	ldw	x,c_lreg+2
2009  0794 89            	pushw	x
2010  0795 be00          	ldw	x,c_lreg
2011  0797 89            	pushw	x
2012  0798 cd0000        	call	_WIZCHIP_WRITE
2014  079b 5b05          	addw	sp,#5
2016  079d               L375:
2017                     ; 212    while(getSn_CR(sn));
2019  079d 7b06          	ld	a,(OFST+1,sp)
2020  079f 97            	ld	xl,a
2021  07a0 a604          	ld	a,#4
2022  07a2 42            	mul	x,a
2023  07a3 58            	sllw	x
2024  07a4 58            	sllw	x
2025  07a5 58            	sllw	x
2026  07a6 1c0108        	addw	x,#264
2027  07a9 cd0000        	call	c_itolx
2029  07ac be02          	ldw	x,c_lreg+2
2030  07ae 89            	pushw	x
2031  07af be00          	ldw	x,c_lreg
2032  07b1 89            	pushw	x
2033  07b2 cd0000        	call	_WIZCHIP_READ
2035  07b5 5b04          	addw	sp,#4
2036  07b7 4d            	tnz	a
2037  07b8 26e3          	jrne	L375
2038                     ; 214    return (int32_t)len;
2040  07ba 1e0b          	ldw	x,(OFST+6,sp)
2041  07bc cd0000        	call	c_uitolx
2044  07bf ac730673      	jpf	L601
2106                     	xdef	_sock_pack_info
2107                     	xdef	_recv
2108                     	xdef	_send
2109                     	xdef	_disconnect
2110                     	xdef	_listen
2111                     	xdef	_close
2112                     	xdef	_socket
2113                     	xref	_wiz_recv_data
2114                     	xref	_wiz_send_data
2115                     	xref	_getSn_RX_RSR
2116                     	xref	_getSn_TX_FSR
2117                     	xref	_WIZCHIP_READ_BUF
2118                     	xref	_WIZCHIP_WRITE
2119                     	xref	_WIZCHIP_READ
2120                     	xref.b	c_lreg
2139                     	xref	c_uitolx
2140                     	xref	c_itolx
2141                     	xref	c_lzmp
2142                     	end
