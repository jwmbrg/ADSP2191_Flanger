/*****************************************************************************************************************

        init.asm

*****************************************************************************************************************/	

#include "def2191_stud-1.h"	

/************************************************************************************************/
/*			   GLOBAL DECLARATIONS							*/	
/************************************************************************************************/ 
.global 	Codec_Reset;			  
.global		Program_SPORT0_Registers;
.global		Program_DMA_Controller;
.global		AD1885_Codec_Initialization;
.global		Change_PLL_Multiplier;

/************************************************************************************************/
/*			     CONSTANT & MACRO DEFINITIONS					*/	
/************************************************************************************************/ 
/*			register				address	*/
/*         --------------		----------- */
#define         REGS_RESET                      0x0000
#define		MASTER_VOLUME			0x0200
#define         HEAD_VOLUME                     0x0400
#define		MASTER_VOLUME_MONO		0x0600	
#define		RESERVED_REG_2			0x0800
#define		PC_BEEP_Volume			0x0A00
#define		PHONE_Volume			0x0C00
#define         MIC_Volume                      0x0E00
#define		LINE_IN_Volume			0x1000
#define         CD_Volume                       0x1200
#define		VIDEO_Volume			0x1400
#define         AUX_Volume                      0x1600
#define		PCM_OUT_Volume			0x1800
#define		RECORD_SELECT			0x1A00
#define         RECORD_GAIN                     0x1C00
#define		RESERVED_REG_3			0x1E00
#define		GENERAL_PURPOSE			0x2000
#define		THREE_D_CONTROL_REG		0x2200
#define		RESERVED_REG_4			0x2400
#define		POWERDOWN_CTRL_STAT		0x2600
#define		EXTEND_AUDIO_ID			0x2800
#define		EXTEND_AUDIO_CTL		0x2A00
#define         SAMPLE_RATE_GENERATE_1          0x2C00
#define         SAMPLE_RATE_GENERATE_0          0x3200
#define         JACK_SENSE                      0x7200
#define         SERIAL_CONFIGURATION            0x7400
#define         MISC_CONTROL_BITS               0x7600
#define         VENDOR_ID_1                     0x7C00
#define         VENDOR_ID_2                     0x7E00

/* Mask bit selections in Serial Configuration Register for 
   accessing registers on any of the 3 codecs */
#define		MASTER_Reg_Mask			0x1000
#define		SLAVE1_Reg_Mask			0x2000
#define		SLAVE2_Reg_Mask			0x4000
#define		MASTER_SLAVE1			0x3000
#define		MASTER_SLAVE2			0x5000
#define         MASTER_SLAVE1_SLAVE2            0x7000

/* Macros for setting Bits 15, 14 and 13 in Slot 0 Tag Phase */
#define		ENABLE_VFbit_SLOT1_SLOT2	0xE000
#define		ENABLE_VFbit_SLOT1			0xC000
#define 	ENABLE_VFbit_STEREO			0x9800

/* TDM Timeslot Definitions */
#define         TAG_PHASE               0
#define		COMMAND_ADDRESS_SLOT	1
#define         COMMAND_DATA_SLOT       2
#define         STATUS_ADDRESS_SLOT     1
#define         STATUS_DATA_SLOT        2
#define         LEFT                    3
#define         RIGHT                   4

/************************************************************************************************/
/* 				DM data 							*/
/************************************************************************************************/
.SECTION /dm    data0;
.var 	rx_buf[16]; 		/* receive buffer */
.GLOBAL rx_buf;
							/* transmit buffer */ 
.var 	tx_buf[16] = 	ENABLE_VFbit_SLOT1_SLOT2, SERIAL_CONFIGURATION, 0x9900, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
						0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000;
.GLOBAL tx_buf;

