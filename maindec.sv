module maindec(input logic control_enable,
					input logic [10:0] Op,
					output logic Reg2Loc,
					output logic ALUSrc,
					output logic MemtoReg,
					output logic RegWrite,
					output logic MemRead,
					output logic MemWrite,
					output logic Branch,
					output logic [1:0] ALUOp);
		logic [8:0] aux;
		always_comb
		casez(Op)
			11'b111_1100_0010: aux=9'b011110000; 	   //LDUR 
			11'b111_1100_0000: aux=9'b110001000;		//STUR
			11'b101_1010_0???: aux=9'b100000101;		//CBZ
			11'b100_0101_1000: aux=9'b000100010;		//ADD 
			11'b110_0101_1000: aux=9'b000100010;		//SUB
			11'b100_0101_0000: aux=9'b000100010;		//AND
			11'b101_0101_0000: aux=9'b000100010;		//ORR
			11'b110_1001_01??: aux=9'b010100010;        //MOVZ 
			default: 		   aux=9'b000000000;
		endcase
		always_comb begin
			if(control_enable) begin
				Reg2Loc = aux[8];
				ALUSrc = aux[7];
				MemtoReg = aux[6];
				RegWrite = aux[5];
				MemRead = aux[4];
				MemWrite = aux[3];
				Branch = aux[2];
				ALUOp = aux[1:0];
			end else begin
				Reg2Loc = 1'b0;
				ALUSrc = 1'b0;
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				ALUOp = '0;
			end
		end
endmodule
