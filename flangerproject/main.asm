/*****************************************************************************************************************

main.asm

************************************************************************************************/

#include "def2191_stud-1.h"
#include "lcd_macro.h"
#define   CMAX 20
#define   CMIN 0

#define   DMAX 10
#define   DMIN 0	

#define   FMAX 4
#define   FMIN 0

#define   MMAX 10	//only filtered
#define   MMIN 0	//only original
#define _SAMPSPERMILLI 48
/************************************************************************************************/
/*			   GLOBAL & EXTERNAL DECLARATIONS					*/	
/************************************************************************************************/    
// Global symbols
.global	 	Start;
.global         PUSH1;
.global         CW1;
.global         CCW1;
.global         CW2;
.global         CCW2;
.global printadigit;
.global tempdigit;

// External symbols
//egentillagda

//
//assignment 6
//filter 


.extern		Change_PLL_Multiplier;
.extern 	Codec_Reset;
.extern		Program_SPORT0_Registers;
.extern		Program_DMA_Controller;
.extern		AD1885_Codec_Initialization;
.extern		RX_Status;
.extern		Initialize_LCD;
.extern		Poll_Rotary_Encoder1;
.extern		Poll_Rotary_Encoder2;
.extern         Check_Rotary_Encoder1_Push;
.extern		Wait_10ms;



.extern init_buffers;

.extern centerDelay;
.extern delaySamples;



.extern centerDeviation;
.extern frequency;
.extern mix;
.extern decimalmix;

.extern delayTop;
.extern delayBottom;
.extern stepTimes;


/************************************************************************************************/  
/*                              DM DATA                                                         */
/************************************************************************************************/ 
.SECTION/dm data0;
.var filtertext[7]='F','i','l','t','e','r',' ';
.var one='1';
.var two='2';
.var three='3';
.var four='4';

.var saturationtext[11]='S','a','t','u','r','a','t','i','o','n',' ';
.var saton[3]='O','n',' ';
.var satoff[3]='O','f','f';
/************************************************************************************************/  
/*                             Configuration variables                                          */
/************************************************************************************************/ 
.var cursetting=0; //0:delay,1:deviatoin,2:frequency,3:mix;
.var cdelaytext[16]='C','e','n','t','e','r','d','e','l','a','y',':',' ',' ',' ',' ';
.var devdelaytext[16]='D','e','v','i','a','t','i','o','n',':',' ',' ',' ',' ',' ',' ';
.var frequencytext[16]='F','r','e','q','u','e','n','c','y',':',' ',' ',' ',' ',' ',' ';
.var mixtext[16]='M','i','x',':',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ';
.var currcfg=0;
.var digits[10]='0','1','2','3','4','5','6','7','8','9';

.var tempdigit;
/************************************************************************************************/  
/*                              PM DATA                                                         */
/************************************************************************************************/ 
.SECTION/pm program0;

// ----- Program execution starts here...! -------	
Start:
	 
	call Change_PLL_Multiplier;		// Change the multiplier of the processor. External clock is only 16 MHz.
	call Codec_Reset;			// Reset the codec
	call Program_SPORT0_Registers;		// Initialize SPORT0 for codec communications 
	call Program_DMA_Controller;		// Start Serial Port 0 tx and rx DMA Transfers 
	call AD1885_Codec_Initialization;	// Initialize & program AD1885 
   

	// Set direction of flagpins
	IOPG = General_Purpose_IO;
   	nop;
  	ar = 0xFC8B;
	IO(DIRS) = AR;  
	
	call Initialize_LCD;			// Initialize the LCD
	call Wait_10ms;				// Wait 10 milliseconds...
	AR = 0x000B;
        IO(FLAGC) = AR;	
	
	
	AR=0;

	

	


	// Clear RX_Status flag indicating incoming RX data is audio data and can be processed according 
	ax0=0x0000;
	dm(RX_Status) = ax0;
	//DIS sec_reg;
	call  init_buffers;
	nop;
	call calc_params;
	call changetodelay;
	//ena sec_reg;
	
// ----- Go into infinite program loop after initialization... ------
wait_forever:

	idle;						

        // Check if Rotary Encoder 1 was pushed...
        CALL Check_Rotary_Encoder1_Push;

	// Check if Rotary Encoder 1 was turned
	CALL Poll_Rotary_Encoder1;

	// Check if Rotary Encoder 2 was turned	
	CALL Poll_Rotary_Encoder2;

	jump wait_forever;


PUSH1:     
                
        nop;
        RTS;
	
