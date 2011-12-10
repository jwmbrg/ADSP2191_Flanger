/* -----------------------------------------------------------------------------
def2191.h - SYSTEM REGISTER BIT & ADDRESS DEFINITIONS FOR ADSP-2191 DSP

Copyright (c) 2001 Analog Devices, Inc.,  All rights reserved

The def2191.h file defines ALL ADSP-2191 DSP symbolic names.

-----------------------------------------------------------------------------*/

#ifndef __DEF2191_H_
#define __DEF2191_H_

// Begin with a 219x CORE
#include <def219x.h>

//---------------------------------------------------------------------------
//                     I/O Processor Register Map                            
//---------------------------------------------------------------------------

// DMA Bus Bridge; these are on IOPG=0x00

#define DMA_Bus_Bridge_Page 0x00
#define D_ADLO_0  0x044    // DMA Bridge Addr FIFO 0 Register (15-0)
#define D_ADLO_1  0x045    // DMA Bridge Addr FIFO 1 Register (15-0)
#define D_ADLO_2  0x046    // DMA Bridge Addr FIFO 2 Register (15-0)
#define D_ADLO_3  0x047    // DMA Bridge Addr FIFO 3 Register (15-0)
#define D_DALO_0  0x048    // DMA Bridge Data FIFO 0 (15-0)
#define D_DALO_1  0x049    // DMA Bridge Data FIFO 1 (15-0)
#define D_DALO_2  0x04a    // DMA Bridge Data FIFO 2 (15-0)
#define D_DALO_3  0x04b    // DMA Bridge Data FIFO 3 (15-0)
#define ADDAHI_0  0x04c    // DMA Bridge Addr & Data FIFO 0 (23-16)
#define ADDAHI_1  0x04d    // DMA Bridge Addr & Data FIFO 1 (23-16)
#define ADDAHI_2  0x04e    // DMA Bridge Addr & Data FIFO 2 (23-16)
#define ADDAHI_3  0x04f    // DMA Bridge Addr & Data FIFO 3 (23-16)

// External Access Bridge; these are on IOPG=0x00

#define External_Access_Bridge_Page 0x00
#define E_STAT    0x080    //  EAB config/status register

// Trace Buffer; these are on IOPG=0x00

#define Trace_Buffer_Page 0x00
#define TCSR      0x090    // Trace Control/Status Register
#define STBUF0    0x091    // Source Top of Stack reg (Low bits)
#define STBUF1    0x092    // Source Top of Stack reg (High bits)
#define DTBUF0    0x093    // Destin Top of Stack reg (Low bits)
#define DTBUF1    0x094    // Destin Top of Stack reg (High bits)

// JTAG Debug; these are on IOPG=0x00

#define JTAG_and_Debug_Page 0x00
#define INDATA    0x0E0    // INDATA register
#define OUTDATA   0x0E1    // OUTDATA Register
#define JDCSR     0x0E2    // JDCC Control/Status register

// ADSP-2191 On-Chip System IO Space

// Clock and System Control; these are on IOPG=0x00 (0x00200-0x003FF)

#define Clock_and_System_Control_Page 0x00
#define PLLCTL    0x200    // PLL Control register
#define LOCKCNT   0x201    // PLL Lock Counter
#define SWRST     0x202    // Software Reset Register
#define NXTSCR    0x203    // Next System Configuration register
#define SYSCR     0x204    // System Configuration register

// Reserved  (0x00400-0x005FF)

// Interrupt Controller; these are on IOPG=0x01 (0x00600-0x007FF)

#define Interrupt_Controller_Page 0x01
#define IPR0      0x200    // Interrupt Priority Register 0
#define IPR1      0x201    // Interrupt Priority Register 1
#define IPR2      0x202    // Interrupt Priority Register 2
#define IPR3      0x203    // Interrupt Priority Register 3
#define INTRD0    0x204    // Source Interrupt Register 0
#define INTRD1    0x205    // Source Interrupt Register 1
#define INTRD2    0x206    // Source Interrupt Register 2
#define INTRD3    0x207    // Source Interrupt Register 3
#define INTRD4    0x208    // Source Interrupt Register 4
#define INTRD5    0x209    // Source Interrupt Register 5
#define INTRD6    0x20A    // Source Interrupt Register 6
#define INTRD7    0x20B    // Source Interrupt Register 7
#define INTRD8    0x20C    // Source Interrupt Register 8
#define INTRD9    0x20D    // Source Interrupt Register 9
#define INTRD10   0x20E    // Source Interrupt Register 10
#define INTRD11   0x20F    // Source Interrupt Register 11

