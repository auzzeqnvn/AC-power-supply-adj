
#define NUM_LED_SCAN 2
#define TIME_WARNING_DISPLAY    400

extern unsigned char Uc_led_count;
extern unsigned char   Uc_led_data;
extern unsigned int    Uint_data_led1;
extern unsigned int    Uint_data_led2;
extern unsigned int    Uint_data_led3;

extern bit   Bit_Led1_Warning;
extern bit   Bit_Led2_Warning;

void    SCAN_LED(void);