/***********************************/
/* Codec Register Initializations */
/* - refer to AD1885 Data Sheet for register bit assignments */
.var Init_Codec_Registers[50] =
        REGS_RESET,                     0xFFFF,
	MASTER_VOLUME,			0x0000,		/* Unmute Master Volume */
	HEAD_VOLUME,			0x0000,		/* Adjusted Headphone Vloume */
	MASTER_VOLUME_MONO,		0x8000,	
	PC_BEEP_Volume,			0x8000,
	PHONE_Volume,			0x8008,
        MIC_Volume,                     0x8008,
	LINE_IN_Volume,			0x8808,
        CD_Volume,                      0x8808,
        VIDEO_Volume,                   0x8808,
        AUX_Volume,                     0x8808,
	PCM_OUT_Volume,			0x0F0F,		/* Unmuted and attenuate by 10.5 dB */
	RECORD_SELECT,			0x0404,		/* Selected LINE IN as Record Select */
	RECORD_GAIN,			0x0A0A,		/* Unmuted Record Gain */
	GENERAL_PURPOSE,		0x0000,		
        THREE_D_CONTROL_REG,            0x0000,
        POWERDOWN_CTRL_STAT,            0x0000,
	EXTEND_AUDIO_ID,		0x0001,
	EXTEND_AUDIO_CTL,		0x0001,
        SAMPLE_RATE_GENERATE_1,         0xAC44,         /*Sample Rate 44.100 Hz*/
        SAMPLE_RATE_GENERATE_0,         0xAC44,
        JACK_SENSE,                     0x0000,
	MISC_CONTROL_BITS,		0x0404,
	VENDOR_ID_1,			0x4144,
	VENDOR_ID_2,			0x5360;
	
.var Codec_Init_Results[50]; 	
.var RX_Status = 0x8000;				/* RX Processing flag */
.GLOBAL RX_Status;


/************************************************************************************************/  
/*                              PM DATA                                                         */
/************************************************************************************************/ 
.SECTION /pm    program0;

/************************************************************************************************/
/* Change_PLL_Multiplier									*/
/************************************************************************************************/
Change_PLL_Multiplier:

	IOPG = Clock_and_System_Control_Page;
	
	ax1 = 0x0552;		//Stop the PLL - In Bypass
	IO(PLLCTL) = ax1;
	nop;
	
//     ar = dm(PLL_Multiplier);        //Reprogram the PLL - In Bypass
	ar = 0x1552;
	IO(PLLCTL) = ar;
	
//	dm(Old_PLL_Multiplier) = ar;
	
//	ar = tglbit 1 of ar;	//ex. 1550 -> 1552
	
	ar = 0x1550;
	
	IO(PLLCTL) = ar;	//Start the PLL - In Bypass
	nop;
		
	ax1 = 0x0450;		//Come out of Bypass - Takes ~ 500 clkin cycles
	IO(PLLCTL) = ax1;
	
	cntr = 1100;
	do wt until ce;
	wt:	nop;
	
	RTS;


/************************************************************************************************/
/* AD1885 HARDWARE RESET									*/
/* Toggle flag_7 to assert and deassert 1885_RESET					 	*/
/************************************************************************************************/

Codec_Reset:

	IOPG = General_Purpose_IO;
	
        AY0 = IO(DIRC);

	AY1 = 0x008C;				/* Configure PF I/O pins 2, 3, 7 as outputs */
	
	AR = AY0 OR AY1; 
        IO(DIRC) = AR;  
	
	AR = 0x0010; 
	IO(MASKAS) = AR;   			/* Unmask FLAG 4 as GPIO interrupt source 0 */
	
	AR = 0x0000;
        IO(FSPRC) = AR;                          /* Select FLAG polarity as active High - NOTE: Depends on hardware implementation */

	AR = 0x0000;
        IO(FSSRC) = AR;                          /* Select Flag input as level sensitive */
		
	AX1 = 0x0088;				/* Assert AD1885 /RESET (active low) */
	IO(FLAGC) = AX1;

	CNTR = 0xA0; 				/* AD1885 /Reset Active low for 1 usec assuming 160Mhz DSP Core CLK */
	DO loop_1 until CE;  		/* Duration of 1 usec */
  		loop_1: nop;
	AX1 = 0x0088;				/* De-assert AD1885 /RESET and turn-on PF_2 (LED_10)*/
	IO(FLAGS) = AX1;

		CNTR = 0x4;					/* Delay to allow the Codec to recover from Reset */
		DO loop_2 until CE;
	
			CNTR = 0x6A40; 				
			DO loop_3 until CE;  		
			loop_3: nop;
	
	loop_2: nop;

	RTS;
	
/************************************************************************************************/
/* SPORT0 CONTROL REGISTER PROGRAMMING								*/
/* Multichannel Mode, Autobuffer DMA , Early FS, Active HI FS, Fall Edge, Data=16		*/
/************************************************************************************************/

