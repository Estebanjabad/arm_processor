// SHIFT LEFT

module sl  (input logic [15:0] a,
            input logic [1:0] lsl,
            output logic [63:0] y);
	 always_comb
    casez(lsl)
        0: y = { {48{1'b0}}, {a} };
        1: y = { {32{1'b0}}, {a}, {16{1'b0}} };
        2: y = { {16{1'b0}}, {a}, {32{1'b0}} }; 
        3: y = { {a}, {48{1'b0}} };
    endcase

endmodule