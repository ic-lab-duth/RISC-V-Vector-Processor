module vector_top #(parameter int LANES_DATA_WIDTH=32,
                    parameter int MICROOP_BIT=9,
                    parameter int INSTRUCTION_BITS=32,
                    parameter int NUMBER_VECTOR_LANES=8,
                    parameter int VREG_BITS=256,
                    parameter int SCALAR_DATA_WIDTH=32,
                    parameter int ADDR_RANGE=32768,
                    parameter int LENGTH_RANGE=32,
			        parameter int BUS_WIDTH=32,
                    parameter int MEMORY_BITS=32,
                    parameter int REGISTER_NUMBERS=32,
                    parameter int DATA_FROM_SCALAR=96,
                    parameter int MULTICYCLE_OPERATION_CYCLES=2,
                    parameter int PERM_GROUPING = 1)
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

                    input logic mem_ready,

                    output logic mem_op_done);

//setting wires for multiply module
logic [LANES_DATA_WIDTH-1:0] mask_register [0:NUMBER_VECTOR_LANES-1];
logic [2:0] memory_sew;
logic [2:0] indexed_sew;
logic load_operation_memory;
logic store_operation_memory;
logic [31:0] stride;
logic [31:0] addr;
logic [1:0] mode_memory;
logic memory_enable;
logic [MICROOP_BIT-1:0] alu_op_out [0:NUMBER_VECTOR_LANES-1];
logic [4:0] operand_1;
logic [4:0] operand_2;
logic [4:0] destination;
logic [(LANES_DATA_WIDTH/8)-1:0] mask_bits [0:NUMBER_VECTOR_LANES-1];
logic masked_operation;
logic load_operation;
logic store_operation;
logic indexed_memory_operation;
logic write_back_enable;
logic [LANES_DATA_WIDTH-1:0] operand_1_immediate_out;
logic [LANES_DATA_WIDTH-1:0] operand_1_scalar_out;
logic multiplication_flag;
logic [2:0] sew_out;
logic operation_done;
logic [4:0] register_to_write;
logic read_done_in_dispatch;
logic [4:0] destination_id;
logic [4:0] destination_id_in;
logic store_done;

assign mem_op_done = read_done_in_dispatch | store_done;

//////////////////////////////////////////////////////////////
/////                     DISPATCH                       /////
/////                                                    /////
//////////////////////////////////////////////////////////////

dispatch #(.INSTRUCTION_BITS(INSTRUCTION_BITS),
           .NUMBER_VECTOR_LANES(NUMBER_VECTOR_LANES),
           .VREG_BITS(VREG_BITS),
           .LANES_DATA_WIDTH(LANES_DATA_WIDTH),
           .SCALAR_DATA_WIDTH(SCALAR_DATA_WIDTH),
           .MICROOP_BIT(MICROOP_BIT),
           .ADDR_RANGE(ADDR_RANGE),
           .REGISTER_NUMBERS(REGISTER_NUMBERS),
           .MULTICYCLE_OPERATION_CYCLES(MULTICYCLE_OPERATION_CYCLES))
 dispatch_mod (.clk(clk),
               .rst(rst),
               .instruction(instruction),
               .valid_fifo(valid_fifo),
               .ready(ready),
               .read_done(read_done_in_dispatch),
               .store_done(store_done),
               .destination_id_in(destination_id_in),
               .memory_sew(memory_sew),
               .indexed_sew(indexed_sew),
               .load_operation_memory(load_operation_memory),
               .store_operation_memory(store_operation_memory),
               .stride(stride),
               .addr(addr),
               .mode_memory(mode_memory),
               .memory_enable(memory_enable),
               .destination_id(destination_id),
               .operation_done(operation_done),
               .register_to_write(register_to_write),
               .mask_register(mask_register),
               .alu_op_out(alu_op_out),
               .operand_1(operand_1),
               .operand_2(operand_2),
               .destination(destination),
               .mask_bits(mask_bits),
               .masked_operation(masked_operation),
               .load_operation(load_operation),
               .store_operation(store_operation),
               .indexed_memory_operation(indexed_memory_operation),
               .write_back_enable(write_back_enable),
               .operand_1_immediate_out(operand_1_immediate_out),
               .operand_1_scalar_out(operand_1_scalar_out),
               .multiplication_flag(multiplication_flag),
               .sew_out(sew_out));