Program_SPORT0_Registers:
  	DIS int;								/* Disable all interrupts */
  	IRPTL = 0x0;							/* Clear all interrupts */
  	ICNTL = 0x0;							/* Interrupt nesting disable */
  	IMASK = 0;								/* Initially no interrupts */

   	IOPG = Interrupt_Controller_Page;		/* Assign Interrupt Vector Table Priorities */
  	ar = 0xbb0b;
  	io(IPR0) = ar;		 					/* 1=Sport0 RX */

	ar = 0xbbbb;							/* Remainder assigned lowest priorities */
  	io(IPR1) = ar;
  	io(IPR2) = ar;
  	io(IPR3) = ar;
  

/* RESET SPORT0 & DMA */
  	IOPG = SPORT0_Controller_Page;			/* Set IOPG for SPORT0 */
	ar = 0x0000;
  	io(SP0_TCR) = ar;
  	io(SP0_RCR) = ar;
	io(SP0DR_CFG) = ar;
  	io(SP0DT_CFG) = ar;
  	io(SP0_MCMC1) = ar;				
	ar = 3;
	io(SP0DR_IRQ) = ar;				
	io(SP0DT_IRQ) = ar; 

/* Set SPORT0 frame sync divisor */
  	ar = 0x00FF;							/* AC'97 48Khz Frame Sync with 12.288Mhz Input Clock */
  	io(SP0_RFSDIV) = ar;

/* Set: Internal RFS, 16-bits receive, Internal clock */
  	ar = (IRFS + BITS16 ); /* + ICLK);*/
  	io(SP0_RCR) = ar;

/* Set: 16-bits transmit */
  	ar = (BITS16); 
  	io(SP0_TCR) = ar;

/* Enable MCM Transmit and Receive Channels */
  	ar = 0xFFFF;							/* Enable 16 Channels for TX */
  	io(SP0_MTCS0) = ar;
	ar = 0x0000;							/* ...disable the remaining channels */								
  	io(SP0_MTCS1) = ar;
  	io(SP0_MTCS2) = ar;
  	io(SP0_MTCS3) = ar;
  	io(SP0_MTCS4) = ar;
  	io(SP0_MTCS5) = ar;
  	io(SP0_MTCS6) = ar;
  	io(SP0_MTCS7) = ar;

  	ar = 0xFFFF;							/* Enable 16 Channels for RX */
  	io(SP0_MRCS0) = ar;
  	ar = 0x0000;							/* ...disable the remaining channels */								
  	io(SP0_MRCS1) = ar;
  	io(SP0_MRCS2) = ar;
  	io(SP0_MRCS3) = ar;
  	io(SP0_MRCS4) = ar;
 	io(SP0_MRCS5) = ar;
  	io(SP0_MRCS6) = ar;
  	io(SP0_MRCS7) = ar;  	
	

/* Set MCM Configuration Reg 1 - MCM enalbled , 1 frame delay, Win size = 16 Channels */
  	ar = 0x0023;
  	io(SP0_MCMC1) = ar;

/* Set MCM Configuration Reg 2 */
  	ar = 0x000C;
  	io(SP0_MCMC2) = ar;  

/* SPORT0 Interrupts Unmasked */
	AY0=IMASK;
	AY1=0x0010;
	AR = AY0 or AY1;						/* Clear SPORT0 RX mask bit */
	IMASK=AR;
	RTS;

/************************************************************************************************/
/* 			DMA Controller Programming For SPORT0 					*/
/************************************************************************************************/

Program_DMA_Controller:	

/* SPORT0 DMA AUTOBUFFER XMIT */
	ar= 0x0010; 						/* Set Autobuffer */
  	io(SP0DT_CFG) = ar;  

 	ar = 0;								/* SPORT0 TX DMA Internal Memory Page */
  	io(SP0DT_SRP) = ar;  
  	
	ar = tx_buf;						/* SPORT0 TX DMA Internal Memory Address */
	io(SP0DT_SRA) = ar;

	ar = LENGTH(tx_buf);				/* SPORT0 TX DMA Internal Memory Count */
	io(SP0DT_CNT) = ar;