// Memory DMA Controller; these are on IOPG=0x02 (0x00800-0x009FF)

#define Memory_DMA_Controller_Page 0x02
#define DMACW_PTR 0x100    // Mem Wr Channel - DMA Current Pointer
#define DMACW_CFG 0x101    // Mem Wr Channel - DMA Configuration
#define DMACW_SRP 0x102    // Mem Wr Channel - DMA Start Page
#define DMACW_SRA 0x103    // Mem Wr Channel - DMA Start Address
#define DMACW_CNT 0x104    // Mem Wr Channel - DMA Count
#define DMACW_CP  0x105    // Mem Wr Channel - DMA Next Descriptor Pointer
#define DMACW_CPR 0x106    // Mem Wr Channel - DMA Descriptor Ready
#define DMACW_IRQ 0x107    // Mem Wr Channel - DMA Interrupt Register

#define DMACR_PTR 0x180    // Mem Rd Channel - DMA Current Pointer
#define DMACR_CFG 0x181    // Mem Rd Channel - DMA Start Address
#define DMACR_CNT 0x184    // Mem Rd Channel - DMA Count
#define DMACR_CP  0x185    // Mem Rd Channel - DMA Next Descriptor Pointer
#define DMACR_CPR 0x186    // Mem Rd Channel - DMA Descriptor Ready
#define DMACR_IRQ 0x187    // Mem Rd Channel - DMA Interrupt Register

// SPORT0 Controller; these are on IOPG=0x02 (0x00A00-0x00BFF)

#define SPORT0_Controller_Page 0x02
#define SP0_TCR    0x200   // SPORT0 Transmit Configuration Register
#define SP0_RCR    0x201   // SPORT0 Receive Configuration Register
#define SP0_TX     0x202   // SPORT0 TX transmit Register
#define SP0_RX     0x203   // SPORT0 RX Receive register
#define SP0_TSCKDIV 0x204  // SPORT0 Transmit Serial Clock Divider
#define SP0_RSCKDIV 0x205  // SPORT0 Receive Serial Clock Divider
#define SP0_TFSDIV 0x206   // SPORT0 Transmit Frame Sync Divider
#define SP0_RFSDIV 0x207   // SPORT0 Receive Frame Sync Divider
#define SP0_STATR  0x208   // SPORT0 Status Register
#define SP0_MTCS0  0x209   // SPORT0 Multi-Channel Transmit Select Register
#define SP0_MTCS1  0x20A   // SPORT0 Multi-Channel Transmit Select Register
#define SP0_MTCS2  0x20B   // SPORT0 Multi-Channel Transmit Select Register
#define SP0_MTCS3  0x20C   // SPORT0 Multi-Channel Transmit Select Register
#define SP0_MTCS4  0x20D   // SPORT0 Multi-Channel Transmit Select Register
#define SP0_MTCS5  0x20E   // SPORT0 Multi-Channel Transmit Select Register
#define SP0_MTCS6  0x20F   // SPORT0 Multi-Channel Transmit Select Register
#define SP0_MTCS7  0x210   // SPORT0 Multi-Channel Transmit Select Register
#define SP0_MRCS0  0x211   // SPORT0 Multi-Channel Receive Select Register
#define SP0_MRCS1  0x212   // SPORT0 Multi-Channel Receive Select Register
#define SP0_MRCS2  0x213   // SPORT0 Multi-Channel Receive Select Register
#define SP0_MRCS3  0x214   // SPORT0 Multi-Channel Receive Select Register
#define SP0_MRCS4  0x215   // SPORT0 Multi-Channel Receive Select Register
#define SP0_MRCS5  0x216   // SPORT0 Multi-Channel Receive Select Register
#define SP0_MRCS6  0x217   // SPORT0 Multi-Channel Receive Select Register
#define SP0_MRCS7  0x218   // SPORT0 Multi-Channel Receive Select Register
#define SP0_MCMC1  0x219   // SPORT0 Multi-Channel Configuration Register 1
#define SP0_MCMC2  0x21A   // SPORT0 Multi-Channel Configuration Register 2

