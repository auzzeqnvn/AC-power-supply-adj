#include "mega88p.h"

#define DOUT_MOSI_SPI_7753_MCU   PORTD.5
#define DIN_MISO_SPI_7753_MCU    PIND.6
#define DOUT_CLK_SPI_7753_MCU   PORTD.7
#define DOUT_CS_SPI_7753_1_MCU   PORTB.0

#define DOUT_CS_SPI_7753_2_MCU PORTD.1
#define DOUT_CS_SPI_7753_3_MCU PORTD.1

#define SPI_SCK_HIGHT   DOUT_CLK_SPI_7753_MCU = 1
#define SPI_SCK_LOW   DOUT_CLK_SPI_7753_MCU = 0

#define SPI_MOSI_HIGHT  DOUT_MOSI_SPI_7753_MCU = 1
#define SPI_MOSI_LOW  DOUT_MOSI_SPI_7753_MCU = 0

#define SPI_MISO_HIGHT  DIN_MISO_SPI_7753_MCU == 1
#define SPI_MISO_LOW  DIN_MISO_SPI_7753_MCU == 0

#define PHASE_1_ON  DOUT_CS_SPI_7753_1_MCU = 0
#define PHASE_1_OFF DOUT_CS_SPI_7753_1_MCU = 1
#define PHASE_2_ON  DOUT_CS_SPI_7753_2_MCU = 0
#define PHASE_2_OFF DOUT_CS_SPI_7753_2_MCU = 1
#define PHASE_3_ON  DOUT_CS_SPI_7753_3_MCU = 0
#define PHASE_3_OFF DOUT_CS_SPI_7753_3_MCU = 1

//Dia chi cac thanh ghi SPI_ADE7753
#define WAVEFORM        0x01,3    
#define AENERGY         0x02,3
#define RAENERGY        0x03,3
#define LAENERGY		0x04,3
#define VAENERGY		0x05,3
#define RVAENERGY		0x06,3
#define LVAENERGY		0x07,3
#define LVARENERGY		0x08,3
#define MODE			0x09,2
#define IRQEN			0x0A,2
#define STATUS			0x0B,2
#define RSTSTATUS		0x0C,2
#define CH1OS			0x0D,1
#define CH2OS			0x0E,1
#define GAIN			0x0F,1
#define PHCAL			0x10,1
#define APOS			0x11,2
#define WGAIN			0x12,2
#define WDIV			0x13,1
#define CFNUM			0x14,2
#define CFDEN			0x15,2
#define IRMS			0x16,3
#define VRMS			0x17,3
#define IRMSOS			0x18,2
#define VRMSOS			0x19,2
#define VAGAIN			0x1A,2
#define VADIV			0x1B,1
#define LINECYC			0x1C,2
#define ZXTOUT			0x1D,2
#define SAGCYC			0x1E,1
#define SAGLVL			0x1F,1
#define IPKLVL			0x20,1
#define VPKLVL			0x21,1
#define IPEAK			0x22,3
#define RSTIPEAK		0x23,3
#define VPEAK			0x24,3
#define RSTVPEAK		0x25,3
#define TEMP			0x26,1
#define PERIOD			0x27,2
#define TMODE			0x3D,1
#define CHKSUM			0x3E,1
#define DIEREV			0x3F,1


void    SPI_7753_SEND(unsigned char data);
unsigned char    SPI_7753_RECEIVE(void);
void    ADE7753_WRITE(unsigned char IC_CS,unsigned char addr,unsigned char num_data,unsigned char data_1,unsigned char data_2,unsigned char data_3);
unsigned long int    ADE7753_READ(unsigned char IC_CS,unsigned char addr,unsigned char num_data);
void    ADE7753_INIT(void);
