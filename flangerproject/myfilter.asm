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
.extern decimalmix;
.extern delaySamples;
.extern delayTop;
.extern delayBottom;
.extern centerDelay;
.extern direction;
.extern stepTimes;
.extern stepState;
.extern printadigit;
.extern tempdigit;
.extern counter;
.extern countertext;

.section/pm program0;

myfilter:
		
		/*Left Channel processing*/
		dis M_MODE;		
	
		M0=0x0001;
		M3=0x0000;
		
		AY1=dm(Left_Channel);		
				//ay1 is our currents sample
		MODIFY(I0+=1);
		//DM(I0+=0)=AY1;

		AX0=dm(delaySamples);				
		AY0=0;
		AR=AY0-AX0;					
		AX0=AR; //ax0 is the actual value we should look backwards in the buffer for (-delaysamples)
		M0=AX0;
		MODIFY(I0+=M0);   //pekar på nte tidigare samplet

		
		AX0=DM(I0+=M3);//collect delayed sample
	
		

		//AX0 is our old sample /delayline
		AR=dm(delaySamples); 		
		M0=AR;
		MODIFY(I0+=M0);//back on x(N)	
		
		/***mix new and old samples here*/
		
		MR=0;
		MX0=AX0;
		MY0=0x5000;		//insert other fb here

		
		MR=MR+MX0*MY0 (SS);			//ett gånger det gamla samplet

		MY0=0x7fff;			
		MX0=AY1;		//current sample
		MR=MR+MX0*MY0 (SS);			//ett gånger det nuvarande samplet plus det gamla samplet
		call shiftmr;
		
		DM(i0+=0)=MR1;				//spara det i vår delaybuffer

		MR=0;
		MX0=Mr1;
		MY0=0x5000;		//ta sen det och kör igenom BL
		MR=MR+MX0*MY0 (SS);

					//för att sist lägga på det gamla samplet igen
		MX0=AX0;
		MY0=0x5000;		//ta sen det och kör igenom BL
		MR=MR+MX0*MY0 (SS);

		DM(Left_Channel_Out) = MR1;

		//DM(Right_Channel_Out) = AY1;


/***************räkna ut om vi ska räkna ut ett nytt sample*************************/
		
		
			
		AR=dm(stepState);
		
		AR=AR+0x0001;
				//increase stepstate
		dm(stepState)=AR;
		nop;
		nop;
		AX0=AR;	
		AX1=dm(stepTimes);	//compare to steptimes if less than zero, reset and call calc_next
		AR=AX0-AX1;
		IF LT JUMP leffejump; 
		AR=0x0;
		dm(stepState)=AR;
		call calc_next;
		

		
leffejump:	nop;
		
		

/*right channel processing*/
hoger: 
		AR=dm(Right_Channel);
		//AR=0;
		

rickejump:	


		//DM(Right_Channel_Out) = AR;
		RTS;


shiftmr:
		AR = 15;
		SE = AR;
		SR = LSHIFT MR2 (HI);
		AR = -1;
		SE = AR;
		SR = SR OR LSHIFT MR1 (HI);
		MR1=SR1;
		RTS;
		nop;

calc_next:
	/*check direction*/
	/*positive direction;*/	




	AX0=DM(direction);
	AX1=0x0001;
	AR=AX0-AX1;		//if direction was=0 we go to the negdir part
	IF LT JUMP negdir;
	

	
	AX0=dm(delaySamples);

	AY0=0x0001;
	AR=AX0+AY0;
	dm(delaySamples)=AR;	
	nop;
	nop;

	AY0=dm(delayTop);
	AR=AR-AY0;
	IF LE jump endcalc;
	AR=0;
	dm(direction)=AR;
	jump endcalc;

negdir:	
	AX0=dm(delaySamples);
	AY0=1;
	AR=AX0-AY0;
	
	dm(delaySamples)=AR;
	nop;	
	nop;
	AR=AR-1;
	AY0=dm(delayBottom);
	AR=AY0-AR;
	IF LE  jump endcalc;
	AR=1;
	dm(direction)=AR;
endcalc:	

	//call printcount;

	nop;
	nop;
	rts;


