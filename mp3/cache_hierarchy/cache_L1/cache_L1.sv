import rv32i_types::*;

module cache_L1 #(parameter ways = 2, parameter sets = 8)
(
    input clk,

    /* CPU signals */
    input  rv32i_word mem_address,
    input  rv32i_word mem_wdata,
    output rv32i_word mem_rdata,
    input  logic mem_read,
    input  logic mem_write,
    input  rv32i_mem_wmask mem_byte_enable,
    output logic mem_resp,

    /* Physical Memory Signals */
    output rv32i_word pmem_address,
    output rv32i_cache_line pmem_wdata,
    input  rv32i_cache_line pmem_rdata,
    output logic pmem_read,
    output logic pmem_write,
    input  logic pmem_resp
);

// From datapath to control
logic [ways-1:0] hits;
logic dirty;
logic [$clog2(ways)-1:0] lru_out;
// From control to datapath
logic load_lru;
logic [$clog2(ways)-1:0] way_sel;
logic load_word;
logic load_line;
logic tag_sel;

cache_control #(.ways(ways)) control
(
    .*
);

cache_datapath_L1 #(.ways(ways), .sets(sets)) datapath
(
    .*
);

endmodule : cache_L1
