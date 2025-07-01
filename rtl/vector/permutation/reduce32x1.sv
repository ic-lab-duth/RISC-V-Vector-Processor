module reduce32x1(
input logic[31:0][0:0] p,
output logic[1:0][5:0] res);
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
	FA fa5 (.a(p[15][0]), .b(p[16][0]), .c_in(p[17][0]), .s(fs5), .c_out(fc5));

	logic fs6, fc6;
	FA fa6 (.a(p[18][0]), .b(p[19][0]), .c_in(p[20][0]), .s(fs6), .c_out(fc6));

	logic fs7, fc7;
	FA fa7 (.a(p[21][0]), .b(p[22][0]), .c_in(p[23][0]), .s(fs7), .c_out(fc7));

	logic fs8, fc8;
	FA fa8 (.a(p[24][0]), .b(p[25][0]), .c_in(p[26][0]), .s(fs8), .c_out(fc8));

	logic fs9, fc9;
	FA fa9 (.a(p[27][0]), .b(p[28][0]), .c_in(p[29][0]), .s(fs9), .c_out(fc9));

	logic fs10, fc10;
	FA fa10 (.a(p[30][0]), .b(p[31][0]), .c_in(fs0), .s(fs10), .c_out(fc10));

	logic fs11, fc11;
	FA fa11 (.a(fs1), .b(fs2), .c_in(fs3), .s(fs11), .c_out(fc11));

	logic fs12, fc12;
	FA fa12 (.a(fs4), .b(fs5), .c_in(fs6), .s(fs12), .c_out(fc12));

	logic fs13, fc13;
	FA fa13 (.a(fs7), .b(fs8), .c_in(fs9), .s(fs13), .c_out(fc13));

	logic fs14, fc14;
	FA fa14 (.a(fs10), .b(fs11), .c_in(fs12), .s(fs14), .c_out(fc14));

	logic hs1, hc1;
	HA ha1 (.a(fc0), .b(fc1), .s(hs1), .c_out(hc1));

	logic fs16, fc16;
	FA fa16 (.a(fc2), .b(fc3), .c_in(fc4), .s(fs16), .c_out(fc16));

	logic fs17, fc17;
	FA fa17 (.a(fc5), .b(fc6), .c_in(fc7), .s(fs17), .c_out(fc17));

	logic fs18, fc18;
	FA fa18 (.a(fc8), .b(fc9), .c_in(hs1), .s(fs18), .c_out(fc18));

	logic fs19, fc19;
	FA fa19 (.a(fc10), .b(fc11), .c_in(fc12), .s(fs19), .c_out(fc19));

	logic fs20, fc20;
	FA fa20 (.a(fc13), .b(fs16), .c_in(fs17), .s(fs20), .c_out(fc20));

	logic fs21, fc21;
	FA fa21 (.a(fs18), .b(fc14), .c_in(fs19), .s(fs21), .c_out(fc21));

	logic hs2, hc2;
	HA ha2 (.a(hc1), .b(fc16), .s(hs2), .c_out(hc2));

	logic fs23, fc23;
	FA fa23 (.a(fc17), .b(fc18), .c_in(hs2), .s(fs23), .c_out(fc23));

	logic fs24, fc24;
	FA fa24 (.a(fc19), .b(fc20), .c_in(fs23), .s(fs24), .c_out(fc24));

	logic hs3, hc3;
	HA ha3 (.a(hc2), .b(fc23), .s(hs3), .c_out(hc3));

	assign res[0] = {1'b0, hc3, fc24, fc21, fs20, fs13};

	assign res[1] = {1'b0, 1'b0, hs3, fs24, fs21, fs14};

endmodule