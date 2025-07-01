module part_adder #(
    parameter int WIDTH = 8
)(
    input   logic carry_i,
    input   logic [WIDTH-1:0] opA,
    input   logic [WIDTH-1:0] opB,
    output  logic [WIDTH-1:0] result,
    output  logic carry_o
);

    assign {carry_o, result} = opA + opB + carry_i;

endmodule

module simd_internal_add #(
    parameter int MIN_WIDTH = 8,
    parameter int MAX_WIDTH = 64,
    parameter int SEW_WIDTH = $clog2(MAX_WIDTH/MIN_WIDTH) + 1
)(
    input   logic [SEW_WIDTH-1:0] sew,
    input   logic [MAX_WIDTH/MIN_WIDTH-1:0] carry,
    input   logic [MAX_WIDTH-1:0] opA,
    input   logic [MAX_WIDTH-1:0] opB,
    output  logic [MAX_WIDTH-1:0] result
);

    localparam int RATIO = MAX_WIDTH/MIN_WIDTH;
    logic [RATIO-2:0] stop_carry;

    always_comb begin
        stop_carry = 0;
        for (int i = 0; i < SEW_WIDTH; ++i) begin
            for (int j = RATIO/(2**i); j < RATIO; j += RATIO/(2**i))
                stop_carry[j - 1] |= sew[i];
        end
    end

    genvar i, j;
    generate
        for (i = 0; i < RATIO; ++i) begin : gen_adders
            logic carry_o;
            if (i == 0) begin
                part_adder #(.WIDTH(MIN_WIDTH)) padder (
                    .carry_i    (carry[i]),
                    .opA        (opA[i*MIN_WIDTH +: MIN_WIDTH]),
                    .opB        (opB[i*MIN_WIDTH +: MIN_WIDTH]),
                    .result     (result[i*MIN_WIDTH +: MIN_WIDTH]),
                    .carry_o    (carry_o)
                );
            end else begin
                part_adder #(.WIDTH(MIN_WIDTH)) padder (
                    .carry_i    (stop_carry[i - 1] ? carry[i] : gen_adders[i - 1].carry_o),
                    .opA        (opA[i*MIN_WIDTH +: MIN_WIDTH]),
                    .opB        (opB[i*MIN_WIDTH +: MIN_WIDTH]),
                    .result     (result[i*MIN_WIDTH +: MIN_WIDTH]),
                    .carry_o    (carry_o)
                );
            end
        end
    endgenerate
endmodule

module simd_add #(
    parameter int W = 32, // MAX WIDTH
    parameter int N = 4   // NUMBER OF ELEMENTS FOR MIN WIDTH
)(
    input  logic              sub  ,
    input  logic              rev  ,
    input  logic              carry,
    input  logic[$clog2(N):0] sew  ,
    input  logic[N-1:0]       c_in ,
    input  logic[W-1:0]       a    ,
    input  logic[W-1:0]       b    ,
    output logic[W-1:0]       s    ,
    output logic[N-1:0]       c_out
);

