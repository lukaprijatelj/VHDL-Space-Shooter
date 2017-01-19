// Listing 4.15
module disp_hex_mux
   (
    input wire clk, reset,
    input wire [3:0] hex7, hex6, hex5, hex4, hex3, hex2, hex1, hex0,  // hex digits
    input wire [7:0] dp_in,             // 4 decimal points
    output reg [7:0] an,  // enable 1-out-of-4 asserted low
    output reg [7:0] sseg // led segments
   );

   // constant declaration
   // refreshing rate around 800 Hz (50 MHz/2^16)
   localparam N = 18;
   // internal signal declaration
   reg [N-1:0] q_reg;
   wire [N-1:0] q_next;
   reg [3:0] hex_in;
   reg dp;

   // N-bit counter
   // register
   always @(posedge clk, posedge reset)
      if (reset)
         q_reg <= 0;
      else
         q_reg <= q_next;

   // next-state logic
   assign q_next = q_reg + 1;

   // 2 MSBs of counter to control 4-to-1 multiplexing
   // and to generate active-low enable signal
   always @*
      case (q_reg[N-1:N-3])
         3'b000:
            begin
               an =  8'b11111110;
               hex_in = hex0;
               dp = dp_in[0];
            end
         3'b001:
            begin
               an =  8'b11111101;
               hex_in = hex1;
               dp = dp_in[1];
            end
         3'b010:
            begin
               an =  8'b11111011;
               hex_in = hex2;
               dp = dp_in[2];
            end
			3'b011:
            begin
               an =  8'b11110111;
               hex_in = hex3;
               dp = dp_in[3];
            end
         3'b100:
            begin
               an =  8'b11101111;
               hex_in = hex4;
               dp = dp_in[4];
            end
         3'b101:
            begin
               an =  8'b11011111;
               hex_in = hex5;
               dp = dp_in[5];
            end
			3'b110:
            begin
               an =  8'b10111111;
               hex_in = hex6;
               dp = dp_in[6];
            end
         default:
            begin
               an =  8'b01111111;
               hex_in = hex7;
               dp = dp_in[7];
            end
       endcase

   // hex to seven-segment led display
   always @*
   begin
      case(hex_in)
         4'b0000 : sseg[6:0] = 7'b1000000;
			4'b0001 : sseg[6:0] = 7'b1111001;
			4'b0010 : sseg[6:0] = 7'b0100100;
			4'b0011 : sseg[6:0] = 7'b0110000;
			
			4'b0100 : sseg[6:0] = 7'b0011001;
			4'b0101 : sseg[6:0] = 7'b0010010;
			4'b0110 : sseg[6:0] = 7'b0000010;
			4'b0111 : sseg[6:0] = 7'b1111000;
			
			4'b1000 : sseg[6:0] = 7'b0000000;
			4'b1001 : sseg[6:0] = 7'b0011000;
			4'b1010 : sseg[6:0] = 7'b0001000;
			4'b1011 : sseg[6:0] = 7'b0000011;
			
			4'b1100 : sseg[6:0] = 7'b1000110;
			4'b1101 : sseg[6:0] = 7'b0100001;
			4'b1110 : sseg[6:0] = 7'b0000110;
			4'b1111 : sseg[6:0] = 7'b0001110;
			
			default: sseg[6:0] = 7'b1000000; 
     endcase
     sseg[7] = ~dp;
   end

endmodule