# adc_data_out_using_spi_or_qspi
Systemverilog code to output 16bit ADC data to an external SPI/QSPI memory.

In order to store more ADC conversions outside of the IC, this simple SPI master design can be used. The largest benefit of streaming out ADC conversion data on the SPI bus is **using the oscilloscope's SPI decoding to simultaneously view ADC input and conversion value**. A bus format recognizable (decode-able) by the oscilloscope is needed to get the real-time decoding. The digital gate overhead for including this is minimal and digital test mux pins could be used to selectively output the SCK, MOSI and CS_N signals.

If you place a standard SPI DAC IC on the evaluation board you could even compare a delayed version of the ADC analog input with itself (address data would need to configured to be static and single byte). The point is that driving ADC conversion data out using the SPI bus format is very useful.

![picture](https://github.com/charkster/adc_data_out_using_spi/blob/main/single_cycle.png)

**UPDATE**

I added a QSPI version. This version outputs the instruction and address using 1x SPI and then transitions to 4x SPI when the data is transmitted. There is a mode where instruction, address and data are all sent at 4x SPI, but that requires a separate instruction to be sent in advance. There is no limit to how much data can be sent in a single bus frame, which means the 1x SPI portion could make up a tiny part of the entire frame.

As for future improvements, the address counter could be used to automatically transition to the "IDLE" state when the last valid PSRAM address is approached (as to not over-write the memory).

![picture](https://github.com/charkster/adc_data_out_using_spi/blob/main/qspi_single_cycle.png)
