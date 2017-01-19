module user
   #(
    parameter MIN_X = 0, MAX_X = 0, MIN_Y = 0, MAX_Y = 0, BOX_WIDTH = 0, BOX_HEIGHT = 0   // Display bounds
   )
   (
    input wire clk, reset,
	 input wire stop,
	 input wire [9:0] pix_x, pix_y,
	 input wire [7:0] received_y,
	 input wire move_bullet,
	 input wire shoot_button,
	 input wire killed,
	 input wire [5:0] bullet_hit,
    output reg [2:0] graph_rgb,
	 output wire [9:0] user_x_pos, user_y_pos,
	 output wire [9:0] bullet_x_pos0,
	 output wire [9:0] bullet_x_pos1,
	 output wire [9:0] bullet_x_pos2,
	 output wire [9:0] bullet_x_pos3,
	 output wire [9:0] bullet_x_pos4,
	 output wire [9:0] bullet_x_pos5,
	 output wire [9:0] bullet_y_pos0,
	 output wire [9:0] bullet_y_pos1,
	 output wire [9:0] bullet_y_pos2,
	 output wire [9:0] bullet_y_pos3,
	 output wire [9:0] bullet_y_pos4,
	 output wire [9:0] bullet_y_pos5
   );
	
	/* STATES */
	reg [2:0] state_reg = none, state_next;
   localparam  [2:0]
               none  = 3'b000,
               pressed = 3'b001,
               rewrite = 3'b010;
	
	/* SET user X,Y position */
   reg [9:0] USER_Y_POS = 400;
	reg [9:0] USER_X_POS = 310, USER_X_POS_reg;
	assign user_x_pos = USER_X_POS;
	assign user_y_pos = USER_Y_POS;
	
	/* BULLET X,Y position */
	reg [5:0] active_bullets = 0;
	reg [5:0] active_bullets_reg = 0;
	reg [9:0] BULLET_X_POS [5:0];
	reg [9:0] BULLET_Y_POS [5:0];
	reg [9:0] BULLET_X_POS_reg [5:0];
	reg [9:0] BULLET_Y_POS_reg [5:0];
	assign bullet_x_pos0 = BULLET_X_POS[0];
	assign bullet_x_pos1 = BULLET_X_POS[1];
	assign bullet_x_pos2 = BULLET_X_POS[2];
	assign bullet_x_pos3 = BULLET_X_POS[3];
	assign bullet_x_pos4 = BULLET_X_POS[4];
	assign bullet_x_pos5 = BULLET_X_POS[5];
	assign bullet_y_pos0 = BULLET_Y_POS[0];
	assign bullet_y_pos1 = BULLET_Y_POS[1];
	assign bullet_y_pos2 = BULLET_Y_POS[2];
	assign bullet_y_pos3 = BULLET_Y_POS[3];
	assign bullet_y_pos4 = BULLET_Y_POS[4];
	assign bullet_y_pos5 = BULLET_Y_POS[5];
	
	/* ROM objects */
	wire [9:0] pix_x_user, pix_y_user;
	wire bit_on_data;
		assign bit_on_data = objects_data[pix_x_user];
		assign pix_y_user =  pix_y - USER_Y_POS;
		assign pix_x_user = USER_X_POS - pix_x;
	wire [9:0] pix_x_bullet0, pix_y_bullet0;
	wire bit_on_data0;
		assign bit_on_data0 = objects_data1[pix_x_bullet0];
		assign pix_y_bullet0 =  pix_y - BULLET_Y_POS[0] + 8'h40;
		assign pix_x_bullet0 = BULLET_X_POS[0] - pix_x;
	wire [9:0] pix_x_bullet1, pix_y_bullet1;
	wire bit_on_data1;
		assign bit_on_data1 = objects_data2[pix_x_bullet1];
		assign pix_y_bullet1 =  pix_y - BULLET_Y_POS[1] + 8'h40;
		assign pix_x_bullet1 = BULLET_X_POS[1] - pix_x;
	wire [9:0] pix_x_bullet2, pix_y_bullet2;
	wire bit_on_data2;
		assign bit_on_data2 = objects_data3[pix_x_bullet2];
		assign pix_y_bullet2 =  pix_y - BULLET_Y_POS[2] + 8'h40;
		assign pix_x_bullet2 = BULLET_X_POS[2] - pix_x;
	wire [9:0] pix_x_bullet3, pix_y_bullet3;
	wire bit_on_data3;
		assign bit_on_data3 = objects_data4[pix_x_bullet3];
		assign pix_y_bullet3 =  pix_y - BULLET_Y_POS[3] + 8'h40;
		assign pix_x_bullet3 = BULLET_X_POS[3] - pix_x;
	wire [9:0] pix_x_bullet4, pix_y_bullet4;
	wire bit_on_data4;
		assign bit_on_data4 = objects_data5[pix_x_bullet4];
		assign pix_y_bullet4 =  pix_y - BULLET_Y_POS[4] + 8'h40;
		assign pix_x_bullet4 = BULLET_X_POS[4] - pix_x;
	wire [9:0] pix_x_bullet5, pix_y_bullet5;
	wire bit_on_data5;
		assign bit_on_data5 = objects_data6[pix_x_bullet5];
		assign pix_y_bullet5 =  pix_y - BULLET_Y_POS[5] + 8'h40;
		assign pix_x_bullet5 = BULLET_X_POS[5] - pix_x;
	
	/* INITIALIZE ROM modules */
	wire [31:0] objects_data, objects_data1, objects_data2, objects_data3, objects_data4, objects_data5, objects_data6;
	objects_rom objects (.clk(clk), .addr(pix_y_user[7:0]), .data(objects_data));
	objects_rom objects0 (.clk(clk), .addr(pix_y_bullet0[7:0]), .data(objects_data1));
	objects_rom objects1 (.clk(clk), .addr(pix_y_bullet1[7:0]), .data(objects_data2));
	objects_rom objects2 (.clk(clk), .addr(pix_y_bullet2[7:0]), .data(objects_data3));
	objects_rom objects3 (.clk(clk), .addr(pix_y_bullet3[7:0]), .data(objects_data4));
	objects_rom objects4 (.clk(clk), .addr(pix_y_bullet4[7:0]), .data(objects_data5));
	objects_rom objects5 (.clk(clk), .addr(pix_y_bullet5[7:0]), .data(objects_data6));
	
	/* PRESCALER for user object (used to slow down left/right movement) */
	wire tick;
	reg [7:0] tmp_received_y = 0;
	mod_m_counter #(.N(30), .M(2000000)) first_prescaler (.clk(clk), .reset(reset), .max_tick(tick));
	
	
	/* CLOCK and RESET */
	always @(posedge clk, posedge reset)
   begin
		if(reset)
			begin
				USER_X_POS <= 310;
				tmp_received_y <= received_y;
				state_reg <= none;
			end
		else
			begin
				active_bullets <= active_bullets_reg;
				BULLET_Y_POS[0] <= BULLET_Y_POS_reg[0];
				BULLET_Y_POS[1] <= BULLET_Y_POS_reg[1];
				BULLET_Y_POS[2] <= BULLET_Y_POS_reg[2];
				BULLET_Y_POS[3] <= BULLET_Y_POS_reg[3];
				BULLET_Y_POS[4] <= BULLET_Y_POS_reg[4];
				BULLET_Y_POS[5] <= BULLET_Y_POS_reg[5];
				BULLET_X_POS[0] <= BULLET_X_POS_reg[0];
				BULLET_X_POS[1] <= BULLET_X_POS_reg[1];
				BULLET_X_POS[2] <= BULLET_X_POS_reg[2];
				BULLET_X_POS[3] <= BULLET_X_POS_reg[3];
				BULLET_X_POS[4] <= BULLET_X_POS_reg[4];
				BULLET_X_POS[5] <= BULLET_X_POS_reg[5];
				
				if(tick == 1'b1)
					begin
						USER_X_POS <= USER_X_POS_reg;
						tmp_received_y <= received_y;  // Makes sure that accelerometer data hasn't changed since data was last received
					end
				else if(killed == 1'b1)
					USER_X_POS <= USER_X_POS_reg;
				
				if(state_next == rewrite)
					state_reg <= none;
				else
					state_reg <= state_next;
			end
	end
	
	
	/* RGB calculations */
	always @*
	begin
		/* DEFAULTS */
		USER_X_POS_reg = USER_X_POS;
		state_next = state_reg;
		active_bullets_reg = active_bullets;
		BULLET_Y_POS_reg[0] = BULLET_Y_POS[0];
		BULLET_Y_POS_reg[1] = BULLET_Y_POS[1];
		BULLET_Y_POS_reg[2] = BULLET_Y_POS[2];
		BULLET_Y_POS_reg[3] = BULLET_Y_POS[3];
		BULLET_Y_POS_reg[4] = BULLET_Y_POS[4];
		BULLET_Y_POS_reg[5] = BULLET_Y_POS[5];
		BULLET_X_POS_reg[0] = BULLET_X_POS[0];
		BULLET_X_POS_reg[1] = BULLET_X_POS[1];
		BULLET_X_POS_reg[2] = BULLET_X_POS[2];
		BULLET_X_POS_reg[3] = BULLET_X_POS[3];
		BULLET_X_POS_reg[4] = BULLET_X_POS[4];
		BULLET_X_POS_reg[5] = BULLET_X_POS[5];
		graph_rgb = 3'b000;
		
		
		if(stop == 1'b0)
			begin
				/* User view check */
				if(tmp_received_y > 128 && (USER_X_POS + BOX_WIDTH + (5'b11111 - tmp_received_y[6:2])) < MAX_X)		// Check if user can go right
					USER_X_POS_reg = USER_X_POS + (5'b11111 - tmp_received_y[6:2]);
				else if(tmp_received_y < 128 && USER_X_POS > (MIN_X + tmp_received_y[6:2]))		// Check if user can go left
					USER_X_POS_reg = USER_X_POS - {5'b00000,tmp_received_y[6:2]};
					
				/* Shoot button pressed */
				if(shoot_button)
					begin
						state_next = pressed;
					end
				
				/* Enable bullet */
				if(state_reg == pressed)
					begin
						if(active_bullets[0] == 1'b0)
							begin
								BULLET_Y_POS_reg[0] = 393;
								active_bullets_reg[0] = 1'b1;
								BULLET_X_POS_reg[0] = USER_X_POS;
							end
						else if(active_bullets[1] == 1'b0)
							begin
								BULLET_Y_POS_reg[1] = 393;
								active_bullets_reg[1] = 1'b1;
								BULLET_X_POS_reg[1] = USER_X_POS;
							end
						else if(active_bullets[2] == 1'b0)
							begin
								BULLET_Y_POS_reg[2] = 393;
								active_bullets_reg[2] = 1'b1;
								BULLET_X_POS_reg[2] = USER_X_POS;
							end
						else if(active_bullets[3] == 1'b0)
							begin
								BULLET_Y_POS_reg[3] = 393;
								active_bullets_reg[3] = 1'b1;
								BULLET_X_POS_reg[3] = USER_X_POS;
							end
						else if(active_bullets[4] == 1'b0)
							begin
								BULLET_Y_POS_reg[4] = 393;
								active_bullets_reg[4] = 1'b1;
								BULLET_X_POS_reg[4] = USER_X_POS;
							end
						else if(active_bullets[5] == 1'b0)
							begin
								BULLET_Y_POS_reg[5] = 393;
								active_bullets_reg[5] = 1'b1;
								BULLET_X_POS_reg[5] = USER_X_POS;
							end
						state_next = rewrite;
					end
				/* BULLET view check */
				else if(move_bullet == 1'b1)
					begin
						if(active_bullets[0] == 1'b1 && BULLET_Y_POS[0] > 1)
							BULLET_Y_POS_reg[0] = BULLET_Y_POS[0] - 1'b1;
						else if(active_bullets[0] == 1'b0 || bullet_hit[0] == 1'b1 || BULLET_Y_POS[0] < 2)
							begin
								BULLET_Y_POS_reg[0] = 1000;
								active_bullets_reg[0] = 1'b0;
							end
							
						if(active_bullets[1] == 1'b1 && BULLET_Y_POS[1] > 1)
							BULLET_Y_POS_reg[1] = BULLET_Y_POS[1] - 1'b1;
						else if(active_bullets[1] == 1'b0 || bullet_hit[1] == 1'b1 || BULLET_Y_POS[1] < 2)
							begin
								BULLET_Y_POS_reg[1] = 1000;
								active_bullets_reg[1] = 1'b0;
							end
							
						if(active_bullets[2] == 1'b1 && BULLET_Y_POS[2] > 1)
							BULLET_Y_POS_reg[2] = BULLET_Y_POS[2] - 1'b1;
						else if(active_bullets[2] == 1'b0 || bullet_hit[2] == 1'b1 || BULLET_Y_POS[2] < 2)
							begin
								BULLET_Y_POS_reg[2] = 1000;
								active_bullets_reg[2] = 1'b0;
							end
							
						if(active_bullets[3] == 1'b1 && BULLET_Y_POS[3] > 1)
							BULLET_Y_POS_reg[3] = BULLET_Y_POS[3] - 1'b1;
						else if(active_bullets[3] == 1'b0 || bullet_hit[3] == 1'b1 || BULLET_Y_POS[3] < 2)
							begin
								BULLET_Y_POS_reg[3] = 1000;
								active_bullets_reg[3] = 1'b0;
							end
							
						if(active_bullets[4] == 1'b1 && BULLET_Y_POS[4] > 1)
							BULLET_Y_POS_reg[4] = BULLET_Y_POS[4] - 1'b1;
						else if(active_bullets[4] == 1'b0 || bullet_hit[4] == 1'b1 || BULLET_Y_POS[4] < 2)
							begin
								BULLET_Y_POS_reg[4] = 1000;
								active_bullets_reg[4] = 1'b0;
							end
							
						if(active_bullets[5] == 1'b1 && BULLET_Y_POS[5] > 1)
							BULLET_Y_POS_reg[5] = BULLET_Y_POS[5] - 1'b1;
						else if(active_bullets[5] == 1'b0 || bullet_hit[5] == 1'b1 || BULLET_Y_POS[5] < 2)
							begin
								BULLET_Y_POS_reg[5] = 1000;
								active_bullets_reg[5] = 1'b0;
							end
					end	
					
					/* Reset user */
					if(killed == 1'b1)
						begin
							USER_X_POS_reg = 310;
						end
			end
		
		/* User RGB setter */
		if(pix_x > USER_X_POS && pix_x < (USER_X_POS + BOX_WIDTH) && pix_y > USER_Y_POS && pix_y < (USER_Y_POS + BOX_HEIGHT))
			graph_rgb = {1'b0, bit_on_data, 1'b0};
		
		/* Bullets RGB setters */
		if(pix_x > BULLET_X_POS[0] && pix_x < (BULLET_X_POS[0] + BOX_WIDTH) && pix_y > BULLET_Y_POS[0] && pix_y < (BULLET_Y_POS[0] + 3'h7))
			graph_rgb = {bit_on_data0, bit_on_data0, 1'b0};
		if(pix_x > BULLET_X_POS[1] && pix_x < (BULLET_X_POS[1] + BOX_WIDTH) && pix_y > BULLET_Y_POS[1] && pix_y < (BULLET_Y_POS[1] + 3'h7))
			graph_rgb = {bit_on_data1, bit_on_data1, 1'b0};
		if(pix_x > BULLET_X_POS[2] && pix_x < (BULLET_X_POS[2] + BOX_WIDTH) && pix_y > BULLET_Y_POS[2] && pix_y < (BULLET_Y_POS[2] + 3'h7))
			graph_rgb = {bit_on_data2, bit_on_data2, 1'b0};
		if(pix_x > BULLET_X_POS[3] && pix_x < (BULLET_X_POS[3] + BOX_WIDTH) && pix_y > BULLET_Y_POS[3] && pix_y < (BULLET_Y_POS[3] + 3'h7))
			graph_rgb = {bit_on_data3, bit_on_data3, 1'b0};
		if(pix_x > BULLET_X_POS[4] && pix_x < (BULLET_X_POS[4] + BOX_WIDTH) && pix_y > BULLET_Y_POS[4] && pix_y < (BULLET_Y_POS[4] + 3'h7))
			graph_rgb = {bit_on_data4, bit_on_data4, 1'b0};
		if(pix_x > BULLET_X_POS[5] && pix_x < (BULLET_X_POS[5] + BOX_WIDTH) && pix_y > BULLET_Y_POS[5] && pix_y < (BULLET_Y_POS[5] + 3'h7))
			graph_rgb = {bit_on_data5, bit_on_data5, 1'b0};
	end
endmodule 