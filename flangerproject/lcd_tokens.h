/****************************************************
* LCD_tokens.h
*
* Tokens used for communication between LCD and DSP
* 
* - Patrik P‰‰j‰rvi 2003
* - Per Johansson, Rubico AB, 2004
*****************************************************/




#define DISPLAY_CLEAR				0x0001			// Clear display, cursor home
#define CURSOR_HOME				0x0002			// Cursor home
#define DISPLAY_ON_CURSOR_OFF_BLINK_OFF		0x000C			// Display ON, cursor and blink OFF
#define FUNCTION_SET_4_BITS			0x0028			// 4 bit data length
#define ENTRY_MODE_INC_NO_SHIFT			0x0006			// Increment, no display shift

//#define DISPLAY_OFF_CURSOR_OFF_BLINK_OFF	0x0008			// Display, cursor and blink OFF
//#define FUNCTION_SET_8_BITS			0x0038			// 8 bit data length

#define	DD_RAM_ADDRESS_SET_40			0x00C0			// Set DDRAM address to 0x40
#define	DD_RAM_ADDRESS_SET_00			0x0080			// Set DDRAM address to 0x00
//#define	DD_RAM_ADDRESS_SET		0x0080			// Set DDRAM address to 0x00
//#define DISPLAY_SHIFT_RIGHT			0x001C			// Shift display to the right
