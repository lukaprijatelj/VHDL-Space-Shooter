module accelerometer_read
   (
	 input wire clk,
	 input wire reset,
	 input wire ready,  
    input wire MISO, 
	 output wire SS,
	 output wire MOSI,
	 output wire int1_interrupt,
	 output wire [7:0] received_y
   );
	
	/* symbolic state declaration */
	reg [2:0] state_reg, state_next;
   localparam  [2:0]
               sleep  = 3'b000,
               interrupt_received = 3'b001,
               send_instruction = 3'b010,
               send_address = 3'b011,
					receive_data = 3'b100;
	
	/* Instruction type READ */
	localparam read_mosi = 8'b00001011;  // 0x0A
	
	/* Addresses */
	localparam y_axis = 8'h09;  // 0x09
	
	/* SEND out of Processor */
	reg mosi_reg;
	assign MOSI = mosi_reg;
	assign SS = (state_reg == sleep || state_reg == interrupt_received) ? 1 : 0;
	
	/* Receive data registers */
	reg [7:0] received_y_reg, received_y_next;
	assign received_y = received_y_reg;
	
	/* LOCAL variables */
	reg [4:0] index_reg = 7, index_next;
	reg rewrite_helper = 0;
	assign int1_interrupt = (state_reg == sleep) ? 1'b0 : 1'b1;
	
	/* CLOCK and RESET */
	always @(posedge clk, posedge reset)
	begin
		if(reset)
			begin
				state_reg <= sleep;
				received_y_reg <= 0;
				index_reg <= 7;
			end
		else
			begin
				state_reg <= state_next;
				index_reg <= index_next;
				
				if(rewrite_helper)
					begin
						received_y_reg <= received_y_next;
					end
			end
	end
	

	/* MAIN logic */
	always @*
	begin
		state_next = state_reg;
		index_next = index_reg;
		rewrite_helper = 0;

		case(state_reg)
			sleep:
				begin
					if(ready)
						state_next = interrupt_received;
					
					mosi_reg = 0;
				end
			interrupt_received:
				begin
					index_next = 7;
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
		
					/* Sends the READ instruction */
					mosi_reg = read_mosi[index_reg];
				end
			send_address:
				begin
					if(index_reg > 0)
						index_next = index_reg - 1'b1;
					else
						begin
							index_next = 7;
							state_next = receive_data;
						end

					/* SENDS the y-axis address */
					mosi_reg = y_axis[index_reg];
				end
			receive_data:
				begin
					if(index_reg > 0)
						index_next = index_reg - 1'b1;
					else
						begin
							index_next = 7;
							rewrite_helper = 1'b1;
							state_next = sleep;
						end
					
					/* RECEIVE DATA */
					received_y_next[index_reg] = MISO;
				end
		endcase
	end
endmodule
