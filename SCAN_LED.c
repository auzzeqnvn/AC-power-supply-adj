#include "scan_led.h"
#include "SPI_SOFTWARE.h"

unsigned char   Uc_led_count = 1;
unsigned char   Uc_led_data = 0;
unsigned int    Uint_data_led1 = 0;
unsigned int    Uint_data_led2 = 0;
unsigned int    Uint_data_led3 = 0;
unsigned char   Uc_Select_led=1;

bit   Bit_Led1_Warning = 0;
bit   Bit_Led2_Warning = 0;

unsigned int   Uint_Warning_Count = 0;

unsigned char   BCDLED[11]={0xEE,0x88,0xB6,0xBC,0xD8,0x7C,0x7E,0xA8,0xFE,0xFC,0x00};

/* Day du lieu quet led qua duong spi_software
Co thẻ day tu 1 den 3 byte du lieu.
Du lieu sau khi day ra day du moi tien hanh xuat du lieu
num_bytes : so byte duoc day ra
data_first : du lieu dau tien
data_second: du lieu thu 2
data_third ; du lieu thu 3
*/
void    SEND_DATA_LED(unsigned char num_bytes,unsigned char  byte_first,unsigned char  byte_second,unsigned char  byte_third)
{
    unsigned char   i;
    unsigned char   data[4];
    for(i=0;i<4;i++)    data[i] = 0;
    data[0] = byte_first;
    data[1] = byte_second;
    data[2] = byte_third;

    for(i=0;i<(num_bytes - 1);i++)    SPI_SENDBYTE(data[i],0);
    SPI_SENDBYTE(data[i],1);
}


/* 
Ham quet led
num_led: Thu tu led
data: Du lieu hien thi tren led.
*/
void    SCAN_LED(void)
{
    unsigned char   byte1,byte2,byte3;
    unsigned char    data;
    unsigned char   bit_left;
    bit_left = 0x01;
    byte1 = 0;
    byte2 = 0;
    byte3 = 0;

    Uc_Select_led++;
    bit_left <<= (Uc_Select_led-1);
    if(Uc_Select_led > 8)   
    {
        Uc_Select_led = 1;
        bit_left = 0x01;
    }
    /* 7-seg 1*/
    data = Uint_data_led1/1000;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte3 |= 0x20;
    data = Uint_data_led1/100%10;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte3 |= 0x40;
    data = Uint_data_led1/10%10;
    byte1 = BCDLED[data];
    byte1 |= 0x01;
    if(byte1 & bit_left) byte3 |= 0x80;
    data = Uint_data_led1%10;
    byte1 = BCDLED[data];
    if(byte1 & bit_left) byte3 |= 0x10;
    /* 7-seg 2 */
    data = Uint_data_led2/1000;
    byte1 = BCDLED[data];
    if(Bit_Led2_Warning && Uint_Warning_Count < TIME_WARNING_DISPLAY/2)    byte1 = BCDLED[10];
    if(byte1 & bit_left) byte3 |= 0x08;
    data = Uint_data_led2/100%10;
    byte1 = BCDLED[data];
    byte1 |= 0x01;
    if(Bit_Led2_Warning && Uint_Warning_Count < TIME_WARNING_DISPLAY/2)    byte1 = BCDLED[10];
    if(byte1 & bit_left) byte3 |= 0x04;
    data = Uint_data_led2/10%10;
    byte1 = BCDLED[data];
    if(Bit_Led2_Warning && Uint_Warning_Count < TIME_WARNING_DISPLAY/2)    byte1 = BCDLED[10];
    if(byte1 & bit_left) byte3 |= 0x02;
    data = Uint_data_led2%10;
    byte1 = BCDLED[data];
    if(Bit_Led2_Warning && Uint_Warning_Count < TIME_WARNING_DISPLAY/2)    byte1 = BCDLED[10];
    if(byte1 & bit_left) byte3 |= 0x01;
    bit_left = 0xff - bit_left;
    // SEND_DATA_LED(2,bit_left,byte3,byte2);
    SEND_DATA_LED(2,byte3,bit_left,byte2);

    Uint_Warning_Count++;
    if(Uint_Warning_Count > TIME_WARNING_DISPLAY)  Uint_Warning_Count = 0;
}