#define SP0DR_PTR  0x300   // SPORT0 -RCV DMA Current Pointer
#define SP0DR_CFG  0x301   // SPORT0 -RCV DMA Configuration
#define SP0DR_SRP  0x302   // SPORT0 -RCV DMA Start Page
#define SP0DR_SRA  0x303   // SPORT0 -RCV DMA Start Address
#define SP0DR_CNT  0x304   // SPORT0 -RCV DMA Count
#define SP0DR_CP   0x305   // SPORT0 -RCV DMA Next Descriptor Pointer
#define SP0DR_CPR  0x306   // SPORT0 -RCV DMA Descriptor Ready
#define SP0DR_IRQ  0x307   // SPORT0 -RCV DMA Interrupt Register

#define SP0DT_PTR  0x380   // SPORT0 -XMT DMA Current Pointer
#define SP0DT_CFG  0x381   // SPORT0 -XMT DMA Configuration
#define SP0DT_SRP  0x382   // SPORT0 -XMT DMA Start Page
#define SP0DT_SRA  0x383   // SPORT0 -XMT DMA Start Address
#define SP0DT_CNT  0x384   // SPORT0 -XMT DMA Count
#define SP0DT_CP   0x385   // SPORT0 -XMT DMA Next Descriptor Pointer
#define SP0DT_CPR  0x386   // SPORT0 -XMT DMA Descriptor Ready
#define SP0DT_IRQ  0x387   // SPORT0 -XMT DMA Interrupt Register

// SPORT1 Controller; these are on IOPG=0x03 (0x00C00-0x00DFF)

#define SPORT1_Controller_Page 0x03
#define SP1_TCR    0x000   // SPORT1 Transmit Configuration Register
#define SP1_RCR    0x001   // SPORT1 Receive Configuration Register
#define SP1_TX     0x002   // SPORT1 TX transmit Register
#define SP1_RX     0x003   // SPORT1 RX Receive register
#define SP1_TSCKDIV 0x004  // SPORT1 Transmit Serial Clock Divider
#define SP1_RSCKDIV 0x005  // SPORT1 Receive Serial Clock Divider
#define SP1_TFSDIV 0x006   // SPORT1 Transmit Frame Sync Divider
#define SP1_RFSDIV 0x007   // SPORT1 Receive Frame Sync Divider
#define SP1_STATR  0x008   // SPORT1 Status Register
#define SP1_MTCS0  0x009   // SPORT1 Multi-Channel Transmit Select Register
#define SP1_MTCS1  0x00A   // SPORT1 Multi-Channel Transmit Select Register
#define SP1_MTCS2  0x00B   // SPORT1 Multi-Channel Transmit Select Register
#define SP1_MTCS3  0x00C   // SPORT1 Multi-Channel Transmit Select Register
#define SP1_MTCS4  0x00D   // SPORT1 Multi-Channel Transmit Select Register
#define SP1_MTCS5  0x00E   // SPORT1 Multi-Channel Transmit Select Register
#define SP1_MTCS6  0x00F   // SPORT1 Multi-Channel Transmit Select Register
#define SP1_MTCS7  0x010   // SPORT1 Multi-Channel Transmit Select Register
#define SP1_MRCS0  0x011   // SPORT1 Multi-Channel Receive Select Register
#define SP1_MRCS1  0x012   // SPORT1 Multi-Channel Receive Select Register
#define SP1_MRCS2  0x013   // SPORT1 Multi-Channel Receive Select Register
#define SP1_MRCS3  0x014   // SPORT1 Multi-Channel Receive Select Register
#define SP1_MRCS4  0x015   // SPORT1 Multi-Channel Receive Select Register
#define SP1_MRCS5  0x016   // SPORT1 Multi-Channel Receive Select Register
#define SP1_MRCS6  0x017   // SPORT1 Multi-Channel Receive Select Register
#define SP1_MRCS7  0x018   // SPORT1 Multi-Channel Receive Select Register
#define SP1_MCMC1  0x019   // SPORT1 Multi-Channel Configuration Register 1
#define SP1_MCMC2  0x01A   // SPORT1 Multi-Channel Configuration Register 2

