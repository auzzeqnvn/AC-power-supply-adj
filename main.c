/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : AC_Power_Supply_Adj
Version : 1.0
Date    : 12/1/2018
Author  : 
Company : 
Comments: 
Dieu che dien ap xoay chieu 35VAC


Chip type               : ATmega88P
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega88p.h>
#include "ADE7753.h"
#include "scan_led.h"
#include <delay.h>


#define ADC1    2
#define ADC_SET_VOLTAGE    1
#define ADC3    4

#define BUZZER  PORTC.5

#define BUZZER_ON   BUZZER = 1
#define BUZZER_OFF  BUZZER = 0

#define PHASE_1 PORTB.1
#define PHASE_2 PORTB.2

#define VOLTAGE_RATIO   6045//3831//4139
#define CURRENT_RATIO   566

// #define STEP_1  1.315789
// #define STEP_2  1.298701
// #define STEP_3  1.226994
// #define STEP_4  1.190476 
// #define STEP_5  1.123596
// #define STEP_6  1   

#define CALIB   0
#define CALIB2   1

#define NUM_SAMPLE  30
#define NUM_FILTER  7

#define TIME_UPDATE_DISPLAY  200
#define SPEED_BUZZER    200
// Declare your global variables here
unsigned long   Ul_Voltage_Buff[NUM_SAMPLE];
unsigned long   Ul_Current_Buff[NUM_SAMPLE];


unsigned int    Uint_Voltage;
unsigned int    Uint_Current;

unsigned char   Uc_Buff_Count = 0;

unsigned char   Uc_Buzzer_Count; 

bit Bit_En_Meas = 0;

unsigned int   Uc_Voltage_Duty = 0;

unsigned int   Uc_Timer_Update_Display=0;

void    PWM_PHASE1(unsigned int duty);
void    PWM_PHASE2(unsigned int duty);

// Voltage Reference: Int., cap. on AREF
#define ADC_VREF_TYPE ((1<<REFS1) | (1<<REFS0) | (0<<ADLAR))
// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
    ADMUX=adc_input | ADC_VREF_TYPE;
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=(1<<ADSC);
    // Wait for the AD conversion to complete
    while ((ADCSRA & (1<<ADIF))==0);
    ADCSRA|=(1<<ADIF);
    return ADCW;
}
// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
    // Reinitialize Timer2 value
    TCNT2=0x7E;  
     if(Uc_Timer_Update_Display < TIME_UPDATE_DISPLAY)   Uc_Timer_Update_Display++;
    // Place your code here
    SCAN_LED();
    Uc_Buzzer_Count++;
    if(Uc_Buzzer_Count > SPEED_BUZZER)      Uc_Buzzer_Count = 0;
    Bit_En_Meas = 1;
    
}

void    PWM_PHASE1(unsigned int duty)
{
    if(duty <= 1)
    {
        OCR1AH=0x00;
        OCR1AL=0;
    }
    else
    {
        OCR1AH=(duty>>8) & 0xff;
        OCR1AL= duty & 0xff;
    }
}

void    PWM_PHASE2(unsigned int duty)
{
    if(duty <= 1)
    {
        OCR1BH=0x00;
        OCR1BL=0;
    }
    else
    {
        OCR1BH=(duty>>8) & 0xff;
        OCR1BL=duty & 0xff;
    }
}

