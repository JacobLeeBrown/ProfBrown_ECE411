import rv32i_types::*;

module cache
(
    input clk,

    /* CPU signals */
    output mem_resp,
    output [31:0] mem_rdata,
    input mem_read,
    input mem_write,
    input [3:0] mem_byte_enable,
    input [31:0] mem_address,
    input [31:0] mem_wdata,

    /* Physical Memory Signals */
    input pmem_resp,
    input [255:0] pmem_rdata,
    output pmem_read,
    output pmem_write,
    output [31:0] pmem_address,
    output [255:0] pmem_wdata
);

// From datapath to control
logic [1:0] hits;
logic dirty;
logic lru_out;
// From control to datapath
logic load_lru;
logic way_sel;
logic load_word;
logic load_line;
logic tag_sel;

cache_control control
(
    .*
);

cache_datapath datapath
(
    .*
);

endmodule : cache
