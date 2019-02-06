module accelerometer_test
   (
     input wire clk, 
	  input wire reset,
	  
	  output wire int1,
	  input wire MISO, 
     output wire SS,
	  output wire SCLK,
	  output wire MOSI,
	  output wire int2,
	  
	  output wire [7:0] received_y
   );
	
	/* LOCAL VARIABLES */
	wire [7:0] in0_b, in1_b, in2_b, in3_b;
	wire write_finished, start, second_clock;
	
	/* SS Select */
	wire writeSS, writeSS1, readXAxisSS;
	assign SS = (writeSS == 0 || readXAxisSS == 0 || writeSS1 == 0 || writeSS2 == 0 || writeSS3 == 0 || writeSS4 == 0 || writeSS5 == 0) ? 0 : 1;
	
	/* MOSI helpers */
	wire writeMOSI, readXAxisMOSI, writeMOSI1,writeMOSI2,writeMOSI3,writeMOSI4,writeMOSI5;
	
	/* SCLK helpers */
	assign SCLK = second_clock;
	assign int2 = 0;
	
	/* CPE processor is too fast, we need to use counter as a prescaler 5MHz */
	mod_m_counter_gyro #(.N(7), .M(32)) prescaler (.clk(clk), .reset(reset), .max_tick(second_clock));


	/* INITIALIZE SPI and GYRO sensor */
	wire first_wait, second_wait, third_wait, fourth_wait, fifth_wait, sixth_wait;
	accelerometer_write write_INT1MAP (.clk(second_clock), .reset(reset), .ready(1), .address(8'h20), .data(8'hFA), .MISO(MISO), .SS(writeSS), .MOSI(writeMOSI), .write_finished(first_wait));
	accelerometer_write write_INT1MAP2 (.clk(second_clock), .reset(reset), .ready(first_wait), .address(8'h23), .data(8'h96), .MISO(MISO), .SS(writeSS1), .MOSI(writeMOSI1), .write_finished(second_wait));
	accelerometer_write write_INT1MAP3 (.clk(second_clock), .reset(reset), .ready(second_wait), .address(8'h25), .data(8'h1E), .MISO(MISO), .SS(writeSS2), .MOSI(writeMOSI2), .write_finished(third_wait));
	accelerometer_write write_INT1MAP4 (.clk(second_clock), .reset(reset), .ready(third_wait), .address(8'h27), .data(8'h3F), .MISO(MISO), .SS(writeSS3), .MOSI(writeMOSI3), .write_finished(fourth_wait));
	accelerometer_write write_INT1MAP5 (.clk(second_clock), .reset(reset), .ready(fourth_wait), .address(8'h2B), .data(8'h40), .MISO(MISO), .SS(writeSS4), .MOSI(writeMOSI4), .write_finished(fifth_wait));
	accelerometer_write write_INT1MAP6 (.clk(second_clock), .reset(reset), .ready(fifth_wait), .address(8'h2D), .data(8'h0A), .MISO(MISO), .SS(writeSS5), .MOSI(writeMOSI5), .write_finished(sixth_wait));
	
	
	/* READ GYRO sensor registers with SPI */
	accelerometer_read read_x_axis (.clk(second_clock), .reset(reset), .ready(sixth_wait), .MISO(MISO), .SS(readXAxisSS), .MOSI(readXAxisMOSI), .int1_interrupt(int1), .received_y(received_y));
	
	/* MULTIPLEXER */
	MUX8_1 selectMOSI_output (.select({writeSS,writeSS1,writeSS2,writeSS3,writeSS4,writeSS5,readXAxisSS}), .d0(writeMOSI), .d1(writeMOSI1), .d2(writeMOSI2), .d3(writeMOSI3), .d4(writeMOSI4), .d5(writeMOSI5), .d6(readXAxisMOSI), .y(MOSI));
	
endmodule
