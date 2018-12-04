
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega88P
;Program type           : Application
;Clock frequency        : 20,000000 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega88P
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Uint_Voltage=R5
	.DEF _Uint_Voltage_msb=R6
	.DEF _Uint_Current=R7
	.DEF _Uint_Current_msb=R8
	.DEF _Uc_Buff_Count=R10
	.DEF _Uc_Buzzer_Count=R9
	.DEF _Uc_Voltage_Duty=R12
	.DEF _Uc_Timer_Update_Display=R13
	.DEF _Uc_Timer_Update_Display_msb=R14
	.DEF _Uc_Select_led=R11

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x1,0x0,0x0
	.DB  0x0

_0x40003:
	.DB  0x1
_0x40004:
	.DB  0xEE,0x88,0xB6,0xBC,0xD8,0x7C,0x7E,0xA8
	.DB  0xFE,0xFC

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  0x0A
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _BCDLED
	.DW  _0x40004*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x200

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : AC_Power_Supply_Adj
;Version : 1.0
;Date    : 12/1/2018
;Author  :
;Company :
;Comments:
;Dieu che dien ap xoay chieu 35VAC
;
;
;Chip type               : ATmega88P
;Program type            : Application
;AVR Core Clock frequency: 11.059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega88p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include "ADE7753.h"
;#include "scan_led.h"
;#include <delay.h>
;
;
;#define ADC1    2
;#define ADC_SET_VOLTAGE    1
;#define ADC3    4
;
;#define ADC_SET_VOLTAGE_VALUE_MIN   100
;#define ADC_SET_VOLTAGE_VALUE_MAX   1000
;#define ADC_SET_VOLTAGE_RATIO   350
;
;#define BUZZER  PORTC.5
;
;#define BUZZER_ON   BUZZER = 1
;#define BUZZER_OFF  BUZZER = 0
;
;
;
;#define PHASE_1 PORTB.1
;#define PHASE_2 PORTB.2
;
;#define VOLTAGE_RATIO   12765
;#define CURRENT_RATIO   566
;
;#define NUM_SAMPLE  30
;#define NUM_FILTER  7
;
;#define TIME_UPDATE_DISPLAY  200
;#define SPEED_BUZZER    200
;// Declare your global variables here
;unsigned long   Ul_Voltage_Buff[NUM_SAMPLE];
;unsigned long   Ul_Current_Buff[NUM_SAMPLE];
;
;
;unsigned int    Uint_Voltage;
;unsigned int    Uint_Current;
;
;unsigned char   Uc_Buff_Count = 0;
;
;unsigned char   Uc_Buzzer_Count;
;
;bit Bit_En_Meas = 0;
;
;unsigned char   Uc_Voltage_Duty = 0;
;
;unsigned int   Uc_Timer_Update_Display=0;
;
;void    PWM_PHASE1(unsigned char duty);
;void    PWM_PHASE2(unsigned char duty);
;// // Voltage Reference: AREF pin
;// #define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Voltage Reference: Int., cap. on AREF
;#define ADC_VREF_TYPE ((1<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0054 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0055     ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xC0)
	STS  124,R30
; 0000 0056     // Delay needed for the stabilization of the ADC input voltage
; 0000 0057     delay_us(10);
	__DELAY_USB 67
; 0000 0058     // Start the AD conversion
; 0000 0059     ADCSRA|=(1<<ADSC);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 005A     // Wait for the AD conversion to complete
; 0000 005B     while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ _0x3
; 0000 005C     ADCSRA|=(1<<ADIF);
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
; 0000 005D     return ADCW;
	LDS  R30,120
	LDS  R31,120+1
	ADIW R28,1
	RET
; 0000 005E }
; .FEND
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0061 {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0062     // Reinitialize Timer2 value
; 0000 0063     TCNT2=0x7E;
	LDI  R30,LOW(126)
	STS  178,R30
; 0000 0064      if(Uc_Timer_Update_Display < TIME_UPDATE_DISPLAY)   Uc_Timer_Update_Display++;
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R13,R30
	CPC  R14,R31
	BRSH _0x6
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 13,14,30,31
; 0000 0065     // Place your code here
; 0000 0066     SCAN_LED();
_0x6:
	RCALL _SCAN_LED
; 0000 0067     Uc_Buzzer_Count++;
	INC  R9
; 0000 0068     if(Uc_Buzzer_Count > SPEED_BUZZER)      Uc_Buzzer_Count = 0;
	LDI  R30,LOW(200)
	CP   R30,R9
	BRSH _0x7
	CLR  R9
; 0000 0069     Bit_En_Meas = 1;
_0x7:
	SBI  0x1E,2
; 0000 006A 
; 0000 006B }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void    PWM_PHASE1(unsigned char duty)
; 0000 006E {
_PWM_PHASE1:
; .FSTART _PWM_PHASE1
; 0000 006F     unsigned char   pwm = duty*255/100;
; 0000 0070     if(duty <= 1)
	ST   -Y,R26
	ST   -Y,R17
;	duty -> Y+1
;	pwm -> R17
	LDD  R26,Y+1
	LDI  R30,LOW(255)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	MOV  R17,R30
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRSH _0xA
; 0000 0071     {
; 0000 0072         // TCCR1A &= (0<<COM1B1);
; 0000 0073         OCR1AH=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 0074         OCR1AL=0;
	STS  136,R30
; 0000 0075     }
; 0000 0076     else
	RJMP _0xB
_0xA:
; 0000 0077     {
; 0000 0078         // TCCR1A |= (1<<COM1B1);
; 0000 0079         OCR1AH=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 007A         OCR1AL=pwm;
	STS  136,R17
; 0000 007B     }
_0xB:
; 0000 007C }
	RJMP _0x2000003
; .FEND
;
;void    PWM_PHASE2(unsigned char duty)
; 0000 007F {
_PWM_PHASE2:
; .FSTART _PWM_PHASE2
; 0000 0080     unsigned char   pwm = (duty)*255/100;
; 0000 0081     // OCR1BH=0x00;
; 0000 0082     // OCR1BL=pwm;
; 0000 0083     if(duty <= 1)
	ST   -Y,R26
	ST   -Y,R17
;	duty -> Y+1
;	pwm -> R17
	LDD  R26,Y+1
	LDI  R30,LOW(255)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	MOV  R17,R30
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRSH _0xC
; 0000 0084     {
; 0000 0085         // TCCR1A &= (0<<COM1A1);
; 0000 0086         OCR1BH=0x00;
	LDI  R30,LOW(0)
	STS  139,R30
; 0000 0087         OCR1BL=0;
	STS  138,R30
; 0000 0088     }
; 0000 0089     else
	RJMP _0xD
_0xC:
; 0000 008A     {
; 0000 008B         // TCCR1A |= (1<<COM1A1);
; 0000 008C         OCR1BH=0x00;
	LDI  R30,LOW(0)
	STS  139,R30
; 0000 008D         OCR1BL=pwm;
	STS  138,R17
; 0000 008E     }
_0xD:
; 0000 008F }
_0x2000003:
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
;
;void    CONTROL_VOLTAGE(void)
; 0000 0092 {
_CONTROL_VOLTAGE:
; .FSTART _CONTROL_VOLTAGE
; 0000 0093     unsigned int    Uint_Vr_Set_Voltage;
; 0000 0094 
; 0000 0095     Uint_Vr_Set_Voltage = read_adc(ADC_SET_VOLTAGE);
	RCALL __SAVELOCR2
;	Uint_Vr_Set_Voltage -> R16,R17
	LDI  R26,LOW(1)
	RCALL _read_adc
	MOVW R16,R30
; 0000 0096     Uc_Voltage_Duty = (unsigned long)Uint_Vr_Set_Voltage*100/1023;
	MOVW R26,R16
	CLR  R24
	CLR  R25
	__GETD1N 0x64
	RCALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3FF
	RCALL __DIVD21U
	MOV  R12,R30
; 0000 0097     // Uint_data_led1 = Uint_Vr_Set_Voltage;
; 0000 0098     // Uint_data_led2 = Uc_Voltage_Duty;
; 0000 0099     // Uint_data_led2 = Uc_Voltage_Duty;
; 0000 009A     PWM_PHASE2(Uc_Voltage_Duty);
	MOV  R26,R12
	RCALL _PWM_PHASE2
; 0000 009B     PWM_PHASE1(Uc_Voltage_Duty);
	MOV  R26,R12
	RCALL _PWM_PHASE1
; 0000 009C }
	RJMP _0x2000002