#define SP1DR_PTR  0x100   // SPORT1 -DMA RCV Current Pointer
#define SP1DR_CFG  0x101   // SPORT1 -RCV DMA Configuration
#define SP1DR_SRP  0x102   // SPORT1 -RCV DMA Start Page
#define SP1DR_SRA  0x103   // SPORT1 -RCV DMA Start Address
#define SP1DR_CNT  0x104   // SPORT1 -RCV DMA Count
#define SP1DR_CP   0x105   // SPORT1 -RCV DMA Next Descriptor Pointer
#define SP1DR_CPR  0x106   // SPORT1 -RCV DMA Descriptor Ready
#define SP1DR_IRQ  0x107   // SPORT1 -RCV DMA Interrupt Register

#define SP1DT_PTR  0x180   // SPORT1 -XMT DMA Current Pointer
#define SP1DT_CFG  0x181   // SPORT1 -XMT DMA Configuration
#define SP1DT_SRP  0x182   // SPORT1 -XMT DMA Start Page
#define SP1DT_SRA  0x183   // SPORT1 -XMT DMA Start Address
#define SP1DT_CNT  0x184   // SPORT1 -XMT DMA Count
#define SP1DT_CP   0x185   // SPORT1 -XMT DMA Next Descriptor Pointer
#define SP1DT_CPR  0x186   // SPORT1 -XMT DMA Descriptor Ready
#define SP1DT_IRQ  0x187   // SPORT1 -XMT DMA Interrupt Register

// SPORT2 Controller; these are on IOPG=0x03 (0x00E00-0x00FFF)

#define SPORT2_Controller_Page 0x03
#define SP2_TCR    0x200   // SPORT2 Transmit Configuration Register
#define SP2_RCR    0x201   // SPORT2 Receive Configuration Register
#define SP2_TX     0x202   // SPORT2 TX transmit Register
#define SP2_RX     0x203   // SPORT2 RX Receive register
#define SP2_TSCKDIV 0x204  // SPORT2 Transmit Serial Clock Divider
#define SP2_RSCKDIV 0x205  // SPORT2 Receive Serial Clock Divider
#define SP2_TFSDIV 0x206   // SPORT2 Transmit Frame Sync Divider
#define SP2_RFSDIV 0x207   // SPORT2 Receive Frame Sync Divider
#define SP2_STATR  0x208   // SPORT2 Status Register
#define SP2_MTCS0  0x209   // SPORT2 Multi-Channel Transmit Select Register
#define SP2_MTCS1  0x20A   // SPORT2 Multi-Channel Transmit Select Register
#define SP2_MTCS2  0x20B   // SPORT2 Multi-Channel Transmit Select Register
#define SP2_MTCS3  0x20C   // SPORT2 Multi-Channel Transmit Select Register
#define SP2_MTCS4  0x20D   // SPORT2 Multi-Channel Transmit Select Register
#define SP2_MTCS5  0x20E   // SPORT2 Multi-Channel Transmit Select Register
#define SP2_MTCS6  0x20F   // SPORT2 Multi-Channel Transmit Select Register
#define SP2_MTCS7  0x210   // SPORT2 Multi-Channel Transmit Select Register
#define SP2_MRCS0  0x211   // SPORT2 Multi-Channel Receive Select Register
#define SP2_MRCS1  0x212   // SPORT2 Multi-Channel Receive Select Register
#define SP2_MRCS2  0x213   // SPORT2 Multi-Channel Receive Select Register
#define SP2_MRCS3  0x214   // SPORT2 Multi-Channel Receive Select Register
#define SP2_MRCS4  0x215   // SPORT2 Multi-Channel Receive Select Register
#define SP2_MRCS5  0x216   // SPORT2 Multi-Channel Receive Select Register
#define SP2_MRCS6  0x217   // SPORT2 Multi-Channel Receive Select Register
#define SP2_MRCS7  0x218   // SPORT2 Multi-Channel Receive Select Register
#define SP2_MCMC1  0x219   // SPORT2 Multi-Channel Configuration Register 1
#define SP2_MCMC2  0x21A   // SPORT2 Multi-Channel Configuration Register 2

