module fetch #(parameter N = 64) (input logic PC_enable,
				 input logic PCSrc_F,
				 input logic clk,
				 input logic reset,
				 input logic [N-1:0] PCBranch_F,
				 output logic [N-1:0] imem_addr_F);
				 
				 logic [N-1:0] offset = 'd4;
				 logic [N-1:0] add_out;
				 logic [N-1:0] mux_out;
				 logic [N-1:0] flop_out;
				 mux2 #(N) mux(add_out, PCBranch_F, PCSrc_F, mux_out);
				 flopre #(N) flop(PC_enable,clk,reset,mux_out,flop_out);
				 adder #(N) add (flop_out,offset,add_out);
				 assign imem_addr_F = flop_out;
endmodule