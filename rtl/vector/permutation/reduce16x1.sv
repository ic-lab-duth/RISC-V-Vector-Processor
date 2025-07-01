module reduce16x1(
input logic[15:0][0:0] p,
output logic[1:0][4:0] res);
	logic fs0, fc0;
	FA fa0 (.a(p[0][0]), .b(p[1][0]), .c_in(p[2][0]), .s(fs0), .c_out(fc0));

	logic fs1, fc1;
	FA fa1 (.a(p[3][0]), .b(p[4][0]), .c_in(p[5][0]), .s(fs1), .c_out(fc1));

	logic fs2, fc2;
	FA fa2 (.a(p[6][0]), .b(p[7][0]), .c_in(p[8][0]), .s(fs2), .c_out(fc2));

	logic fs3, fc3;
	FA fa3 (.a(p[9][0]), .b(p[10][0]), .c_in(p[11][0]), .s(fs3), .c_out(fc3));

	logic fs4, fc4;
	FA fa4 (.a(p[12][0]), .b(p[13][0]), .c_in(p[14][0]), .s(fs4), .c_out(fc4));

	logic fs5, fc5;
	FA fa5 (.a(p[15][0]), .b(fs0), .c_in(fs1), .s(fs5), .c_out(fc5));

	logic fs6, fc6;
	FA fa6 (.a(fs2), .b(fs3), .c_in(fs4), .s(fs6), .c_out(fc6));

	logic hs1, hc1;
	HA ha1 (.a(fc0), .b(fc1), .s(hs1), .c_out(hc1));

	logic fs8, fc8;
	FA fa8 (.a(fc2), .b(fc3), .c_in(fc4), .s(fs8), .c_out(fc8));

	logic fs9, fc9;
	FA fa9 (.a(hs1), .b(fc5), .c_in(fc6), .s(fs9), .c_out(fc9));

	logic hs2, hc2;
	HA ha2 (.a(hc1), .b(fc8), .s(hs2), .c_out(hc2));

	assign res[0] = {1'b0, hc2, fc9, fs8, fs5};

	assign res[1] = {1'b0, 1'b0, hs2, fs9, fs6};

endmodule