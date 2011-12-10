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
.var centerDeviation =14;
.var frequency=4;
.var mix=10;



/*********************************************************
* Filter State variables
*********************************************************/
#define 	_b_Buffer_Size		129
#define		_a_Buffer_Size		1


.var bcoeffslength=0;
.var acoeffslength=0;
.var b_Coeffs[_b_Buffer_Size];
.var b_Right_Buffer[_b_Buffer_Size]; //= 0x0000, 0x0000, 0x000;
.var b_Left_Buffer[_b_Buffer_Size];// = 0x0000, 0x0000, 0x0000;

.var a_Coeffs[_a_Buffer_Size];//=0x7000,0;//"ass5acoeffs.dat";//=0,0,0;//"ycoeffs.dat";
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

createFilter:
nop;
RTS;
nop;


