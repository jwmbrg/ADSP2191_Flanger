/*********************************************************
* rotary_encoder.asm
*
* Routines for monitoring the status of the two rotary 
* encoders on the ADSP-2191 Signal Processing board.
* Insert actions to be performed when rotary encoder
* is turned under labels CWx (clockwise turn, rotary 
* enc x) or CCWx (counterclockwise turn, rotary enc x).
*
* If the sampling frequency is changed, change RE_DELAY
* as:
* 		fs <= 11025		<->		RE_DELAY = 1
* 		fs = 22050		<->		RE_DELAY = 2
* 		fs = 44100		<->		RE_DELAY = 4
*
* - Patrik Pääjärvi, LTU, 2003
* - Per Johansson, Rubico AB, 2004
*********************************************************/

#include "def2191_stud-1.h"

#define RE_DELAY	0x0004			// 0.1ms @ fs=44100Hz
		
// Global symbols
.global		Poll_Rotary_Encoder1;
.global		Poll_Rotary_Encoder2;
.global 	Check_Rotary_Encoder1_Push;
//.global		RE1_State;
//.global		RE2_State;
//.global		New_LCD_Info;

// External symbols
.extern         CW1;
.extern         CCW1;
.extern		PUSH1;
.extern         CW2;
.extern         CCW2;

/******************** Data Memory Variables ***********************************/
.SECTION /dm    data0;

// State variables of rotary encoder 1 and 2
.var 		RE1_State = 0;
.var 		RE2_State = 0;

.var		New_LCD_Info = 0;

// Internal variables
.var		PF5_State = 0x0100;
.var		PF7_State = 0x0020;
.var		Delta_T1 = 0;
.var		Delta_T2 = 0;
.var		Polling_Allowed1 = 1;
.var		Polling_Allowed2 = 1;
.var		Last_state_encoder1_push = 0x0000;

/******************** Program Code *********************************************/
.SECTION /pm    program0;

// ******* Poll_Rotary_Encoder1 ***********************************************
// Checks if rotary encoder 1 knob has been turned and decides the direction
// of turn. Direction-dependent actions can be issued under labels 
//
//  ~ CW: Clockwise turn,
// or
//  ~ CCW: Counterclockwise turn.
// ****************************************************************************
Poll_Rotary_Encoder1:   // PF8 PF9 and PF4

	// Check current state of PF5 (line A).
    // If not changed, check state of PF4 (line B).
    // If changed, update PF5_State and reset Delta_T1 and Polling_Allowed1
    IOPG = General_Purpose_IO;
    AX0 = IO(FLAGS);
    
    AR = TSTBIT 8 OF AX0;
    AX0 = AR;
    AY0 = DM(PF5_State);
    AR = AX0 XOR AY0;
 	IF EQ JUMP Check_PF4_State;
    dm(PF5_State) = AX0;
    AR = 0;
    DM(Delta_T1) = AR;
    DM(Polling_Allowed1) = AR;
    RTS;
    
    // If PF5 state is low, check PF5 state if Delta_T1 = RE_DELAY,
	// else, increment Delta_T1
Check_PF4_State:
	// If polling not allowed (NE) -> RTS 
	AX1 = DM(Polling_Allowed1);
 	AR = PASS AX1;
 	IF NE RTS;
	AR = TSTBIT 8 OF AX0;
	IF EQ RTS;
	AX0 = DM(Delta_T1);
	AY0 = RE_DELAY;
	AR = AX0 XOR AY0;
	IF NE JUMP Inc_Delta_T1;
	
	// Set Polling_Allowed1 to indicate that turn has been serviced.
	// If PF4 state is high -> CW turn. If PF4 state is low -> CCW turn
	AR = 1;
	DM(Polling_Allowed1) = AR;
	
	AX0 = IO(FLAGS);
	AR = TSTBIT 9 OF AX0;
	IF EQ JUMP CW1;
	JUMP CCW1;

	Inc_Delta_T1:
	AR = DM(Delta_T1);
	AR = AR + 1;
	DM(Delta_T1) = AR;	
	RTS;

Check_Rotary_Encoder1_Push:
	IOPG = General_Purpose_IO;
        AX0 = IO(FLAGS);
        AR = TSTBIT 4 OF AX0;
	ax1 = dm(Last_state_encoder1_push);
	ar = ar xor ax1;
	if eq jump Check_Rotary_Encoder1_Push_END;
		AR = TSTBIT 4 OF AX0;
		dm(Last_state_encoder1_push) = ar;
		if eq jump Check_Rotary_Encoder1_Push_END;
		jump PUSH1;
	Check_Rotary_Encoder1_Push_END:
RTS;	
	
// ******* Poll_Rotary_Encoder2 ***********************************************
// Checks if rotary encoder 2 knob has been turned and decides the direction
// of turn. Direction-dependent actions can be issued under labels 
//
//  ~ CW: Clockwise turn,
// or
//  ~ CCW: Counterclockwise turn.
// ****************************************************************************
Poll_Rotary_Encoder2:

	// Check current state of PF7 (line A).
    // If not changed, check state of PF6 (line B).
    // If changed, update PF7_State and reset Delta_T2 and Polling_Allowed2
   	IOPG = General_Purpose_IO;
    AX0 = IO(FLAGS);
    AR = TSTBIT 5 OF AX0;
    AX0 = AR;
    AY0 = DM(PF7_State);
    AR = AX0 XOR AY0;
 	IF EQ JUMP Check_PF6_State;
    dm(PF7_State) = AX0;
    AR = 0;
    dm(Delta_T2) = AR;
    dm(Polling_Allowed2) = AR;
    RTS;
    
    // If PF7 state is low, check PF7 state if Delta_T2 = RE_DELAY,
	// else, increment Delta_T2
Check_PF6_State:
	// If polling not allowed (NE) -> RTS 
	AX1 = DM(Polling_Allowed2);
 	AR = PASS AX1;
 	IF NE RTS;
 //	AX0 = IO(FLAGS);  // Extra
	AR = TSTBIT 5 OF AX0;
	IF EQ RTS;
	AX0 = DM(Delta_T2);
	AY0 = RE_DELAY;
	AR = AX0 XOR AY0;
	IF NE JUMP Inc_Delta_T2;
	
	// Set Polling_Allowed2 to indicate that turn has been serviced.
	// If PF6 state is high -> CW turn. If PF6 state is low -> CCW turn
	AR = 1;
	dm(Polling_Allowed2) = AR;
	AX0 = IO(FLAGS);
	AR = TSTBIT 6 OF AX0;
	IF EQ JUMP CCW2;
	JUMP CW2;

	Inc_Delta_T2:
	AR = dm(Delta_T2);
	AR = AR + 1;
	dm(Delta_T2) = AR;	
	RTS;

	
