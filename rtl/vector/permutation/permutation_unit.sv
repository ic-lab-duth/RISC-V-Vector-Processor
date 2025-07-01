module permutation_unit #(
    W = 8,
    N = 8
)(
    input  logic                    slideUp,
    input  logic                    slideDown,
    input  logic                    group,
    input  logic                    gather,
    input  logic[$clog2(N):0]        scalar,
    input  logic[N-1:0]             mask,
    input  logic[N-1:0][$clog2(N):0] vector,
    input  logic[N-1:0][W-1:0]      in,
    output logic[N-1:0][W-1:0]      out
);

logic[N-1:0][N-1:0] one_mask;
logic[N-1:0][N-1:0] zero_mask;
logic[N-1:0][1:0][$clog2(N):0] ones;
logic[N-1:0][1:0][$clog2(N):0] zeros;
logic[N-1:0][1:0][$clog2(N):0] dst_result;
logic[N-1:0][$clog2(N):0] src_result;
logic[N-1:0][N-1:0] dst_matrix;
logic[N-1:0][N-1:0] src_matrix;
logic[N-1:0]        src_mask;
logic[N-1:0]        dst_mask;
logic[N-1:0][N-1:0] final_matrix;

genvar i, j;
generate
    for (i = 0; i < N; ++i) begin
        assign one_mask[i]      = mask & ((1 << i) - 1);
        assign zero_mask[N-i-1] = mask | ((1 << i) - 1);

        if (N == 4) begin
            reduce4x1 one_counter   (.p(one_mask[i] ), .res(ones[i] ));
            reduce4x1 zero_counter  (.p(zero_mask[N-i-1]), .res(zeros[i]));
        end else if (N == 8) begin
            reduce8x1 one_counter   (.p(one_mask[i] ), .res(ones[i] ));
            reduce8x1 zero_counter  (.p(zero_mask[N-i-1]), .res(zeros[i]));
        end else if (N == 16) begin
            reduce16x1 one_counter  (.p(one_mask[i] ), .res(ones[i] ));
            reduce16x1 zero_counter (.p(zero_mask[N-i-1]), .res(zeros[i]));
        end else if (N == 32) begin
            reduce32x1 one_counter  (.p(one_mask[i] ), .res(ones[i] ));
            reduce32x1 zero_counter (.p(zero_mask[N-i-1]), .res(zeros[i]));
        end else if (N == 64) begin
            reduce64x1 one_counter  (.p(one_mask[i] ), .res(ones[i] ));
            reduce64x1 zero_counter (.p(zero_mask[N-i-1]), .res(zeros[i]));
        end

        assign dst_result[i] = slideUp ? {($clog2(N)+1)'(scalar), ($clog2(N)+1)'(i)} : mask[i] ? ones[i] : zeros[i];
        assign src_result[i] = slideDown ? i + scalar : vector[i];

        for (j = 0; j < N; ++j) begin
            add_comparator #(.N($clog2(N)+1)) i_add_comparator (.a(dst_result[i][0]), .b(dst_result[i][1]), .k(($clog2(N)+1)'(j)), .r(dst_matrix[j][i]));
        end
        assign src_matrix[i] = 1 << src_result[i];

        assign dst_mask[i] = slideUp   | group;
        assign src_mask[i] = slideDown | gather;

        assign final_matrix[i] = (dst_matrix[i] & dst_mask) | (src_matrix[i] & src_mask);

        and_or_mux #(.INPUTS(N), .DW(W)) mux (.data_in(in), .sel(final_matrix[i]), .data_out(out[i]));
    end
endgenerate

endmodule
