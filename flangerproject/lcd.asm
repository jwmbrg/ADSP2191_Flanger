/*****************************************************************************
* LCD.asm
*
* Routines for handling the 2-line, 16-char LCD (L1672) on the STUD-1 board 
*  	
* - Patrik P„„j„rvi, LTU, 2003
* - Per Johansson, Rubico AB, 2004
*****************************************************************************/


// D7-4 PF10-13
// E 	PF14    
// RS	PF15    

#define		e_flagnr		0x4000 //
#define		rs_flagnr		0x8000 //

#include "def2191_stud-1.h"
#include "lcd_tokens.h"
#include "lcd_macro.h"

// Global symbols
.global 	Initialize_LCD;
.global		Set_RS;
.global		Clear_RS;
.global		LCD_Token;
.global		Send_LCD_Token;
.global		Wait_100us;
.global		Wait_10ms;

/******************** Data Memory Variables ***********************************/
.SECTION /dm    data0;
.var LCD_Token;

/******************** Program Code *********************************************/
.SECTION /pm program0;

// ******* Initialize_LCD *****************************************************
// Set data length to 4 bits and clear display (reset LCD module) 
// ****************************************************************************	
Initialize_LCD:
	
	IOPG = General_Purpose_IO;
   	
	AX1 = e_flagnr;
	IO(FLAGC) = AX1;					    // Make sure E=0
	
	CALL Clear_RS;							// Make sure RS=0
	
	// ******* Reset sequence ******************
	CALL Wait_10ms;
	CALL Wait_10ms;
	CALL Wait_10ms;
				
	AX1 = 0x33;
	CALL Send_LCD_Token;
	CALL Wait_10ms;
	
	AX1 = 0x32;
	CALL Send_LCD_Token;
	CALL Wait_10ms;
	// *****************************************		

	// ******* Instr. set: DL = 4 bits *********
	AX1 = FUNCTION_SET_4_BITS;
	CALL Send_LCD_Token;
	CALL Wait_100us;
	// *****************************************

	// ******* Entry mode set ******************
	AX1 = ENTRY_MODE_INC_NO_SHIFT;
	CALL Send_LCD_Token;
	CALL Wait_100us;
	// *****************************************

	// ******* Display on **********************
	AX1 = DISPLAY_ON_CURSOR_OFF_BLINK_OFF;
	CALL Send_LCD_Token;
	CALL Wait_100us;
	// *****************************************

	// ******* Clear display *******************
	AX1 = DISPLAY_CLEAR;
	CALL Send_LCD_Token;
	CALL Wait_100us;
	// *****************************************
	
	// ******* Cursor home *********************
	AX1 = CURSOR_HOME;
	CALL Send_LCD_Token;
	CALL Wait_100us;
	// *****************************************
	
	// ******* Cursor set  *********************
	AX1 = 0xC0;
	CALL Send_LCD_Token;
	CALL Wait_100us;
	// *****************************************

	CALL Wait_10ms;
	CALL Wait_10ms;
	CALL Wait_10ms;
	
	RTS;

// ******* Clear_RS ***********************************************************
// Clear RS bit 
// ****************************************************************************			
Clear_RS:	
	AX1 = rs_flagnr;
    IO(FLAGC) = AX1;	
	CALL Wait_250ns;		
//Clear_RS.END: 
	RTS;
	
// ******* Set_RS *************************************************************
// Set RS bit 
// ****************************************************************************			
Set_RS:
	AX1 = rs_flagnr;
    IO(FLAGS) = AX1;	
	CALL Wait_250ns;		
//Set_RS.END: 
	RTS;

		
// ******* Send_LCD_Token *****************************************************
// Send LCD token stored in AX1
// ****************************************************************************					
Send_LCD_Token:
	

	ax0 = 0x3C00;
	IO(FLAGC) = ax0;		// Clear data bits
	
	DM(LCD_Token) = AX1;	
	ay0 = 0x00F0;
	ar = ax1 and ay0;
	si = ar;
	sr = lshift si by 6 (LO);
	ax0 = sr0;
	ay0 = IO(FLAGS);
	ar = ax0 or ay0;
	IO(FLAGS) = ar;		
		
	
	//////// E cycle	
	AX1 = e_flagnr;
    IO(FLAGS) = AX1;	
	CALL Wait_250ns;
	AX1 = e_flagnr;
    IO(FLAGC) = AX1;					
	CALL Wait_250ns;
  	   	
	
	ax0 = 0x3C00;
	IO(FLAGC) = ax0;		// Clear data bits
	
	AX1 = DM(LCD_Token);	
	ay0 = 0x000F;
	ar = ax1 and ay0;
	si = ar;
	sr = lshift si by 10 (LO);
	ax0 = sr0;
	ay0 = IO(FLAGS);
	ar = ax0 or ay0;
	IO(FLAGS) = ar;		
		
		
	//////// E cycle
	AX1 = e_flagnr;
    IO(FLAGS) = AX1;								// Toggle Enable pin
    CALL Wait_250ns;	
	AX1 = e_flagnr;
    IO(FLAGC) = AX1;
	CALL Wait_250ns;
	CALL Wait_250ns;
	CALL Wait_250ns;
//	CALL Wait_250ns;
				   
//	CALL Wait_100us;
		
//Send_LCD_Token.END:      
	RTS;

	
// ******* Wait_10ms **********************************************************
// Delay (at least) 10 ms
// ****************************************************************************	
Wait_10ms:	
	CNTR = 150;
	DO tenmsloop UNTIL CE;
		CALL Wait_100us;
		tenmsloop: nop;
//Wait_10ms.END:
	RTS;
	
// ******* Wait_100us **********************************************************
// Delay (at least) 100 us
// ****************************************************************************	
Wait_100us:	
	CNTR = 8000;
	DO hundredusloop UNTIL CE;
		nop; 
		hundredusloop: nop;
//Wait_100us.END:  
	RTS;
	
Wait_250ns:
	CNTR = 3000;  // 20 org
	DO loop_1 UNTIL CE;
		nop;
		loop_1: nop;
//Wait_250ns.END:  
	RTS;
	
