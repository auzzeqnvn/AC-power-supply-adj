#include "SPI_SOFTWARE.h"


void    SPI_SENDBYTE(unsigned char  data,unsigned char action)
{
    unsigned char   i;
    for(i=0;i<8;i++)
    {
        if((data & 0x80) == 0x80)    DO_SPI_MOSI = 1;
        else    DO_SPI_MOSI = 0;
        data <<= 1;
        DO_SPI_SCK = 1;
        DO_SPI_SCK = 0;
    }
    if(action)
    {
        DO_SPI_LATCH = 1;
        DO_SPI_LATCH = 0;
    }
}