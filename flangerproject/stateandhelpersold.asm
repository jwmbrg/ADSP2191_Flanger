#include "def2191_stud-1.h"

.global mac_overflow_detector;
.global bcoeffslength;
.global acoeffslength;
.global curfilter;

.global init_ass1_buffers;
.global init_ass3_buffers;
.global init_ass4_buffers;
.global init_ass5_buffers;

.global shouldShiftMR;
.global saturate;
.global errstring;
.section/dm    data0;
/*********************************************************
* State variables
*********************************************************/
.var shouldShiftMR=0;
.var curfilter=0;
.var saturate=0;
.var errstring[3]='E','r','r';
/*********************************************************
* Filter1
*********************************************************/
#define 	ass1_Coeff_size		129
#define		ass1_y_size		1


.var bcoeffslength=0;
.var acoeffslength=0;
.var ass1_coeffs[ass1_Coeff_size] ="ass1coeffs.dat";
.var ass1_right_Buffer[ass1_Coeff_size]; //= 0x0000, 0x0000, 0x000;
.var ass1_left_Buffer[ass1_Coeff_size];// = 0x0000, 0x0000, 0x0000;
.var ass1_ycoeffs[ass1_y_size]=0;//=0x7000,0;//"ass5acoeffs.dat";//=0,0,0;//"ycoeffs.dat";
.var ass1_right_out_Buffer[ass1_y_size]; //= 0x0000, 0x0000, 0x0000;
.var ass1_left_out_Buffer[ass1_y_size];// = 0x0000, 0x0000, 0x0000;


/*********************************************************
* Filter3
*********************************************************/

#define 	ass3_Coeff_size		129
#define		ass3_y_size		1
.var ass3_coeffs[ass3_Coeff_size] ="ass3coeffs.dat";
.var ass3_right_Buffer[ass3_Coeff_size]; //= 0x0000, 0x0000, 0x000;
.var ass3_left_Buffer[ass3_Coeff_size];// = 0x0000, 0x0000, 0x0000;
.var ass3_ycoeffs[ass3_y_size]=0;//"ass5acoeffs.dat";//=0,0,0;//"ycoeffs.dat";
.var ass3_right_out_Buffer[ass3_y_size]; //= 0x0000, 0x0000, 0x0000;
.var ass3_left_out_Buffer[ass3_y_size];// = 0x0000, 0x0000, 0x0000;

/*********************************************************
* Filter4
*********************************************************/

#define 	ass4_Coeff_size		129
#define		ass4_y_size		1
.var ass4_coeffs[ass4_Coeff_size] ="ass4coeffs.dat";
.var ass4_right_Buffer[ass4_Coeff_size]; //= 0x0000, 0x0000, 0x000;
.var ass4_left_Buffer[ass4_Coeff_size];// = 0x0000, 0x0000, 0x0000;
.var ass4_ycoeffs[ass4_y_size]=0;//"ass5acoeffs.dat";//=0,0,0;//"ycoeffs.dat";
.var ass4_right_out_Buffer[ass4_y_size]; //= 0x0000, 0x0000, 0x0000;
.var ass4_left_out_Buffer[ass4_y_size];// = 0x0000, 0x0000, 0x0000;

/*********************************************************
* Filter5
*********************************************************/

#define 	ass5_Coeff_size		3
#define		ass5_y_size		2
.var ass5_coeffs[ass5_Coeff_size] ="ass5bcoeffs.dat";
.var ass5_right_Buffer[ass5_Coeff_size]; //= 0x0000, 0x0000, 0x000;
.var ass5_left_Buffer[ass5_Coeff_size];// = 0x0000, 0x0000, 0x0000;
.var ass5_ycoeffs[ass5_y_size]="ass5acoeffs.dat";//"ass5acoeffs.dat";//=0,0,0;//"ycoeffs.dat";
.var ass5_right_out_Buffer[ass5_y_size]; //= 0x0000, 0x0000, 0x0000;
.var ass5_left_out_Buffer[ass5_y_size];// = 0x0000, 0x0000, 0x0000;