CW1:	DIS int;
	AR=dm(cursetting);
	AX1=AR;
	AR=AX1+1;
	AX0=3;
	AY1=AR;
	AR=AX0-AX1;
	//	CNTR=AR;
	IF EQ JUMP nextsetting;
	AR=dm(cursetting);
	AX1=AR;
	AR=AX1+1;
	
nextsetting:
	dm(cursetting)=AR;
	//if AR > 4
	//AR = 0
	AR=AR-0;
	IF EQ JUMP changetodelay;
        AR=AR-1;
	IF EQ JUMP changetodeviation;
	AR=AR-1;
	IF EQ JUMP changetofrequency;
	AR=AR-1;
	IF EQ JUMP changetomix;
	nop;
        RTS;
CCW1:	
	DIS int;
	AR=dm(cursetting);
	AX1=AR;
	AR=AX1-1;


	IF GE JUMP nextsetting;
	nop;	
	AR=3;
	jump nextsetting;
	nop;
	RTS;

CW2:	DIS int;
	AR=dm(cursetting);
       	AR=AR-0;
	IF EQ JUMP inc_cdelay;
        AR=AR-1;
	IF EQ JUMP inc_dev;
	AR=AR-1;
	IF EQ JUMP inc_freq;
	AR=AR-1;
	IF EQ JUMP inc_mix;
        
	RTS;
CCW2:	DIS int;
	AR=dm(cursetting);
       	AR=AR-0;
	IF EQ JUMP dec_cdelay;
        AR=AR-1;
	IF EQ JUMP dec_dev;
	AR=AR-1;
	IF EQ JUMP dec_freq;
	AR=AR-1;
	IF EQ JUMP dec_mix;
  
	
	nop;
	RTS;
/************************************************************************************************/  
/*  Incrementer and decrementer for all configurations that saturates at min and maxvalues      */
/************************************************************************************************/ 
inc_cdelay:
	AR=dm(centerDelay);
	AR=AR+1;
	
	AX1=CMAX;	
	AR=AR-AX1;

	//AR=AR-29;
	
	IF GT JUMP endInc; 
	AR=dm(centerDelay);
	AR=AR+1;	
	dm(centerDelay)=AR;
	jump changetodelay;
	
dec_cdelay:
	AR=dm(centerDelay);
	AR=AR-1;
	
	AX1=CMIN;	
	AR=AR-AX1;

	//AR=AR-29;
	
	IF LT JUMP endInc; 
	AR=dm(centerDelay);
	AR=AR-1;
	dm(centerDelay)=AR;
	jump changetodelay;

inc_dev: /*test for hardcoded max*/
	
	AR=dm(centerDeviation);
	AR=AR+1;
	AX1=DMAX;	
	AR=AR-AX1;
	IF GT JUMP changetodeviation;

	AR=dm(centerDeviation);
	AR=AR+1;
	dm(centerDeviation)=AR;
	call testDeviation;

	jump changetodeviation;

dec_dev:
	AR=dm(centerDeviation);
	AR=AR-1;
	
	AX1=DMIN;	
	AR=AR-AX1;

	//AR=AR-29;
	
	IF LT JUMP endInc; 
	AR=dm(centerDeviation);
	AR=AR-1;
	dm(centerDeviation)=AR;
	jump changetodeviation;

inc_freq:
	AR=dm(frequency);
	AR=AR+1;
	
	AX1=FMAX;	
	AR=AR-AX1;

	//AR=AR-29;
	
	IF GT JUMP endInc; 
	AR=dm(frequency);
	AR=AR+1;	
	dm(frequency)=AR;
	jump changetofrequency;
dec_freq:
	AR=dm(frequency);
	AR=AR-1;
	
	AX1=FMIN;	
	AR=AR-AX1;

	//AR=AR-29;
	
	IF LT JUMP endInc; 
	AR=dm(frequency);
	AR=AR-1;
	dm(frequency)=AR;
	jump changetofrequency;
	

inc_mix:
	AR=dm(mix);
	AR=AR+1;
	
	AX1=MMAX;	
	AR=AR-AX1;

	//AR=AR-29;
	
	IF GT JUMP endInc; 
	AR=dm(mix);
	AR=AR+1;	
	dm(mix)=AR;
	jump changetomix;
dec_mix:
	AR=dm(mix);
	AR=AR-1;
	
	AX1=MMIN;	
	AR=AR-AX1;

	//AR=AR-29;
	
	IF LT JUMP endInc; 
	AR=dm(mix);
	AR=AR-1;
	dm(mix)=AR;
	jump changetomix;


