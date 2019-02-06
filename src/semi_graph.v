module semi_graph
   (
	 input wire clk, reset,
    input wire video_on,
	 input wire [7:0] received_y,
    input wire [9:0] pix_x, pix_y,
	 input wire shoot_button,
	 input wire pause_switch,
	 output wire [3:0] lives,
	 output wire [15:0] score,
    output reg [2:0] graph_rgb
   );

   /* CONSTANT and SIGNAL declaration */
	localparam MIN_X = 0;
   localparam MAX_X = 640;
	localparam MIN_Y = 0;
   localparam MAX_Y = 480;
   
	/* ROM bounding object */
	localparam BOX_WIDTH = 32;
   localparam BOX_HEIGHT = 32;

	/* STOP signal */
	wire stop;
	assign stop = (lives_reg == 1'b0 || pause_switch == 1'b1) ? 1'b1 : 1'b0;
	
	/* SCORE */
	reg [15:0] score_user = 0, score_user_reg;
	assign score = score_user;
	reg [3:0] lives_reg = 3'b111, lives_next;
	assign lives = lives_reg;
	
	/* BULLET_TIME and MOVE_TIME generator */
	wire move_object, move_bullet;
	wire [29:0] time_number;
	mod_m_counter #(.N(30), .M(700000)) move_time_generator (.clk(clk), .reset(reset), .max_tick(move_object), .q(time_number));
	mod_m_counter #(.N(30), .M(100000)) bullet_time_generator (.clk(clk), .reset(reset), .max_tick(move_bullet));
	
	/* RANDOM number generator (simple) */
	wire [9:0] random0, random1, random2, random3, random4, random5;
	random_generator random_module (.clk(clk), .time_number(time_number[27:18] + random0), .random0(random0), .random1(random1), .random2(random2), .random3(random3), .random4(random4), .random5(random5));
	
	/* USER object */
	wire [9:0] user_x_pos, user_y_pos;
	wire [9:0] bullet_x_pos [5:0];
	wire [9:0] bullet_y_pos [5:0];
	wire [5:0] bullet_hit;
	wire user_killed;
	wire [2:0] graph_rgb_reg1, graph_rgb_reg2, graph_rgb_reg3, graph_rgb_reg4, graph_rgb_reg5, graph_rgb_reg6, graph_rgb_reg7;
	user #(MIN_X, MAX_X, MIN_Y, MAX_Y, BOX_WIDTH, BOX_HEIGHT) user_object (.clk(clk), .reset(reset), .stop(stop), .pix_x(pix_x), .pix_y(pix_y), .received_y(received_y), 
						.move_bullet(move_bullet), .shoot_button(shoot_button), .killed(user_killed), .bullet_hit(bullet_hit), .graph_rgb(graph_rgb_reg1), .user_x_pos(user_x_pos), .user_y_pos(user_y_pos),
						.bullet_x_pos0(bullet_x_pos[0]), .bullet_x_pos1(bullet_x_pos[1]), .bullet_x_pos2(bullet_x_pos[2]), .bullet_x_pos3(bullet_x_pos[3]), .bullet_x_pos4(bullet_x_pos[4]), .bullet_x_pos5(bullet_x_pos[5]),
						.bullet_y_pos0(bullet_y_pos[0]), .bullet_y_pos1(bullet_y_pos[1]), .bullet_y_pos2(bullet_y_pos[2]), .bullet_y_pos3(bullet_y_pos[3]), .bullet_y_pos4(bullet_y_pos[4]), .bullet_y_pos5(bullet_y_pos[5])); 
	
	/* ENEMY objects */
	wire [9:0] enemy_x_pos [5:0];
	wire [9:0] enemy_y_pos [5:0];
	wire [5:0] killed, bullet_enemy_hit;
	wire [9:0] bullet_enemy_x_pos [5:0];
	wire [9:0] bullet_enemy_y_pos [5:0];
	enemy #(MIN_X, MAX_X, MIN_Y, MAX_Y, BOX_WIDTH, BOX_HEIGHT, 80) enemy_object1 (.clk(clk), .reset(reset), .stop(stop), .pix_x(pix_x), .pix_y(pix_y), .random_number_x(random0), 
			.move_down(move_object), .killed(killed[0]), .move_bullet(move_bullet), .shoot(time_number[15]), .bullet_hit(bullet_enemy_hit[0]), .graph_rgb(graph_rgb_reg2), 
			.enemy_x_pos(enemy_x_pos[0]), .enemy_y_pos(enemy_y_pos[0]), .bullet_x_pos(bullet_enemy_x_pos[0]), .bullet_y_pos(bullet_enemy_y_pos[0]));
	enemy #(MIN_X, MAX_X, MIN_Y, MAX_Y, BOX_WIDTH, BOX_HEIGHT, 180) enemy_object2 (.clk(clk), .reset(reset), .stop(stop), .pix_x(pix_x), .pix_y(pix_y), .random_number_x(random1), 
			.move_down(move_object), .killed(killed[1]), .move_bullet(move_bullet), .shoot(time_number[12]), .bullet_hit(bullet_enemy_hit[1]), .graph_rgb(graph_rgb_reg3), 
			.enemy_x_pos(enemy_x_pos[1]), .enemy_y_pos(enemy_y_pos[1]), .bullet_x_pos(bullet_enemy_x_pos[1]), .bullet_y_pos(bullet_enemy_y_pos[1]));
	enemy #(MIN_X, MAX_X, MIN_Y, MAX_Y, BOX_WIDTH, BOX_HEIGHT, 250) enemy_object3 (.clk(clk), .reset(reset), .stop(stop), .pix_x(pix_x), .pix_y(pix_y), .random_number_x(random2), 
			.move_down(move_object), .killed(killed[2]), .move_bullet(move_bullet), .shoot(time_number[13]), .bullet_hit(bullet_enemy_hit[2]), .graph_rgb(graph_rgb_reg4), 
			.enemy_x_pos(enemy_x_pos[2]), .enemy_y_pos(enemy_y_pos[2]), .bullet_x_pos(bullet_enemy_x_pos[2]), .bullet_y_pos(bullet_enemy_y_pos[2]));
	enemy #(MIN_X, MAX_X, MIN_Y, MAX_Y, BOX_WIDTH, BOX_HEIGHT, 380) enemy_object4 (.clk(clk), .reset(reset), .stop(stop), .pix_x(pix_x), .pix_y(pix_y), .random_number_x(random3), 
			.move_down(move_object), .killed(killed[3]), .move_bullet(move_bullet), .shoot(time_number[20]), .bullet_hit(bullet_enemy_hit[3]), .graph_rgb(graph_rgb_reg5), 
			.enemy_x_pos(enemy_x_pos[3]), .enemy_y_pos(enemy_y_pos[3]), .bullet_x_pos(bullet_enemy_x_pos[3]), .bullet_y_pos(bullet_enemy_y_pos[3]));
	enemy #(MIN_X, MAX_X, MIN_Y, MAX_Y, BOX_WIDTH, BOX_HEIGHT, 510) enemy_object5 (.clk(clk), .reset(reset), .stop(stop), .pix_x(pix_x), .pix_y(pix_y), .random_number_x(random4), 
			.move_down(move_object), .killed(killed[4]), .move_bullet(move_bullet), .shoot(time_number[12]), .bullet_hit(bullet_enemy_hit[4]), .graph_rgb(graph_rgb_reg6), 
			.enemy_x_pos(enemy_x_pos[4]), .enemy_y_pos(enemy_y_pos[4]), .bullet_x_pos(bullet_enemy_x_pos[4]), .bullet_y_pos(bullet_enemy_y_pos[4]));
	enemy #(MIN_X, MAX_X, MIN_Y, MAX_Y, BOX_WIDTH, BOX_HEIGHT, 600) enemy_object6 (.clk(clk), .reset(reset), .stop(stop), .pix_x(pix_x), .pix_y(pix_y), .random_number_x(random5), 
			.move_down(move_object), .killed(killed[5]), .move_bullet(move_bullet), .shoot(time_number[17]), .bullet_hit(bullet_enemy_hit[5]), .graph_rgb(graph_rgb_reg7), 
			.enemy_x_pos(enemy_x_pos[5]), .enemy_y_pos(enemy_y_pos[5]), .bullet_x_pos(bullet_enemy_x_pos[5]), .bullet_y_pos(bullet_enemy_y_pos[5]));
	
	
	/* Collision checks */
	assign user_killed = ((bullet_enemy_x_pos[0] + 14) > user_x_pos && (bullet_enemy_x_pos[0] + 18) < (user_x_pos + BOX_WIDTH) && (bullet_enemy_y_pos[0] + 3'h7) > user_y_pos && bullet_enemy_y_pos[0] < MAX_Y ||
									(bullet_enemy_x_pos[1] + 14) > user_x_pos && (bullet_enemy_x_pos[1] + 18) < (user_x_pos + BOX_WIDTH) && (bullet_enemy_y_pos[1] + 3'h7) > user_y_pos && bullet_enemy_y_pos[1] < MAX_Y ||
									(bullet_enemy_x_pos[2] + 14) > user_x_pos && (bullet_enemy_x_pos[2] + 18) < (user_x_pos + BOX_WIDTH) && (bullet_enemy_y_pos[2] + 3'h7) > user_y_pos && bullet_enemy_y_pos[2] < MAX_Y ||
									(bullet_enemy_x_pos[3] + 14) > user_x_pos && (bullet_enemy_x_pos[3] + 18) < (user_x_pos + BOX_WIDTH) && (bullet_enemy_y_pos[3] + 3'h7) > user_y_pos && bullet_enemy_y_pos[3] < MAX_Y ||
									(bullet_enemy_x_pos[4] + 14) > user_x_pos && (bullet_enemy_x_pos[4] + 18) < (user_x_pos + BOX_WIDTH) && (bullet_enemy_y_pos[4] + 3'h7) > user_y_pos && bullet_enemy_y_pos[4] < MAX_Y ||
									(bullet_enemy_x_pos[5] + 14) > user_x_pos && (bullet_enemy_x_pos[5] + 18) < (user_x_pos + BOX_WIDTH) && (bullet_enemy_y_pos[5] + 3'h7) > user_y_pos && bullet_enemy_y_pos[5] < MAX_Y) ? 1'b1 : 1'b0;	
	
	assign bullet_enemy_hit[0] = ((bullet_enemy_x_pos[0] + 14) > user_x_pos && (bullet_enemy_x_pos[0] + 18) < (user_x_pos + BOX_WIDTH) && (bullet_enemy_y_pos[0] + 3'h7) > user_y_pos) ? 1'b1 : 1'b0;	
	assign bullet_enemy_hit[1] = ((bullet_enemy_x_pos[1] + 14) > user_x_pos && (bullet_enemy_x_pos[1] + 18) < (user_x_pos + BOX_WIDTH) && (bullet_enemy_y_pos[1] + 3'h7) > user_y_pos) ? 1'b1 : 1'b0;	
	assign bullet_enemy_hit[2] = ((bullet_enemy_x_pos[2] + 14) > user_x_pos && (bullet_enemy_x_pos[2] + 18) < (user_x_pos + BOX_WIDTH) && (bullet_enemy_y_pos[2] + 3'h7) > user_y_pos) ? 1'b1 : 1'b0;	
	assign bullet_enemy_hit[3] = ((bullet_enemy_x_pos[3] + 14) > user_x_pos && (bullet_enemy_x_pos[3] + 18) < (user_x_pos + BOX_WIDTH) && (bullet_enemy_y_pos[3] + 3'h7) > user_y_pos) ? 1'b1 : 1'b0;	
	assign bullet_enemy_hit[4] = ((bullet_enemy_x_pos[4] + 14) > user_x_pos && (bullet_enemy_x_pos[4] + 18) < (user_x_pos + BOX_WIDTH) && (bullet_enemy_y_pos[4] + 3'h7) > user_y_pos) ? 1'b1 : 1'b0;	
	assign bullet_enemy_hit[5] = ((bullet_enemy_x_pos[5] + 14) > user_x_pos && (bullet_enemy_x_pos[5] + 18) < (user_x_pos + BOX_WIDTH) && (bullet_enemy_y_pos[5] + 3'h7) > user_y_pos) ? 1'b1 : 1'b0;	
	
	assign bullet_hit[0] = ((bullet_x_pos[0] + 14) > enemy_x_pos[0] && (bullet_x_pos[0] + 18) < (enemy_x_pos[0] + BOX_WIDTH) && bullet_y_pos[0] < (enemy_y_pos[0] + BOX_HEIGHT) ||
									(bullet_x_pos[0] + 14) > enemy_x_pos[1] && (bullet_x_pos[0] + 18) < (enemy_x_pos[1] + BOX_WIDTH) && bullet_y_pos[0] < (enemy_y_pos[1] + BOX_HEIGHT) ||
									(bullet_x_pos[0] + 14) > enemy_x_pos[2] && (bullet_x_pos[0] + 18) < (enemy_x_pos[2] + BOX_WIDTH) && bullet_y_pos[0] < (enemy_y_pos[2] + BOX_HEIGHT) ||
									(bullet_x_pos[0] + 14) > enemy_x_pos[3] && (bullet_x_pos[0] + 18) < (enemy_x_pos[3] + BOX_WIDTH) && bullet_y_pos[0] < (enemy_y_pos[3] + BOX_HEIGHT) ||
									(bullet_x_pos[0] + 14) > enemy_x_pos[4] && (bullet_x_pos[0] + 18) < (enemy_x_pos[4] + BOX_WIDTH) && bullet_y_pos[0] < (enemy_y_pos[4] + BOX_HEIGHT) ||
									(bullet_x_pos[0] + 14) > enemy_x_pos[5] && (bullet_x_pos[0] + 18) < (enemy_x_pos[5] + BOX_WIDTH) && bullet_y_pos[0] < (enemy_y_pos[5] + BOX_HEIGHT)) ? 1'b1 : 1'b0;	
	assign bullet_hit[1] = ((bullet_x_pos[1] + 14) > enemy_x_pos[0] && (bullet_x_pos[1] + 18) < (enemy_x_pos[0] + BOX_WIDTH) && bullet_y_pos[1] < (enemy_y_pos[0] + BOX_HEIGHT) ||
									(bullet_x_pos[1] + 14) > enemy_x_pos[1] && (bullet_x_pos[1] + 18) < (enemy_x_pos[1] + BOX_WIDTH) && bullet_y_pos[1] < (enemy_y_pos[1] + BOX_HEIGHT) ||
									(bullet_x_pos[1] + 14) > enemy_x_pos[2] && (bullet_x_pos[1] + 18) < (enemy_x_pos[2] + BOX_WIDTH) && bullet_y_pos[1] < (enemy_y_pos[2] + BOX_HEIGHT) ||
									(bullet_x_pos[1] + 14) > enemy_x_pos[3] && (bullet_x_pos[1] + 18) < (enemy_x_pos[3] + BOX_WIDTH) && bullet_y_pos[1] < (enemy_y_pos[3] + BOX_HEIGHT) ||
									(bullet_x_pos[1] + 14) > enemy_x_pos[4] && (bullet_x_pos[1] + 18) < (enemy_x_pos[4] + BOX_WIDTH) && bullet_y_pos[1] < (enemy_y_pos[4] + BOX_HEIGHT) ||
									(bullet_x_pos[1] + 14) > enemy_x_pos[5] && (bullet_x_pos[1] + 18) < (enemy_x_pos[5] + BOX_WIDTH) && bullet_y_pos[1] < (enemy_y_pos[5] + BOX_HEIGHT)) ? 1'b1 : 1'b0;
	assign bullet_hit[2] = ((bullet_x_pos[2] + 14) > enemy_x_pos[0] && (bullet_x_pos[2] + 18) < (enemy_x_pos[0] + BOX_WIDTH) && bullet_y_pos[2] < (enemy_y_pos[0] + BOX_HEIGHT) ||
									(bullet_x_pos[2] + 14) > enemy_x_pos[1] && (bullet_x_pos[2] + 18) < (enemy_x_pos[1] + BOX_WIDTH) && bullet_y_pos[2] < (enemy_y_pos[1] + BOX_HEIGHT) ||
									(bullet_x_pos[2] + 14) > enemy_x_pos[2] && (bullet_x_pos[2] + 18) < (enemy_x_pos[2] + BOX_WIDTH) && bullet_y_pos[2] < (enemy_y_pos[2] + BOX_HEIGHT) ||
									(bullet_x_pos[2] + 14) > enemy_x_pos[3] && (bullet_x_pos[2] + 18) < (enemy_x_pos[3] + BOX_WIDTH) && bullet_y_pos[2] < (enemy_y_pos[3] + BOX_HEIGHT) ||
									(bullet_x_pos[2] + 14) > enemy_x_pos[4] && (bullet_x_pos[2] + 18) < (enemy_x_pos[4] + BOX_WIDTH) && bullet_y_pos[2] < (enemy_y_pos[4] + BOX_HEIGHT) ||
									(bullet_x_pos[2] + 14) > enemy_x_pos[5] && (bullet_x_pos[2] + 18) < (enemy_x_pos[5] + BOX_WIDTH) && bullet_y_pos[2] < (enemy_y_pos[5] + BOX_HEIGHT)) ? 1'b1 : 1'b0;
	assign bullet_hit[3] = ((bullet_x_pos[3] + 14) > enemy_x_pos[0] && (bullet_x_pos[3] + 18) < (enemy_x_pos[0] + BOX_WIDTH) && bullet_y_pos[3] < (enemy_y_pos[0] + BOX_HEIGHT) ||
									(bullet_x_pos[3] + 14) > enemy_x_pos[1] && (bullet_x_pos[3] + 18) < (enemy_x_pos[1] + BOX_WIDTH) && bullet_y_pos[3] < (enemy_y_pos[1] + BOX_HEIGHT) ||
									(bullet_x_pos[3] + 14) > enemy_x_pos[2] && (bullet_x_pos[3] + 18) < (enemy_x_pos[2] + BOX_WIDTH) && bullet_y_pos[3] < (enemy_y_pos[2] + BOX_HEIGHT) ||
									(bullet_x_pos[3] + 14) > enemy_x_pos[3] && (bullet_x_pos[3] + 18) < (enemy_x_pos[3] + BOX_WIDTH) && bullet_y_pos[3] < (enemy_y_pos[3] + BOX_HEIGHT) ||
									(bullet_x_pos[3] + 14) > enemy_x_pos[4] && (bullet_x_pos[3] + 18) < (enemy_x_pos[4] + BOX_WIDTH) && bullet_y_pos[3] < (enemy_y_pos[4] + BOX_HEIGHT) ||
									(bullet_x_pos[3] + 14) > enemy_x_pos[5] && (bullet_x_pos[3] + 18) < (enemy_x_pos[5] + BOX_WIDTH) && bullet_y_pos[3] < (enemy_y_pos[5] + BOX_HEIGHT)) ? 1'b1 : 1'b0;
	assign bullet_hit[4] = ((bullet_x_pos[4] + 14) > enemy_x_pos[0] && (bullet_x_pos[4] + 18) < (enemy_x_pos[0] + BOX_WIDTH) && bullet_y_pos[4] < (enemy_y_pos[0] + BOX_HEIGHT) ||
									(bullet_x_pos[4] + 14) > enemy_x_pos[1] && (bullet_x_pos[4] + 18) < (enemy_x_pos[1] + BOX_WIDTH) && bullet_y_pos[4] < (enemy_y_pos[1] + BOX_HEIGHT) ||
									(bullet_x_pos[4] + 14) > enemy_x_pos[2] && (bullet_x_pos[4] + 18) < (enemy_x_pos[2] + BOX_WIDTH) && bullet_y_pos[4] < (enemy_y_pos[2] + BOX_HEIGHT) ||
									(bullet_x_pos[4] + 14) > enemy_x_pos[3] && (bullet_x_pos[4] + 18) < (enemy_x_pos[3] + BOX_WIDTH) && bullet_y_pos[4] < (enemy_y_pos[3] + BOX_HEIGHT) ||
									(bullet_x_pos[4] + 14) > enemy_x_pos[4] && (bullet_x_pos[4] + 18) < (enemy_x_pos[4] + BOX_WIDTH) && bullet_y_pos[4] < (enemy_y_pos[4] + BOX_HEIGHT) ||
									(bullet_x_pos[4] + 14) > enemy_x_pos[5] && (bullet_x_pos[4] + 18) < (enemy_x_pos[5] + BOX_WIDTH) && bullet_y_pos[4] < (enemy_y_pos[5] + BOX_HEIGHT)) ? 1'b1 : 1'b0;
	assign bullet_hit[5] = ((bullet_x_pos[5] + 14) > enemy_x_pos[0] && (bullet_x_pos[5] + 18) < (enemy_x_pos[0] + BOX_WIDTH) && bullet_y_pos[5] < (enemy_y_pos[0] + BOX_HEIGHT) ||
									(bullet_x_pos[5] + 14) > enemy_x_pos[1] && (bullet_x_pos[5] + 18) < (enemy_x_pos[1] + BOX_WIDTH) && bullet_y_pos[5] < (enemy_y_pos[1] + BOX_HEIGHT) ||
									(bullet_x_pos[5] + 14) > enemy_x_pos[2] && (bullet_x_pos[5] + 18) < (enemy_x_pos[2] + BOX_WIDTH) && bullet_y_pos[5] < (enemy_y_pos[2] + BOX_HEIGHT) ||
									(bullet_x_pos[5] + 14) > enemy_x_pos[3] && (bullet_x_pos[5] + 18) < (enemy_x_pos[3] + BOX_WIDTH) && bullet_y_pos[5] < (enemy_y_pos[3] + BOX_HEIGHT) ||
									(bullet_x_pos[5] + 14) > enemy_x_pos[4] && (bullet_x_pos[5] + 18) < (enemy_x_pos[4] + BOX_WIDTH) && bullet_y_pos[5] < (enemy_y_pos[4] + BOX_HEIGHT) ||
									(bullet_x_pos[5] + 14) > enemy_x_pos[5] && (bullet_x_pos[5] + 18) < (enemy_x_pos[5] + BOX_WIDTH) && bullet_y_pos[5] < (enemy_y_pos[5] + BOX_HEIGHT)) ? 1'b1 : 1'b0;
	
	assign killed[0] = ((bullet_x_pos[0] + 14) > enemy_x_pos[0] && (bullet_x_pos[0] + 18) < (enemy_x_pos[0] + BOX_WIDTH) && bullet_y_pos[0] < (enemy_y_pos[0] + BOX_HEIGHT) ||
									(bullet_x_pos[1] + 14) > enemy_x_pos[0] && (bullet_x_pos[1] + 18) < (enemy_x_pos[0] + BOX_WIDTH) && bullet_y_pos[1] < (enemy_y_pos[0] + BOX_HEIGHT) ||
									(bullet_x_pos[2] + 14) > enemy_x_pos[0] && (bullet_x_pos[2] + 18) < (enemy_x_pos[0] + BOX_WIDTH) && bullet_y_pos[2] < (enemy_y_pos[0] + BOX_HEIGHT) ||
									(bullet_x_pos[3] + 14) > enemy_x_pos[0] && (bullet_x_pos[3] + 18) < (enemy_x_pos[0] + BOX_WIDTH) && bullet_y_pos[3] < (enemy_y_pos[0] + BOX_HEIGHT) ||
									(bullet_x_pos[4] + 14) > enemy_x_pos[0] && (bullet_x_pos[4] + 18) < (enemy_x_pos[0] + BOX_WIDTH) && bullet_y_pos[4] < (enemy_y_pos[0] + BOX_HEIGHT) ||
									(bullet_x_pos[5] + 14) > enemy_x_pos[0] && (bullet_x_pos[5] + 18) < (enemy_x_pos[0] + BOX_WIDTH) && bullet_y_pos[5] < (enemy_y_pos[0] + BOX_HEIGHT)) ? 1'b1 : 1'b0;
	assign killed[1] = ((bullet_x_pos[0] + 14) > enemy_x_pos[1] && (bullet_x_pos[0] + 18) < (enemy_x_pos[1] + BOX_WIDTH) && bullet_y_pos[0] < (enemy_y_pos[1] + BOX_HEIGHT) ||
									(bullet_x_pos[1] + 14) > enemy_x_pos[1] && (bullet_x_pos[1] + 18) < (enemy_x_pos[1] + BOX_WIDTH) && bullet_y_pos[1] < (enemy_y_pos[1] + BOX_HEIGHT) ||
									(bullet_x_pos[2] + 14) > enemy_x_pos[1] && (bullet_x_pos[2] + 18) < (enemy_x_pos[1] + BOX_WIDTH) && bullet_y_pos[2] < (enemy_y_pos[1] + BOX_HEIGHT) ||
									(bullet_x_pos[3] + 14) > enemy_x_pos[1] && (bullet_x_pos[3] + 18) < (enemy_x_pos[1] + BOX_WIDTH) && bullet_y_pos[3] < (enemy_y_pos[1] + BOX_HEIGHT) ||
									(bullet_x_pos[4] + 14) > enemy_x_pos[1] && (bullet_x_pos[4] + 18) < (enemy_x_pos[1] + BOX_WIDTH) && bullet_y_pos[4] < (enemy_y_pos[1] + BOX_HEIGHT) ||
									(bullet_x_pos[5] + 14) > enemy_x_pos[1] && (bullet_x_pos[5] + 18) < (enemy_x_pos[1] + BOX_WIDTH) && bullet_y_pos[5] < (enemy_y_pos[1] + BOX_HEIGHT)) ? 1'b1 : 1'b0;
	assign killed[2] = ((bullet_x_pos[0] + 14) > enemy_x_pos[2] && (bullet_x_pos[0] + 18) < (enemy_x_pos[2] + BOX_WIDTH) && bullet_y_pos[0] < (enemy_y_pos[2] + BOX_HEIGHT) ||
									(bullet_x_pos[1] + 14) > enemy_x_pos[2] && (bullet_x_pos[1] + 18) < (enemy_x_pos[2] + BOX_WIDTH) && bullet_y_pos[1] < (enemy_y_pos[2] + BOX_HEIGHT) ||
									(bullet_x_pos[2] + 14) > enemy_x_pos[2] && (bullet_x_pos[2] + 18) < (enemy_x_pos[2] + BOX_WIDTH) && bullet_y_pos[2] < (enemy_y_pos[2] + BOX_HEIGHT) ||
									(bullet_x_pos[3] + 14) > enemy_x_pos[2] && (bullet_x_pos[3] + 18) < (enemy_x_pos[2] + BOX_WIDTH) && bullet_y_pos[3] < (enemy_y_pos[2] + BOX_HEIGHT) ||
									(bullet_x_pos[4] + 14) > enemy_x_pos[2] && (bullet_x_pos[4] + 18) < (enemy_x_pos[2] + BOX_WIDTH) && bullet_y_pos[4] < (enemy_y_pos[2] + BOX_HEIGHT) ||
									(bullet_x_pos[5] + 14) > enemy_x_pos[2] && (bullet_x_pos[5] + 18) < (enemy_x_pos[2] + BOX_WIDTH) && bullet_y_pos[5] < (enemy_y_pos[2] + BOX_HEIGHT)) ? 1'b1 : 1'b0;	
	assign killed[3] = ((bullet_x_pos[0] + 14) > enemy_x_pos[3] && (bullet_x_pos[0] + 18) < (enemy_x_pos[3] + BOX_WIDTH) && bullet_y_pos[0] < (enemy_y_pos[3] + BOX_HEIGHT) ||
									(bullet_x_pos[1] + 14) > enemy_x_pos[3] && (bullet_x_pos[1] + 18) < (enemy_x_pos[3] + BOX_WIDTH) && bullet_y_pos[1] < (enemy_y_pos[3] + BOX_HEIGHT) ||
									(bullet_x_pos[2] + 14) > enemy_x_pos[3] && (bullet_x_pos[2] + 18) < (enemy_x_pos[3] + BOX_WIDTH) && bullet_y_pos[2] < (enemy_y_pos[3] + BOX_HEIGHT) ||
									(bullet_x_pos[3] + 14) > enemy_x_pos[3] && (bullet_x_pos[3] + 18) < (enemy_x_pos[3] + BOX_WIDTH) && bullet_y_pos[3] < (enemy_y_pos[3] + BOX_HEIGHT) ||
									(bullet_x_pos[4] + 14) > enemy_x_pos[3] && (bullet_x_pos[4] + 18) < (enemy_x_pos[3] + BOX_WIDTH) && bullet_y_pos[4] < (enemy_y_pos[3] + BOX_HEIGHT) ||
									(bullet_x_pos[5] + 14) > enemy_x_pos[3] && (bullet_x_pos[5] + 18) < (enemy_x_pos[3] + BOX_WIDTH) && bullet_y_pos[5] < (enemy_y_pos[3] + BOX_HEIGHT)) ? 1'b1 : 1'b0;
	assign killed[4] = ((bullet_x_pos[0] + 14) > enemy_x_pos[4] && (bullet_x_pos[0] + 18) < (enemy_x_pos[4] + BOX_WIDTH) && bullet_y_pos[0] < (enemy_y_pos[4] + BOX_HEIGHT) ||
									(bullet_x_pos[1] + 14) > enemy_x_pos[4] && (bullet_x_pos[1] + 18) < (enemy_x_pos[4] + BOX_WIDTH) && bullet_y_pos[1] < (enemy_y_pos[4] + BOX_HEIGHT) ||
									(bullet_x_pos[2] + 14) > enemy_x_pos[4] && (bullet_x_pos[2] + 18) < (enemy_x_pos[4] + BOX_WIDTH) && bullet_y_pos[2] < (enemy_y_pos[4] + BOX_HEIGHT) ||
									(bullet_x_pos[3] + 14) > enemy_x_pos[4] && (bullet_x_pos[3] + 18) < (enemy_x_pos[4] + BOX_WIDTH) && bullet_y_pos[3] < (enemy_y_pos[4] + BOX_HEIGHT) ||
									(bullet_x_pos[4] + 14) > enemy_x_pos[4] && (bullet_x_pos[4] + 18) < (enemy_x_pos[4] + BOX_WIDTH) && bullet_y_pos[4] < (enemy_y_pos[4] + BOX_HEIGHT) ||
									(bullet_x_pos[5] + 14) > enemy_x_pos[4] && (bullet_x_pos[5] + 18) < (enemy_x_pos[4] + BOX_WIDTH) && bullet_y_pos[5] < (enemy_y_pos[4] + BOX_HEIGHT)) ? 1'b1 : 1'b0;
	assign killed[5] = ((bullet_x_pos[0] + 14) > enemy_x_pos[5] && (bullet_x_pos[0] + 18) < (enemy_x_pos[5] + BOX_WIDTH) && bullet_y_pos[0] < (enemy_y_pos[5] + BOX_HEIGHT) ||
									(bullet_x_pos[1] + 14) > enemy_x_pos[5] && (bullet_x_pos[1] + 18) < (enemy_x_pos[5] + BOX_WIDTH) && bullet_y_pos[1] < (enemy_y_pos[5] + BOX_HEIGHT) ||
									(bullet_x_pos[2] + 14) > enemy_x_pos[5] && (bullet_x_pos[2] + 18) < (enemy_x_pos[5] + BOX_WIDTH) && bullet_y_pos[2] < (enemy_y_pos[5] + BOX_HEIGHT) ||
									(bullet_x_pos[3] + 14) > enemy_x_pos[5] && (bullet_x_pos[3] + 18) < (enemy_x_pos[5] + BOX_WIDTH) && bullet_y_pos[3] < (enemy_y_pos[5] + BOX_HEIGHT) ||
									(bullet_x_pos[4] + 14) > enemy_x_pos[5] && (bullet_x_pos[4] + 18) < (enemy_x_pos[5] + BOX_WIDTH) && bullet_y_pos[4] < (enemy_y_pos[5] + BOX_HEIGHT) ||
									(bullet_x_pos[5] + 14) > enemy_x_pos[5] && (bullet_x_pos[5] + 18) < (enemy_x_pos[5] + BOX_WIDTH) && bullet_y_pos[5] < (enemy_y_pos[5] + BOX_HEIGHT)) ? 1'b1 : 1'b0;

	
	/* CLOCK and RESET */
	always @(posedge clk, posedge reset)
	begin
		if(reset)
			begin
				score_user <= 0;
				lives_reg <= 7;
			end
		else
			begin
				score_user <= score_user_reg;
				lives_reg <= lives_next;
			end
	end
	
	
   /* RGB multiplexing circuit */
   always @*
	begin
		score_user_reg = score_user;
		lives_next = lives_reg;
		graph_rgb = 3'b000; // black background
		
		if(stop == 1'b0)
			begin
				if(user_killed == 1'b1)
					lives_next = lives_reg - 1'b1;
				
				if(killed[0] == 1'b1 || killed[1] == 1'b1 || killed[2] == 1'b1 || killed[3] == 1'b1 || killed[4] == 1'b1 || killed[5] == 1'b1)
					score_user_reg = score_user + 1'b1;
			end
		
		if (~video_on)
			graph_rgb = 3'b000;
		else
			begin
				graph_rgb = graph_rgb_reg1 | graph_rgb_reg2 | graph_rgb_reg3 | graph_rgb_reg4 | graph_rgb_reg5 | graph_rgb_reg6 | graph_rgb_reg7;
			end
	end
endmodule