#define SP2DR_PTR  0x300   // SPORT2 -DMA RCV Current Pointer register
#define SP2DR_CFG  0x301   // SPORT2 -RCV DMA Configuration register
#define SP2DR_SRP  0x302   // SPORT2 -RCV DMA Start Page register
#define SP2DR_SRA  0x303   // SPORT2 -RCV DMA Start Address register
#define SP2DR_CNT  0x304   // SPORT2 -RCV DMA Count register
#define SP2DR_CP   0x305   // SPORT2 -RCV DMA Next Descriptor Pointer register
#define SP2DR_CPR  0x306   // SPORT2 -RCV DMA Descriptor Ready
#define SP2DR_IRQ  0x307   // SPORT2 -RCV DMA Interrupt Register

#define SP2DT_PTR  0x380   // SPORT2 -XMT DMA Current Pointer register
#define SP2DT_CFG  0x381   // SPORT2 -XMT DMA Configuration register
#define SP2DT_SRP  0x382   // SPORT2 -XMT DMA Start Page register
#define SP2DT_SRA  0x383   // SPORT2 -XMT DMA Start Address register
#define SP2DT_CNT  0x384   // SPORT2 -XMT DMA Count register
#define SP2DT_CP   0x385   // SPORT2 -XMT DMA Next Descriptor Pointer register
#define SP2DT_CPR  0x386   // SPORT2 -XMT DMA Descriptor Ready
#define SP2DT_IRQ  0x387   // SPORT2 -XMT DMA Interrupt Register

// SPI0 Controller; these are on IOPG=0x04 (0x01000-0x011FF)

#define SPI0_Controller_Page 0x04
#define SPICTL0    0x000   // SPI0 Control Register
#define SPIFLG0    0x001   // SPI0 Flag register
#define SPIST0     0x002   // SPI0 Status register
#define TDBR0      0x003   // SPI0 Transmit Data Buffer Register
#define RDBR0      0x004   // SPI0 Receive Data Buffer Register
#define SPIBAUD0   0x005   // SPI0 Baud rate Register
#define RDBRS0     0x006   // SPI0 Receive Data Buffer Shadow Register

#define SPI0D_PTR  0x100   // SPI 0 -DMA Current Pointer register
#define SPI0D_CFG  0x101   // SPI 0 -DMA Configuration register
#define SPI0D_SRP  0x102   // SPI 0 -DMA Start Page register
#define SPI0D_SRA  0x103   // SPI 0 -DMA Start Address register
#define SPI0D_CNT  0x104   // SPI 0 -DMA Count register
#define SPI0D_CP   0x105   // SPI 0 -DMA Next Descriptor Pointer
#define SPI0D_CPR  0x106   // SPI 0 -DMA Descriptor Ready
#define SPI0D_IRQ  0x107   // SPI 0 -DMA Interrupt register

// SPI1 Controller; these are on IOPG=0x04 (0x01200-0x013FF)

#define SPI1_Controller_Page 0x04
#define SPICTL1    0x200   // SPI1 Control Register
#define SPIFLG     0x201   // SPI1 Flag register
#define SPIST1     0x202   // SPI1 Status register
#define TDBR1      0x203   // SPI1 Transmit Data Buffer Register
#define RDBR1      0x204   // SPI1 Receive Data Buffer Register
#define SPIBAUD1   0x205   // SPI1 Baud rate Register
#define RDBRS1     0x206   // SPI1 Receive Data Buffer Shadow Register

#define SPI1D_PTR  0x300   // SPI 1 -DMA Current Pointer register
#define SPI1D_CFG  0x301   // SPI 1 -DMA Configuration register
#define SPI1D_SRP  0x302   // SPI 1 -DMA Start Page register
#define SPI1D_SRA  0x303   // SPI 1 -DMA Start Address register
#define SPI1D_CNT  0x304   // SPI 1 -DMA Count register
#define SPI1D_CP   0x305   // SPI 1 -DMA Next Descriptor Pointer
#define SPI1D_CPR  0x306   // SPI 1 -DMA Descriptor Ready
#define SPI1D_IRQ  0x307   // SPI 1 -DMA Interrupt register

