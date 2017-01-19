module MUX8_1
	// I/O ports
	(
		input wire [6:0] select, 
		input wire d0, d1, d2, d3, d4, d5, d6,
		output wire y
	);
	reg selected;
	
	assign y = selected;
	
	always @*
	begin
		selected = d0;
		case(select)
			7'b0111111: selected = d0;
			7'b1011111: selected = d1;
			7'b1101111: selected = d2;
			7'b1110111: selected = d3;
			7'b1111011: selected = d4;
			7'b1111101: selected = d5;
			7'b1111110: selected = d6;
			7'b1111111: selected = 1;
		endcase		
	end
endmodule
