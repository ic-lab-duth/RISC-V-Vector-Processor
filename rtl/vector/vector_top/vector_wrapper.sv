module vector_wrapper #(
                    parameter int DATA_FROM_SCALAR=96)
                   (input logic clk,
                    input logic rst,
                    //inputs from scoreboard
                    input logic valid_fifo,
                    input logic [DATA_FROM_SCALAR-1:0] instruction,
                    output logic ready,
                    // Vector memory interface
                    output  logic mem_valid_rd,
                    output  logic mem_valid_wr,
                    output  logic mem_unit,
                    output  logic [1:0] mem_sew,
                    output  logic [31 : 0] mem_address,
                    output  logic [255 : 0] mem_data_wr,

                    input   logic mem_valid_o,
                    input   logic [255 : 0] mem_data_o,
                    input   logic mem_ready,

                    output logic mem_op_done);



    logic [95:0] pop_data;
    logic valid;
    logic pop;
fifo_duth #(.DW(96), .DEPTH(4)) i_fifo_duth (
    .clk      (clk      ),
    .rst      (rst      ),
    .push_data(instruction),
    .push     (valid_fifo & ready),
    .ready    (ready    ),
    .pop_data (pop_data ),
    .valid    (valid    ),
    .pop      (pop      )
);


vector_top i_vector_top (
    .clk         (clk         ),
    .rst         (rst         ),
    .valid_fifo  (valid       ),
    .instruction (pop_data    ),
    .ready       (pop         ),
    .mem_valid_rd(mem_valid_rd),
    .mem_valid_wr(mem_valid_wr),
    .mem_unit    (mem_unit    ),
    .mem_sew     (mem_sew     ),
    .mem_address (mem_address ),
    .mem_data_wr (mem_data_wr ),
    .mem_valid_o (mem_valid_o ),
    .mem_data_o  (mem_data_o  ),
    .mem_ready   (mem_ready   ),
    .mem_op_done (mem_op_done )
);


endmodule