// UART Controller; these are on IOPG=0x05 (0x01400-0x015FF)

#define UART_Controller_Page 0x05
#define THR        0x000   // UART - Transmit Holding register
#define RBR        0x001   // UART - Receive Buffer register
#define DLL        0x002   // UART - Divisor Latch (Low-Byte)
#define IER        0x003   // UART - Interrupt Enable Register
#define DLH        0x004   // UART - Divisor Latch (High-Byte)
#define IIR        0x005   // UART - Interrupt Identification Register
#define LCR        0x006   // UART - Line Control Register
#define MCR        0x007   // UART - Module Control Register
#define LSR        0x008   // UART - Line Status Register
#define MSR        0x009   // UART - Modem Status Register
#define SCR        0x00A   // UART - Scratch Register

#define UARDR_PTR  0x100   // UART -DMA RCV Current Pointer register
#define UARDR_CFG  0x101   // UART -RCV DMA Configuration register
#define UARDR_SRP  0x102   // UART -RCV DMA Start Page register
#define UARDR_SRA  0x103   // UART -RCV DMA Start Address register
#define UARDR_CNT  0x104   // UART -RCV DMA Count register
#define UARDR_CP   0x105   // UART -RCV DMA Next Descriptor Pointer register
#define UARDR_CPR  0x106   // UART -RCV DMA Descriptor Ready
#define UARDR_IRQ  0x107   // UART -RCV DMA Interrupt Register

#define UARDT_PTR  0x180   // UART -XMT DMA Current Pointer register
#define UARDT_CFG  0x181   // UART -XMT DMA Configuration register
#define UARDT_SRP  0x182   // UART -XMT DMA Start Page register
#define UARDT_SRA  0x183   // UART -XMT DMA Start Address register
#define UARDT_CNT  0x184   // UART -XMT DMA Count register
#define UARDT_CP   0x185   // UART -XMT DMA Next Descriptor Pointer register
#define UARDT_CPR  0x186   // UART -XMT DMA Descriptor Ready
#define UARDT_IRQ  0x187   // UART -XMT DMA Interrupt register

// Timer; these are on IOPG=0x05 (0x01600-0x017FF)

#define Timer_Page 0x05
#define GSR0       0x200   // Timer 0 Global Status and Sticky Register
#define CFGR0      0x201   // Timer 0 configuration Register
#define CNTL0      0x202   // Timer 0 Counter Register (low word)
#define CNTH0      0x203   // Timer 0 Counter Register (high word)
#define PRDL0      0x204   // Timer 0 Period Register (low word)
#define PRDH0      0x205   // Timer 0 Period Register (high word)
#define WLR0       0x206   // Timer 0 Width Register (low word)
#define WHR0       0x207   // Timer 0 Width Register (high word)
#define GSR1       0x208   // Timer 1 Global Status and Sticky Register
#define CFGR1      0x209   // Timer 1 configuration register
#define CNTL1      0x20A   // Timer 1 Counter Register (low word)
#define CNTH1      0x20B   // Timer 1 Counter Register (high word)
#define PRDL1      0x20C   // Timer 1 Period Register (low word)
#define PRDH1      0x20D   // Timer 1 Period Register (high word)
#define WLR1       0x20E   // Timer 1 Width Register (low word)
#define WHR1       0x20F   // Timer 1 Width Register (high word)
#define GSR2       0x210   // Timer 2 Global Status and Sticky Register
#define CFGR2      0x211   // Timer 2 configuration register
#define CNTL2      0x212   // Timer 2 Counter Register (low word)
#define CNTH2      0x213   // Timer 2 Counter Register (high word)
#define PRDL2      0x214   // Timer 2 Period Register (low word)
#define PRDH2      0x215   // Timer 2 Period Register (high word)
#define WLR2       0x216   // Timer 2 Width Register (low word)
#define WHR2       0x217   // Timer 2 Width Register (high word)

// General Purpose IO; these are on IOPG=0x06 (0x01800-0x019FF)

