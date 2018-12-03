#include "mega88p.h"

#define DO_SPI_MOSI PORTB.3
#define DO_SPI_SCK  PORTB.5
#define DO_SPI_LATCH    PORTB.1

void    SPI_SENDBYTE(unsigned char  data,unsigned char action);