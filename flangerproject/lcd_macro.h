/*********************************************************************
* LCD_macro.h
* 
* Defines the Output_LCD_Token macro which outputs a 
* string of tokens on the 2-line, 16-char LCD display 
* on the ADSP-2191 Signal Processing board.
*
* Usage:	
*
* <Output_LCD_Token(token_var,num_of_chars,linenr,linepos);>
*
* writes 'num_of_chars' characters from starting address
* 'token_var' on line 'linenr', position 'linepos' on LCD.
*
* Valid parameter ranges:
*							num_of_chars: 1-16
*							linenr: 1 - 2
*							linepos: 1 - 16	
*
* Example: 
*			<Output_LCD_Token(Token_Buffer,3,2,5);>
* writes the three first characters stored in 'Token_Buffer'
* on line 2, position 5 on the LCD.		
*
*
* --!!!-- NOTE: THIS MACRO USES I7 AND L7 DAG REGISTERS --!!!--
*
* 
* - Patrik P‰‰j‰rvi, LTU, 2003
* - Per Johansson, Rubico AB, 2004  	
*********************************************************************/
.extern	Set_RS;
.extern	Clear_RS;
.extern	LCD_Token;
.extern	Send_LCD_Token;
.extern	Wait_100us;

#define Output_LCD_Token(token_var,num_of_chars,linenr,linepos)\
	\
	ENA M_MODE;\
	DMPG1 = 0x0;\
        I7 = token_var;\
	L7 = 0;\
	CALL Clear_RS;\
	AR = linenr;\
	AR = AR -1;\
	MX0 = AR;\
	MY0 = 0x0040;\
	MR = MX0 * MY0 (SS);\
	AX0 = MR0;\
	DIS M_MODE;\
	AR = linepos;\
	AR = AR - 1;\
	AY0 = AR;\
	AR = AX0 + AY0;\
	AX0 = AR;\
	AY0 = 0x0080;\
	AR = AX0 OR AY0;\
	AX1 = AR;\
	CALL Send_LCD_Token;\
	\
	CALL Set_RS;\
	CNTR = num_of_chars;\
	DO loop_? UNTIL CE;\
		AX1 = DM(I7+=1);\
                CALL Send_LCD_Token;\
		loop_?: nop;\
	nop
