module flopre_tb;
	 parameter N = 64;
    logic clk;
    logic reset;
    logic enable;
    logic [N-1:0] d;
    logic [N-1:0] q;


    flopre #(64) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .d(d),
        .q(q)
    );

    always begin
        #5 clk = ~clk;
    end

   
    initial begin
        
        clk = 0;
        reset = 1;
        enable = 0;
        d = 0;

        #10;
        reset = 0; 
        enable = 1; 
        d = 'hA5;

        #10;
        enable = 0; 
        d = 'h5A;

        #10;
        enable = 1; 
        d = 'h3C; 

        #10;
        $stop;
    end
endmodule