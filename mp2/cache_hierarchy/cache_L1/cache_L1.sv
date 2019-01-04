import rv32i_types::*;

module cache_L1
(
    input clk,

    /* CPU signals */
    input rv32i_word mem_address,
    input rv32i_word mem_wdata,
    output rv32i_word mem_rdata,
    input mem_read,
    input mem_write,
    input rv32i_mem_wmask mem_byte_enable,
    output mem_resp,

    /* Physical Memory Signals */
    output rv32i_word pmem_address,
    output rv32i_cache_line pmem_wdata,
    input rv32i_cache_line pmem_rdata,
    output pmem_read,
    output pmem_write,
    input pmem_resp
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

cache_control #(.ways(2)) control
(
    .*
);

cache_datapath_L1 datapath
(
    .*
);

endmodule : cache_L1
