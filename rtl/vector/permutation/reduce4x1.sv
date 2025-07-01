module reduce4x1(
input logic[3:0][0:0] p,
output logic[1:0][2:0] res);
	logic fs0, fc0;
	FA fa0 (.a(p[0][0]), .b(p[1][0]), .c_in(p[2][0]), .s(fs0), .c_out(fc0));

	assign res[0] = {1'b0, fc0, p[3][0]};

	assign res[1] = {1'b0, 1'b0, fs0};

endmodule