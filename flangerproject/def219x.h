/************************************************************************
 *
 * def219x.h : $Revision: 1.6 $
 *
 * (c) Copyright 2000-2003 Analog Devices, Inc.  All rights reserved.
 *
 ************************************************************************/

/*
** System register bit and address defines to symbolic names for
** ADSP-219x DSPs.
*/

/*-----------------------------------------------------------------------------
The def219x.h file defines ADSP-219x DSP family common symbolic names; for 
names that are unique to particular ADSP-219x family DSPs, see that DSP's 
definitions file (such as the def2192-12.h file) instead. This include file 
(def219x.h) contains a list of macro "defines" that let programs use symbolic 
names for the following ADSP-219x facilities:

- system register bit definitions
- system register map

Here are some example uses:

mstat = ASTAT_AR_SAT | ASTAT_M_MODE;   >> this ORs together the bitmask macros
     OR
ax0 = 0x0000;
ar = setbit ASTAT_AR_SAT_P of ax0;     >>> this uses the define of AR_SAT bit
ar = setbit ASTAT_M_MODE_P of ar;      >>> this uses the define of M_MODE bit
mstat = ar;


ccode = cond_SV;                       >>> this uses the define of SV condition
ax0 = 0; 
ar = 0;
ar = setbit ASTAT_SV_P of ax0;         >>> this uses the define of SV bit
astat = ar;
if swcond ar = ax0 xor 0x1000;

AR = setbit CACTL_CFZ_P of AX0;        >>> this uses the define of CACTL_CFZ_P bit
REG(CACTL) = AR;                       >>> this uses the define for the CACTL register's address

ax0 = 0x0800;
REG(B0) = ax0;                         >>> this uses the define for the B0 register's address
-----------------------------------------------------------------------------*/

#ifndef __DEF219x_H_
#define __DEF219x_H_

#define MK_BMSK_( x ) (1<<x)    // Make a bit mask from a bit position

//---------------------------------------------------------------------------
//                System Register bit definitions                            
//---------------------------------------------------------------------------

//**************************************************
//   ASTAT register
//**************************************************

// Bit Positions
#define ASTAT_AZ_P     0                       // Bit  0: ALU result zero
#define ASTAT_AN_P     1                       // Bit  1: ALU result negative   
#define ASTAT_AV_P     2                       // Bit  2: ALU overflow   
#define ASTAT_AC_P     3                       // Bit  3: ALU carry   
#define ASTAT_AS_P     4                       // Bit  4: ALU X input sign (ABS ops)   
#define ASTAT_AQ_P     5                       // Bit  5: ALU quotient (DIV ops)   
#define ASTAT_MV_P     6                       // Bit  6: Multiplier overflow   
#define ASTAT_SS_P     7                       // Bit  7: Shifter input sign   
#define ASTAT_SV_P     8                       // Bit  8: Shifter overflow   

// Bit Masks
#define ASTAT_AZ       MK_BMSK_(ASTAT_AZ_P)    // ALU result zero
#define ASTAT_AN       MK_BMSK_(ASTAT_AN_P)    // ALU result negative   
#define ASTAT_AV       MK_BMSK_(ASTAT_AV_P)    // ALU overflow   
#define ASTAT_AC       MK_BMSK_(ASTAT_AC_P)    // ALU carry   
#define ASTAT_AS       MK_BMSK_(ASTAT_AS_P)    // ALU X input sign (ABS ops)   
#define ASTAT_AQ       MK_BMSK_(ASTAT_AQ_P)    // ALU quotient (DIV ops)   
#define ASTAT_MV       MK_BMSK_(ASTAT_MV_P)    // Multiplier overflow   
#define ASTAT_SS       MK_BMSK_(ASTAT_SS_P)    // Shifter input sign   
#define ASTAT_SV       MK_BMSK_(ASTAT_SV_P)    // Shifter overflow   


//**************************************************
//   MSTAT register
//**************************************************

// Bit Positions
#define MSTAT_SEC_REG_P    0                           // Bit  0: Secondary data registers enable
#define MSTAT_BIT_REV_P    1                           // Bit  1: Bit-reversed address output enable 
#define MSTAT_AV_LATCH_P   2                           // Bit  2: ALU overflow latch mode select 
#define MSTAT_AR_SAT_P     3                           // Bit  3: ALU saturation mode select 
#define MSTAT_M_MODE_P     4                           // Bit  4: MAC result mode select 
#define MSTAT_TIMER_P      5                           // Bit  5: Timer enable 
#define MSTAT_SEC_DAG_P    6                           // Bit  6: Secondary DAG registers enable 
                      
