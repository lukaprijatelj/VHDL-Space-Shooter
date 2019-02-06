module enemy
   #(
    parameter MIN_X = 0, MAX_X = 0, MIN_Y = 0, MAX_Y = 0, BOX_WIDTH = 0, BOX_HEIGHT = 0, RANDOM = 0   // Display bounds
   )
   (
    input wire clk, reset,
	 input wire stop,
	 input wire [9:0] pix_x, pix_y,
	 input wire [9:0] random_number_x,
	 input wire move_down,
	 input wire killed,
	 input wire move_bullet,
	 input wire shoot,
	 input wire bullet_hit,
    output reg [2:0] graph_rgb,
	 output wire [9:0] enemy_x_pos, enemy_y_pos,
	 output wire [9:0] bullet_x_pos,
	 output wire [9:0] bullet_y_pos
   );
	
	/* STATES */
	reg [2:0] state_reg = none, state_next;
   localparam  [2:0]
               none  = 3'b000,
               pressed = 3'b001,
               rewrite = 3'b010;
	
	/* SET enemy X,Y positions */
   reg [9:0] ENEMY_Y_POS = 0, ENEMY_Y_POS_reg;
	reg [9:0] ENEMY_X_POS = RANDOM, ENEMY_X_POS_reg;
	assign enemy_x_pos = ENEMY_X_POS;
	assign enemy_y_pos = ENEMY_Y_POS;
	
	/* ROM objects */
	wire [9:0] pix_x_enemy, pix_y_enemy;
	wire bit_on_data;
		assign bit_on_data = objects_data[pix_x_enemy];
		assign pix_y_enemy = (pix_y - ENEMY_Y_POS) + 8'h20;
		assign pix_x_enemy = ENEMY_X_POS - pix_x;
	wire [9:0] pix_x_bullet0, pix_y_bullet0;
	wire bit_on_data0;
		assign bit_on_data0 = objects_data1[pix_x_bullet0];
		assign pix_y_bullet0 =  pix_y - BULLET_Y_POS + 8'h40;
		assign pix_x_bullet0 = BULLET_X_POS - pix_x;
	
	/* INITIALIZE ROM modules */
	wire [31:0] objects_data, objects_data1;
	objects_rom objects (.clk(clk), .addr(pix_y_enemy[7:0]), .data(objects_data));
	objects_rom objects1 (.clk(clk), .addr(pix_y_bullet0[7:0]), .data(objects_data1));
	
	/* BULLET X,Y position */
	reg [9:0] BULLET_X_POS, BULLET_X_POS_reg;
	reg [9:0] BULLET_Y_POS, BULLET_Y_POS_reg;
	reg bullet_active = 0, bullet_active_reg;
	assign bullet_x_pos = BULLET_X_POS;
	assign bullet_y_pos = BULLET_Y_POS;
	
	
	/* CLOCK and RESET */
	always @(posedge clk, posedge reset)
   begin
		if(reset)
			begin
				ENEMY_X_POS <= random_number_x;
				ENEMY_Y_POS <= 0;
				state_reg <= none;
			end
		else
			begin
				ENEMY_Y_POS <= ENEMY_Y_POS_reg;
				ENEMY_X_POS <= ENEMY_X_POS_reg;
			
				if(killed == 1'b1)
					begin
						ENEMY_Y_POS <= 0;
						ENEMY_X_POS <= random_number_x;
					end
					
				if(state_next == rewrite)
					state_reg <= none;
				else
					state_reg <= state_next;
					
				BULLET_X_POS <= BULLET_X_POS_reg;
				BULLET_Y_POS <= BULLET_Y_POS_reg;
				bullet_active <= bullet_active_reg;
			end
	end

	
	/* RGB calculations */
	always @*
	begin
		state_next = state_reg;
		ENEMY_Y_POS_reg = ENEMY_Y_POS;
		ENEMY_X_POS_reg = ENEMY_X_POS;
		BULLET_X_POS_reg = BULLET_X_POS;
		BULLET_Y_POS_reg = BULLET_Y_POS;
		bullet_active_reg = bullet_active;
		graph_rgb = 3'b000;
		
		if(stop == 1'b0)
			begin
				if(move_down)
					ENEMY_Y_POS_reg = ENEMY_Y_POS + 1'b1;
			
				/* Shoot active */
				if(shoot)
					begin
						state_next = pressed;
					end
				
				/* Bullet view check */
				if(move_bullet == 1'b1)
					begin
						if(bullet_active == 1'b1 && BULLET_Y_POS < 1020)
							BULLET_Y_POS_reg = BULLET_Y_POS + 1'b1;
						else if(bullet_active == 1'b0 || bullet_hit == 1'b1 || BULLET_Y_POS > 1018)
							begin
								BULLET_Y_POS_reg = 1000;
								bullet_active_reg = 1'b0;
							end
					end
				
				/* Enable bullet */
				if(state_reg == pressed)
					begin
						if(bullet_active == 1'b0)
							begin
								BULLET_Y_POS_reg = ENEMY_Y_POS + BOX_HEIGHT;
								bullet_active_reg = 1'b1;
								BULLET_X_POS_reg = ENEMY_X_POS;
							end
						state_next = rewrite;
					end
				
				/* Reuse enemy object */
				if(ENEMY_Y_POS == MAX_Y)
					begin
						ENEMY_Y_POS_reg = 0;
						ENEMY_X_POS_reg = random_number_x;
					end			
			end
			
		/* Enemy RGB setter */
		if(pix_x > ENEMY_X_POS && pix_x < (ENEMY_X_POS + BOX_WIDTH) && pix_y > ENEMY_Y_POS && pix_y < (ENEMY_Y_POS + BOX_HEIGHT))
			graph_rgb = {bit_on_data, 1'b0, 1'b0};
		/* Bullet RGB setter */
		if(pix_x > BULLET_X_POS && pix_x < (BULLET_X_POS + BOX_WIDTH) && pix_y > BULLET_Y_POS && pix_y < (BULLET_Y_POS + 3'h7))
			graph_rgb = {bit_on_data0, bit_on_data0, 1'b0};
	end
endmodule 