/*****************************************************************************************************************

        ISR.asm

************************************************************************************************/

#include "def2191_stud-1.h"	

/************************************************************************************************/
/*			   EXTERNAL DECLARATIONS						*/	
/************************************************************************************************/
.EXTERN Start;
.EXTERN	Process_AD1885_Audio_Samples;
.EXTERN RX_Status;
.EXTERN rx_buf;
.EXTERN IOPG_TMP;


/************************************************************************************************/
/* 				PM Reset interrupt vector code					*/
/************************************************************************************************/
.section/pm IVreset; 
  	jump Start;
  	nop; nop; nop;

/************************************************************************************************/
/* 				SPORT0 RX ISR							*/
/************************************************************************************************/
.section/pm IVint4;  
	ENA SEC_REG;						// Enable Secondary Registers 
	ay1 = IOPG;
	DM(IOPG_TMP) = AY1;	
  	IOPG = SPORT0_Controller_Page;
  
 	ax0 = LENGTH(rx_buf);					// Determine if Interrupt occured at the middle of 
	ay0 = IO(SP0DR_CNT);					// the DMA Buffer or at the end of DMA Buffer 
	ar = ax0 - ay0;
	if eq ljump Roll_Over;
	
	ay0 = 0x8000;
	ax0 = dm(RX_Status);					// Get status bit 15 from RX_Status 
	ar =ax0 AND ay0;
	if eq ljump Process_AD1885_Audio_Samples;

// ...house keeping prior to RTI 
Roll_Over:
	ay1=3;							// Clear RX Interrupts 
  	io(SP0DR_IRQ)=ay1;
	AY1 = DM(IOPG_TMP);
	IOPG = ay1;
	DIS SEC_REG;						// Disable Secondary Registers 
	RTI; 									
	

