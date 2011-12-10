#include "def2191_stud-1.h"
#include "lcd_macro.h"
//.global 	init_buffers;
.global		myfilter;

.extern		Left_Channel; 
.extern		Right_Channel;
.extern 	bcoeffslength;
.extern		acoeffslength;
.extern 	mac_overflow_detector;
.extern		shouldShiftMR;
.extern 	errstring;
.extern		Left_Channel_Out;
.extern 	Right_Channel_Out;
.extern delaySamples;
/*#define 	Coeff_size		3
#define		y_size		2
.var coeffs[Coeff_size] ="ass5bcoeffs.dat";

.var right_Buffer[Coeff_size]; //= 0x0000, 0x0000, 0x0000;
.var left_Buffer[Coeff_size];// = 0x0000, 0x0000, 0x0000;


.var ycoeffs[y_size]="ass5acoeffs.dat";//=0,0,0;//"ycoeffs.dat";
.var right_out_Buffer[y_size]; //= 0x0000, 0x0000, 0x0000;
.var left_out_Buffer[y_size];// = 0x0000, 0x0000, 0x0000;
*/
/* Our filter function, that checks the length of the coefficient buffer and loops through the left and right input buffers to generate the output based on previous samples and filter coefficients.
*/
.section/pm program0;

myfilter:
	/* Left Channel processing*/

		M0=-1;
		M4=1;
		
		AR=dm(Left_Channel);
		MODIFY(I0+=1); 
		DM(I0+=0) = AR; //store x(n)
		
		AX0=dm(delaySamples);
		AY0=0;
		AR=AY0-AX0;

		M0=AR;
		MODIFY(I0+=M0);

		AR=DM(I0+=0);
		DM(Left_Channel_Out) = AR;

		M0=AX0;
		MODIFY(I0+=M0);

/*		AR
		AR=dm(bcoeffslength);
		CNTR= AR;
		MR=0;
		DO leftloop UNTIL CE;
			MX0=DM(I0+=M0);
			MY0=DM(I4+=M4);	
			MR = MR + MX0 * MY0 (SS);
			leftloop:nop;  //y[n]=x[n]...x[n-k]

		
		AR=dm(acoeffslength);

		CNTR= AR;
		DO leftyloop UNTIL CE;
			MX0=DM(I2+=M0);
			MY0=DM(I5+=M4);	
			 MR = MR - MX0 * MY0 (SS);
			leftyloop:nop;
		MODIFY(I2+=1);
		DM(I2+=0)=MR1;

		AX0=dm(shouldShiftMR);
		AY0=1;
		AR=AY0-AX0;
		IF NE JUMP leffejump;
		nop;
		call shiftmr;
		nop;*/
		
leffejump:	
	
		DM(Left_Channel_Out) = AR;

/*right channel processing*/
hoger: 
		AR=dm(Right_Channel);
		
		

rickejump:	
		
		DM(Right_Channel_Out) = AR;

RTS;
nop;

shiftmr:
		AR = 13;
		SE = AR;
		SR = LSHIFT
	 MR2 (HI);
		AR = -3;
		SE = AR;
		SR = SR OR LSHIFT MR1 (HI);
		MR1=SR1;
		RTS;
		nop;



