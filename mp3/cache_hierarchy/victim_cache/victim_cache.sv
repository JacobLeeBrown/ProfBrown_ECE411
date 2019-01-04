import rv32i_types::*;

module victim_cache #(parameter entries = 8)
(
    input  logic clk,

    // Higher level memory
    input  rv32i_word mem_address,
    input  rv32i_cache_line mem_wdata,
    output rv32i_cache_line mem_rdata,
    input  logic mem_read,
    input  logic mem_write,
    output logic mem_resp,

    // Lower level memory
    output rv32i_word pmem_address,
    output rv32i_cache_line pmem_wdata,
    input  rv32i_cache_line pmem_rdata,
    output logic pmem_read,
    output logic pmem_write,
    input  logic pmem_resp
);

// Intermediary Signals
logic full;
logic hit;
logic [$clog2(entries)-1:0] hit_idx;
logic [$clog2(entries)-1:0] circular_idx;
logic [$clog2(entries)-1:0] idx;
logic load;
logic circular_inc;
logic read_sel;
logic out_sel;

vc_datapath vc_datapath
(
    .clk,

    // Control
    .full,
    .hit,
    .hit_idx,
    .circular_idx,
    .idx,
    .load,
    .circular_inc,
    .read_sel,
    .out_sel,

    // Higher level memory
    .mem_address,
    .mem_wdata,
    .mem_rdata,

    // Lower level memory
    .pmem_address,
    .pmem_wdata,
    .pmem_rdata
);

vc_control vc_control
(
    .clk,

    // Datapath
    .full,
    .hit,
    .hit_idx,
    .circular_idx,
    .idx,
    .load,
    .circular_inc,
    .read_sel,
    .out_sel,

    // Higher level memory
    .mem_read,
    .mem_write,
    .mem_resp,

    // Lower level memory
    .pmem_read,
    .pmem_write,
    .pmem_resp
);

endmodule : victim_cache