// void    SELECT_LED(unsigned char num_led,unsigned char    data)
// {
//     unsigned char   byte1,byte2,byte3;
//     byte1 = 0;
//     byte2 = 0;
//     byte3 = 0;
//     switch(num_led)
//     {
//         case    1:
//         {
//             byte3 = 0x01;
//             byte2 = 0x01;
//             break;
//         }
//         case    2:
//         {
//             byte3 = 0x02;
//             byte2 = 0x02;
//             //byte1 = 0x04;
//             break;
//         }
//         case    3:
//         {
//             byte3 = 0x04;
//             byte2 = 0x04;
//             byte1 = 0x40;
//             break;
//         }
//         case    4:
//         {
//             byte3 = 0x08;
//             byte2 = 0x08;
//             break;
//         }
//         case    5:
//         {
//             byte3 = 0x40;
//             byte2 = 0x80;
//             break;
//         }
//         case    6:
//         {
//             byte3 = 0x20;
//             byte2 = 0x40;
//             byte1 = 0x40;
//             break;
//         }
//         case    7:
//         {
//             byte3 = 0x10;
//             byte2 = 0x20;
//             break;
//         }
//         case    8:
//         {
//             byte3 = 0x80;
//             byte2 = 0x10;
//             break;
//         }
//         case    9:
//         {
//             byte3 = 0x00;
//             byte2 = 0x40;
//             break;
//         }
//         case    10:
//         {
//             byte3 = 0x00;
//             byte2 = 0x20;
//             byte1 = 0x04;
//             break;
//         }
//         case    11:
//         {
//             byte3 = 0x00;
//             byte2 = 0x10;
//             break;
//         }
//         case    12:
//         {
//             byte3 = 0x00;
//             byte2 = 0x80;
//             break;
//         }
//     }
//     switch(data)
//     {
//         case    0:
//         {
//             byte1 |= 0xB7;
//             break;
//         }
//         case    1:
//         {
//             byte1 |= 0x81;
//             break;
//         }
//         case    2:
//         {
//             byte1 |= 0x3D;
//             break;
//         }
//         case    3:
//         {
//             byte1 |= 0xAD;
//             break;
//         }
//         case    4:
//         {
//             byte1 |= 0x8B;
//             break;
//         }
//         case    5:
//         {
//             byte1 |= 0xAE;
//             break;
//         }
//         case    6:
//         {
//             byte1 |= 0xBE;
//             break;
//         }
//         case    7:
//         {
//             byte1 |= 0x85;
//             break;
//         }
//         case    8:
//         {
//             byte1 |= 0xBF;
//             break;
//         }
//         case    9:
//         {
//             byte1 |= 0xAF;
//             break;
//         }    
//     }
//     SEND_DATA_LED(2,byte1,byte2,byte3);
// }

// void SCAN_LED(void)
// {
//     if(Uc_led_count == 1)   Uc_led_data = Uint_data_led1/1000;
//     else if(Uc_led_count == 2)   Uc_led_data = (Uint_data_led1/100)%10;
//     else if(Uc_led_count == 3)   Uc_led_data = (Uint_data_led1/10)%10;
//     else if(Uc_led_count == 4)   Uc_led_data = (Uint_data_led1%10);
//     else if(Uc_led_count == 5)   Uc_led_data = Uint_data_led2/1000;
//     else if(Uc_led_count == 6)   Uc_led_data = (Uint_data_led2/100)%10;
//     else if(Uc_led_count == 7)   Uc_led_data = (Uint_data_led2/10)%10;
//     else if(Uc_led_count == 8)   Uc_led_data = (Uint_data_led2%10);
//     else if(Uc_led_count == 9)   Uc_led_data = Uint_data_led3/1000;
//     else if(Uc_led_count == 10)   Uc_led_data = (Uint_data_led3/100)%10;
//     else if(Uc_led_count == 11)   Uc_led_data = (Uint_data_led3/10)%10;
//     else if(Uc_led_count == 12)   Uc_led_data = (Uint_data_led3%10);
//     SELECT_LED(Uc_led_count,Uc_led_data);
//     Uc_led_count++;
//     if(Uc_led_count > NUM_LED_SCAN*4)    Uc_led_count = 1;
// }