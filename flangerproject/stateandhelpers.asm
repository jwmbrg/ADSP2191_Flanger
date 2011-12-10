#include "def2191_stud-1.h"

.global mac_overflow_detector;

.global bcoeffslength;
.global acoeffslength;

.global shouldShiftMR;
.global saturate;

.global centerDelay;
.global centerDeviation;
.global frequency;
.global mix;

.global b_Coeffs;
.global b_Right_Buffer; //= 0x0000, 0x0000, 0x000;
.global b_Left_Buffer;// = 0x0000, 0x0000, 0x0000;

.global a_Coeffs;//=0x7000,0;//"ass5acoeffs.dat";//=0,0,0;//"ycoeffs.dat";
.global a_Right_Buffer; //= 0x0000, 0x0000, 0x0000;
.global a_Left_Buffer;// = 
.global init_buffers;

.global delaySamples;

.section/dm    data0;
/*********************************************************
* Other variables
*********************************************************/

.var shouldShiftMR=0;
.var saturate=0;
/*********************************************************
* Configurable variables
*********************************************************/

.var centerDelay= 29;
.var delaySamples= 13000;
.var centerDeviation =14;
.var frequency=4;
.var mix=10;




/*********************************************************
* Filter State variables
*********************************************************/
#define 	_b_Buffer_Size		13000
#define		_a_Buffer_Size		1


.var bcoeffslength=0;
.var acoeffslength=0;
.var b_Coeffs[1];
.var b_Right_Buffer[_b_Buffer_Size]; //= 0x0000, 0x0000, 0x000;
.var b_Left_Buffer[_b_Buffer_Size];// = 0x0000, 0x0000, 0x0000;

.var a_Coeffs[1];//=0x7000,0;//"ass5acoeffs.dat";//=0,0,0;//"ycoeffs.dat";
.var a_Right_Buffer[_a_Buffer_Size]; //= 0x0000, 0x0000, 0x0000;
.var a_Left_Buffer[_a_Buffer_Size];// = 0x0000, 0x0000, 0x0000;
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

init_buffers:
	//init leftbuffer
	DMPG1 = Page(b_Left_Buffer);
	I0 = b_Left_Buffer;
	L0 = length(b_Left_Buffer);
	AX0 = b_Left_Buffer;
	Reg(B0) = AX0;
	
	DMPG1 = Page(a_Left_Buffer);
	I2 = a_Left_Buffer;
	L2 = length(a_Left_Buffer);
	AX0 = a_Left_Buffer;
	Reg(B2) = AX0;


	//init right bufffer
	
	DMPG1 = Page(b_Right_Buffer);
	I1 = b_Right_Buffer;
	L1 = length(b_Right_Buffer);
	AX1 = b_Right_Buffer;
	Reg(B1) = AX1;

	DMPG1 = Page(a_Right_Buffer);
	I3 = a_Right_Buffer;
	L3 = length(a_Right_Buffer);
	AX1 = a_Right_Buffer;
	Reg(B3) = AX1;

	//init coeffs buffer
	DMPG2 = Page(b_Coeffs);
	I4 = b_Coeffs;
	L4 = length(b_Coeffs);
	AX0= b_Coeffs;
	Reg(B4) = AX0;

	DMPG2 = Page(a_Coeffs);
	I5 = a_Coeffs;
	L5 = length(a_Coeffs);
	AX0= a_Coeffs;
	Reg(B5) = AX0;

	AR=length(b_Coeffs);
	dm(bcoeffslength)=AR;

	AR=length(a_Coeffs);
	dm(acoeffslength)=AR;

	AR=1;
	dm(shouldShiftMR)=AR;
	RTS;
	nop;




createFilter:
nop;
RTS;
nop;