/* SPORT0 DMA AUTOBUFFER RCV */
	ar= 0x0010; 						/* Set Autobuffer */
  	io(SP0DR_CFG) = ar;  

 	ar = 0;								/* SPORT0 RX DMA Internal Memory Page */
  	io(SP0DR_SRP) = ar;  
  	
	ar = rx_buf;						/* SPORT0 RX DMA Internal Memory Address */
	io(SP0DR_SRA) = ar;

	ar = LENGTH(rx_buf);				/* SPORT0 RX DMA Internal Memory Count */
	io(SP0DR_CNT) = ar;
  	

/* ENABLE SPORT0 DMA and DIRECTION IN DMA CONFIGURATION REGISTER */
	ar = 0x0011;						/* Enable TX DMA */
	io(SP0DT_CFG) = ar;		

	ar = 0x0017;						/* Enable RX DMA, RX Direction (mem write), RX Interrupts */
	io(SP0DR_CFG) = ar;  

	RTS;

/************************************************************************************************/
/* 				AD1885 Codec Initialization 					*/
/************************************************************************************************/
AD1885_Codec_Initialization:
	ax0 = io(SP0_RCR);					/* Enable SPORT0 RX */
	ar = setbit 0 of ax0;
	io(SP0_RCR) = ar; 

	ax0 = io(SP0_TCR);					/* Enable SPORT0 TX */
	ar = setbit 0 of ax0;
	io(SP0_TCR) = ar;
	
 	ENA int;							/* Enable Interrupts */

	idle;								/* Wait for a few RX interrupts to ensure SPORT is up and running */
	idle;

  	ay0 = 0x8000;
Wait_Codec_Ready:
  	ax0 = dm(rx_buf + 0);				/* Get status bit 15 from AD1885 Tag - SLOT '0' */
	ar =ax0 AND ay0;
	if eq jump Wait_Codec_Ready;
	
	AX0 = IOPG;
	IOPG = General_Purpose_IO;
	AX1 = 0x008C;						/* Assert PF 3 (LED 11 on 2191 EZKIT) indicating codec-DSP communication established  */
	IO(FLAGS) = AX1;
	IOPG = AX0;


/* Write Various registers of AD1885 to configre it - will read back these same registers to ensure they are properly configured */
Initialize_1885_Registers:
	i3 = Init_Codec_Registers;      				/* Pointer to codec initialization commands */
	l3 = 0;
	CNTR = 25;
	ax0 = ENABLE_VFbit_SLOT1_SLOT2;					
	dm(tx_buf + TAG_PHASE) = ax0;					/* Set 'Valid Slot' bits in TAG phase for SLOTS '0', '1' , '2' */
	DO Codec_Init UNTIL CE;
		ax0 = dm(i3, 1);                			/* Fetch next AD1885 register address */
		dm(tx_buf + COMMAND_ADDRESS_SLOT) = ax0;	/* ...put fetched codec register address into TX SLOT '1' */
		ax0 = dm(i3, 1);							/* Fetch register data contents */
		dm(tx_buf + COMMAND_DATA_SLOT) = ax0;		/* ...put fetched codec register data into TX SLOT '2' */
		idle; 
Codec_Init:	idle;									/* ...wait for 2 TDM frames... */

/* Verify AD1885 register writes */
verify_reg_writes:
	i3 = Init_Codec_Registers;
	l3 = 0;
	i2 = Codec_Init_Results;
	l2 = 0;
	CNTR =25;
	ax0 = ENABLE_VFbit_SLOT1;						
	dm(tx_buf + TAG_PHASE) = ax0;					/* Set 'Valid Slot' bits in TAG phase for SLOTS '0', '1' */
	Do ad1885_register_status UNTIL CE;
		ax0 = dm(i3,2);								/* Get next AD1885 register address that is to be read */
		ay0 = 0x8000;								/* Set bit #15 to signify AC'97 'Read-Request' in Command address word */
		ar = ax0 OR ay0;							
		dm(tx_buf + COMMAND_ADDRESS_SLOT) = ar;		/* TX value out of Command address time slot */
		idle;  										/* Wait for 5 AC'97 frames to go by, latency in getting data from AD1885 */
		idle;
		idle;
		idle;
		idle; 
		ax0 = dm(rx_buf + STATUS_ADDRESS_SLOT);
		dm(i2,1) = ax0;
		ax0 = dm(rx_buf + STATUS_DATA_SLOT);		
ad1885_register_status: dm(i2,1) = ax0;								/* Store to results buffer */


	RTS; 					/* End of AD1885 Initialization */
/************************************************************************************************/