// setting wires for vector_lane
logic [NUMBER_VECTOR_LANES-1:0] valid_read;
logic [LANES_DATA_WIDTH-1:0] data_from_load [0:NUMBER_VECTOR_LANES-1];
logic [LANES_DATA_WIDTH-1:0] wrdata [0:NUMBER_VECTOR_LANES-1];
logic [LANES_DATA_WIDTH-1:0] indexed [0:NUMBER_VECTOR_LANES-1];
logic [LANES_DATA_WIDTH-1:0] data_write [0:NUMBER_VECTOR_LANES-1];
logic [4:0] data_destination [0:NUMBER_VECTOR_LANES-1];
logic [2:0] sew_out_lane [0:NUMBER_VECTOR_LANES-1];
logic [NUMBER_VECTOR_LANES-1:0] masked_write_back_out;
logic [NUMBER_VECTOR_LANES-1:0] write_enable_out;
logic [NUMBER_VECTOR_LANES-1:0] write_back_enable_wb;
logic [LANES_DATA_WIDTH-1:0] data_write_wb [0:NUMBER_VECTOR_LANES-1];
logic [4:0] destination_write [0:NUMBER_VECTOR_LANES-1];
logic [LANES_DATA_WIDTH-1:0] data_from_load_out [0:NUMBER_VECTOR_LANES-1];
logic [NUMBER_VECTOR_LANES-1:0] read_done;
logic [4:0] load_data_destination [0:NUMBER_VECTOR_LANES-1];
logic [LANES_DATA_WIDTH-1:0] data_from_load_in [0:NUMBER_VECTOR_LANES-1];
logic [4:0] load_data_destination_in [0:NUMBER_VECTOR_LANES-1];
logic [LANES_DATA_WIDTH-1:0] operand_3 [0:NUMBER_VECTOR_LANES-1];
logic [NUMBER_VECTOR_LANES-1:0] read_done_in;


logic[NUMBER_VECTOR_LANES-1:0]                         lane_perm_slideup;
logic[NUMBER_VECTOR_LANES-1:0]                         lane_perm_slidedown;
logic[NUMBER_VECTOR_LANES-1:0]                         lane_perm_group;
logic[NUMBER_VECTOR_LANES-1:0]                         lane_perm_gather;
logic[NUMBER_VECTOR_LANES-1:0][LANES_DATA_WIDTH-1:0]   lane_perm_input;
logic[NUMBER_VECTOR_LANES-1:0][LANES_DATA_WIDTH-1:0]   lane_perm_vector;
logic[NUMBER_VECTOR_LANES-1:0][LANES_DATA_WIDTH-1:0]   lane_perm_scalar;
logic[NUMBER_VECTOR_LANES-1:0][LANES_DATA_WIDTH/8-1:0] lane_perm_mask;
logic[NUMBER_VECTOR_LANES-1:0][LANES_DATA_WIDTH-1:0]   lane_perm_result;

genvar i;

//////////////////////////////////////////////////////////////
/////      vector_lane/multiplexer for mask operations   /////
/////                                                    /////
//////////////////////////////////////////////////////////////
generate
    for(i=0;i<NUMBER_VECTOR_LANES;i++)begin: vector_lanes
        vector_lane #(.LANES_DATA_WIDTH(LANES_DATA_WIDTH),
                      .MICROOP_BIT(MICROOP_BIT),
                      .LANE_ID(i))
            vec_lane (.clk(clk),
                      .rst(rst),
                      .alu_op(alu_op_out[i]),
                      .operand_1(operand_1),
                      .operand_2(operand_2),
                      .destination(destination),
                      .mask_bits(mask_bits[i]),
                      .masked_operation(masked_operation),
                      .load_operation(load_operation),
                      .store_operation(store_operation),
                      .indexed_memory_operation(indexed_memory_operation),
                      .write_back_enable(write_back_enable),
                      .operand_1_immediate(operand_1_immediate_out),
                      .operand_1_scalar(operand_1_scalar_out),
                      .multiplication_flag(multiplication_flag),
                      .sew_in(sew_out),
                      .vector_mask(mask_register[i]),
                      .valid_read(valid_read[i]),
                      .data_from_load(data_from_load[i]),
                      .wrdata(wrdata[i]),
                      .indexed(indexed[i]),
                      .operand_3(operand_3[i]),
                      .data_write(data_write[i]),
                      .data_destination(data_destination[i]),
                      .sew_out(sew_out_lane[i]),
                      .masked_write_back_out(masked_write_back_out[i]),
                      .write_enable_out(write_enable_out[i]),
                      .read_done(read_done[i]),
                      .data_from_load_out(data_from_load_out[i]),
                      .load_data_destination(load_data_destination[i]),
                      .write_back_enable_wb(write_back_enable_wb[i]),
                      .data_write_wb(data_write_wb[i]),
                      .destination_write(destination_write[i]),
                      .read_done_in(read_done_in[i]),
                      .data_from_load_in(data_from_load_in[i]),
                      .load_data_destination_in(load_data_destination_in[i]),
                      .lane_perm_slideup(lane_perm_slideup[i]),
                      .lane_perm_slidedown(lane_perm_slidedown[i]),
                      .lane_perm_group(lane_perm_group[i]),
                      .lane_perm_gather(lane_perm_gather[i]),
                      .lane_perm_input(lane_perm_input[i]),
                      .lane_perm_vector(lane_perm_vector[i]),
                      .lane_perm_scalar(lane_perm_scalar[i]),
                      .lane_perm_mask(lane_perm_mask[i]),
                      .lane_perm_result(lane_perm_result[i]));
    end
endgenerate

localparam PERM_WIDTH = 8*PERM_GROUPING;
localparam PERM_ELEMENTS = VREG_BITS/PERM_WIDTH;
logic perm_slideup;
logic perm_slidedown;
logic perm_group;
logic perm_gather;
logic [VREG_BITS-1:0] perm_in;
logic [VREG_BITS-1:0] perm_vector;
logic [SCALAR_DATA_WIDTH-1:0] perm_scalar;
logic [PERM_ELEMENTS-1:0] perm_mask;
logic [VREG_BITS-1:0] perm_result;

