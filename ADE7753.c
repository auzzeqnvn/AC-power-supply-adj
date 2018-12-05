#include "ADE7753.h"
#include "delay.h"
#include "scan_led.h"


void    SPI_7753_SEND(unsigned char data)
{
    unsigned char   cnt;
    unsigned char   tmp = data;

    for(cnt = 0;cnt < 8; cnt++)
    {
        if((tmp & 0x80) == 0x80)   SPI_MOSI_HIGHT;
        else SPI_MOSI_LOW;

        SPI_SCK_HIGHT;
        delay_us(50);
        SPI_SCK_LOW;
        delay_us(50);
        tmp <<= 1;
    }
}

unsigned char    SPI_7753_RECEIVE(void)
{
    unsigned char cnt;
    unsigned char data;
    data = 0;
    for(cnt = 0;cnt < 8; cnt++)
    {
        data <<= 1; 
        SPI_SCK_HIGHT;
        delay_us(50);
        if(SPI_MISO_HIGHT)   
        {
            data += 1;
        }  
        SPI_SCK_LOW; 
        delay_us(50); 
    }
    return data;
}

void    ADE7753_WRITE(unsigned char IC_CS,unsigned char addr,unsigned char num_data,unsigned char data_1,unsigned char data_2,unsigned char data_3)
{
    unsigned char data[4];
    unsigned char   i;
    data[0] = data_1;
    data[1] = data_2;
    data[2] = data_3;

    switch (IC_CS)
    {
        case 1:
        {
            PHASE_1_ON;
            PHASE_2_OFF;
            PHASE_3_OFF;
            break;
        }
        case 2:
        {
            PHASE_1_OFF;
            PHASE_2_ON;
            PHASE_3_OFF;
            break;
        }
        case 3:
        {
            PHASE_1_OFF;
            PHASE_2_OFF;
            PHASE_3_ON;
            break;
        }
    }
    addr &= 0x3F;
    addr |= 0x80;
    delay_us(100);
    SPI_7753_SEND(addr);
    delay_us(100);
    for(i=0;i<num_data;i++)    SPI_7753_SEND(data[i]);
    delay_us(100);
    PHASE_1_OFF;
    PHASE_2_OFF;
    PHASE_3_OFF;
}
unsigned long int    ADE7753_READ(unsigned char IC_CS,unsigned char addr,unsigned char num_data)
{
    unsigned char   i;
    unsigned char   data[4];
    unsigned long int res;
    for(i=0;i<4;i++)    data[i] = 0;
    switch (IC_CS)
    {
        case 1:
        {
            PHASE_1_ON;
            PHASE_2_OFF;
            PHASE_3_OFF;
            break;
        }
        case 2:
        {
            PHASE_1_OFF;
            PHASE_2_ON;
            PHASE_3_OFF;
            break;
        }
        case 3:
        {
            PHASE_1_OFF;
            PHASE_2_OFF;
            PHASE_3_ON;
            break;
        }
    }
    delay_us(100);
    addr &= 0x3F;
    SPI_7753_SEND(addr);
    delay_us(100);
    for(i=0;i<num_data;i++) data[i] = SPI_7753_RECEIVE();
    delay_us(100);
    PHASE_1_OFF;
    PHASE_2_OFF;
    PHASE_3_OFF;
    res = 0;
    for(i=0;i<num_data;i++)
    {
        res <<= 8;
        res += data[i];
    }
    return res;
}

void    ADE7753_INIT(void)
{
    unsigned long   res;
    ADE7753_WRITE(1,MODE,0x00,0x4C,0x00);
    delay_ms(200);
    // ADE7753_WRITE(1,MODE,0x80,0x0C,0x00);
    delay_ms(200);
    // ADE7753_WRITE(1,RSTSTATUS,0x00,0x00,0x00);
    // delay_ms(200);
    // ADE7753_WRITE(1,SAGLVL,0X2a,0X00,0X00);
    // res = ADE7753_READ(1,SAGLVL);
    // delay_ms(200);
    // ADE7753_WRITE(1,SAGCYC,0XFF,0X00,0X00);
    // res = ADE7753_READ(1,SAGCYC);
    // delay_ms(200);
}