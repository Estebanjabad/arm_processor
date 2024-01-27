module forwarding(input logic [4:0] ID_EX_reg_rm, ID_EX_reg_rn,
                                    EX_MEM_reg_rd, MEM_WB_reg_rd, 
                  input logic EX_MEM_regWrite, MEM_WB_regWrite,
                  output logic [1:0] forwardA, forwardB);
    always_comb begin
        forwardA = 2'b00;
        forwardB = 2'b00; 

        if ( MEM_WB_regWrite && (MEM_WB_reg_rd != 31) &&
            !((EX_MEM_regWrite && (EX_MEM_reg_rd != 31)) &&
            (EX_MEM_reg_rd != ID_EX_reg_rn)) &&
            (MEM_WB_reg_rd == ID_EX_reg_rn) ) forwardA = 2'b01;

        if ( MEM_WB_regWrite &&
            (MEM_WB_reg_rd != 31) &&
            !( (EX_MEM_regWrite && (EX_MEM_reg_rd != 31)) &&
               (EX_MEM_reg_rd != ID_EX_reg_rm) ) &&
            (MEM_WB_reg_rd == ID_EX_reg_rm)) forwardB = 2'b01;

        if (  EX_MEM_regWrite && 
             (EX_MEM_reg_rd != 31) &&
             (EX_MEM_reg_rd == ID_EX_reg_rn) ) forwardA = 2'b10;

        if (  EX_MEM_regWrite && 
             (EX_MEM_reg_rd != 31) &&
             (EX_MEM_reg_rd == ID_EX_reg_rm)) forwardB = 2'b10;
    end
endmodule