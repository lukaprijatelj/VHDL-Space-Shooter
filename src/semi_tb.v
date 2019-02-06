// The `timescale directive specifies that
// the simulation time unit is 1 ns and
// the simulation timestep is 10 ps
`timescale 1 ns/10 ps
module semi_testbench #(
		parameter W = 32
	);
	
	reg clk; 
	reg reset;

	reg MISO; 
	reg int1;
	wire SS;
	wire SCLK;
	wire MOSI;
	reg int2;
	wire bite;
	wire [9:0] pix_x_user, pix_y_user;
		
		// TEST
		 wire [7:0] led;
		 wire ready_button;
		 wire [31:0] data_out;
		
		// VGA
		 wire Hsync, Vsync;
		 wire [3:0] vgaRed, vgaGreen, vgaBlue;
	
	localparam T=20; // perioda ure
		
	// Vzpostavitev Unit Under Test (UUT)
	semi_display uut (
		.clk(clk),
		.reset(reset),
		.int1(int1),
		.MISO(MISO),
		.SS(SS),
		.SCLK(SCLK),
		.MOSI(MOSI),
		.int2(int2),
		.led(led),
		.ready_button(ready_button),
		.bite(bite),
		.Hsync(Hsync),
		.Vsync(Vsync),
		.vgaRed(vgaRed),
		.vgaGreen(vgaGreen),
		.vgaBlue(vgaBlue)
	);

	initial
		begin
			reset = 1'b1;
			#(T/2);
			reset = 1'b0;
		end
	
	always
		begin
			clk = 1'b1;
			#(T/2);
			clk = 1'b0;
			#(T/2);
		end
		
	initial
		begin
			
			
			
			
			
			
			
			
			
			// ==== absolute delay ====
			#(4000000*T); // wait for 80 ns
			#(40000000*T);
			#(40000000*T);
			#(40000000*T);
			// ==== stop simulation ====
			// return to interactive simulation mode
		$stop;
	end
endmodule
