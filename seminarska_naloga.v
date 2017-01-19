module seminarska_naloga
   (
		input wire clk, reset,
		input wire shoot_button,
		input wire pause_switch,
		
		// ACCELEROMETER
		output wire int1,
	   input wire MISO, 
      output wire SS,
	   output wire SCLK,
	   output wire MOSI,
	   output wire int2,
		
		// VGA
		output wire Hsync, Vsync,
		output wire [3:0] vgaRed, vgaGreen, vgaBlue,
		
		// 7 Segment
		output wire [7:0] sseg,
		output wire [7:0] an
   );


	/* SIGNAL declaration */
	wire [9:0] pixel_x, pixel_y;
	wire video_on, pixel_tick;
	wire [7:0] received_y;
	reg [2:0] rgb_reg;
	wire [2:0] rgb_next;
	wire btn_tick;
	wire [15:0] score;
	wire [3:0] lives;

	/* VGA SYNC circuit */
	vga_sync vsync_unit
		(.clk(clk), .reset(reset), .hsync(Hsync), .vsync(Vsync),
		 .video_on(video_on), .p_tick(pixel_tick),
		 .pixel_x(pixel_x), .pixel_y(pixel_y));	 
	
	/* DEBOUNCE unit */
	debounce debounce_module (.clk(clk), .reset(reset), .sw(shoot_button), .db_level(), .db_tick(btn_tick));
	
	/* ACCELEROMETER unit */
	accelerometer_test accelerometer_unit (.clk(clk), .reset(reset), .int1(int1), .MISO(MISO), .SS(SS), .SCLK(SCLK), .MOSI(MOSI), .int2(int2), .received_y(received_y));
	
	/* GRAPHIC generator */ 
	semi_graph semi_graph_unit
		(.clk(clk), .reset(reset), .video_on(video_on), .received_y(received_y), .pix_x(pixel_x), .pix_y(pixel_y), .shoot_button(btn_tick), .pause_switch(pause_switch), .lives(lives), .score(score), .graph_rgb(rgb_next));	
	
	/* SCORE display */
	disp_hex_mux display_module (.clk(clk), .reset(reset), .hex7(4'b0000), .hex6(4'b0000), .hex5(4'b0000), .hex4(lives), .hex3(score[15:12]), .hex2(score[11:8]), .hex1(score[7:4]), .hex0(score[3:0]), .dp_in(8'b00000000), .an(an), .sseg(sseg));
	
	/* RGB buffer */
	always @(posedge clk)
		if (pixel_tick)
			rgb_reg <= rgb_next;
   
	
	/* OUTPUT (extends RGB to 4 bit value) */
	assign vgaRed = (video_on) ? { 4{rgb_reg[2]} } : 4'b0;
	assign vgaGreen = (video_on) ? { 4{rgb_reg[1]} } : 4'b0;
	assign vgaBlue = (video_on) ? { 4{rgb_reg[0]} } : 4'b0;

endmodule
