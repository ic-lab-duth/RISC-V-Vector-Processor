/**
 * @info fifo_duth
 *
 * @author VLSI Lab, EE dept., Democritus University of Thrace
 *
 * @brief FIFO circular buffer. Uses an input decoder to store to the proper place and an output MUX to select the proper output data.
 *
 * @param DW data width
 * @param DEPTH number of buffer slots. Note: If 1, leads to 50% throughput, so use @see eb_one_slot with FULL_THROUGHPUT asserted.
 */

module fifo_duth
#(
    parameter int DW    = 16,
    parameter int DEPTH = 4
)
(
    input  logic            clk,
    input  logic            rst,
    // input channel
    input  logic[DW-1:0]    push_data,
    input  logic            push,
    output logic            ready,
    // output channel
    output logic[DW-1:0]    pop_data,
    output logic            valid,
    input  logic            pop
);

logic[DEPTH-1:0][DW-1:0]    mem;
logic[DEPTH-1:0]            push_pnt;
logic[DEPTH-1:0]            pop_pnt;
logic[DEPTH  :0]            status_cnt;

assign valid = ~status_cnt[0];
assign ready = ~status_cnt[DEPTH];

//Pointer update (one-hot shifting pointers)
always_ff @ (posedge clk, posedge rst) begin: ff_push_pnt
    if (rst) begin
        push_pnt <= 1;
    end else begin
        // push pointer
        if (push) begin
            push_pnt <= {push_pnt[DEPTH-2:0], push_pnt[DEPTH-1]};
        end
    end
end
always_ff @ (posedge clk, posedge rst) begin: ff_pop_pnt
    if (rst) begin
        pop_pnt <= 1;
    end else begin
        // pop pointer
        if (pop) begin
            pop_pnt <= {pop_pnt[DEPTH-2:0], pop_pnt[DEPTH-1]};
        end
    end
end

// Status (occupied slots) Counter
always_ff @ (posedge clk, posedge rst) begin: ff_status_cnt
    if (rst) begin
        status_cnt <= 1; // status counter onehot coded
    end else begin
        if (push & ~pop) begin
            // shift left status counter (increment)
            status_cnt <= { status_cnt[DEPTH-1:0],1'b0 } ;
        end else if (~push &  pop) begin
            // shift right status counter (decrement)
            status_cnt <= {1'b0, status_cnt[DEPTH:1] };
        end
    end
end

// data write (push)
// address decoding needed for onehot push pointer
always_ff @ (posedge clk) begin: ff_reg_dec
    for (int i=0; i < DEPTH; i++) begin
        if ( push & push_pnt[i] ) begin
            mem[i] <= push_data;
        end
    end
end

mux
#(
    .INPUTS (DEPTH),
    .WIDTH     (DW)
)
mux_out
(
    .data_i  (mem),
    .sel      (pop_pnt),
    .data_o (pop_data)
);

endmodule