; .FEND
;/*
;Doc thong so dien ap va dong dien, loc nhieu.
;Loc nhieu va tinh toan ra gia tri thuc cua dong dien va dien ap.
;Cap nhat cac thong so len led hien thi
;*/
;void    READ_CURRENT_INFO(void)
; 0000 00A3 {
_READ_CURRENT_INFO:
; .FSTART _READ_CURRENT_INFO
; 0000 00A4     unsigned long   Ul_Buff[NUM_SAMPLE];
; 0000 00A5     unsigned char   Uc_loop = 0,Uc_loop2 = 0;
; 0000 00A6     unsigned long   Ul_temp;
; 0000 00A7 
; 0000 00A8     Ul_Voltage_Buff[Uc_Buff_Count] = ADE7753_READ(1,VRMS);
	SBIW R28,63
	SBIW R28,61
	RCALL __SAVELOCR2
;	Ul_Buff -> Y+6
;	Uc_loop -> R17
;	Uc_loop2 -> R16
;	Ul_temp -> Y+2
	LDI  R17,0
	LDI  R16,0
	MOV  R30,R10
	LDI  R26,LOW(_Ul_Voltage_Buff)
	LDI  R27,HIGH(_Ul_Voltage_Buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ADE7753_READ
	POP  R26
	POP  R27
	RCALL __PUTDP1
; 0000 00A9     delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00AA     /* Tinh toan va loc nhieu gia tri dien ap */
; 0000 00AB     for(Uc_loop = 0; Uc_loop < NUM_SAMPLE; Uc_loop++)
	LDI  R17,LOW(0)
_0xF:
	CPI  R17,30
	BRSH _0x10
; 0000 00AC     {
; 0000 00AD         Ul_Buff[Uc_loop] = Ul_Voltage_Buff[Uc_loop];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R26,LOW(_Ul_Voltage_Buff)
	LDI  R27,HIGH(_Ul_Voltage_Buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 00AE     }
	SUBI R17,-1
	RJMP _0xF
_0x10:
; 0000 00AF     for(Uc_loop = 0; Uc_loop < NUM_SAMPLE; Uc_loop++)
	LDI  R17,LOW(0)
_0x12:
	CPI  R17,30
	BRLO PC+2
	RJMP _0x13
; 0000 00B0     {
; 0000 00B1         for(Uc_loop2 = Uc_loop; Uc_loop2 < NUM_SAMPLE; Uc_loop2++)
	MOV  R16,R17
_0x15:
	CPI  R16,30
	BRLO PC+2
	RJMP _0x16
; 0000 00B2         {
; 0000 00B3             if(Ul_Buff[Uc_loop] > Ul_Buff[Uc_loop2])
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0x17
; 0000 00B4             {
; 0000 00B5                 Ul_temp = Ul_Buff[Uc_loop];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	__PUTD1S 2
; 0000 00B6                 Ul_Buff[Uc_loop] = Ul_Buff[Uc_loop2];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 00B7                 Ul_Buff[Uc_loop2] = Ul_temp;
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	__GETD2S 2
	RCALL __PUTDZ20
; 0000 00B8             }
; 0000 00B9         }
_0x17:
	SUBI R16,-1
	RJMP _0x15
_0x16:
; 0000 00BA     }
	SUBI R17,-1
	RJMP _0x12
_0x13:
; 0000 00BB     Ul_temp = 0;
	LDI  R30,LOW(0)
	__CLRD1S 2
; 0000 00BC     for(Uc_loop = NUM_FILTER; Uc_loop < NUM_SAMPLE - NUM_FILTER; Uc_loop++)
	LDI  R17,LOW(7)
_0x19:
	CPI  R17,23
	BRSH _0x1A
; 0000 00BD     {
; 0000 00BE         Ul_temp += Ul_Buff[Uc_loop];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	__GETD2S 2
	RCALL __ADDD12
	__PUTD1S 2
; 0000 00BF     }
	SUBI R17,-1
	RJMP _0x19
_0x1A:
; 0000 00C0     Ul_temp = Ul_temp/(NUM_SAMPLE - 2*NUM_FILTER);
	__GETD2S 2
	__GETD1N 0x10
	RCALL __DIVD21U
	__PUTD1S 2
; 0000 00C1     // Ul_temp = Ul_temp / 100;
; 0000 00C2     // Uint_Voltage = (unsigned int)((float)(Ul_temp*(0.015233297 + Ul_temp*(0.0000003453386290397 - Ul_temp*0.000000000 ...
; 0000 00C3     if(Uc_Timer_Update_Display >= TIME_UPDATE_DISPLAY)
; 0000 00C4     {
; 0000 00C5         // Uint_data_led1 = Ul_temp /10000;
; 0000 00C6         // Uint_data_led2 = Ul_temp %10000;
; 0000 00C7     }
; 0000 00C8     Uint_Voltage = (unsigned int)((float)Ul_temp/VOLTAGE_RATIO);
	RCALL __CDF1U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x46477400
	RCALL __DIVF21
	RCALL __CFD1U
	__PUTW1R 5,6
; 0000 00C9     if(Uc_Timer_Update_Display >= TIME_UPDATE_DISPLAY)    Uint_data_led1 = Uint_Voltage;
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R13,R30
	CPC  R14,R31
	BRLO _0x1C
	__PUTWMRN _Uint_data_led1,0,5,6
; 0000 00CA 
; 0000 00CB     Ul_Current_Buff[Uc_Buff_Count] = ADE7753_READ(1,IRMS);
_0x1C:
	MOV  R30,R10
	LDI  R26,LOW(_Ul_Current_Buff)
	LDI  R27,HIGH(_Ul_Current_Buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(22)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ADE7753_READ
	POP  R26
	POP  R27
	RCALL __PUTDP1
; 0000 00CC     delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00CD     /* Tinh toan va loc nhieu gia tri dong dien */
; 0000 00CE     for(Uc_loop = 0; Uc_loop < NUM_SAMPLE; Uc_loop++)
	LDI  R17,LOW(0)
_0x1E:
	CPI  R17,30
	BRSH _0x1F
; 0000 00CF     {
; 0000 00D0         Ul_Buff[Uc_loop] = Ul_Current_Buff[Uc_loop];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R26,LOW(_Ul_Current_Buff)
	LDI  R27,HIGH(_Ul_Current_Buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 00D1     }
	SUBI R17,-1
	RJMP _0x1E
_0x1F:
; 0000 00D2     for(Uc_loop = 0; Uc_loop < NUM_SAMPLE; Uc_loop++)
	LDI  R17,LOW(0)
_0x21:
	CPI  R17,30
	BRLO PC+2
	RJMP _0x22
; 0000 00D3     {
; 0000 00D4         for(Uc_loop2 = Uc_loop; Uc_loop2 < NUM_SAMPLE; Uc_loop2++)
	MOV  R16,R17
_0x24:
	CPI  R16,30
	BRLO PC+2
	RJMP _0x25
; 0000 00D5         {
; 0000 00D6             if(Ul_Buff[Uc_loop] > Ul_Buff[Uc_loop2])
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __CPD12
	BRSH _0x26
; 0000 00D7             {
; 0000 00D8                 Ul_temp = Ul_Buff[Uc_loop];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	__PUTD1S 2
; 0000 00D9                 Ul_Buff[Uc_loop] = Ul_Buff[Uc_loop2];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
; 0000 00DA                 Ul_Buff[Uc_loop2] = Ul_temp;
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	__GETD2S 2
	RCALL __PUTDZ20
; 0000 00DB             }
; 0000 00DC         }
_0x26:
	SUBI R16,-1
	RJMP _0x24
_0x25:
; 0000 00DD     }
	SUBI R17,-1
	RJMP _0x21
_0x22:
; 0000 00DE     Ul_temp = 0;
	LDI  R30,LOW(0)
	__CLRD1S 2
; 0000 00DF     for(Uc_loop = NUM_FILTER; Uc_loop < NUM_SAMPLE - NUM_FILTER; Uc_loop++)
	LDI  R17,LOW(7)
_0x28:
	CPI  R17,23
	BRSH _0x29
; 0000 00E0     {
; 0000 00E1         Ul_temp += Ul_Buff[Uc_loop];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	__GETD2S 2
	RCALL __ADDD12
	__PUTD1S 2
; 0000 00E2     }
	SUBI R17,-1
	RJMP _0x28
_0x29:
; 0000 00E3     Ul_temp = Ul_temp/(NUM_SAMPLE - 2*NUM_FILTER);
	__GETD2S 2
	__GETD1N 0x10
	RCALL __DIVD21U
	__PUTD1S 2
; 0000 00E4     Uint_Current = (unsigned int)((float)Ul_temp/CURRENT_RATIO);
	RCALL __CDF1U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x440D8000
	RCALL __DIVF21
	RCALL __CFD1U
	__PUTW1R 7,8
; 0000 00E5     if(Uc_Timer_Update_Display >= TIME_UPDATE_DISPLAY)
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R13,R30
	CPC  R14,R31
	BRLO _0x2A
; 0000 00E6     {
; 0000 00E7         // Uint_data_led2 = Uint_Current;
; 0000 00E8         Uc_Timer_Update_Display = 0;
	CLR  R13
	CLR  R14
; 0000 00E9     }
; 0000 00EA     if(Uint_Current > 550)  Bit_Led2_Warning = 1;
_0x2A:
	LDI  R30,LOW(550)
	LDI  R31,HIGH(550)
	CP   R30,R7
	CPC  R31,R8
	BRSH _0x2B
	SBI  0x1E,1
; 0000 00EB     else    Bit_Led2_Warning = 0;
	RJMP _0x2E
_0x2B:
	CBI  0x1E,1
; 0000 00EC 
; 0000 00ED 
; 0000 00EE     Uc_Buff_Count++;
_0x2E:
	INC  R10
; 0000 00EF     if(Uc_Buff_Count >= NUM_SAMPLE) Uc_Buff_Count = 0;
	LDI  R30,LOW(30)
	CP   R10,R30
	BRLO _0x31
	CLR  R10
; 0000 00F0 }
_0x31:
	RCALL __LOADLOCR2
	ADIW R28,63
	ADIW R28,63
	RET
; .FEND
;
;void main(void)
; 0000 00F3 {
_main:
; .FSTART _main
; 0000 00F4 // Declare your local variables here
; 0000 00F5 
; 0000 00F6 // Crystal Oscillator division factor: 1
; 0000 00F7 #pragma optsize-
; 0000 00F8 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00F9 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00FA #ifdef _OPTIMIZE_SIZE_
; 0000 00FB #pragma optsize+
; 0000 00FC #endif
; 0000 00FD 
; 0000 00FE // Input/Output Ports initialization
; 0000 00FF // Port B initialization
; 0000 0100 // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=Out Bit1=In Bit0=Out
; 0000 0101 DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(63)
	OUT  0x4,R30
; 0000 0102 // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=T Bit2=0 Bit1=T Bit0=0
; 0000 0103 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 0104 
; 0000 0105 // Port C initialization
; 0000 0106 // Function: Bit6=In Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 0107 DDRC=(0<<DDC6) | (1<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(33)
	OUT  0x7,R30
; 0000 0108 // State: Bit6=T Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=0
; 0000 0109 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 010A 
; 0000 010B // Port D initialization
; 0000 010C // Function: Bit7=Out Bit6=In Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 010D DDRD=(1<<DDD7) | (0<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(160)
	OUT  0xA,R30
; 0000 010E // State: Bit7=0 Bit6=T Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 010F PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0110 
; 0000 0111 
; 0000 0112 // Timer/Counter 0 initialization
; 0000 0113 // Clock source: System Clock
; 0000 0114 // Clock value: Timer 0 Stopped
; 0000 0115 // Mode: Normal top=0xFF
; 0000 0116 // OC0A output: Disconnected
; 0000 0117 // OC0B output: Disconnected
; 0000 0118 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 0119 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x25,R30
; 0000 011A TCNT0=0x00;
	OUT  0x26,R30
; 0000 011B OCR0A=0x00;
	OUT  0x27,R30
; 0000 011C OCR0B=0x00;
	OUT  0x28,R30
; 0000 011D 
; 0000 011E // Timer/Counter 1 initialization
; 0000 011F // Clock source: System Clock
; 0000 0120 // Clock value: 11059,200 kHz
; 0000 0121 // Mode: Ph. correct PWM top=0x00FF
; 0000 0122 // OC1A output: Non-Inverted PWM
; 0000 0123 // OC1B output: Non-Inverted PWM
; 0000 0124 // Noise Canceler: Off
; 0000 0125 // Input Capture on Falling Edge
; 0000 0126 // Timer Period: 0,046115 ms
; 0000 0127 // Output Pulse(s):
; 0000 0128 // OC1A Period: 0,046115 ms Width: 0 us
; 0000 0129 // OC1B Period: 0,046115 ms Width: 0 us
; 0000 012A // Timer1 Overflow Interrupt: Off
; 0000 012B // Input Capture Interrupt: Off
; 0000 012C // Compare A Match Interrupt: Off
; 0000 012D // Compare B Match Interrupt: Off
; 0000 012E // TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
; 0000 012F // TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
; 0000 0130 // TCNT1H=0x00;
; 0000 0131 // TCNT1L=0x00;
; 0000 0132 // ICR1H=0x00;
; 0000 0133 // ICR1L=0x00;
; 0000 0134 // OCR1AH=0x00;
; 0000 0135 // OCR1AL=0x00;
; 0000 0136 // OCR1BH=0x00;
; 0000 0137 // OCR1BL=0x00;
; 0000 0138 
; 0000 0139 // Timer/Counter 1 initialization
; 0000 013A // Clock source: System Clock
; 0000 013B // Clock value: 11059,200 kHz
; 0000 013C // Mode: Ph. correct PWM top=0x00FF
; 0000 013D // OC1A output: Non-Inverted PWM
; 0000 013E // OC1B output: Inverted PWM
; 0000 013F // Noise Canceler: Off
; 0000 0140 // Input Capture on Falling Edge
; 0000 0141 // Timer Period: 0,046115 ms
; 0000 0142 // Output Pulse(s):
; 0000 0143 // OC1A Period: 0,046115 ms Width: 0 us
; 0000 0144 // OC1B Period: 0,046115 ms Width: 0,046115 ms
; 0000 0145 // Timer1 Overflow Interrupt: Off
; 0000 0146 // Input Capture Interrupt: Off
; 0000 0147 // Compare A Match Interrupt: Off
; 0000 0148 // Compare B Match Interrupt: Off
; 0000 0149 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(177)
	STS  128,R30
; 0000 014A TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	STS  129,R30
; 0000 014B TCNT1H=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 014C TCNT1L=0x00;
	STS  132,R30
; 0000 014D ICR1H=0x00;
	STS  135,R30
; 0000 014E ICR1L=0x00;
	STS  134,R30
; 0000 014F OCR1AH=0x00;
	STS  137,R30
; 0000 0150 OCR1AL=0x00;
	STS  136,R30
; 0000 0151 OCR1BH=0x00;
	STS  139,R30
; 0000 0152 OCR1BL=0x00;
	STS  138,R30
; 0000 0153 
; 0000 0154 // Timer/Counter 2 initialization
; 0000 0155 // Clock source: System Clock
; 0000 0156 // Clock value: 43,200 kHz
; 0000 0157 // Mode: Normal top=0xFF
; 0000 0158 // OC2A output: Disconnected
; 0000 0159 // OC2B output: Disconnected
; 0000 015A // Timer Period: 3,0093 ms
; 0000 015B ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 015C TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 015D TCCR2B=(0<<WGM22) | (1<<CS22) | (1<<CS21) | (0<<CS20);
	LDI  R30,LOW(6)
	STS  177,R30
; 0000 015E TCNT2=0x7E;
	LDI  R30,LOW(126)
	STS  178,R30
; 0000 015F OCR2A=0x00;
	LDI  R30,LOW(0)
	STS  179,R30
; 0000 0160 OCR2B=0x00;
	STS  180,R30
; 0000 0161 
; 0000 0162 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0163 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0000 0164 
; 0000 0165 // Timer/Counter 1 Interrupt(s) initialization
; 0000 0166 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	STS  111,R30
; 0000 0167 
; 0000 0168 // Timer/Counter 2 Interrupt(s) initialization
; 0000 0169 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (1<<TOIE2);
	LDI  R30,LOW(1)
	STS  112,R30
; 0000 016A 
; 0000 016B // External Interrupt(s) initialization
; 0000 016C // INT0: Off
; 0000 016D // INT1: Off
; 0000 016E // Interrupt on any change on pins PCINT0-7: Off
; 0000 016F // Interrupt on any change on pins PCINT8-14: Off
; 0000 0170 // Interrupt on any change on pins PCINT16-23: Off
; 0000 0171 EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	STS  105,R30
; 0000 0172 EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 0173 PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 0174 
; 0000 0175 // USART initialization
; 0000 0176 // USART disabled
; 0000 0177 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 0178 
; 0000 0179 // Analog Comparator initialization
; 0000 017A // Analog Comparator: Off
; 0000 017B // The Analog Comparator's positive input is
; 0000 017C // connected to the AIN0 pin
; 0000 017D // The Analog Comparator's negative input is
; 0000 017E // connected to the AIN1 pin
; 0000 017F ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0180 // Digital input buffer on AIN0: On
; 0000 0181 // Digital input buffer on AIN1: On
; 0000 0182 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	LDI  R30,LOW(0)
	STS  127,R30
; 0000 0183 
; 0000 0184 // // ADC initialization
; 0000 0185 // // ADC Clock frequency: 691.200 kHz
; 0000 0186 // // ADC Voltage Reference: AREF pin
; 0000 0187 // // ADC Auto Trigger Source: ADC Stopped
; 0000 0188 // // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 0189 // // ADC4: On, ADC5: On
; 0000 018A // DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
; 0000 018B // ADMUX=ADC_VREF_TYPE;
; 0000 018C // ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
; 0000 018D // ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
; 0000 018E // ADC initialization
; 0000 018F // ADC Clock frequency: 691,200 kHz
; 0000 0190 // ADC Voltage Reference: Int., cap. on AREF
; 0000 0191 // ADC Auto Trigger Source: ADC Stopped
; 0000 0192 // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 0193 // ADC4: On, ADC5: On
; 0000 0194 DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	STS  126,R30
; 0000 0195 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(192)
	STS  124,R30
; 0000 0196 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(132)
	STS  122,R30
; 0000 0197 ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0198 
; 0000 0199 
; 0000 019A // SPI initialization
; 0000 019B // SPI disabled
; 0000 019C SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 019D 
; 0000 019E // TWI initialization
; 0000 019F // TWI disabled
; 0000 01A0 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 01A1 // Global enable interrupts
; 0000 01A2 #asm("sei")
	sei
; 0000 01A3 
; 0000 01A4 // ADE7753_INIT();
; 0000 01A5 for(Uc_Buff_Count = 0; Uc_Buff_Count < NUM_SAMPLE; Uc_Buff_Count++)
	CLR  R10
_0x33:
	LDI  R30,LOW(30)
	CP   R10,R30
	BRSH _0x34
; 0000 01A6 {
; 0000 01A7     Ul_Voltage_Buff[Uc_Buff_Count] = 0;
	MOV  R30,R10
	LDI  R26,LOW(_Ul_Voltage_Buff)
	LDI  R27,HIGH(_Ul_Voltage_Buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	__GETD1N 0x0
	RCALL __PUTDP1
; 0000 01A8     Ul_Current_Buff[Uc_Buff_Count] = 0;
	MOV  R30,R10
	LDI  R26,LOW(_Ul_Current_Buff)
	LDI  R27,HIGH(_Ul_Current_Buff)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	__GETD1N 0x0
	RCALL __PUTDP1
; 0000 01A9 }
	INC  R10
	RJMP _0x33
_0x34:
; 0000 01AA Uc_Buff_Count = 0;
	CLR  R10
; 0000 01AB delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	RCALL _delay_ms
; 0000 01AC BUZZER_ON;
	SBI  0x8,5
; 0000 01AD delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 01AE BUZZER_OFF;
	CBI  0x8,5
; 0000 01AF delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 01B0 BUZZER_ON;
	SBI  0x8,5
; 0000 01B1 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 01B2 BUZZER_OFF;
	CBI  0x8,5
; 0000 01B3 while (1)
_0x3D:
; 0000 01B4       {
; 0000 01B5       // Place your code here
; 0000 01B6         if(Bit_En_Meas)
	SBIS 0x1E,2
	RJMP _0x40
; 0000 01B7         {
; 0000 01B8                 Bit_En_Meas = 0;
	CBI  0x1E,2
; 0000 01B9                 READ_CURRENT_INFO();
	RCALL _READ_CURRENT_INFO
; 0000 01BA         }
; 0000 01BB         CONTROL_VOLTAGE();
_0x40:
	RCALL _CONTROL_VOLTAGE
; 0000 01BC         if(Bit_Led2_Warning == 1)
	SBIS 0x1E,1
	RJMP _0x43
; 0000 01BD         {
; 0000 01BE             if(Uc_Buzzer_Count < SPEED_BUZZER/2)   BUZZER_ON;
	LDI  R30,LOW(100)
	CP   R9,R30
	BRSH _0x44
	SBI  0x8,5
; 0000 01BF             else    BUZZER_OFF;
	RJMP _0x47
_0x44:
	CBI  0x8,5
; 0000 01C0         }
_0x47:
; 0000 01C1         else    BUZZER_OFF;
	RJMP _0x4A
_0x43:
	CBI  0x8,5
; 0000 01C2       }
_0x4A:
	RJMP _0x3D
; 0000 01C3 }
_0x4D:
	RJMP _0x4D
; .FEND
;#include "ADE7753.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include "delay.h"
;#include "scan_led.h"
;
;
;void    SPI_7753_SEND(unsigned char data)
; 0001 0007 {

	.CSEG
_SPI_7753_SEND:
; .FSTART _SPI_7753_SEND
; 0001 0008     unsigned char   cnt;
; 0001 0009     unsigned char   tmp = data;
; 0001 000A 
; 0001 000B     for(cnt = 0;cnt < 8; cnt++)
	ST   -Y,R26
	RCALL __SAVELOCR2
;	data -> Y+2
;	cnt -> R17
;	tmp -> R16
	LDD  R16,Y+2
	LDI  R17,LOW(0)
_0x20004:
	CPI  R17,8
	BRSH _0x20005
; 0001 000C     {
; 0001 000D         if((tmp & 0x80) == 0x80)   SPI_MOSI_HIGHT;
	MOV  R30,R16
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0x20006
	SBI  0xB,5
; 0001 000E         else SPI_MOSI_LOW;
	RJMP _0x20009
_0x20006:
	CBI  0xB,5
; 0001 000F 
; 0001 0010         SPI_SCK_HIGHT;
_0x20009:
	SBI  0xB,7
; 0001 0011         delay_us(50);
	__DELAY_USW 250
; 0001 0012         SPI_SCK_LOW;
	CBI  0xB,7
; 0001 0013         delay_us(50);
	__DELAY_USW 250
; 0001 0014         tmp <<= 1;
	LSL  R16
; 0001 0015     }
	SUBI R17,-1
	RJMP _0x20004
_0x20005:
; 0001 0016 }
	RCALL __LOADLOCR2
	RJMP _0x2000001
; .FEND
;
;unsigned char    SPI_7753_RECEIVE(void)
; 0001 0019 {
_SPI_7753_RECEIVE:
; .FSTART _SPI_7753_RECEIVE
; 0001 001A     unsigned char cnt;
; 0001 001B     unsigned char data;
; 0001 001C     data = 0;
	RCALL __SAVELOCR2
;	cnt -> R17
;	data -> R16
	LDI  R16,LOW(0)
; 0001 001D     for(cnt = 0;cnt < 8; cnt++)
	LDI  R17,LOW(0)
_0x20011:
	CPI  R17,8
	BRSH _0x20012
; 0001 001E     {
; 0001 001F         data <<= 1;
	LSL  R16
; 0001 0020         SPI_SCK_HIGHT;
	SBI  0xB,7
; 0001 0021         delay_us(50);
	__DELAY_USW 250
; 0001 0022         if(SPI_MISO_HIGHT)
	SBIC 0x9,6
; 0001 0023         {
; 0001 0024             data += 1;
	SUBI R16,-LOW(1)
; 0001 0025         }
; 0001 0026         SPI_SCK_LOW;
	CBI  0xB,7
; 0001 0027         delay_us(50);
	__DELAY_USW 250
; 0001 0028     }
	SUBI R17,-1
	RJMP _0x20011
_0x20012:
; 0001 0029     return data;
	MOV  R30,R16
_0x2000002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0001 002A }
; .FEND
;
;void    ADE7753_WRITE(unsigned char IC_CS,unsigned char addr,unsigned char num_data,unsigned char data_1,unsigned char d ...
; 0001 002D {
; 0001 002E     unsigned char data[4];
; 0001 002F     unsigned char   i;
; 0001 0030     data[0] = data_1;
;	IC_CS -> Y+10
;	addr -> Y+9
;	num_data -> Y+8
;	data_1 -> Y+7
;	data_2 -> Y+6
;	data_3 -> Y+5
;	data -> Y+1
;	i -> R17
; 0001 0031     data[1] = data_2;
; 0001 0032     data[2] = data_3;
; 0001 0033 
; 0001 0034     switch (IC_CS)
; 0001 0035     {
; 0001 0036         case 1:
; 0001 0037         {
; 0001 0038             PHASE_1_ON;
; 0001 0039             PHASE_2_OFF;
; 0001 003A             PHASE_3_OFF;
; 0001 003B             break;
; 0001 003C         }
; 0001 003D         case 2:
; 0001 003E         {
; 0001 003F             PHASE_1_OFF;
; 0001 0040             PHASE_2_ON;
; 0001 0041             PHASE_3_OFF;
; 0001 0042             break;
; 0001 0043         }
; 0001 0044         case 3:
; 0001 0045         {
; 0001 0046             PHASE_1_OFF;
; 0001 0047             PHASE_2_OFF;
; 0001 0048             PHASE_3_ON;
; 0001 0049             break;
; 0001 004A         }
; 0001 004B     }
; 0001 004C     addr &= 0x3F;
; 0001 004D     addr |= 0x80;
; 0001 004E     delay_us(100);
; 0001 004F     SPI_7753_SEND(addr);
; 0001 0050     delay_us(100);
; 0001 0051     for(i=0;i<num_data;i++)    SPI_7753_SEND(data[i]);
; 0001 0052 delay_us(100);
; 0001 0053     PHASE_1_OFF;
; 0001 0054     PHASE_2_OFF;
; 0001 0055     PHASE_3_OFF;
; 0001 0056 }
;unsigned long int    ADE7753_READ(unsigned char IC_CS,unsigned char addr,unsigned char num_data)
; 0001 0058 {
_ADE7753_READ:
; .FSTART _ADE7753_READ
; 0001 0059     unsigned char   i;
; 0001 005A     unsigned char   data[4];
; 0001 005B     unsigned long int res;
; 0001 005C     for(i=0;i<4;i++)    data[i] = 0;
	ST   -Y,R26
	SBIW R28,8
	ST   -Y,R17
;	IC_CS -> Y+11
;	addr -> Y+10
;	num_data -> Y+9
;	i -> R17
;	data -> Y+5
;	res -> Y+1
	LDI  R17,LOW(0)
_0x2003A:
	CPI  R17,4
	BRSH _0x2003B
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R17,-1
	RJMP _0x2003A
_0x2003B:
; 0001 005D switch (IC_CS)
	LDD  R30,Y+11
	LDI  R31,0
; 0001 005E     {
; 0001 005F         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2003F
; 0001 0060         {
; 0001 0061             PHASE_1_ON;
	CBI  0x5,0
; 0001 0062             PHASE_2_OFF;
	SBI  0xB,1
; 0001 0063             PHASE_3_OFF;
	SBI  0xB,1
; 0001 0064             break;
	RJMP _0x2003E
; 0001 0065         }
; 0001 0066         case 2:
_0x2003F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20046
; 0001 0067         {
; 0001 0068             PHASE_1_OFF;
	SBI  0x5,0
; 0001 0069             PHASE_2_ON;
	CBI  0xB,1
; 0001 006A             PHASE_3_OFF;
	SBI  0xB,1
; 0001 006B             break;
	RJMP _0x2003E
; 0001 006C         }
; 0001 006D         case 3:
_0x20046:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2003E
; 0001 006E         {
; 0001 006F             PHASE_1_OFF;
	SBI  0x5,0
; 0001 0070             PHASE_2_OFF;
	SBI  0xB,1
; 0001 0071             PHASE_3_ON;
	CBI  0xB,1
; 0001 0072             break;
; 0001 0073         }
; 0001 0074     }
_0x2003E:
; 0001 0075     delay_us(100);
	__DELAY_USW 500
; 0001 0076     addr &= 0x3F;
	LDD  R30,Y+10
	ANDI R30,LOW(0x3F)
	STD  Y+10,R30
; 0001 0077     SPI_7753_SEND(addr);
	LDD  R26,Y+10
	RCALL _SPI_7753_SEND
; 0001 0078     delay_us(100);
	__DELAY_USW 500
; 0001 0079     for(i=0;i<num_data;i++) data[i] = SPI_7753_RECEIVE();
	LDI  R17,LOW(0)
_0x20055:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0x20056
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _SPI_7753_RECEIVE
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-1
	RJMP _0x20055
_0x20056:
; 0001 007A delay_us(100);
	__DELAY_USW 500
; 0001 007B     PHASE_1_OFF;
	SBI  0x5,0
; 0001 007C     PHASE_2_OFF;
	SBI  0xB,1
; 0001 007D     PHASE_3_OFF;
	SBI  0xB,1
; 0001 007E     res = 0;
	LDI  R30,LOW(0)
	__CLRD1S 1
; 0001 007F     for(i=0;i<num_data;i++)
	LDI  R17,LOW(0)
_0x2005E:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0x2005F
; 0001 0080     {
; 0001 0081         res <<= 8;
	__GETD2S 1
	LDI  R30,LOW(8)
	RCALL __LSLD12
	__PUTD1S 1
; 0001 0082         res += data[i];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R31,0
	__GETD2S 1
	RCALL __CWD1
	RCALL __ADDD12
	__PUTD1S 1
; 0001 0083     }
	SUBI R17,-1
	RJMP _0x2005E
_0x2005F:
; 0001 0084     return res;
	__GETD1S 1
	LDD  R17,Y+0
	ADIW R28,12
	RET
; 0001 0085 }
; .FEND
;
;void    ADE7753_INIT(void)
; 0001 0088 {
; 0001 0089     unsigned long   res;
; 0001 008A     ADE7753_WRITE(1,MODE,0x00,0x00,0x00);
;	res -> Y+0
; 0001 008B     delay_ms(200);
; 0001 008C     ADE7753_WRITE(1,IRQEN,0x00,0x10,0x00);
; 0001 008D     res = ADE7753_READ(1,IRQEN);
; 0001 008E     ADE7753_WRITE(1,RSTSTATUS,0x00,0x00,0x00);
; 0001 008F     delay_ms(200);
; 0001 0090     ADE7753_WRITE(1,SAGLVL,0X2a,0X00,0X00);
; 0001 0091     res = ADE7753_READ(1,SAGLVL);
; 0001 0092     delay_ms(200);
; 0001 0093     ADE7753_WRITE(1,SAGCYC,0XFF,0X00,0X00);
; 0001 0094     res = ADE7753_READ(1,SAGCYC);
; 0001 0095     delay_ms(200);
; 0001 0096 }
;#include "scan_led.h"
;#include "SPI_SOFTWARE.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;
;unsigned char   Uc_led_count = 1;

	.DSEG
;unsigned char   Uc_led_data = 0;
;unsigned int    Uint_data_led1 = 0;
;unsigned int    Uint_data_led2 = 0;
;unsigned int    Uint_data_led3 = 0;
;unsigned char   Uc_Select_led=1;
;
;bit   Bit_Led1_Warning = 0;
;bit   Bit_Led2_Warning = 0;
;
;unsigned int   Uint_Warning_Count = 0;
;
;unsigned char   BCDLED[11]={0xEE,0x88,0xB6,0xBC,0xD8,0x7C,0x7E,0xA8,0xFE,0xFC,0x00};
;
;/* Day du lieu quet led qua duong spi_software
;Co thẻ day tu 1 den 3 byte du lieu.
;Du lieu sau khi day ra day du moi tien hanh xuat du lieu
;num_bytes : so byte duoc day ra
;data_first : du lieu dau tien
;data_second: du lieu thu 2
;data_third ; du lieu thu 3
;*/
;void    SEND_DATA_LED(unsigned char num_bytes,unsigned char  byte_first,unsigned char  byte_second,unsigned char  byte_t ...
; 0002 001B {

	.CSEG
_SEND_DATA_LED:
; .FSTART _SEND_DATA_LED
; 0002 001C     unsigned char   i;
; 0002 001D     unsigned char   data[4];
; 0002 001E     for(i=0;i<4;i++)    data[i] = 0;
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
;	num_bytes -> Y+8
;	byte_first -> Y+7
;	byte_second -> Y+6
;	byte_third -> Y+5
;	i -> R17
;	data -> Y+1
	LDI  R17,LOW(0)
_0x40006:
	CPI  R17,4
	BRSH _0x40007
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R17,-1
	RJMP _0x40006
_0x40007:
; 0002 001F data[0] = byte_first;
	LDD  R30,Y+7
	STD  Y+1,R30
; 0002 0020     data[1] = byte_second;
	LDD  R30,Y+6
	STD  Y+2,R30
; 0002 0021     data[2] = byte_third;
	LDD  R30,Y+5
	STD  Y+3,R30
; 0002 0022 
; 0002 0023     for(i=0;i<(num_bytes - 1);i++)    SPI_SENDBYTE(data[i],0);
	LDI  R17,LOW(0)
_0x40009:
	LDD  R30,Y+8
	LDI  R31,0
	SBIW R30,1
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x4000A
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _SPI_SENDBYTE
	SUBI R17,-1
	RJMP _0x40009
_0x4000A:
; 0002 0024 SPI_SENDBYTE(data[i],1);
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _SPI_SENDBYTE
; 0002 0025 }
	LDD  R17,Y+0
	ADIW R28,9
	RET
; .FEND
;
;
;/*
;Ham quet led
;num_led: Thu tu led
;data: Du lieu hien thi tren led.
;*/
;void    SCAN_LED(void)
; 0002 002E {
_SCAN_LED:
; .FSTART _SCAN_LED
; 0002 002F     unsigned char   byte1,byte2,byte3;
; 0002 0030     unsigned char    data;
; 0002 0031     unsigned char   bit_left;
; 0002 0032     bit_left = 0x01;
	RCALL __SAVELOCR6
;	byte1 -> R17
;	byte2 -> R16
;	byte3 -> R19
;	data -> R18
;	bit_left -> R21
	LDI  R21,LOW(1)
; 0002 0033     byte1 = 0;
	LDI  R17,LOW(0)
; 0002 0034     byte2 = 0;
	LDI  R16,LOW(0)
; 0002 0035     byte3 = 0;
	LDI  R19,LOW(0)
; 0002 0036 
; 0002 0037     Uc_Select_led++;
	INC  R11
; 0002 0038     bit_left <<= (Uc_Select_led-1);
	MOV  R30,R11
	SUBI R30,LOW(1)
	MOV  R26,R21
	RCALL __LSLB12
	MOV  R21,R30
; 0002 0039     if(Uc_Select_led > 8)
	LDI  R30,LOW(8)
	CP   R30,R11
	BRSH _0x4000B
; 0002 003A     {
; 0002 003B         Uc_Select_led = 1;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0002 003C         bit_left = 0x01;
	LDI  R21,LOW(1)
; 0002 003D     }
; 0002 003E     /* 7-seg 1*/
; 0002 003F     data = Uint_data_led1/1000;
_0x4000B:
	LDS  R26,_Uint_data_led1
	LDS  R27,_Uint_data_led1+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	MOV  R18,R30
; 0002 0040     byte1 = BCDLED[data];
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
; 0002 0041     if(byte1 & bit_left) byte3 |= 0x20;
	MOV  R30,R21
	AND  R30,R17
	BREQ _0x4000C
	ORI  R19,LOW(32)
; 0002 0042     data = Uint_data_led1/100%10;
_0x4000C:
	LDS  R26,_Uint_data_led1
	LDS  R27,_Uint_data_led1+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	MOV  R18,R30
; 0002 0043     byte1 = BCDLED[data];
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
; 0002 0044     if(byte1 & bit_left) byte3 |= 0x40;
	MOV  R30,R21
	AND  R30,R17
	BREQ _0x4000D
	ORI  R19,LOW(64)
; 0002 0045     data = Uint_data_led1/10%10;
_0x4000D:
	LDS  R26,_Uint_data_led1
	LDS  R27,_Uint_data_led1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	MOV  R18,R30
; 0002 0046     byte1 = BCDLED[data];
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
; 0002 0047     byte1 |= 0x01;
	ORI  R17,LOW(1)
; 0002 0048     if(byte1 & bit_left) byte3 |= 0x80;
	MOV  R30,R21
	AND  R30,R17
	BREQ _0x4000E
	ORI  R19,LOW(128)
; 0002 0049     data = Uint_data_led1%10;
_0x4000E:
	LDS  R26,_Uint_data_led1
	LDS  R27,_Uint_data_led1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	MOV  R18,R30
; 0002 004A     byte1 = BCDLED[data];
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
; 0002 004B     if(byte1 & bit_left) byte3 |= 0x10;
	MOV  R30,R21
	AND  R30,R17
	BREQ _0x4000F
	ORI  R19,LOW(16)
; 0002 004C     /* 7-seg 2 */
; 0002 004D     data = Uint_data_led2/1000;
_0x4000F:
	LDS  R26,_Uint_data_led2
	LDS  R27,_Uint_data_led2+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	MOV  R18,R30
; 0002 004E     byte1 = BCDLED[data];
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
; 0002 004F     if(Bit_Led2_Warning && Uint_Warning_Count < TIME_WARNING_DISPLAY/2)    byte1 = BCDLED[10];
	SBIS 0x1E,1
	RJMP _0x40011
	LDS  R26,_Uint_Warning_Count
	LDS  R27,_Uint_Warning_Count+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLO _0x40012
_0x40011:
	RJMP _0x40010
_0x40012:
	__GETBRMN 17,_BCDLED,10
; 0002 0050     if(byte1 & bit_left) byte3 |= 0x08;
_0x40010:
	MOV  R30,R21
	AND  R30,R17
	BREQ _0x40013
	ORI  R19,LOW(8)
; 0002 0051     data = Uint_data_led2/100%10;
_0x40013:
	LDS  R26,_Uint_data_led2
	LDS  R27,_Uint_data_led2+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	MOV  R18,R30
; 0002 0052     byte1 = BCDLED[data];
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
; 0002 0053     byte1 |= 0x01;
	ORI  R17,LOW(1)
; 0002 0054     if(Bit_Led2_Warning && Uint_Warning_Count < TIME_WARNING_DISPLAY/2)    byte1 = BCDLED[10];
	SBIS 0x1E,1
	RJMP _0x40015
	LDS  R26,_Uint_Warning_Count
	LDS  R27,_Uint_Warning_Count+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLO _0x40016
_0x40015:
	RJMP _0x40014
_0x40016:
	__GETBRMN 17,_BCDLED,10
; 0002 0055     if(byte1 & bit_left) byte3 |= 0x04;
_0x40014:
	MOV  R30,R21
	AND  R30,R17
	BREQ _0x40017
	ORI  R19,LOW(4)
; 0002 0056     data = Uint_data_led2/10%10;
_0x40017:
	LDS  R26,_Uint_data_led2
	LDS  R27,_Uint_data_led2+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	MOV  R18,R30
; 0002 0057     byte1 = BCDLED[data];
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
; 0002 0058     if(Bit_Led2_Warning && Uint_Warning_Count < TIME_WARNING_DISPLAY/2)    byte1 = BCDLED[10];
	SBIS 0x1E,1
	RJMP _0x40019
	LDS  R26,_Uint_Warning_Count
	LDS  R27,_Uint_Warning_Count+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLO _0x4001A
_0x40019:
	RJMP _0x40018
_0x4001A:
	__GETBRMN 17,_BCDLED,10
; 0002 0059     if(byte1 & bit_left) byte3 |= 0x02;
_0x40018:
	MOV  R30,R21
	AND  R30,R17
	BREQ _0x4001B
	ORI  R19,LOW(2)
; 0002 005A     data = Uint_data_led2%10;
_0x4001B:
	LDS  R26,_Uint_data_led2
	LDS  R27,_Uint_data_led2+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	MOV  R18,R30
; 0002 005B     byte1 = BCDLED[data];
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
; 0002 005C     if(Bit_Led2_Warning && Uint_Warning_Count < TIME_WARNING_DISPLAY/2)    byte1 = BCDLED[10];
	SBIS 0x1E,1
	RJMP _0x4001D
	LDS  R26,_Uint_Warning_Count
	LDS  R27,_Uint_Warning_Count+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLO _0x4001E
_0x4001D:
	RJMP _0x4001C
_0x4001E:
	__GETBRMN 17,_BCDLED,10
; 0002 005D     if(byte1 & bit_left) byte3 |= 0x01;
_0x4001C:
	MOV  R30,R21
	AND  R30,R17
	BREQ _0x4001F
	ORI  R19,LOW(1)
; 0002 005E     bit_left = 0xff - bit_left;
_0x4001F:
	LDI  R30,LOW(255)
	SUB  R30,R21
	MOV  R21,R30
; 0002 005F     // SEND_DATA_LED(2,bit_left,byte3,byte2);
; 0002 0060     SEND_DATA_LED(2,byte3,bit_left,byte2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R21
	MOV  R26,R16
	RCALL _SEND_DATA_LED
; 0002 0061 
; 0002 0062     Uint_Warning_Count++;
	LDI  R26,LOW(_Uint_Warning_Count)
	LDI  R27,HIGH(_Uint_Warning_Count)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0002 0063     if(Uint_Warning_Count > TIME_WARNING_DISPLAY)  Uint_Warning_Count = 0;
	LDS  R26,_Uint_Warning_Count
	LDS  R27,_Uint_Warning_Count+1
	CPI  R26,LOW(0x191)
	LDI  R30,HIGH(0x191)
	CPC  R27,R30
	BRLO _0x40020
	LDI  R30,LOW(0)
	STS  _Uint_Warning_Count,R30
	STS  _Uint_Warning_Count+1,R30
; 0002 0064 }
_0x40020:
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;
;
;// void    SELECT_LED(unsigned char num_led,unsigned char    data)
;// {
;//     unsigned char   byte1,byte2,byte3;
;//     byte1 = 0;
;//     byte2 = 0;
;//     byte3 = 0;
;//     switch(num_led)
;//     {
;//         case    1:
;//         {
;//             byte3 = 0x01;
;//             byte2 = 0x01;
;//             break;
;//         }
;//         case    2:
;//         {
;//             byte3 = 0x02;
;//             byte2 = 0x02;
;//             //byte1 = 0x04;
;//             break;
;//         }
;//         case    3:
;//         {
;//             byte3 = 0x04;
;//             byte2 = 0x04;
;//             byte1 = 0x40;
;//             break;
;//         }
;//         case    4:
;//         {
;//             byte3 = 0x08;
;//             byte2 = 0x08;
;//             break;
;//         }
;//         case    5:
;//         {
;//             byte3 = 0x40;
;//             byte2 = 0x80;
;//             break;
;//         }
;//         case    6:
;//         {
;//             byte3 = 0x20;
;//             byte2 = 0x40;
;//             byte1 = 0x40;
;//             break;
;//         }
;//         case    7:
;//         {
;//             byte3 = 0x10;
;//             byte2 = 0x20;
;//             break;
;//         }
;//         case    8:
;//         {
;//             byte3 = 0x80;
;//             byte2 = 0x10;
;//             break;
;//         }
;//         case    9:
;//         {
;//             byte3 = 0x00;
;//             byte2 = 0x40;
;//             break;
;//         }
;//         case    10:
;//         {
;//             byte3 = 0x00;
;//             byte2 = 0x20;
;//             byte1 = 0x04;
;//             break;
;//         }
;//         case    11:
;//         {
;//             byte3 = 0x00;
;//             byte2 = 0x10;
;//             break;
;//         }
;//         case    12:
;//         {
;//             byte3 = 0x00;
;//             byte2 = 0x80;
;//             break;
;//         }
;//     }
;//     switch(data)
;//     {
;//         case    0:
;//         {
;//             byte1 |= 0xB7;
;//             break;
;//         }
;//         case    1:
;//         {
;//             byte1 |= 0x81;
;//             break;
;//         }
;//         case    2:
;//         {
;//             byte1 |= 0x3D;
;//             break;
;//         }
;//         case    3:
;//         {
;//             byte1 |= 0xAD;
;//             break;
;//         }
;//         case    4:
;//         {
;//             byte1 |= 0x8B;
;//             break;
;//         }
;//         case    5:
;//         {
;//             byte1 |= 0xAE;
;//             break;
;//         }
;//         case    6:
;//         {
;//             byte1 |= 0xBE;
;//             break;
;//         }
;//         case    7:
;//         {
;//             byte1 |= 0x85;
;//             break;
;//         }
;//         case    8:
;//         {
;//             byte1 |= 0xBF;
;//             break;
;//         }
;//         case    9:
;//         {
;//             byte1 |= 0xAF;
;//             break;
;//         }
;//     }
;//     SEND_DATA_LED(2,byte1,byte2,byte3);
;// }
;
;// void SCAN_LED(void)
;// {
;//     if(Uc_led_count == 1)   Uc_led_data = Uint_data_led1/1000;
;//     else if(Uc_led_count == 2)   Uc_led_data = (Uint_data_led1/100)%10;
;//     else if(Uc_led_count == 3)   Uc_led_data = (Uint_data_led1/10)%10;
;//     else if(Uc_led_count == 4)   Uc_led_data = (Uint_data_led1%10);
;//     else if(Uc_led_count == 5)   Uc_led_data = Uint_data_led2/1000;
;//     else if(Uc_led_count == 6)   Uc_led_data = (Uint_data_led2/100)%10;
;//     else if(Uc_led_count == 7)   Uc_led_data = (Uint_data_led2/10)%10;
;//     else if(Uc_led_count == 8)   Uc_led_data = (Uint_data_led2%10);
;//     else if(Uc_led_count == 9)   Uc_led_data = Uint_data_led3/1000;
;//     else if(Uc_led_count == 10)   Uc_led_data = (Uint_data_led3/100)%10;
;//     else if(Uc_led_count == 11)   Uc_led_data = (Uint_data_led3/10)%10;
;//     else if(Uc_led_count == 12)   Uc_led_data = (Uint_data_led3%10);
;//     SELECT_LED(Uc_led_count,Uc_led_data);
;//     Uc_led_count++;
;//     if(Uc_led_count > NUM_LED_SCAN*4)    Uc_led_count = 1;
;// }
;#include "SPI_SOFTWARE.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;
;
;void    SPI_SENDBYTE(unsigned char  data,unsigned char action)
; 0003 0005 {

	.CSEG
_SPI_SENDBYTE:
; .FSTART _SPI_SENDBYTE
; 0003 0006     unsigned char   i;
; 0003 0007     for(i=0;i<8;i++)
	ST   -Y,R26
	ST   -Y,R17
;	data -> Y+2
;	action -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x60004:
	CPI  R17,8
	BRSH _0x60005
; 0003 0008     {
; 0003 0009         if((data & 0x80) == 0x80)    DO_SPI_MOSI = 1;
	LDD  R30,Y+2
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0x60006
	SBI  0x5,3
; 0003 000A         else    DO_SPI_MOSI = 0;
	RJMP _0x60009
_0x60006:
	CBI  0x5,3
; 0003 000B         data <<= 1;
_0x60009:
	LDD  R30,Y+2
	LSL  R30
	STD  Y+2,R30
; 0003 000C         DO_SPI_SCK = 1;
	SBI  0x5,5
; 0003 000D         DO_SPI_SCK = 0;
	CBI  0x5,5
; 0003 000E     }
	SUBI R17,-1
	RJMP _0x60004
_0x60005:
; 0003 000F     if(action)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x60010
; 0003 0010     {
; 0003 0011         DO_SPI_LATCH = 1;
	SBI  0x8,0
; 0003 0012         DO_SPI_LATCH = 0;
	CBI  0x8,0
; 0003 0013     }
; 0003 0014 }
_0x60010:
	LDD  R17,Y+0
_0x2000001:
	ADIW R28,3
	RET
; .FEND

	.DSEG
_Uint_data_led1:
	.BYTE 0x2
_Uint_data_led2:
	.BYTE 0x2
_Ul_Voltage_Buff:
	.BYTE 0x78
_Ul_Current_Buff:
	.BYTE 0x78
_Uint_Warning_Count:
	.BYTE 0x2
_BCDLED:
	.BYTE 0xB

	.CSEG

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1388
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