assign perm_slideup   = lane_perm_slideup[0];
assign perm_slidedown = lane_perm_slidedown[0];
assign perm_group     = lane_perm_group[0];
assign perm_gather     = lane_perm_gather[0];
assign perm_scalar = lane_perm_scalar[0];

always_comb for (int i = 0; i < NUMBER_VECTOR_LANES; ++i) begin
    perm_in[LANES_DATA_WIDTH*i +: LANES_DATA_WIDTH] = lane_perm_input[i];
    perm_vector[LANES_DATA_WIDTH*i +: LANES_DATA_WIDTH] = lane_perm_vector[i];
    perm_mask[LANES_DATA_WIDTH/8*i +: LANES_DATA_WIDTH/8] = lane_perm_mask[i];
    lane_perm_result[i] = perm_result[LANES_DATA_WIDTH*i +: LANES_DATA_WIDTH];

end


logic slideUp;
logic slideDown;
logic group;
logic gather;
logic [$clog2(PERM_ELEMENTS):0] scalar;
logic [PERM_ELEMENTS-1:0] mask;
logic [PERM_ELEMENTS-1:0][$clog2(PERM_ELEMENTS):0] vector;
logic [PERM_ELEMENTS-1:0][PERM_WIDTH-1:0] in;
logic [PERM_ELEMENTS-1:0][PERM_WIDTH-1:0] out;

assign slideUp = perm_slideup;
assign slideDown = perm_slidedown;
assign group = perm_group;
assign gather = perm_gather;
assign scalar = perm_scalar;
assign in = perm_in;
assign perm_result = out;

always_comb begin
    for (int i = 0; i < PERM_ELEMENTS; ++i) begin
        vector[i] = perm_vector[PERM_GROUPING*8*i +: $clog2(PERM_ELEMENTS) + 1];
        mask[i] = perm_mask[PERM_GROUPING*i];
    end
end

permutation_unit #(.W(PERM_WIDTH), .N(PERM_ELEMENTS)) i_permutation_unit (
    .slideUp  (slideUp  ),
    .slideDown(slideDown),
    .group    (group    ),
    .gather   (gather   ),
    .scalar   (scalar   ),
    .mask     (mask     ),
    .vector   (vector   ),
    .in       (in       ),
    .out      (out      )
);



assign register_to_write=data_destination[0];
assign operation_done=write_enable_out[0];
assign read_done_in_dispatch=read_done[0];

//multiplexer
 multiplexer_to_register #(.LANES_DATA_WIDTH(LANES_DATA_WIDTH),
                           .NUMBER_VECTOR_LANES(NUMBER_VECTOR_LANES))
          multiplexer_mod (.sew(sew_out_lane),
                           .destination(data_destination),
                           .data_write(data_write),
                           .mask_operation(masked_write_back_out),
                           .write_enable(write_enable_out),
                           .load_data_destination_in(load_data_destination),
                           .data_from_load_in(data_from_load_out),
                           .read_done_in(read_done),
                           .operand_3(operand_3),
                           .destination_out(destination_write),
                           .data_write_out(data_write_wb),
                           .write_enable_out(write_back_enable_wb),
                           .load_destination_out(load_data_destination_in),
                           .data_from_load_out(data_from_load_in),
                           .read_done_out(read_done_in));

//////////////////////////////////////////////////////////////
/////                 memory interface                   /////
/////                                                    /////
//////////////////////////////////////////////////////////////

top_mem #(.ADDR_RANGE(ADDR_RANGE),
          .LENGTH_RANGE(LENGTH_RANGE),
          .BUS_WIDTH(BUS_WIDTH),
          .MEMORY_BITS(MEMORY_BITS),
          .LANES_DATA_WIDTH(LANES_DATA_WIDTH),
          .VREG_BITS(VREG_BITS),
          .NUMBER_VECTOR_LANES(NUMBER_VECTOR_LANES))
mem_mod (.clk(clk),
         .rst(rst),
         .destination_id(destination_id),
         .enable_in(memory_enable),
         .load_operation(load_operation_memory),
         .store_operation(store_operation_memory),
         .in_stride(stride),
         .wrdata_in(wrdata),
         .mode_in(mode_memory),
         .sew_in(memory_sew),
         .indexed_sew(indexed_sew),
         .indexed(indexed),
         .in_addr(addr),
         .rddata_out(data_from_load),
         .valid_read(valid_read),
         .store_done(store_done),
         .destination_id_out(destination_id_in),
         // Vector Memory interface
        .mem_valid_rd(mem_valid_rd),
        .mem_valid_wr(mem_valid_wr),
        .mem_unit    (mem_unit),
        .mem_sew     (mem_sew),
        .mem_address (mem_address),
        .mem_data_wr (mem_data_wr),
        .mem_valid_o (mem_valid_o),
        .mem_data_o  (mem_data_o),

        .mem_ready   (mem_ready));


endmodule
