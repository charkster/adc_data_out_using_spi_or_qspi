
module adc_buffer(
  input  logic        adc_clk_4x, // 4 clock cycles for each new adc_data
  input  logic        rst_n,      // rst_n assumed to be synchronized to adc_clk_4x
  input  logic        start,      // start goes high with first valid adc_data and is synchronized to adc_clk_4x
  input  logic [15:0] adc_data,
  output logic [15:0] adc_data_buf,
  output logic        start_buf
);

logic [15:0] data_buffer [3:0];
logic [3:0]  counter;
logic        shift_data;
logic        final_cycle;

assign start_buf = start || (counter != 'd0);

 always_ff @(posedge adc_clk_4x or negedge rst_n)
   if (!rst_n)                          counter <= 'd0;
   else if (start && (counter == 'd0))  counter <= 'd1;
   else if ((!start) && (!final_cycle)) counter <= 'd1;
   else if (counter != 'd0)             counter <= counter + 'd1;

 always_ff @(posedge adc_clk_4x or negedge rst_n)
   if (!rst_n)         final_cycle <= 'd0;
   else if (start)     final_cycle <= 'd0;
   else                final_cycle <= 'd1;

assign shift_data = (counter == 'd3) || (counter == 'd7) || (counter == 'd11) || (counter == 'd15);

always_ff @(posedge adc_clk_4x or negedge rst_n)
  if (!rst_n) begin
     data_buffer[3] <= 'd0;
     data_buffer[2] <= 'd0;
     data_buffer[1] <= 'd0;
     data_buffer[0] <= 'd0; end
  else if (shift_data) begin 
     data_buffer[3] <= data_buffer[2];
     data_buffer[2] <= data_buffer[1];
     data_buffer[1] <= data_buffer[0]; 
     data_buffer[0] <= adc_data; end
                                 
assign adc_data_buf = data_buffer[3];

endmodule