void    CONTROL_VOLTAGE(void)
{
    unsigned int    Uint_Vr_Set_Voltage;

    Uint_Vr_Set_Voltage = read_adc(ADC_SET_VOLTAGE);
    Uc_Voltage_Duty = (unsigned int)((unsigned long)Uint_Vr_Set_Voltage*255/1023);
    PWM_PHASE2(Uc_Voltage_Duty);
    PWM_PHASE1(Uc_Voltage_Duty);
    // Uint_data_led1 = Uc_Voltage_Duty;
    // Uint_data_led2 = Uint_Vr_Set_Voltage;
}
/* 
Doc thong so dien ap va dong dien, loc nhieu.
Loc nhieu va tinh toan ra gia tri thuc cua dong dien va dien ap.
Cap nhat cac thong so len led hien thi
*/
void    READ_CURRENT_INFO(void)
{
    unsigned long   Ul_Buff[NUM_SAMPLE];
    unsigned char   Uc_loop = 0,Uc_loop2 = 0;
    unsigned long   Ul_temp;

    Ul_Voltage_Buff[Uc_Buff_Count] = ADE7753_READ(1,VRMS);
    delay_ms(10);
    /* Tinh toan va loc nhieu gia tri dien ap */
    for(Uc_loop = 0; Uc_loop < NUM_SAMPLE; Uc_loop++)
    {
        Ul_Buff[Uc_loop] = Ul_Voltage_Buff[Uc_loop];
    }
    for(Uc_loop = 0; Uc_loop < NUM_SAMPLE; Uc_loop++)
    {
        for(Uc_loop2 = Uc_loop; Uc_loop2 < NUM_SAMPLE; Uc_loop2++)
        {
            if(Ul_Buff[Uc_loop] > Ul_Buff[Uc_loop2])
            {
                Ul_temp = Ul_Buff[Uc_loop];
                Ul_Buff[Uc_loop] = Ul_Buff[Uc_loop2];
                Ul_Buff[Uc_loop2] = Ul_temp;
            }
        }
    }
    Ul_temp = 0;
    for(Uc_loop = NUM_FILTER; Uc_loop < NUM_SAMPLE - NUM_FILTER; Uc_loop++)
    {
        Ul_temp += Ul_Buff[Uc_loop];
    }
    Ul_temp = Ul_temp/(NUM_SAMPLE - 2*NUM_FILTER);

    #if CALIB
    if(Uc_Timer_Update_Display >= TIME_UPDATE_DISPLAY)   
    {
        Uint_data_led1 = Ul_temp /10000;
        Uint_data_led2 = Ul_temp %10000;
    }
    #endif
    Uint_Voltage = (unsigned int)((float)Ul_temp/VOLTAGE_RATIO);

    // #if !CALIB2
    // if(Uint_Voltage < 50)   Uint_Voltage = (unsigned int)((float)Ul_temp/(VOLTAGE_RATIO*STEP_1));
    // else if(Uint_Voltage < 100)     Uint_Voltage = (unsigned int)((float)Ul_temp/(VOLTAGE_RATIO*(STEP_1 - (Uint_Voltage - 50)*(STEP_1-STEP_2)/50)));
    // else if(Uint_Voltage < 200)   Uint_Voltage = (unsigned int)((float)Ul_temp/(VOLTAGE_RATIO*(STEP_2 - (Uint_Voltage - 100)*(STEP_2-STEP_3)/100)));
    // else if(Uint_Voltage < 300)   Uint_Voltage = (unsigned int)((float)Ul_temp/(VOLTAGE_RATIO*(STEP_3 - (Uint_Voltage - 200)*(STEP_3-STEP_4)/100)));
    // else if(Uint_Voltage < 400)   Uint_Voltage = (unsigned int)((float)Ul_temp/(VOLTAGE_RATIO*(STEP_4 - (Uint_Voltage - 300)*(STEP_4-STEP_5)/100)));
    // else if(Uint_Voltage < 500)   Uint_Voltage = (unsigned int)((float)Ul_temp/(VOLTAGE_RATIO*(STEP_5 - (Uint_Voltage - 400)*(STEP_5-STEP_6)/100)));
    // #endif

    #if !CALIB
    if(Uc_Timer_Update_Display >= TIME_UPDATE_DISPLAY)    Uint_data_led1 = Uint_Voltage;
    #endif
    if(Uint_Voltage > 380)
    {
        Bit_Led1_Warning = 1;
    }
    else    Bit_Led1_Warning = 0;

    Ul_Current_Buff[Uc_Buff_Count] = ADE7753_READ(1,IRMS);
    delay_ms(10);
    /* Tinh toan va loc nhieu gia tri dong dien */
    for(Uc_loop = 0; Uc_loop < NUM_SAMPLE; Uc_loop++)
    {
        Ul_Buff[Uc_loop] = Ul_Current_Buff[Uc_loop];
    }
    for(Uc_loop = 0; Uc_loop < NUM_SAMPLE; Uc_loop++)
    {
        for(Uc_loop2 = Uc_loop; Uc_loop2 < NUM_SAMPLE; Uc_loop2++)
        {
            if(Ul_Buff[Uc_loop] > Ul_Buff[Uc_loop2])
            {
                Ul_temp = Ul_Buff[Uc_loop];
                Ul_Buff[Uc_loop] = Ul_Buff[Uc_loop2];
                Ul_Buff[Uc_loop2] = Ul_temp;
            }
        }
    }
    Ul_temp = 0;
    for(Uc_loop = NUM_FILTER; Uc_loop < NUM_SAMPLE - NUM_FILTER; Uc_loop++)
    {
        Ul_temp += Ul_Buff[Uc_loop];
    }
    Ul_temp = Ul_temp/(NUM_SAMPLE - 2*NUM_FILTER);
    Uint_Current = (unsigned int)((float)Ul_temp/CURRENT_RATIO);
    if(Uc_Timer_Update_Display >= TIME_UPDATE_DISPLAY)   
    {
        #if !CALIB
        Uint_data_led2 = Uint_Current;
        #endif
        Uc_Timer_Update_Display = 0;
    }
    if(Uint_Current > 550)  Bit_Led2_Warning = 1;
    else    Bit_Led2_Warning = 0;


    Uc_Buff_Count++;
    if(Uc_Buff_Count >= NUM_SAMPLE) Uc_Buff_Count = 0;
}

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=Out Bit1=In Bit0=Out 
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=T Bit2=0 Bit1=T Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out 
DDRC=(0<<DDC6) | (1<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (1<<DDC0);
// State: Bit6=T Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=0 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=In Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (0<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=0 Bit6=T Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);


// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 20000.000 kHz
// Mode: Ph. correct PWM top=0x01FF
// OC1A output: Non-Inverted PWM
// OC1B output: Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0.0511 ms
// Output Pulse(s):
// OC1A Period: 0.0511 ms Width: 0 us
// OC1B Period: 0.0511 ms Width: 0.0511 ms
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 43,200 kHz
// Mode: Normal top=0xFF
// OC2A output: Disconnected
// OC2B output: Disconnected
// Timer Period: 3,0093 ms
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
TCCR2B=(0<<WGM22) | (1<<CS22) | (1<<CS21) | (0<<CS20);
TCNT2=0x7E;
OCR2A=0x00;
OCR2B=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (1<<TOIE2);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EIMSK=(0<<INT1) | (0<<INT0);
PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);

