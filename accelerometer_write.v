module accelerometer_write
   (
	 input wire clk,
	 input wire reset,
	 input wire ready,
	 input wire [7:0] address,
	 input wire [7:0] data,
    input wire MISO, 
	 output wire SS,
	 output wire MOSI,
	 output wire write_finished
   );
	
	// symbolic state declaration
	reg [2:0] state_reg, state_next;
   localparam  [2:0]
					ready_state = 3'b000,
               send_instruction = 3'b001,
               send_address = 3'b010,
					send_data = 3'b011,
					sleep = 3'b100;
	
	/* Instruction type WRITE */
	localparam write_mosi = 8'b00001010;  // 0x0B
	
	/* SEND out of Processor */
	reg mosi_reg, write_finish_reg = 0;
	assign MOSI = mosi_reg;
	assign SS = (state_reg == sleep || state_reg == ready_state) ? 1 : 0;
	assign write_finished = write_finish_reg;
	
	/* LOCAL variables */
	reg [4:0] index_reg = 7, index_next;
	
	
	
	/* CLOCK and RESET */
	always @(posedge clk, posedge reset)
	begin
		if(reset)
			begin
				state_reg <= ready_state;
				index_reg <= 7;
			end
		else
			begin
				state_reg <= state_next;
				index_reg <= index_next;
			end
	end
	
	
	
	/* MAIN logic */
	always @*
	begin
		state_next = state_reg;
		index_next = index_reg;
		write_finish_reg = 0;
		
		case(state_reg)
			ready_state:
				begin
					if(ready)
						state_next = send_instruction;
				end
			send_instruction:
				begin
					if(index_reg > 0)
						index_next = index_reg - 1'b1;
					else
						begin
							index_next = 7;
							state_next = send_address;
						end
		
					/* Sends the WRITE instruction */
					mosi_reg = write_mosi[index_reg];
				end
			send_address:
				begin
					if(index_reg > 0)
						index_next = index_reg - 1'b1;
					else
						begin
							index_next = 7;
							state_next = send_data;
						end
						
					/* SEND address to write on */
					mosi_reg = address[index_reg];
				end
			send_data:
				begin
					if(index_reg > 0)
						index_next = index_reg - 1'b1;
					else
						begin
							index_next = 7;
							state_next = sleep;
						end
					
					/* SEND data */
					mosi_reg = data[index_reg];
				end
			sleep:
				begin
					mosi_reg = 0;
					write_finish_reg = 1'b1;
				end
		endcase
	end

	
endmodule
