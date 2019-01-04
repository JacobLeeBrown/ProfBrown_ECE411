import rv32i_types::*;

module mp2
(
    input clk,

    /* Memory signals */
    input pmem_resp,
    input [255:0] pmem_rdata,
    output pmem_read,
    output pmem_write,
    output [31:0] pmem_address,
    output [255:0] pmem_wdata
);

// CPU - Cache
rv32i_word mem_address;
rv32i_word mem_wdata;
rv32i_word mem_rdata;
logic mem_read;
logic mem_write;
rv32i_mem_wmask mem_byte_enable;
logic mem_resp;

// Cache - EWB
rv32i_word l1mem_address;
rv32i_cache_line l1mem_wdata;
rv32i_cache_line l1mem_rdata;
logic l1mem_read;
logic l1mem_write;
logic l1mem_resp;

cpu cpu
(
    .*
);

cache_L1 cache
(
    .clk,

    /* CPU signals */
    .mem_address,
    .mem_wdata,
    .mem_rdata,
    .mem_read,
    .mem_write,
    .mem_byte_enable,
    .mem_resp,

    /* Physical Memory Signals */
    // .pmem_address,
    // .pmem_wdata,
    // .pmem_rdata,
    // .pmem_read ,
    // .pmem_write,
    // .pmem_resp   
    .pmem_address(l1mem_address),
    .pmem_wdata  (l1mem_wdata),
    .pmem_rdata  (l1mem_rdata),
    .pmem_read   (l1mem_read),
    .pmem_write  (l1mem_write),
    .pmem_resp   (l1mem_resp)
);

ewb ewb 
(
    .clk,

    // Higher level memory
    .mem_address(l1mem_address),
    .mem_wdata  (l1mem_wdata),
    .mem_rdata  (l1mem_rdata),
    .mem_read   (l1mem_read),
    .mem_write  (l1mem_write),
    .mem_resp   (l1mem_resp),

    // Lower level memory
    .pmem_address,
    .pmem_wdata,
    .pmem_rdata,
    .pmem_read,
    .pmem_write,
    .pmem_resp
);

endmodule : mp2
