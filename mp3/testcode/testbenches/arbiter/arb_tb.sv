import rv32i_types::*;

module arb_tb;

timeunit 1ns;
timeprecision 1ns;

/* Clock generator */
logic clk;
initial clk = 0;
always #5 clk = ~clk;

logic load_arb;

// I-Cache
rv32i_word ipmem_address;
rv32i_cache_line ipmem_wdata;
rv32i_cache_line ipmem_rdata;
logic ipmem_read;
logic ipmem_write;
logic ipmem_resp;

// D-Cache
rv32i_word dpmem_address;
rv32i_cache_line dpmem_wdata;
rv32i_cache_line dpmem_rdata;
logic dpmem_read;
logic dpmem_write;
logic dpmem_resp;

// L2 Cache
rv32i_word l2mem_address;
rv32i_cache_line l2mem_wdata;
rv32i_cache_line l2mem_rdata;
logic l2mem_read;
logic l2mem_write;
logic l2mem_resp;

// assign registers = dut.cpu.decode_stage.regfile.data;
// assign halt = ((dut.cpu.fetch_decode_reg.IR.data == 32'h00000063) | (dut.cpu.fetch_decode_reg.IR.data == 32'h0000006F));

arbiter dut (
	.load_arb(clk),
	.*
);

initial begin : tests
	$display("Running tests for arbiter.");

	// 1 for i-cache, D for d-cache.
	ipmem_address = 32'h11111111;
	dpmem_address = 32'hdddddddd;

	// Let's test reading dcache <- 0x69696969 from somwhere.
	// Then icache <- 0x44444444 

	// Since the i-cache is prioritized, it should go first.
	l2mem_rdata = 256'h6969696969696969696969696969696969696969696969696969696969696969;

	#2

	ipmem_read = 1;
	dpmem_read = 1;

	#4
	l2mem_rdata = 256'h4444444444444444444444444444444444444444444444444444444444444444;
	ipmem_read = 0;

	// is ipmem_rdata 0x69?

end : tests


endmodule : arb_tb
