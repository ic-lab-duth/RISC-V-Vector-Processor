module add_comparator #(
    parameter int N = 32
)(
    input  logic[N-1:0] a,
    input  logic[N-1:0] b,
    input  logic[N-1:0] k,
    output logic        r
);

logic[N-1:0] s;
logic[N-1:0] c;
logic[N-1:0] x;

genvar i;
generate
    for (i = 0; i < N; ++i) begin : gen_fa
        FA i_FA (.a(a[i]),  .b(b[i]),  .c_in(~k[i]),  .s(s[i]), .c_out(c[i]));
    end
endgenerate

assign x = s ^ ({c[N-2:0], 1'b0});
assign r = &x;

endmodule
