#include "def2191_stud-1.h"

.global mac_overflow_detector;

/*.global bcoeffslength;
.global acoeffslength;
*/
.global shouldShiftMR;
.global saturate;

.global centerDelay;
.global centerDeviation;
.global frequency;
.global mix;

//.global b_Coeffs;
//.global b_Right_Buffer; //= 0x0000, 0x0000, 0x000;
.global b_Left_Buffer;// = 0x0000, 0x0000, 0x0000;

//.global a_Coeffs;//=0x7000,0;//"ass5acoeffs.dat";//=0,0,0;//"ycoeffs.dat";
//.global a_Right_Buffer; //= 0x0000, 0x0000, 0x0000;
//.global a_Left_Buffer;// = 
.global init_buffers;

.global delaySamples;
.global delayTop;
.global delayBottom;
.global stepTimes;
.global stepState;
.global direction;
.global decimalmix;
.global countertext;
.global counter;
.section/dm    data0;
/*********************************************************
* Other variables
*********************************************************/

.var shouldShiftMR=0;
.var saturate=0;
/*********************************************************
* Configurable variables
*********************************************************/

.var centerDelay= 20;
.var centerDeviation =10;
.var frequency=4;
.var mix=10;
.var decimalmix=1;

//debug

.var counter=22;
.var countertext[11]='C','o','u','n','t','e','r','r','r','n',' ';
/********************************************************************************
* Calculated discrete time versions of the configurable variables		*
*********************************************************************************/
.var delaySamples= 0;
.var delayTop=0;
.var delayBottom=0;
.var stepTimes;
.var stepState=0;
.var direction=1; //1 equals positive direction, 0 equals negative direction








/*********************************************************
* Filter State variables
*********************************************************/
#define 	_b_Buffer_Size		13400
#define		_a_Buffer_Size		1



.var b_Left_Buffer[_b_Buffer_Size];// = 0x0000, 0x0000, 0x0000;


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

/*
		AX0=dm(saturate);
		AY0=1;
		AR=AY0-AX0;
		IF NE JUMP enden;
		nop;
		sat MR; */
		nop;
enden:

RTS;
nop;

init_buffers:
	//init leftbuffer
	DMPG1 = Page(b_Left_Buffer);
	I0 = b_Left_Buffer;
	L0 = length(b_Left_Buffer);
	AX0 = I0;
	Reg(B0) = Ax0;



	//init right bufffer
	/*
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
*/
	//init coeffs buffer





	RTS;
	nop;




createFilter:
nop;
RTS;
nop;


