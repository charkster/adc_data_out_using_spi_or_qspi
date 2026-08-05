module tb_qspi_master ();

   parameter EXT_CLK_PERIOD_NS = 176;

   reg  clk;
   reg  rst_n;
   reg  start;
   
   initial begin
      clk = 1'b0;
      forever
        #(EXT_CLK_PERIOD_NS/2) clk = ~clk;
   end
   
   initial begin
      rst_n = 1'b0;
      start = 1'b0;
      repeat(2) @(posedge clk);
      rst_n = 1'b1;
      @(posedge clk);
      start = 1'b1;
      repeat(4*1) @(posedge clk);
      start = 1'b0;
      repeat(4*10) @(posedge clk);
      start = 1'b1;
      repeat(4*2) @(posedge clk);
      start = 1'b0;
      repeat(4*10) @(posedge clk);
      start = 1'b1;
      repeat(4*3) @(posedge clk);
      start = 1'b0;
      repeat(4*10) @(posedge clk);
      start = 1'b1;
      repeat(4*4) @(posedge clk);
      start = 1'b0;
      repeat(4*10) @(posedge clk);
      start = 1'b1;
      repeat(4*5) @(posedge clk);
      start = 1'b0;
      repeat(4*10) @(posedge clk);
      start = 1'b1;
      repeat(4*6) @(posedge clk);
      start = 1'b0;
      repeat(4*10) @(posedge clk);
      start = 1'b1;
      repeat(4*7) @(posedge clk);
      start = 1'b0;
      repeat(4*10) @(posedge clk);
      start = 1'b1;
      repeat(4*8) @(posedge clk);
      start = 1'b0;
      repeat(4*10) @(posedge clk);
      $finish;
   end
   
   logic  [1:0] nibble_counter;
  logic        start_buf;
  logic [15:0] adc_data;
  logic [15:0] adc_data_buf;
  
  always_ff @(posedge clk or negedge rst_n)
    if (!rst_n)                  nibble_counter <= 'd0;
    else if (start || start_buf) nibble_counter <= nibble_counter + 'd1; // overflow expected
    else                         nibble_counter <= 'd0;
  
  always_ff @(posedge clk or negedge rst_n)
    if (!rst_n)                                adc_data <= 'd0;
    else if (start && (nibble_counter == 'd0)) adc_data <= adc_data + 'd1; // example adc data is sequential
  
  adc_buffer u_adc_buffer
  ( .adc_clk_4x (clk),   // input  logic        
    .rst_n,              // input  logic        
    .start,              // input  logic        
    .adc_data,           // input  logic [15:0] 
    .adc_data_buf,       // output logic [15:0] 
    .start_buf           // output logic        
  );
  
  qspi_master_psram_write u_qspi_master_psram_write
  ( .clk,                     // input
    .rst_n,                   // input
    .start    (start_buf),    // input
    .adc_data (adc_data_buf), // input [15:0]
    .busy (),                 // output
    .sck  (),                 // output
    .sio0 (),                 // output
    .sio1 (),                 // output
    .sio2 (),                 // output
    .sio3 (),                 // output
    .cs_n ()                  // output
  );
   
endmodule
