// DATAPATH

module datapath #(parameter N = 64)
					(input logic reset, clk,
					input logic reg2loc,									
					input logic AluSrc,
					input logic [3:0] AluControl,
					input logic	Branch,
					input logic memRead,
					input logic memWrite,
					input logic regWrite,	
					input logic memtoReg,									
					input logic [31:0] IM_readData,
					input logic [N-1:0] DM_readData,
					output logic [N-1:0] IM_addr, DM_addr, DM_writeData,
					output logic DM_writeEnable, DM_readEnable );					
					
	logic PCSrc;
	logic [N-1:0] PCBranch_E, aluResult_E, writeData_E, writeData3; 
	logic [N-1:0] Imm_D, readData1_D, readData2_D;
	logic zero_E;
	logic [95:0] qIF_ID;
	logic [285:0] qID_EX;
	logic [217:0] qEX_MEM;
	logic [139:0] qMEM_WB;
	logic [4:0] reg_rd, reg_rm, reg_rn;
	logic [1:0] forwardA, forwardB;
	logic [N-1:0] readData1_E, readData2_E;
	
	fetch 	#(64) 	FETCH 	(.PCSrc_F(PCSrc),
										.clk(clk),
										.reset(reset),
										.PCBranch_F(qEX_MEM[197:134]),
										.imem_addr_F(IM_addr));								
					
	
	flopr 	#(96)		IF_ID 	(.clk(clk),
										.reset(reset), 
										.d({IM_addr, IM_readData}),
										.q(qIF_ID));
										
	
	decode 	#(64) 	DECODE 	(.regWrite_D(qMEM_WB[134]),
										.reg2loc_D(reg2loc), 
										.clk(clk),
										.writeData3_D(writeData3),
										.instr_D(qIF_ID[31:0]), 
										.Imm_D(Imm_D), 
										.readData1_D(readData1_D),
										.readData2_D(readData2_D),
										.reg_rd(reg_rd),
										.reg_rm(reg_rm),
										.reg_rn(reg_rn),
										.wa3_D(qMEM_WB[4:0]));				
																									
									
	flopr 	#(286)	ID_EX 	(.clk(clk),
										.reset(reset), 
										.d({reg_rd, reg_rm, reg_rn, AluSrc, AluControl, Branch, memRead, memWrite, regWrite, memtoReg,	
											qIF_ID[95:32], Imm_D, readData1_D, readData2_D, qIF_ID[4:0]}),
										.q(qID_EX));	

	forwarding          FORWARDING  (.ID_EX_reg_rm (qID_EX[280:276]),
									 .ID_EX_reg_rn (qID_EX[275:271]),
									 .EX_MEM_reg_rd(qEX_MEM[217:213]),
									 .MEM_WB_reg_rd(qMEM_WB[139:135]),
									 .EX_MEM_regWrite(qEX_MEM[199]),
									 .MEM_WB_regWrite(qMEM_WB[134]),
									 .forwardA(forwardA), 
									 .forwardB(forwardB));

	
	mux3 #(64) mux3_A (.d0(qID_EX[132:69]), .d1(writeData3), .d2(qEX_MEM[132:69]), .s(forwardA), .y(readData1_E));
	mux3 #(64) mux3_B (.d0(qID_EX[68:5]), .d1(writeData3), .d2(qEX_MEM[132:69])  , .s(forwardB), .y(readData2_E));
										
	execute 	#(64) 	EXECUTE 	(.AluSrc(qID_EX[270]),
										.AluControl(qID_EX[269:266]),
										.PC_E(qID_EX[260:197]), 
										.signImm_E(qID_EX[196:133]), 
										.readData1_E(readData1_E), 
										.readData2_E(readData2_E), 
										.PCBranch_E(PCBranch_E), 
										.aluResult_E(aluResult_E), 
										.writeData_E(writeData_E), 
										.zero_E(zero_E));											
											
									
	flopr 	#(218)	EX_MEM 	(.clk(clk),
										.reset(reset), 
										.d({qID_EX[285:281], qID_EX[280:276], qID_EX[275:271], qID_EX[265:261], PCBranch_E, zero_E, aluResult_E, writeData_E, qID_EX[4:0]}),
										.q(qEX_MEM));	
	
										
	memory				MEMORY	(.Branch_M(qEX_MEM[202]), 
										.zero_M(qEX_MEM[133]), 
										.PCSrc_M(PCSrc));
			
	
	// Salida de señales a Data Memory
	assign DM_writeData = qEX_MEM[68:5];
	assign DM_addr = qEX_MEM[132:69];
	
	// Salida de señales de control:
	assign DM_writeEnable = qEX_MEM[200];
	assign DM_readEnable = qEX_MEM[201];
	
	flopr 	#(140)	MEM_WB 	(.clk(clk),
										.reset(reset), 
										.d({qEX_MEM[217:213], qEX_MEM[199:198], qEX_MEM[132:69],	DM_readData, qEX_MEM[4:0]}),
										.q(qMEM_WB));
		
	
	writeback #(64) 	WRITEBACK (.aluResult_W(qMEM_WB[132:69]), 
										.DM_readData_W(qMEM_WB[68:5]), 
										.memtoReg(qMEM_WB[133]), 
										.writeData3_W(writeData3));		
		
endmodule
