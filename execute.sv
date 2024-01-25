module execute #(parameter N = 64) (input logic AluSrc,
					input logic [3:0] AluControl,
					input logic [N-1:0] PC_E,
					input logic [N-1:0] signImm_E,
					input logic [N-1:0] readData1_E,
					input logic [N-1:0] readData2_E,
					output logic [N-1:0] PCBranch_E,
					output logic [N-1:0] aluResult_E,
					output logic [N-1:0] writeData_E,
					output logic zero_E); 
		logic [N-1:0] add_in;
		logic [N-1:0] alu_in;
		sl2 #(N) shift(signImm_E, add_in);
		adder #(N) add(PC_E,add_in, PCBranch_E);
		mux2 #(N) mux(readData2_E, signImm_E, AluSrc, alu_in);
		alu ALU(readData1_E, alu_in, AluControl, aluResult_E, zero_E);
		assign writeData_E = readData2_E;
endmodule