endInc:
	call testDeviation;
	call calc_params;
	ena int;
	RTS;
/************************************************************************************************/  
/*                  Prints the current configurabled parameter and its value       	        */
/************************************************************************************************/ 
changetodelay:
	call testDeviation;
	Output_LCD_Token(cdelaytext,16,1,0);
	AR=dm(centerDelay);

	//should be removed

	dm(tempdigit)=AR;

	call printadigit;
	nop;
	call calc_params;
	ena int;
	RTS;
	nop;



changetodeviation:
Output_LCD_Token(devdelaytext,16,1,0);
	call testDeviation;
	
	AR=dm(centerDeviation);
	dm(tempdigit)=AR;
	call printadigit;
	call calc_params;
	ena int;
	RTS;
	
	nop;

changetofrequency:
	Output_LCD_Token(frequencytext,16,1,0);
	AR=dm(frequency);
	dm(tempdigit)=AR;
	call printadigit;
	call calc_params;
	ena int;
	RTS;
	nop;
changetomix:
	Output_LCD_Token(mixtext,16,1,0);
	AR=dm(mix);
	dm(tempdigit)=AR;
	call printadigit;
	call calc_params;
	ena int;
	RTS;
	nop;


/************************************************************************************************/  
/*                 Converts from user defined variables to discrete variables  	        */
/************************************************************************************************/ 

calc_params:
	//center delay in samples
	ena M_MODE;	
	nop;
	nop;	
	nop;
	AR=dm(centerDelay);
	
	//MSTAT=AR;
	nop;
	MX0=AR;
	MY0=_SAMPSPERMILLI ;
	MR=0;
	MR=MR+MX0*MY0 (SS);
	AR=MR0;
	////DDASASDDASDA

	//AR=11;//delete me//AR=12000;
	//DM(centerDelay)=AR;
	AR=880;

	dm(delaySamples)=AR;
	
	//topdelay
	Ar=dm(centerDeviation);

	MX0=AR;
	MY0=_SAMPSPERMILLI;
	MR=0;
	MR=MR+MX0*MY0 (SS);	
	AR=dm(delaySamples);
	AR=AR+MR0;
	//AR=1320;//delete me//AR=12000;
	dm(delayTop)=AR;

	//bottomdelay in samples
	Ar=dm(centerDeviation);
	MX0=AR;
	MY0=_SAMPSPERMILLI;
	MR=0;
	MR=MR+MX0*MY0 (SS);	
	AR=dm(delaySamples);
	AR=AR-MR0;
	//AR=440;//delete me//AR=12000;cc

	dm(delayBottom)=AR;
	/*how hoften should we increase delayCenter*/
	
	
	
	AR=dm(centerDeviation);
	MX0=AR;
	MY0=_SAMPSPERMILLI;
	MR=0;
	MR=MR+MX0*MY0 (SS);
	MX0=MR0;
	MY0=40000;
	MR=0;
	MR=MR+MX0*MY0 (SS);
	AR=25;//MR0;

	dm(stepTimes)=AR;//MR0;
/*
//what should the true mixvalue be:
	AX0=dm(mix);
	AR=AX0-1;
	AY0=0x0;
	dm(decimalmix)=AY0;
	IF LT JUMP utmede; 
	AR=AX0-1;
	AY0=0x1001;
	dm(decimalmix)=AY0;
	IF LT JUMP utmede; 
	AR=AX0-1;
	AY0=0x1C01; //ca_ 2
	dm(decimalmix)=AY0;
	IF LT JUMP utmede; 
	AR=AX0-1;
	AY0=0x2801; // ca 3
	dm(decimalmix)=AY0;
	IF LT JUMP utmede; 
	AR=AX0-1;
	AY0=0x3801; //ca 4
	dm(decimalmix)=AY0;
	IF LT JUMP utmede; 
	AR=AX0-1;
	AY0=0x4001; //ca 5
	dm(decimalmix)=AY0;
	IF LT JUMP utmede; 
	AR=AX0-1;
	AY0=0x5001; //ca 6
	dm(decimalmix)=AY0;
	IF LT JUMP utmede; 
	AR=AX0-1;
	AY0=0x5801; //ca 7
	dm(decimalmix)=AY0;
	IF LT JUMP utmede; 
	AR=AX0-1;
	AY0=0x6801; //ca 8
	dm(decimalmix)=AY0;
	IF LT JUMP utmede; 
	AR=AX0-1;
	AY0=0x7801; //ca 9
	dm(decimalmix)=AY0;
	IF LT JUMP utmede; 
	AR=AX0-1;
	AY0=0x7fff; //ca 10
	dm(decimalmix)=AY0;
	IF LT JUMP utmede; 
*/
	dis M_MODE;	
	nop;	
	nop;
	nop;
