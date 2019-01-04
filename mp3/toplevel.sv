import rv32i_types::*;

// Encompasses CPU (pipeline) and Cache Hierarchy, thus only connects to
// physical memory.
module toplevel
(
    input clk,

    input rv32i_cache_line pmem_rdata,
    input logic pmem_resp,
    output rv32i_word pmem_address,
    output rv32i_cache_line pmem_wdata,
    output logic pmem_read,
    output logic pmem_write
);

/* Intermediary Signals */

// CPU
rv32i_word dmem_addr;
rv32i_word pc_out;
rv32i_word instr_base;

// Cache Hierarchy
rv32i_word imem_address;
rv32i_word imem_wdata;
rv32i_word imem_rdata;
logic imem_read;
logic imem_write;
rv32i_mem_wmask imem_byte_enable;
logic imem_resp;

rv32i_word dmem_address;
rv32i_word dmem_wdata;
rv32i_word dmem_rdata;
logic dmem_read; 
logic dmem_write;
rv32i_mem_wmask dmem_byte_enable;
logic dmem_resp;

logic ipmem_read;
logic ipmem_write;
logic dpmem_read;
logic dpmem_write;
logic l2mem_read;
logic l2mem_write;
logic l2pmem_read;
logic l2pmem_write;

// Performance Counter
logic flush_decode;
rv32i_opcode opcode;
logic load_fetch;
logic load_decode;
logic load_execute;
logic load_memory;
logic predict_incorrect_bimodal;

rv32i_word perf_mem_address_out;
rv32i_word perf_mem_rdata_out;
logic perf_mem_resp_out;
logic perf_mem_read_out;


/**************************************/
/* ****** Host of All Problems ****** */
/**************************************/

assign instr_base       = imem_rdata;

cpu cpu
(
    .*
);

/*********************************/
/* ****** Cache Hierarchy ****** */
/*********************************/

assign imem_address     = pc_out;
assign imem_wdata       = 32'h0000DEAD;
assign imem_read        = 1'b1;
assign imem_write       = 1'b0;
assign imem_byte_enable = 4'b0000;

assign dmem_address     = dmem_addr;

cache_hierarchy #(.l1_ways(2), .l2_ways(4), .l1_sets(8), .l2_sets(8)) cache_money
(
    .clk(clk),

    /* CPU */
    // I-cache
    .imem_address    ,
    .imem_wdata      ,
    .imem_rdata      ,
    .imem_read       ,
    .imem_write      ,
    .imem_byte_enable,
    .imem_resp       ,
    // D-Cache
    .dmem_address    ,//(perf_mem_address_out),    // Intercepted by Perf. Counter
    .dmem_wdata      ,
    .dmem_rdata      ,//(perf_mem_rdata_out),      // Intercepted by Perf. Counter
    .dmem_read       ,//(perf_mem_read_out),       // Intercepted by Perf. Counter
    .dmem_write      ,
    .dmem_byte_enable,
    .dmem_resp       ,//(perf_mem_resp_out),       // Intercepted by Perf. Counter

    /* Physical Memory */
    .pmem_address    ,
    .pmem_wdata      ,
    .pmem_rdata      ,
    .pmem_read       ,
    .pmem_write      ,
    .pmem_resp       ,

    /* Performance Counter */
    .ipmem_read      ,
    .ipmem_write     ,
    .dpmem_read      ,
    .dpmem_write     ,
    .l2mem_read      ,
    .l2mem_write     ,
    .l2pmem_read     ,
    .l2pmem_write
);


/**************************************/
/* ****** Performance Counters ****** */
/**************************************/

// performance_counter performance_counter_inst
// (
//     .clk,
//     // Interaction between cpu and i-cache
//     .i_access (imem_read  | imem_write),
//     .i_miss   (ipmem_read | ipmem_write),
//     // Interaction between cpu and d-cache
//     .d_access (dmem_read  | dmem_write),
//     .d_miss   (dpmem_read | dpmem_write),
//     // Interaction between arbiter and l2
//     .l2_access(l2mem_read | l2mem_write),
//     .l2_miss (l2pmem_read | l2pmem_write),

//     .branch_mispredict(flush_decode),
//     .opcode,

//     .load_fetch,
//     .load_decode,
//     .load_execute,
//     .load_memory,
//     .predict_incorrect_bimodal,

//     .perf_mem_address (dmem_address),
//     .perf_mem_rdata   (dmem_rdata),
//     .perf_mem_resp    (dmem_resp),
//     .perf_mem_read    (dmem_read),

//     .perf_mem_address_out,
//     .perf_mem_rdata_out,
//     .perf_mem_resp_out,
//     .perf_mem_read_out
// );


endmodule : toplevel
