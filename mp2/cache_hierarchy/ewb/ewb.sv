import rv32i_types::*;

module ewb
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
logic valid_out, valid_in, out_sel, load;

ewb_datapath ewb_datapath
(
    .clk,

    // Control
    .valid_out,
    .valid_in,
    .out_sel,
    .load,

    // Higher level memory
    .mem_address,
    .mem_wdata,
    .mem_rdata,

    // Lower level memory
    .pmem_address,
    .pmem_wdata,
    .pmem_rdata
);

ewb_control ewb_control
(
    .clk,

    // Datapath
    .valid_out,
    .valid_in,
    .out_sel,
    .load,

    // Higher level memory
    .mem_read,
    .mem_write,
    .mem_resp,

    // Lower level memory
    .pmem_read,
    .pmem_write,
    .pmem_resp
);

endmodule : ewb