#define General_Purpose_IO 0x06
#define DIRC       0x000   // Peripheral Flag Direction Register (clear)
#define DIRS       0x001   // Peripheral Flag Direction Register (set)
#define FLAGC      0x002   // Peripheral Interrupt Flag Register (clear)
#define FLAGS      0x003   // Peripheral Interrupt Flag Register (set)
#define MASKAC     0x004   // Flag Mask Interrupt A Register (clear)
#define MASKAS     0x005   // Flag Mask Interrupt A Register (set)
#define MASKBC     0x006   // Flag Mask Interrupt B Register (clear)
#define MASKBS     0x007   // Flag Mask Interrupt B Register (set)
#define FSPRC      0x008   // Flag Source Polarity Register (clear)
#define FSPRS      0x009   // Flag Source Polarity Register (set)
#define FSSRC      0x00A   // Flag Source Sensitivity Register (clear)
#define FSSRS      0x00B   // Flag Source Sensitivity Register (set)
#define FSBERC     0x00C   // Flag Set on BOTH Edges Register (clear)
#define FSBERS     0x00D   // Flag Set on BOTH Edges Register (set)

// External Memory Interface; these are on IOPG=0x06 (0x01A00-0x01BFF)

// 0x01A00  Reserved

#define External_Memory_Interface_Page 0x06
#define EMICTL     0x201   // EMI control Register
#define BMSCTL     0x202   // Boot Space Access Control Register
#define MS0CTL     0x203   // Memory Space Bank 0 Access Control Register
#define MS1CTL     0x204   // Memory Space Bank 1 Access Control Register
#define MS2CTL     0x205   // Memory Space Bank 2 Access Control Register
#define MS3CTL     0x206   // Memory Space Bank 3 Access Control Register
#define IOMSCTL    0x207   // IO Space Access Control Register
#define EMISTAT    0x208   // External Port Status Register
#define MEMPG10    0x209   // Memory Page Register 1/0
#define MEMPG32    0x20A   // Memory Page Register 3/2

// Host Port Bus Interface; these are on IOPG=0x07 (0x01C00-0x01DFF)

// 0x01C00  Reserved

#define Host_Port_Bus_Interface_Page 0x07
#define HPCR       0x001   // Host Port Configuration Register
#define HPPR       0x002   // Host Port Direct Page Register
#define HPDER      0x003   // Host Port DMA Error Register

#define HPSMPHA    0x0FC   // Host Port Semaphore A Register
#define HPSMPHB    0x0FD   // Host Port Semaphore B Register
#define HPSMPHC    0x0FE   // Host Port Semaphore C Register
#define HPSMPHD    0x0FF   // Host Port Semaphore D Register

#define HOSTD_PTR  0x100   // Host Port DMA current Pointer
#define HOSTD_CFG  0x101   // Host Port DMA Configuration
#define HOSTD_SRP  0x102   // Host Port DMA Start Page
#define HOSTD_SRA  0x103   // Host Port DMA Start Address
#define HOSTD_CNT  0x104   // Host Port DMA Word Count
#define HOSTD_CP   0x105   // Host Port DMA Next Descriptor
#define HOSTD_CPR  0x106   // Host Port DMA Descriptor Ready
#define HOSTD_IRQ  0x107   // Host Port DMA Interrupt Register

//
// The following definitions were copied from 2191_EZ_KIT.h... 
//

/*  TX Config Register bits */

#define TSPEN       1                   /* Transmit enable */
#define ICLK        2                   /* internal clock */
#define ZERO_FILL   0
#define SIGN_EXT    4
#define MU_LAW      8
#define A_LAW       0xC
#define LSB_FIRST   0x10
#define BITS16      0x1E0
#define BITS8	    0x0E0
#define ITFS        0x200               /* internal xmit frame sync */
#define TFSR        0x400               /* xmit frame sync required */
#define DITFS       0x800
#define LTFS        0x1000              /* active low frame sync */
#define LATFS       0x2000              /* late frame sync */
#define CKRE        0x4000              /* sample data on rising edge of bitclk */
#define H100        0x8000              /* H100 compatability */

   
/*  Rx Config Register bits */
#define RSPEN       1                   /* rx enable */
#define IRFS        0x200               /* use internal frame sync */
#define RFSR        0x400               /* rx frame sync required */
#define LRFS        0x1000              /* active lo rx frame sync */
#define LARFS       0x2000              /* late rx frame sync */

#endif
