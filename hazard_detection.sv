module hazard_detection(input logic [4:0] ID_EX_reg_rd, IF_ID_reg_rn,
                                          IF_ID_reg_rm, 
                        input logic ID_EX_memRead,
                        output logic IF_ID_enable, control_enable, PC_enable);
    always_comb begin
        
        IF_ID_enable = 1;
        control_enable = 1;
        PC_enable = 1;

        if (ID_EX_memRead &&
        ((ID_EX_reg_rd == IF_ID_reg_rn) ||
        (ID_EX_reg_rd == IF_ID_reg_rm))) begin
            IF_ID_enable = 0;
            control_enable = 0;
            PC_enable = 0;
        end
    end

endmodule