logic[$clog2(N):0][N-1:0] propagations;
logic[N-1:0]              propagation;
always_comb begin
    propagations = {($clog2(N)+1)*N{1'b1}};
    for (int i = 0; i < $clog2(N) + 1; ++i) begin
        for (int j = 0; j < N; j += 2**i) begin
            propagations[i][j] = 1'b0;
        end
    end
end
mux #(
    .INPUTS($clog2(N)+1),
    .WIDTH(N          )
)
i_mux (
    .sel   (sew         ),
    .data_i(propagations),
    .data_o(propagation )
);

logic[W-1:0] a_real;
logic[W-1:0] b_real;

assign a_real = sub &  rev ? ~a : a;
assign b_real = sub & ~rev ? ~b : b;

logic[N-1:0] a_stuffing;
logic[N-1:0] b_stuffing;

assign a_stuffing = carry & sub ? ~c_in |  propagation : carry ? c_in |  propagation : sub ? ~propagation : propagation;
assign b_stuffing = carry & sub ? ~c_in & ~propagation : carry ? c_in & ~propagation : sub ? {N{1'b1}}    : {N{1'b0}};

logic[W+N:0] a_stuffed;
logic[W+N:0] b_stuffed;

always_comb begin
    a_stuffed[W+N] = 1'b0;
    b_stuffed[W+N] = 1'b0;
    for (int i = 0; i < N; ++i) begin
        a_stuffed[i*(W/N+1) +: (W/N+1)] = {a_real[i*(W/N) +: (W/N)], a_stuffing[i]};
        b_stuffed[i*(W/N+1) +: (W/N+1)] = {b_real[i*(W/N) +: (W/N)], b_stuffing[i]};
    end
end

logic[W+N:0] s_stuffed;
assign s_stuffed = a_stuffed + b_stuffed;
always_comb begin
    for (int i = 0; i < N; ++i) begin
        {c_out[i], s[i*(W/N) +: (W/N)]} = s_stuffed[i*(W/N+1)+1 +: (W/N+1)];
    end
end


endmodule : simd_add


module simd_adder #(
    parameter int MIN_WIDTH = 8,
    parameter int MAX_WIDTH = 64,
    parameter int SEW_WIDTH = $clog2(MAX_WIDTH/MIN_WIDTH) + 1
)(
    input   logic sub,
    input   logic rev,
    input   logic carry,
    input   logic [SEW_WIDTH - 1 : 0]   sew,
    input   logic [MAX_WIDTH/MIN_WIDTH - 1 : 0] mask,
    input   logic [MAX_WIDTH - 1 : 0]   opA,
    input   logic [MAX_WIDTH - 1 : 0]   opB,
    output  logic [MAX_WIDTH - 1 : 0]   result
);

simd_add #(.W(MAX_WIDTH), .N(MAX_WIDTH/MIN_WIDTH)) adder (.sub(sub), .rev(rev), .carry(carry), .sew(sew), .c_in(mask), .a(opA), .b(opB), .s(result), .c_out());

    // assign result = opA + opB;

    // logic [MAX_WIDTH - 1 : 0] correct_opA, correct_opB;
    // assign correct_opA = rev ? opB : opA;
    // assign correct_opB = rev ? opA : opB;

    // logic [MAX_WIDTH - 1 : 0] opB_real;
    // assign opB_real = sub ? ~correct_opB : correct_opB;

    // logic [MAX_WIDTH/MIN_WIDTH - 1 : 0] carries, selected_carries_temp;
    // logic [SEW_WIDTH-1:0][MAX_WIDTH/MIN_WIDTH-1:0] carries_temp;
    // assign carries =    carry   ? selected_carries_temp :
    //                     sub     ? {MAX_WIDTH/MIN_WIDTH{1'b1}} : {MAX_WIDTH/MIN_WIDTH{1'b0}};

    // always_comb begin
    //     carries_temp = 0;
    //     for (int i = 0; i < SEW_WIDTH; ++i) begin
    //         for (int j = 0; j < (MAX_WIDTH/MIN_WIDTH)/(2**(SEW_WIDTH - i - 1)); ++j) begin
    //             carries_temp[i][j*(2**(SEW_WIDTH - i - 1))] = mask[j];
    //         end
    //     end
    // end
    // mux #(.INPUTS(SEW_WIDTH), .WIDTH(MAX_WIDTH/MIN_WIDTH)) mux (.sel(sew), .data_i(carries_temp), .data_o(selected_carries_temp));


    // simd_internal_add #(
    //     .MIN_WIDTH(MIN_WIDTH),
    //     .MAX_WIDTH(MAX_WIDTH))
    // internal_adder (
    //     .sew        (sew),
    //     .carry      (carries),
    //     .opA        (correct_opA),
    //     .opB        (opB_real),
    //     .result     (result)
    // );

endmodule