utmede:
	RTS;

/************************************************************************************************/  
/*                  Prints a two digit number on position 15 and 16 on the display    	        */
/************************************************************************************************/ 
printadigit:
	AR=dm(tempdigit);
	//tempdigit is the digit
	//AX1=AR;
	AX1=20;
	AR=AR-AX1;
	//	CNTR=AR;
	IF LT JUMP nextdelaydigit10;
	nop;
	dm(tempdigit)=AR;
	Output_LCD_Token(digits+2,1,1,15);
	//tempdigit is subtracted by 20
	nop;
	nop;
	nop;
	jump nextdelaydigit9;

nextdelaydigit10:
	AR=dm(tempdigit);
	//AX1=AR;
	AX1=10;
	AR=AR-AX1;
	//	CNTR=AR;
	IF LT JUMP nextdelaydigit9; 
	nop;
	dm(tempdigit)=AR;
	Output_LCD_Token(digits+1,1,1,15);

	
	nop;
	nop;
nextdelaydigit9:
	AR=dm(tempdigit);
	//AX1=AR;
	AX1=9;
	AR=AR-AX1;
	//	CNTR=AR;
	IF LT JUMP nextdelaydigit8; 
	Output_LCD_Token(digits+9,1,1,16);
	jump enddigit;

nextdelaydigit8:
	AR=dm(tempdigit);
	//AX1=AR;
	AX1=8;
	AR=AR-AX1;
	//	CNTR=AR;
	IF LT JUMP nextdelaydigit7; 
	Output_LCD_Token(digits+8,1,1,16);
	jump enddigit;

nextdelaydigit7:
	AR=dm(tempdigit);
	//AX1=AR;
	AX1=7;
	AR=AR-AX1;
	//	CNTR=AR;
	IF LT JUMP nextdelaydigit6; 
	Output_LCD_Token(digits+7,1,1,16);
	jump enddigit;

nextdelaydigit6:
	AR=dm(tempdigit);
	//AX1=AR;
	AX1=6;
	AR=AR-AX1;
	//	CNTR=AR;
	IF LT JUMP nextdelaydigit5; 
	Output_LCD_Token(digits+6,1,1,16);
	jump enddigit;
nextdelaydigit5:
	AR=dm(tempdigit);
	//AX1=AR;
	AX1=5;
	AR=AR-AX1;
	//	CNTR=AR;
	IF LT JUMP nextdelaydigit4; 
	Output_LCD_Token(digits+5,1,1,16);
	jump enddigit;
nextdelaydigit4:
	AR=dm(tempdigit);
	//AX1=AR;
	AX1=4;
	AR=AR-AX1;
	//	CNTR=AR;
	IF LT JUMP nextdelaydigit3; 
	Output_LCD_Token(digits+4,1,1,16);
	jump enddigit;
nextdelaydigit3:
	AR=dm(tempdigit);
	//AX1=AR;
	AX1=3;
	AR=AR-AX1;
	//	CNTR=AR;
	IF LT JUMP nextdelaydigit2; 
	Output_LCD_Token(digits+3,1,1,16);
	jump enddigit;
nextdelaydigit2:
	AR=dm(tempdigit);
	//AX1=AR;
	AX1=2;
	AR=AR-AX1;
	//	CNTR=AR;
	IF LT JUMP nextdelaydigit1; 
	Output_LCD_Token(digits+2,1,1,16);
	jump enddigit;
nextdelaydigit1:
	AR=dm(tempdigit);
	//AX1=AR;
	AX1=1;
	AR=AR-AX1;
	//	CNTR=AR;
	IF LT JUMP nextdelaydigit0; 
	Output_LCD_Token(digits+1,1,1,16);
	jump enddigit;
nextdelaydigit0:
	Output_LCD_Token(digits,1,1,16);
	jump enddigit;

enddigit:

RTS;
nop;

testDeviation:
		/*test for delaybased max*/
	AR=dm(centerDeviation);
	AX1=AR;	

	AR=dm(centerDelay);
	AX0=AR;		// deviation - CENTERDELAY/2
	AR=dm(centerDeviation);
	AX1=AR;	

	AR=AX1-AX0;			//if that is greater than zero, it is to big.

	IF LE JUMP endTestDev;
	dm(centerDeviation)=AX0;	

endTestDev:


	rts;
	
