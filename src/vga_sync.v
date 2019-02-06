module vga_sync
   (
    input wire clk, reset,
    output wire hsync, vsync, video_on, p_tick,
    output wire [9:0] pixel_x, pixel_y
   );

   // constant declaration
   // VGA 640-by-480 sync parameters
	//	resolution		clk	HD		HD+HF		HD+HF+HR		MOD-H COUNTER	VD		VD+VF		VD+VF+VR		MOD-V COUNTER		POL V		POL H
	//	640x480 @ 60Hz	25.2	640	656	752			800				480	490		492			525  					-vsync  	-hsync
	//	800x600 @ 72Hz 50.0	800	856	976			1040				600	637		643			666					+hsync	+vsync 	**horizontal needs 11 bit (mod-h) counter!
	
   localparam HD = 640; // horizontal display area
   localparam HF = 16 ; // h. front porch
   localparam HB = 48 ; // h. back porch
   localparam HR = 96 ; // h. sync pulse
	
   localparam VD = 480; // vertical display area
   localparam VF = 10;  // v. front porch
   localparam VB = 33;  // v. back porch
   localparam VR = 2;   // v. sync pulse

   //mod-4 counter
   reg [1:0] mod4_reg;
   wire [1:0] mod4_next;

   // sync counters
   reg [9:0] h_count_reg, h_count_next;
   reg [9:0] v_count_reg, v_count_next;
   
	// output buffer
   reg v_sync_reg, h_sync_reg;
   wire v_sync_next, h_sync_next;
   
	// status signal
   wire h_end, v_end, pixel_tick;

   // body
   // registers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
				mod4_reg <= 2'b00;				
            v_count_reg <= 0;
            h_count_reg <= 0;
            v_sync_reg <= 1'b1;
            h_sync_reg <= 1'b1;
         end
      else
         begin            
				mod4_reg <= mod4_next;				
            v_count_reg <= v_count_next;
            h_count_reg <= h_count_next;
            v_sync_reg <= v_sync_next;
            h_sync_reg <= h_sync_next;
         end

	//mod-4 circuit to generate 25 MHz enable tick
	assign mod4_next =  mod4_reg + 2'b01;
	assign pixel_tick = ( mod4_reg == 3 )? 1'b1 : 1'b0;	//assure 50% duty cycle of pixel tick signal

   // status signals
   // end of horizontal counter (800-1)
   assign h_end = (h_count_reg==(HD+HF+HB+HR-1));
   // end of vertical counter (525-1)
   assign v_end = (v_count_reg==(VD+VF+VB+VR-1));

   // next-state logic of mod-800 horizontal sync counter
   always @*
      if (pixel_tick)  // 25 MHz pulse
         if (h_end)
            h_count_next = 0;
         else
            h_count_next = h_count_reg + 1;
      else
         h_count_next = h_count_reg;

   // next-state logic of mod-525 vertical sync counter
   always @*
      if (pixel_tick & h_end)
         if (v_end)
            v_count_next = 0;
         else
            v_count_next = v_count_reg + 1;
      else
         v_count_next = v_count_reg;

   // horizontal and vertical sync, buffered to avoid glitch
   
	// h_sync_next asserted between 656 and 751
   assign h_sync_next = ~(h_count_reg>=(HD+HF) && h_count_reg<=(HD+HF+HR-1));
   
	// vh_sync_next asserted between 490 and 491
   assign v_sync_next = ~(v_count_reg>=(VD+VF) && v_count_reg<=(VD+VF+VR-1));

   // video on/off
   assign video_on = (h_count_reg<HD) && (v_count_reg<VD);

   // output
   assign hsync = h_sync_reg;
   assign vsync = v_sync_reg;
   assign pixel_x = h_count_reg;
   assign pixel_y = v_count_reg;
   assign p_tick = pixel_tick;

endmodule
