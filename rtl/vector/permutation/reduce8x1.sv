module reduce8x1(
input logic[7:0][0:0] p,
output logic[1:0][3:0] res);
    logic fs0, fc0;
    FA fa0 (.a(p[0][0]), .b(p[1][0]), .c_in(p[2][0]), .s(fs0), .c_out(fc0));

    logic fs1, fc1;
    FA fa1 (.a(p[3][0]), .b(p[4][0]), .c_in(p[5][0]), .s(fs1), .c_out(fc1));

    logic fs2, fc2;
    FA fa2 (.a(p[6][0]), .b(p[7][0]), .c_in(fs0), .s(fs2), .c_out(fc2));

    logic hs1, hc1;
    HA ha1 (.a(fc0), .b(fc1), .s(hs1), .c_out(hc1));

    assign res[0] = {1'b0, hc1, fc2, fs1};

    assign res[1] = {1'b0, 1'b0, hs1, fs2};

endmodule
