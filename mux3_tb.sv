module mux3_tb();
	logic [32-1:0] d0, d1, d2;
	logic [1:0] s;
	logic [32-1:0] y;
	mux3 #(32)  dut(d0, d1, d2, s, y);
	initial begin;
		d0=10;
		d1=20;
		d2=30;
		s=0;
		#10;
		s=1;
		#10;
		s=2;
		#10;
		s=3;
		#10;
	end
endmodule