// USART initialization
// USART disabled
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR1=(0<<AIN0D) | (0<<AIN1D);

// ADC initialization
// ADC Clock frequency: 691,200 kHz
// ADC Voltage Reference: Int., cap. on AREF
// ADC Auto Trigger Source: ADC Stopped
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
// ADC4: On, ADC5: On
DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);


// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
// Global enable interrupts
#asm("sei")

ADE7753_INIT();
PWM_PHASE2(255);
PWM_PHASE1(255);
for(Uc_Buff_Count = 0; Uc_Buff_Count < NUM_SAMPLE; Uc_Buff_Count++)
{
    Ul_Voltage_Buff[Uc_Buff_Count] = 0;
    Ul_Current_Buff[Uc_Buff_Count] = 0;
}
Uc_Buff_Count = 0;
delay_ms(2000);
BUZZER_ON;
delay_ms(100);
BUZZER_OFF;
delay_ms(100);
BUZZER_ON;
delay_ms(100);
BUZZER_OFF;
while (1)
      {
      // Place your code here
        if(Bit_En_Meas)
        {
                Bit_En_Meas = 0;
                READ_CURRENT_INFO();
        }
        CONTROL_VOLTAGE();
        if(Bit_Led2_Warning == 1 || Bit_Led1_Warning)
        {
            if(Uc_Buzzer_Count < SPEED_BUZZER/2)   BUZZER_ON;
            else    BUZZER_OFF;
        }
        else    BUZZER_OFF;
      }
}
