import rv32i_types::*;

module performance_counter (
	input  logic clk,
	input  logic i_miss,
	input  logic i_access,
	input  logic d_miss,
	input  logic d_access,
	input  logic l2_miss,
	input  logic l2_access,
	input  logic branch_mispredict,
	input  rv32i_opcode opcode,
    input  logic load_fetch,
    input  logic load_decode,
    input  logic load_execute,
    input  logic load_memory,
	input  logic predict_incorrect_bimodal,

    // memory intercepts
    input rv32i_word perf_mem_address,
    output rv32i_word perf_mem_rdata,
    output logic perf_mem_resp,
    input logic perf_mem_read,

    output rv32i_word perf_mem_address_out,
    input rv32i_word perf_mem_rdata_out,
    input logic perf_mem_resp_out,
    output logic perf_mem_read_out
);

// we can't actually know infer hits directly (easily, at least)
integer i_accesses = 0;
integer i_misses = 0;
integer i_hits;

integer d_accesses = 0;
integer d_misses = 0;
integer d_hits;

integer l2_accesses = 0;
integer l2_misses = 0;
integer l2_hits;

integer dynamic_mispredicts = 0;
integer branch_mispredicts = 0;
integer total_branches = 0;

integer fetch_stalls = 0;
integer decode_stalls = 0;
integer execute_stalls = 0;
integer memory_stalls = 0;

assign i_hits = i_accesses - i_misses;
assign d_hits = d_accesses - d_misses;
assign l2_hits = l2_accesses - l2_misses;

always_latch
begin
	if (i_miss)
		i_misses <= i_misses + 1;
	if (i_access)
		i_accesses <= i_accesses + 1;

	if (d_miss)
		d_misses <= d_misses + 1;
	if (d_access)
		d_accesses <= d_accesses + 1;
	
	if (l2_miss)
		l2_misses <= l2_misses + 1;
	if (l2_access)
		l2_accesses <= l2_accesses + 1;

	if (branch_mispredict)
		branch_mispredicts <= branch_mispredicts + 1;

	if (predict_incorrect_bimodal)
		dynamic_mispredicts <= dynamic_mispredicts + 1;

	if (opcode == op_br)
		total_branches = total_branches + 1;

	if (load_fetch)
		fetch_stalls <= fetch_stalls + 1;

	if (load_decode)
		decode_stalls <= decode_stalls + 1;

	if (load_execute)
		execute_stalls <= execute_stalls + 1;

	if (load_memory)
		memory_stalls <= memory_stalls + 1;

end

always_comb
begin
	perf_mem_rdata = perf_mem_rdata_out; // output the d-cache's real contents
	perf_mem_address_out = perf_mem_address;
	perf_mem_resp = perf_mem_resp_out;
	perf_mem_read_out = perf_mem_read;

	// if it's in the reserved range, we should :
	// intercept (& prevent) the read
	if (perf_mem_read)
	begin
		if (perf_mem_address == 32'hdddddd00)
			perf_mem_rdata = i_hits;
		if (perf_mem_address == 32'hdddddd01)
			perf_mem_rdata = i_misses;
		if (perf_mem_address == 32'hdddddd02)
			perf_mem_rdata = d_hits;
		if (perf_mem_address == 32'hdddddd03)
			perf_mem_rdata = d_misses;
		if (perf_mem_address == 32'hdddddd04)
			perf_mem_rdata = l2_hits;
		if (perf_mem_address == 32'hdddddd05)
			perf_mem_rdata = l2_misses;
		if (perf_mem_address == 32'hdddddd06)
			perf_mem_rdata = branch_mispredicts;
		if (perf_mem_address == 32'hdddddd07)
			perf_mem_rdata = total_branches;
		if (perf_mem_address == 32'hdddddd08)
			perf_mem_rdata = fetch_stalls;
		if (perf_mem_address == 32'hdddddd09)
			perf_mem_rdata = execute_stalls;
		if (perf_mem_address == 32'hdddddd0a)
			perf_mem_rdata = decode_stalls;
		if (perf_mem_address == 32'hdddddd0b)
			perf_mem_rdata = memory_stalls;
		if (perf_mem_address == 32'hdddddd0c)
			perf_mem_rdata = dynamic_mispredicts;
		if (perf_mem_address[31:8] == 24'hdddddd)
		begin
			perf_mem_address_out = perf_mem_address;
			perf_mem_resp = 1;
			perf_mem_read_out = 0;
		end
	end
end

endmodule : performance_counter
