#include "mega88p.h"

#define DO_SPI_MOSI PORTB.3
#define DO_SPI_SCK  PORTB.5
#define DO_SPI_LATCH    PORTC.0

void    SPI_SENDBYTE(unsigned char  data,unsigned char action);