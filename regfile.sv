module regfile(input logic clk,
					input logic we3,
					input logic [4:0] ra1,
					input logic [4:0] ra2,
					input logic [4:0] wa3,
					input logic [63:0] wd3,
					output logic [63:0] rd1,
					output logic [63:0] rd2);
					
		logic [63:0] REG [0:31] ='{0,1,2,3,4,5,6,7,8,9,10,11,
		12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,0};
		always_comb
		if(we3 && wa3!=31)begin
			if(wa3==ra1) rd1 <= wd3;
			else rd1 <= REG[ra1];
			if(wa3==ra2) rd2 <= wd3;
			else rd2 <= REG[ra2];
		end
		else begin 
			rd1 <= REG[ra1];
			rd2 <= REG[ra2];
		end
		always_ff @(posedge clk)
			if(we3)REG[wa3] <= wa3!=31 ? wd3 : 0;
			
endmodule

