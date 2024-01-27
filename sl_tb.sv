module sl_tb();
	logic [15:0] a1;
   logic [63:0] y1;
	logic [15:0] a2;
   logic [63:0] y2;
	logic [15:0] a3;
   logic [63:0] y3;
	logic [15:0] a4;
   logic [63:0] y4; 
	logic [1:0] z=0;
	logic [1:0] z1=1;
	logic [1:0] z2=2;
	logic [1:0] z3=3;
	sl  dut1(a1,z,y1);
	sl  dut2(a2,z1,y2);
	sl  dut3(a3,z2,y3);
	sl  dut4(a4,z3,y4);
	initial begin;
		a1=16'b1001011010110101;
		a2=16'b1001011010110101;
		a3=16'b1001011010110101;
		a4=16'b1001011010110101;
		#10;
		$stop;
	end
endmodule