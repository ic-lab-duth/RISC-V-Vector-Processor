module reduce64x1(
input logic[63:0][0:0] p,
output logic[1:0][6:0] res);
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
	FA fa10 (.a(p[30][0]), .b(p[31][0]), .c_in(p[32][0]), .s(fs10), .c_out(fc10));

	logic fs11, fc11;
	FA fa11 (.a(p[33][0]), .b(p[34][0]), .c_in(p[35][0]), .s(fs11), .c_out(fc11));

	logic fs12, fc12;
	FA fa12 (.a(p[36][0]), .b(p[37][0]), .c_in(p[38][0]), .s(fs12), .c_out(fc12));

	logic fs13, fc13;
	FA fa13 (.a(p[39][0]), .b(p[40][0]), .c_in(p[41][0]), .s(fs13), .c_out(fc13));

	logic fs14, fc14;
	FA fa14 (.a(p[42][0]), .b(p[43][0]), .c_in(p[44][0]), .s(fs14), .c_out(fc14));

	logic fs15, fc15;
	FA fa15 (.a(p[45][0]), .b(p[46][0]), .c_in(p[47][0]), .s(fs15), .c_out(fc15));

	logic fs16, fc16;
	FA fa16 (.a(p[48][0]), .b(p[49][0]), .c_in(p[50][0]), .s(fs16), .c_out(fc16));

	logic fs17, fc17;
	FA fa17 (.a(p[51][0]), .b(p[52][0]), .c_in(p[53][0]), .s(fs17), .c_out(fc17));

	logic fs18, fc18;
	FA fa18 (.a(p[54][0]), .b(p[55][0]), .c_in(p[56][0]), .s(fs18), .c_out(fc18));

	logic fs19, fc19;
	FA fa19 (.a(p[57][0]), .b(p[58][0]), .c_in(p[59][0]), .s(fs19), .c_out(fc19));

	logic fs20, fc20;
	FA fa20 (.a(p[60][0]), .b(p[61][0]), .c_in(p[62][0]), .s(fs20), .c_out(fc20));

	logic fs21, fc21;
	FA fa21 (.a(p[63][0]), .b(fs0), .c_in(fs1), .s(fs21), .c_out(fc21));

	logic fs22, fc22;
	FA fa22 (.a(fs2), .b(fs3), .c_in(fs4), .s(fs22), .c_out(fc22));

	logic fs23, fc23;
	FA fa23 (.a(fs5), .b(fs6), .c_in(fs7), .s(fs23), .c_out(fc23));

	logic fs24, fc24;
	FA fa24 (.a(fs8), .b(fs9), .c_in(fs10), .s(fs24), .c_out(fc24));

	logic fs25, fc25;
	FA fa25 (.a(fs11), .b(fs12), .c_in(fs13), .s(fs25), .c_out(fc25));

	logic fs26, fc26;
	FA fa26 (.a(fs14), .b(fs15), .c_in(fs16), .s(fs26), .c_out(fc26));

	logic fs27, fc27;
	FA fa27 (.a(fs17), .b(fs18), .c_in(fs19), .s(fs27), .c_out(fc27));

	logic fs28, fc28;
	FA fa28 (.a(fs20), .b(fs21), .c_in(fs22), .s(fs28), .c_out(fc28));

	logic fs29, fc29;
	FA fa29 (.a(fs23), .b(fs24), .c_in(fs25), .s(fs29), .c_out(fc29));

	logic fs30, fc30;
	FA fa30 (.a(fs26), .b(fs27), .c_in(fs28), .s(fs30), .c_out(fc30));

	logic hs1, hc1;
	HA ha1 (.a(fc0), .b(fc1), .s(hs1), .c_out(hc1));

	logic fs32, fc32;
	FA fa32 (.a(fc2), .b(fc3), .c_in(fc4), .s(fs32), .c_out(fc32));

	logic fs33, fc33;
	FA fa33 (.a(fc5), .b(fc6), .c_in(fc7), .s(fs33), .c_out(fc33));

	logic fs34, fc34;
	FA fa34 (.a(fc8), .b(fc9), .c_in(fc10), .s(fs34), .c_out(fc34));

	logic fs35, fc35;
	FA fa35 (.a(fc11), .b(fc12), .c_in(fc13), .s(fs35), .c_out(fc35));

	logic fs36, fc36;
	FA fa36 (.a(fc14), .b(fc15), .c_in(fc16), .s(fs36), .c_out(fc36));

	logic fs37, fc37;
	FA fa37 (.a(fc17), .b(fc18), .c_in(fc19), .s(fs37), .c_out(fc37));

	logic fs38, fc38;
	FA fa38 (.a(fc20), .b(hs1), .c_in(fc21), .s(fs38), .c_out(fc38));

	logic fs39, fc39;
	FA fa39 (.a(fc22), .b(fc23), .c_in(fc24), .s(fs39), .c_out(fc39));

	logic fs40, fc40;
	FA fa40 (.a(fc25), .b(fc26), .c_in(fc27), .s(fs40), .c_out(fc40));

	logic fs41, fc41;
	FA fa41 (.a(fs32), .b(fs33), .c_in(fs34), .s(fs41), .c_out(fc41));

	logic fs42, fc42;
	FA fa42 (.a(fs35), .b(fs36), .c_in(fs37), .s(fs42), .c_out(fc42));

	logic fs43, fc43;
	FA fa43 (.a(fs38), .b(fc28), .c_in(fc29), .s(fs43), .c_out(fc43));

	logic fs44, fc44;
	FA fa44 (.a(fs39), .b(fs40), .c_in(fs41), .s(fs44), .c_out(fc44));

	logic fs45, fc45;
	FA fa45 (.a(fs42), .b(fc30), .c_in(fs43), .s(fs45), .c_out(fc45));

	logic hs2, hc2;
	HA ha2 (.a(hc1), .b(fc32), .s(hs2), .c_out(hc2));

	logic fs47, fc47;
	FA fa47 (.a(fc33), .b(fc34), .c_in(fc35), .s(fs47), .c_out(fc47));

	logic fs48, fc48;
	FA fa48 (.a(fc36), .b(fc37), .c_in(hs2), .s(fs48), .c_out(fc48));

	logic fs49, fc49;
	FA fa49 (.a(fc38), .b(fc39), .c_in(fc40), .s(fs49), .c_out(fc49));

	logic fs50, fc50;
	FA fa50 (.a(fc41), .b(fc42), .c_in(fs47), .s(fs50), .c_out(fc50));

	logic fs51, fc51;
	FA fa51 (.a(fs48), .b(fc43), .c_in(fc44), .s(fs51), .c_out(fc51));

	logic fs52, fc52;
	FA fa52 (.a(fs49), .b(fs50), .c_in(fc45), .s(fs52), .c_out(fc52));

	logic hs3, hc3;
	HA ha3 (.a(hc2), .b(fc47), .s(hs3), .c_out(hc3));

	logic fs54, fc54;
	FA fa54 (.a(fc48), .b(hs3), .c_in(fc49), .s(fs54), .c_out(fc54));

	logic fs55, fc55;
	FA fa55 (.a(fc50), .b(fs54), .c_in(fc51), .s(fs55), .c_out(fc55));

	logic hs4, hc4;
	HA ha4 (.a(hc3), .b(fc54), .s(hs4), .c_out(hc4));

	assign res[0] = {1'b0, hc4, fc55, fc52, fs51, fs44, fs29};

	assign res[1] = {1'b0, 1'b0, hs4, fs55, fs52, fs45, fs30};

endmodule