module mod_m_counter
   #(
    parameter N=4, // število bitov števca
              M=10 // modul štetja M
   )
   (
    input wire clk, reset,
    output wire max_tick,
    output wire [N-1:0] q
   );
	
	reg [N-1:0] r_reg = 0;
	reg [N-1:0] r_next = 0;
	
	reg p;
	
	always @*
	begin
		if(r_reg != (M - 1))
		begin
			r_next = r_reg + 1'b1;
			p= 1'b0;
		end
		else
		begin
			r_next = 0;
			p = 1'b1;
		end
	end
	
	
	always @(posedge clk, posedge reset)
      if (reset)
         r_reg <= 0;
      else
         r_reg <= r_next;
	assign q = r_reg;
	
	assign max_tick = p;
	

	
	
	
	
	
endmodule 