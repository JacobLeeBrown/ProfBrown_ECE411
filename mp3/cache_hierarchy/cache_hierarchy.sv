import rv32i_types::*;

module cache_hierarchy #(parameter l1_ways = 2, parameter l2_ways = 4,
                         parameter l1_sets = 8, parameter l2_sets = 8)
(
    input clk,

    /* CPU */
    // I-Cache
    input  rv32i_word imem_address,
    input  rv32i_word imem_wdata,
    output rv32i_word imem_rdata,
    input  logic imem_read,
    input  logic imem_write,
    input  rv32i_mem_wmask imem_byte_enable,
    output logic imem_resp,
    // D-Cache
    input  rv32i_word dmem_address,             // Intercepted by Perf. Counter
    input  rv32i_word dmem_wdata,
    output rv32i_word dmem_rdata,               // Intercepted by Perf. Counter
    input  logic dmem_read,                     // Intercepted by Perf. Counter
    input  logic dmem_write,
    input  rv32i_mem_wmask dmem_byte_enable,
    output logic dmem_resp,                     // Intercepted by Perf. Counter

    /* Physical Memory */
    output rv32i_word pmem_address,
    output rv32i_cache_line pmem_wdata,
    input  rv32i_cache_line pmem_rdata,
    output logic pmem_read,
    output logic pmem_write,
    input  logic pmem_resp,

    /* Performance Counter */
    output logic ipmem_read,
    output logic ipmem_write,
    output logic dpmem_read,
    output logic dpmem_write,
    output logic l2mem_read,
    output logic l2mem_write,
    output logic l2pmem_read,
    output logic l2pmem_write
);

// L1 - Arbiter Signals
rv32i_word ipmem_address;
rv32i_cache_line ipmem_wdata;
rv32i_cache_line ipmem_rdata;
logic ipmem_resp;

rv32i_word dpmem_address;
rv32i_cache_line dpmem_wdata;
rv32i_cache_line dpmem_rdata;
logic dpmem_resp;

// L2 - Arbiter Signals
rv32i_word l2mem_address;
rv32i_cache_line l2mem_wdata;
rv32i_cache_line l2mem_rdata;
logic l2mem_resp;

// L2 - EWB Signals
rv32i_word l2pmem_address;
rv32i_cache_line l2pmem_wdata;
rv32i_cache_line l2pmem_rdata;
logic l2pmem_resp;


/***********************/
/* **** L1 Caches **** */
/***********************/

cache_L1 #(.ways(l1_ways), .sets(l1_sets)) i_cache 
(
    .clk,

    /* CPU signals */
    .mem_address    (imem_address),
    .mem_wdata      (imem_wdata),
    .mem_rdata      (imem_rdata),
    .mem_read       (imem_read),
    .mem_write      (imem_write),
    .mem_byte_enable(imem_byte_enable),
    .mem_resp       (imem_resp),

    /* Arbiter Signals */
    .pmem_address   (ipmem_address),
    .pmem_wdata     (ipmem_wdata),
    .pmem_rdata     (ipmem_rdata),
    .pmem_read      (ipmem_read),
    .pmem_write     (ipmem_write),
    .pmem_resp      (ipmem_resp)
);

cache_L1 #(.ways(l1_ways), .sets(l1_sets)) d_cache
(
    .clk,

    /* CPU signals */
    .mem_address    (dmem_address),
    .mem_wdata      (dmem_wdata),
    .mem_rdata      (dmem_rdata),
    .mem_read       (dmem_read),
    .mem_write      (dmem_write),
    .mem_byte_enable(dmem_byte_enable),
    .mem_resp       (dmem_resp),

    /* Arbiter Signals */
    .pmem_address   (dpmem_address),
    .pmem_wdata     (dpmem_wdata),
    .pmem_rdata     (dpmem_rdata),
    .pmem_read      (dpmem_read),
    .pmem_write     (dpmem_write),
    .pmem_resp      (dpmem_resp)
);


/*********************/
/* **** Arbiter **** */
/*********************/

arbiter arb_inst (
	.clk,

	// I-Cache
    .ipmem_address,
    .ipmem_wdata,
    .ipmem_rdata,
    .ipmem_read,
    .ipmem_write,
    .ipmem_resp,

	// D-Cache
    .dpmem_address,
    .dpmem_wdata,
    .dpmem_rdata,
    .dpmem_read,
    .dpmem_write,
    .dpmem_resp,

	// L2 Cache
    .l2mem_address,
    .l2mem_wdata,
    .l2mem_rdata,
    .l2mem_read,
    .l2mem_write,
    .l2mem_resp
);


/**********************/
/* **** L2 Cache **** */
/**********************/

cache_L2 #(.ways(l2_ways), .sets(l2_sets)) l2_cache 
(
    .clk,

    /* Arbiter signals */
    .mem_address (l2mem_address),
    .mem_wdata   (l2mem_wdata),
    .mem_rdata   (l2mem_rdata),
    .mem_read    (l2mem_read),
    .mem_write   (l2mem_write),
    .mem_resp    (l2mem_resp),

    /* Physical Memory Signals */
    // .pmem_address(l2pmem_address),
    // .pmem_wdata  (l2pmem_wdata),
    // .pmem_rdata  (l2pmem_rdata),
    // .pmem_read   (l2pmem_read),
    // .pmem_write  (l2pmem_write),
    // .pmem_resp   (l2pmem_resp)
    .pmem_address,
    .pmem_wdata,
    .pmem_rdata,
    .pmem_read,
    .pmem_write,
    .pmem_resp
);


/*********************/
/* ****** EWB ****** */
/*********************/
// Haha, get rekt scrub
// ewb ewb 
// (
//     .clk,

//     // Higher level memory
//     .mem_address (l2pmem_address),
//     .mem_wdata   (l2pmem_wdata),
//     .mem_rdata   (l2pmem_rdata),
//     .mem_read    (l2pmem_read),
//     .mem_write   (l2pmem_write),
//     .mem_resp    (l2pmem_resp),

//     // Lower level memory
//     .pmem_address,
//     .pmem_wdata,
//     .pmem_rdata,
//     .pmem_read,
//     .pmem_write,
//     .pmem_resp
// );


/******************************/
/* ****** Victim Cache ****** */
/******************************/

// victim_cache vc 
// (
//     .clk,

//     // Higher level memory
//     .mem_address (l2pmem_address),
//     .mem_wdata   (l2pmem_wdata),
//     .mem_rdata   (l2pmem_rdata),
//     .mem_read    (l2pmem_read),
//     .mem_write   (l2pmem_write),
//     .mem_resp    (l2pmem_resp),

//     // Lower level memory
//     .pmem_address,
//     .pmem_wdata  ,
//     .pmem_rdata  ,
//     .pmem_read   ,
//     .pmem_write  ,
//     .pmem_resp   
// );


endmodule : cache_hierarchy
