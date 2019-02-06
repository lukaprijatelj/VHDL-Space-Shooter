module random_generator
   (
	 input wire clk,
	 input wire [9:0] time_number,
	 output wire [9:0] random0,
	 output wire [9:0] random1,
	 output wire [9:0] random2,
	 output wire [9:0] random3,
	 output wire [9:0] random4,
	 output wire [9:0] random5
   );
	
	/* REG declarations */
	reg [9:0] random0_reg = 0, random1_reg = 0, random2_reg = 0, random3_reg = 0, random4_reg = 0, random5_reg = 0;
	reg [9:0] random0_next, random1_next, random2_next, random3_next, random4_next, random5_next;
	
	/* Wire assigns */
	assign random0 = random0_reg;
	assign random1 = random1_reg;
	assign random2 = random2_reg;
	assign random3 = random3_reg;
	assign random4 = random4_reg;
	assign random5 = random5_reg;
	
	always @(posedge clk)
	begin
			random0_reg <= random0_next + 64;
			random1_reg <= random1_next + 64;
			random2_reg <= random2_next + 64;
			random3_reg <= random3_next + 64;
			random4_reg <= random4_next + 64;
			random5_reg <= random5_next + 64;
	end
	
	always @*
	begin
		/* Random numbers based on time number */
		random0_next = {1'b0, time_number[7] | time_number[2], time_number[6], time_number[9], time_number[5] | time_number[1],
								time_number[1], time_number[8] | time_number[7], time_number[7] | time_number[1], time_number[0] | time_number[1], time_number[2] | time_number[3]};
		
		random1_next = {1'b0, time_number[1] | time_number[7], time_number[0], time_number[5], time_number[2] | time_number[3],
								time_number[3], time_number[0] | time_number[3], time_number[1] | time_number[7], time_number[5] | time_number[4], time_number[6] | time_number[7]};
		
		random2_next = {1'b0, time_number[8] | time_number[7], time_number[7], time_number[8], time_number[7] | time_number[3],
								time_number[6], time_number[3] | time_number[8], time_number[4] | time_number[1], time_number[4] | time_number[0], time_number[2] | time_number[1]};
		
		random3_next = {1'b0, time_number[2] | time_number[5], time_number[5], time_number[3], time_number[1] | time_number[2],
								time_number[0], time_number[4] | time_number[6], time_number[3] | time_number[2], time_number[9] | time_number[3], time_number[1] | time_number[4]};
		
		random4_next = {1'b0, time_number[3] | time_number[4], time_number[4], time_number[2], time_number[3] | time_number[4],
								time_number[1], time_number[5] | time_number[5], time_number[4] | time_number[3], time_number[5] | time_number[2], time_number[5] | time_number[0]};
		
		random5_next = {1'b0, time_number[2] | time_number[1], time_number[0], time_number[9], time_number[8] | time_number[7],
								time_number[6], time_number[5] | time_number[4], time_number[3] | time_number[2], time_number[1] | time_number[0], time_number[9] | time_number[8]};
	end
endmodule 