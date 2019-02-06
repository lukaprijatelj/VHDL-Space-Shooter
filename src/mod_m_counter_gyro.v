module mod_m_counter_gyro
   #(
    parameter N=4, // število bitov števca
              M=10 // modul štetja M
   )
   (
    input wire clk, reset,
    output wire max_tick,
    output wire [N-1:0] q
   );
	
	reg [N-1:0] r_reg;
	reg [N-1:0] r_next;
	
	reg p;
	
	always @*
	begin
		if(r_reg != (M*2 - 1))
			begin
				r_next = r_reg + 1'b1;
			end
		else
			begin
				r_next = 0;
			end
		
		if(r_reg < M)
			p = 1'b0;
		else
			p = 1'b1;
	end
	
	
	always @(posedge clk, posedge reset)
      if (reset)
         r_reg <= 0;
      else
         r_reg <= r_next;
	assign q = r_reg;
	
	assign max_tick = p;
	

	
	
	
	
	
endmodule 