/*********************************************************
* General methods
*********************************************************/
.section/pm program0;
mac_overflow_detector:

	

		AX0=ASTAT;
		AX1=ASTAT_MV;
		AR= AX0 AND AX1;
		AX0=AR;
		AR = -3;
		SE = AR;
		SR = LSHIFT AX0 (LO);
		
		
		AX1 = IOPG;
		IOPG = General_Purpose_IO;
		AR=SR0;
		IO(FLAGS) = AR;
		IOPG = AX1;
		nop;


		AX0=dm(saturate);
		AY0=1;
		AR=AY0-AX0;
		IF NE JUMP enden;
		nop;
		sat MR; 
		nop;
enden:

RTS;
nop;

getLength:
	AY0=length(ass1_coeffs);
	RTS;
	nop;
/*********************************************************
* Filter1 initialization
*********************************************************/
init_ass1_buffers:
	//init leftbuffer
	DMPG1 = Page(ass1_left_Buffer);
	I0 = ass1_left_Buffer;
	L0 = length(ass1_left_Buffer);
	AX0 = ass1_left_Buffer;
	Reg(B0) = AX0;
	
	DMPG1 = Page(ass1_left_out_Buffer);
	I2 = ass1_left_out_Buffer;
	L2 = length(ass1_left_out_Buffer);
	AX0 = ass1_left_out_Buffer;
	Reg(B2) = AX0;


	//init right bufffer
	
	DMPG1 = Page(ass1_right_Buffer);
	I1 = ass1_right_Buffer;
	L1 = length(ass1_right_Buffer);
	AX1 = ass1_right_Buffer;
	Reg(B1) = AX1;

	DMPG1 = Page(ass1_right_out_Buffer);
	I3 = ass1_right_out_Buffer;
	L3 = length(ass1_right_out_Buffer);
	AX1 = ass1_right_out_Buffer;
	Reg(B3) = AX1;

	//init coeffs buffer
	DMPG2 = Page(ass1_coeffs);
	I4 = ass1_coeffs;
	L4 = length(ass1_coeffs);
	AX0= ass1_coeffs;
	Reg(B4) = AX0;

	DMPG2 = Page(ass1_ycoeffs);
	I5 = ass1_ycoeffs;
	L5 = length(ass1_ycoeffs);
	AX0= ass1_ycoeffs;
	Reg(B5) = AX0;

	AR=length(ass1_coeffs);
	dm(bcoeffslength)=AR;

	AR=length(ass1_ycoeffs);
	dm(acoeffslength)=AR;

	AR=0;
	dm(shouldShiftMR)=AR;
	RTS;
	nop;
/*********************************************************
* Filter3 initialization
*********************************************************/

init_ass3_buffers:
	//init leftbuffer
	DMPG1 = Page(ass3_left_Buffer);
	I0 = ass3_left_Buffer;
	L0 = length(ass3_left_Buffer);
	AX0 = ass3_left_Buffer;
	Reg(B0) = AX0;
	
	DMPG1 = Page(ass3_left_out_Buffer);
	I2 = ass3_left_out_Buffer;
	L2 = length(ass3_left_out_Buffer);
	AX0 = ass3_left_out_Buffer;
	Reg(B2) = AX0;


	//init right bufffer
	
	DMPG1 = Page(ass3_right_Buffer);
	I1 = ass3_right_Buffer;
	L1 = length(ass3_right_Buffer);
	AX1 = ass3_right_Buffer;
	Reg(B1) = AX1;

	DMPG1 = Page(ass3_right_out_Buffer);
	I3 = ass3_right_out_Buffer;
	L3 = length(ass3_right_out_Buffer);
	AX1 = ass3_right_out_Buffer;
	Reg(B3) = AX1;

	//init coeffs buffer
	DMPG2 = Page(ass3_coeffs);
	I4 = ass3_coeffs;
	L4 = length(ass3_coeffs);
	AX0= ass3_coeffs;
	Reg(B4) = AX0;

	DMPG2 = Page(ass3_ycoeffs);
	I5 = ass3_ycoeffs;
	L5 = length(ass3_ycoeffs);
	AX0= ass3_ycoeffs;
	Reg(B5) = AX0;
	AR=length(ass3_coeffs);
	dm(bcoeffslength)=AR;
	AR=length(ass3_ycoeffs);
	dm(acoeffslength)=AR;
	AR=0;
	dm(shouldShiftMR)=AR;

	RTS;
	nop;