// Bit Masks
#define MSTAT_SEC_REG      MK_BMSK_(MSTAT_SEC_REG_P )  // Secondary data registers enable
#define MSTAT_BIT_REV      MK_BMSK_(MSTAT_BIT_REV_P )  // Bit-reversed address output enable 
#define MSTAT_AV_LATCH     MK_BMSK_(MSTAT_AV_LATCH_P)  // ALU overflow latch mode select 
#define MSTAT_AR_SAT       MK_BMSK_(MSTAT_AR_SAT_P  )  // ALU saturation mode select 
#define MSTAT_M_MODE       MK_BMSK_(MSTAT_M_MODE_P  )  // MAC result mode select 
#define MSTAT_TIMER        MK_BMSK_(MSTAT_TIMER_P   )  // Timer enable 
#define MSTAT_SEC_DAG      MK_BMSK_(MSTAT_SEC_DAG_P )  // Secondary DAG registers enable 


//**************************************************
//   SSTAT register
//**************************************************

// Bit Positions
#define SSTAT_PCEM_P   0                       // Bit 0: PC stack empty 
#define SSTAT_PCFL_P   1                       // Bit 1: PC stack full 
#define SSTAT_PCLV_P   2                       // Bit 2: PC stack level 
#define SSTAT_LSEM_P   4                       // Bit 4: Loop stack empty 
#define SSTAT_LSFL_P   5                       // Bit 5: Loop stack full 
#define SSTAT_SSEM_P   6                       // Bit 6: Status stack empty 
#define SSTAT_SSOV_P   7                       // Bit 7: Stacks overflowed 

// Bit Masks
#define SSTAT_PCEM     MK_BMSK_(SSTAT_PCEM_P)  // PC stack empty 
#define SSTAT_PCFL     MK_BMSK_(SSTAT_PCFL_P)  // PC stack full 
#define SSTAT_PCLV     MK_BMSK_(SSTAT_PCLV_P)  // PC stack level 
#define SSTAT_LSEM     MK_BMSK_(SSTAT_LSEM_P)  // Loop stack empty 
#define SSTAT_LSFL     MK_BMSK_(SSTAT_LSFL_P)  // Loop stack full 
#define SSTAT_SSEM     MK_BMSK_(SSTAT_SSEM_P)  // Status stack empty 
#define SSTAT_SSOV     MK_BMSK_(SSTAT_SSOV_P)  // Stacks overflowed 


//**************************************************
//   ICNTL register
//**************************************************

// Bit Positions
#define ICNTL_INE_P         4                      // Bit  4: Interrupt nesting mode enable 
#define ICNTL_GIE_P         5                      // Bit  5: Global interrupt enable 
#define ICNTL_BIASRND_P     7                      // Bit  7: MAC biased rounding mode 
#define ICNTL_PCSTKE_P     10                      // Bit 10: PC stack interrupt enable 
#define ICNTL_CCNTE_P      11                      // Bit 11: Cycle counter enable 

// Bit Masks
#define ICNTL_INE     MK_BMSK_(ICNTL_INE_P    )    // Interrupt nesting mode enable 
#define ICNTL_GIE     MK_BMSK_(ICNTL_GIE_P    )    // Global interrupt enable 
#define ICNTL_BIASRND MK_BMSK_(ICNTL_BIASRND_P)    // MAC biased rounding mode 
#define ICNTL_PCSTKE  MK_BMSK_(ICNTL_PCSTKE_P )    // PC stack interrupt enable 
#define ICNTL_CCNTE   MK_BMSK_(ICNTL_CCNTE_P  )    // Cycle counter enable 


//**************************************************
//   IRPTL and IMASK registers
//**************************************************

// Bit Positions
#define INT_EMU_P           0                      // Bit  0: Offset: 00: Emulator interrupt 
#define INT_PWDN_P          1                      // Bit  1: Offset: 04: Powerdown interrupt 
#define INT_KRNL_P          2                      // Bit  2: Offset: 08: Kernel interrupt 
#define INT_STKI_P          3                      // Bit  3: Offset: 0c: Stack interrupt 
#define INT_INT4_P          4                      // Bit  4: Offset: 10: Off-Core
#define INT_INT5_P          5                      // Bit  5: Offset: 14: Off-Core 
#define INT_INT6_P          6                      // Bit  6: Offset: 18: Off-Core 
#define INT_INT7_P          7                      // Bit  7: Offset: 1c: Off-Core 
#define INT_INT8_P          8                      // Bit  8: Offset: 20: Off-Core 
#define INT_INT9_P          9                      // Bit  9: Offset: 24: Off-Core 
#define INT_INT10_P        10                      // Bit 10: Offset: 28: Off-Core 
#define INT_INT11_P        11                      // Bit 11: Offset: 2c: Off-Core 
#define INT_INT12_P        12                      // Bit 12: Offset: 30: Off-Core 
#define INT_INT13_P        13                      // Bit 13: Offset: 34: Off-Core 
#define INT_INT14_P        14                      // Bit 14: Offset: 38: Off-Core 
#define INT_INT15_P        15                      // Bit 15: Offset: 3c: Off-Core 

