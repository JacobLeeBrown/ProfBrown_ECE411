import rv32i_types::*;

module arbiter (
	input  logic clk,

	// I-Cache
    input  rv32i_word ipmem_address,
    input  rv32i_cache_line ipmem_wdata,
    output rv32i_cache_line ipmem_rdata,
    input  logic ipmem_read,
    input  logic ipmem_write,
    output logic ipmem_resp,

	// D-Cache
    input  rv32i_word dpmem_address,
    input  rv32i_cache_line dpmem_wdata,
    output rv32i_cache_line dpmem_rdata,
    input  logic dpmem_read,
    input  logic dpmem_write,
    output logic dpmem_resp,

	// L2 Cache
    output rv32i_word l2mem_address,
    output rv32i_cache_line l2mem_wdata,
    input  rv32i_cache_line l2mem_rdata,
    output logic l2mem_read,
    output logic l2mem_write,
    input  logic l2mem_resp
);

logic arb_mux_sel, load_arb;
assign load_arb = (ipmem_read | dpmem_read | dpmem_write | l2mem_resp);

arb_control arb_control_inst (
	.clk,
	.icache_read(ipmem_read),
	.dcache_read(dpmem_read),
	.dcache_write(dpmem_write),

	// internal to arbiter
	.arb_mux_sel
);

arb_datapath arb_datapath_inst (
	.clk,
	.arb_mux_sel,
	.load_arb,

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

endmodule : arbiter