/*********************************************************
* Filter4 initialization
*********************************************************/

init_ass4_buffers:
	//init leftbuffer
	DMPG1 = Page(ass4_left_Buffer);
	I0 = ass4_left_Buffer;
	L0 = length(ass4_left_Buffer);
	AX0 = ass4_left_Buffer;
	Reg(B0) = AX0;
	
	DMPG1 = Page(ass4_left_out_Buffer);
	I2 = ass4_left_out_Buffer;
	L2 = length(ass4_left_out_Buffer);
	AX0 = ass4_left_out_Buffer;
	Reg(B2) = AX0;


	//init right bufffer
	
	DMPG1 = Page(ass4_right_Buffer);
	I1 = ass4_right_Buffer;
	L1 = length(ass4_right_Buffer);
	AX1 = ass4_right_Buffer;
	Reg(B1) = AX1;

	DMPG1 = Page(ass4_right_out_Buffer);
	I3 = ass4_right_out_Buffer;
	L3 = length(ass4_right_out_Buffer);
	AX1 = ass4_right_out_Buffer;
	Reg(B3) = AX1;

	//init coeffs buffer
	DMPG2 = Page(ass4_coeffs);
	I4 = ass4_coeffs;
	L4 = length(ass4_coeffs);
	AX0= ass4_coeffs;
	Reg(B4) = AX0;

	DMPG2 = Page(ass4_ycoeffs);
	I5 = ass4_ycoeffs;
	L5 = length(ass4_ycoeffs);
	AX0= ass4_ycoeffs;
	Reg(B5) = AX0;
	AR=length(ass4_coeffs);
	dm(bcoeffslength)=AR;
	AR=length(ass4_ycoeffs);
	dm(acoeffslength)=AR;
	AR=1;
	dm(shouldShiftMR)=AR;
	RTS;
	nop;
/*********************************************************
* Filter5 initialization
*********************************************************/


init_ass5_buffers:
	//init leftbuffer
	DMPG1 = Page(ass5_left_Buffer);
	I0 = ass5_left_Buffer;
	L0 = length(ass5_left_Buffer);
	AX0 = ass5_left_Buffer;
	Reg(B0) = AX0;
	
	DMPG1 = Page(ass5_left_out_Buffer);
	I2 = ass5_left_out_Buffer;
	L2 = length(ass5_left_out_Buffer);
	AX0 = ass5_left_out_Buffer;
	Reg(B2) = AX0;


	//init right bufffer
	
	DMPG1 = Page(ass5_right_Buffer);
	I1 = ass5_right_Buffer;
	L1 = length(ass5_right_Buffer);
	AX1 = ass5_right_Buffer;
	Reg(B1) = AX1;

	DMPG1 = Page(ass5_right_out_Buffer);
	I3 = ass5_right_out_Buffer;
	L3 = length(ass5_right_out_Buffer);
	AX1 = ass5_right_out_Buffer;
	Reg(B3) = AX1;

	//init coeffs buffer
	DMPG2 = Page(ass5_coeffs);
	I4 = ass5_coeffs;
	L4 = length(ass5_coeffs);
	AX0= ass5_coeffs;
	Reg(B4) = AX0;

	DMPG2 = Page(ass5_ycoeffs);
	I5 = ass5_ycoeffs;
	L5 = length(ass5_ycoeffs);
	AX0= ass5_ycoeffs;
	Reg(B5) = AX0;

	AR=length(ass5_coeffs);
	dm(bcoeffslength)=AR;
	AR=length(ass5_ycoeffs);
	dm(acoeffslength)=AR;
	AR=0;
	dm(shouldShiftMR)=AR;
	RTS;
	nop;