// Bit Masks
#define INT_EMU            MK_BMSK_(INT_EMU_P  )   // Offset: 00: Emulator interrupt 
#define INT_PWDN           MK_BMSK_(INT_PWDN_P )   // Offset: 04: Powerdown interrupt
#define INT_KRNL           MK_BMSK_(INT_KRNL_P )   // Offset: 08: Kernel interrupt 
#define INT_STKI           MK_BMSK_(INT_STKI_P )   // Offset: 0c: Stack interrupt 
#define INT_INT4           MK_BMSK_(INT_INT4_P )   // Offset: 10: Off-Core
#define INT_INT5           MK_BMSK_(INT_INT5_P )   // Offset: 14: Off-Core
#define INT_INT6           MK_BMSK_(INT_INT6_P )   // Offset: 18: Off-Core
#define INT_INT7           MK_BMSK_(INT_INT7_P )   // Offset: 1c: Off-Core
#define INT_INT8           MK_BMSK_(INT_INT8_P )   // Offset: 20: Off-Core
#define INT_INT9           MK_BMSK_(INT_INT9_P )   // Offset: 24: Off-Core
#define INT_INT10          MK_BMSK_(INT_INT10_P)   // Offset: 28: Off-Core
#define INT_INT11          MK_BMSK_(INT_INT11_P)   // Offset: 2c: Off-Core
#define INT_INT12          MK_BMSK_(INT_INT12_P)   // Offset: 30: Off-Core
#define INT_INT13          MK_BMSK_(INT_INT13_P)   // Offset: 34: Off-Core
#define INT_INT14          MK_BMSK_(INT_INT14_P)   // Offset: 38: Off-Core
#define INT_INT15          MK_BMSK_(INT_INT15_P)   // Offset: 3c: Off-Core


//**************************************************
//   CACTL register
//**************************************************

// Bit Positions
#define CACTL_CDE_P        5                       // Bit 5: Cache conflicting DM access enable 
#define CACTL_CFZ_P        6                       // Bit 6: Cache freeze 
#define CACTL_CPE_P        7                       // Bit 7: Cache conflicting PM access enable 

// Bit Masks
#define CACTL_CDE          MK_BMSK_(CACTL_CDE_P)   // Cache conflicting DM access enable
#define CACTL_CFZ          MK_BMSK_(CACTL_CFZ_P)   // Cache freeze 
#define CACTL_CPE          MK_BMSK_(CACTL_CPE_P)   // Cache conflicting PM access enable


//**************************************************
//   CCODE register
//**************************************************
#define cond_PF0        0x00           // if PF0 pin high, SWCOND true
#define cond_PF1        0x01           // if PF1 pin high, SWCOND true
#define cond_PF2        0x02           // if PF2 pin high, SWCOND true
#define cond_PF3        0x03           // if PF3 pin high, SWCOND true
#define cond_PF4        0x04           // if PF4 pin high, SWCOND true
#define cond_PF5        0x05           // if PF5 pin high, SWCOND true
#define cond_PF6        0x06           // if PF6 pin high, SWCOND true
#define cond_PF7        0x07           // if PF7 pin high, SWCOND true
#define cond_AS         0x08           // if AS, SWCOND true
#define cond_SV         0x09           // if SV, SWCOND true
#define cond_PF8        0x0A           // if PF8 pin high, SWCOND true
#define cond_PF9        0x0B           // if PF9 pin high, SWCOND true
#define cond_PF10       0x0C           // if PF10 pin high, SWCOND true
#define cond_PF11       0x0D           // if PF11 pin high, SWCOND true
#define cond_PF12       0x0E           // if PF12 pin high, SWCOND true
#define cond_PF13       0x0F           // if PF13 pin high, SWCOND true

//---------------------------------------------------------------------------
//                System Register address definitions                        
//---------------------------------------------------------------------------

#define B0      0x00    // DAG Base register 0 (for circular buffering only)
#define B1      0x01    // DAG Base register 1 (for circular buffering only)
#define B2      0x02    // DAG Base register 2 (for circular buffering only)
#define B3      0x03    // DAG Base register 3 (for circular buffering only)
#define B4      0x04    // DAG Base register 4 (for circular buffering only)
#define B5      0x05    // DAG Base register 5 (for circular buffering only)
#define B6      0x06    // DAG Base register 6 (for circular buffering only)
#define B7      0x07    // DAG Base register 7 (for circular buffering only)

#define CACTL   0x0F    // Cache control register

#define DBGCTRL 0x60    // Emulation Debug Control Register
#define DBGSTAT 0x61    // Emulation Debug Status Register
#define CNT0    0x62    // Cycle Counter Register 0 (LSB) (read this one 1st)
#define CNT1    0x63    // Cycle Counter Register 1
#define CNT2    0x64    // Cycle Counter Register 2
#define CNT3    0x65    // Cycle Counter Register 3 (MSB)

#endif


