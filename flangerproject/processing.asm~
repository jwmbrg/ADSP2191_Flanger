/*****************************************************************************************************

        Processing.asm

*****************************************************************************************************/

#include "def2191_stud-1.h"	
	
/*****************************************************************************************************
   CONSTANT & MACRO DEFINITIONS
*****************************************************************************************************/
/* AD1885 TDM Timeslot Definitions */
#define		TAG_PHASE		0
#define		COMMAND_ADDRESS_SLOT	1
#define		COMMAND_DATA_SLOT	2
#define		STATUS_ADDRESS_SLOT	1
#define		STATUS_DATA_SLOT	2
#define		LEFT			3
#define		RIGHT			4

/* Left and Right ADC valid Bits used for testing of valid audio data in current TDM frame */
#define		M_Left_ADC		12
#define		M_Right_ADC		11

/*****************************************************************************************************
   GLOBAL & EXTERNAL DECLARATIONS
*****************************************************************************************************/
.global		Process_AD1885_Audio_Samples;
.global		IOPG_TMP;
.extern		tx_buf;
.extern		rx_buf;

/*
*	Assignment 6
*/
// Output samples
.global 		Left_Channel_Out;
.global 		Right_Channel_Out;
.extern 	myfilter;
.extern 	ass1_filter;
.extern 	mac_overflow_detector;
/************************************************************************************************/
/* 				DM data 							*/
/************************************************************************************************/
.section/dm    data0;
/* AD1885 stereo-channel data holders - used for DSP processing of audio data recieved from codec */

// Input samples

.var 		Left_Channel;
.var 		Right_Channel;
.global 	Left_Channel;
.global 	Right_Channel;

// Output samples
.var 		Left_Channel_Out;
.var 		Right_Channel_Out;

.var 		IOPG_TMP;


/************************************************************************************************/  
/*                              PM DATA                                                         */
/************************************************************************************************/ 
.section/pm program0;
Process_AD1885_Audio_Samples: 	
        ax0 = 0x8000;               				/* Clear all AC97 link Audio Output Frame slots */
        dm(tx_buf + TAG_PHASE) = ax0;				/* and set Valid Frame bit in SLOT '0' TAG phase  */
        ax0 = 0;
        dm(tx_buf + COMMAND_ADDRESS_SLOT) = ax0;
        dm(tx_buf + COMMAND_DATA_SLOT) = ax0;
        dm(tx_buf + LEFT) = ax0;
        dm(tx_buf + RIGHT) = ax0;

Check_ADCs_For_Valid_Data:
        ax0 = dm(rx_buf + TAG_PHASE);          		/* Get ADC valid bits from tag phase slot*/
        ax1 = 0x1800;                				/* Mask other bits in tag */
        ar = ax0 and ax1;	

Set_TX_Slot_Valid_Bits:
        ay1 = dm(tx_buf + TAG_PHASE);           	/* Frame/Addr/Data valid bits */
	    ar = ar or ay1;            					/* Set TX valid bits based on Recieve TAG info */
		dm(tx_buf + TAG_PHASE) = ar;


Check_AD1885_ADC_Left:                         		
	AR = TSTBIT M_Left_ADC of ax0;					/* Check Left ADC valid bit */
	IF EQ JUMP Check_AD1885_ADC_Right;   			/* If valid data then save ADC sample */
	ax1 = dm(rx_buf + LEFT);						/* Get AD1885 Left channel input sample */
	dm(Left_Channel) = ax1;							/* Save to data holder for processing */


Check_AD1885_ADC_Right:                        				
	AR = TSTBIT M_Right_ADC of ax0;					/* Check Right ADC valid bit */
	IF EQ JUMP Valid_Frame;       								/* If valid data then save ADC sample */
  	ax1 = dm(rx_buf + RIGHT);						/* Get AD1885 Right channel input sample */
	dm(Right_Channel) = ax1; 						/* Save to data holder for processing */

/*****************************************************************************************************
* 	*** Insert DSP Algorithms Here ***						
* 					    						
* 	Input L/R Data Streams - DM(Left_Channel) DM(Right_Channel) 			
* 	Output L/R Results     - DM(Left_Channel_Out) DM(Right_Channel_Out)   				
*
*****************************************************************************************************/
/*
	Insert switch statement here
*/


// Output to tx_buf is set first to give the DMA transfers enough time.
Playback_Audio_Data:

	AR = DM(Right_Channel_Out); 			 
	DM(tx_buf + RIGHT) = AR;				// ...output Right data
	
	AR = DM(Left_Channel_Out);
	DM(tx_buf + LEFT) = AR;					// ...output Left data 



// ****** Process input samples here... ******
	//DIS SEC_REG;
	nop;
	call myfilter;
	//ENA SEC_REG;
	nop;
	nop;
	

// ****** End of sample processing... ******

/* ...house keeping prior to RTI */
Valid_Frame:
	ay1=3;							// Clear RX Interrupts 
  	io(SP0DR_IRQ)=ay1;
	AY1 = DM(IOPG_TMP);
	IOPG = ay1;
	DIS SEC_REG;						// Disable Secondary Registers 
	RTI; 			

	

