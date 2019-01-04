module staller (
	// Instruction memory signals
	input logic imem_read, imem_write,
	input logic imem_resp,

	// Data memory signals
	input logic dmem_read, dmem_write,
	input logic dmem_resp,

	// Load signals
	output logic load_fetch, load_decode, load_execute, load_memory, load_writeback
);

logic imem_stalled, dmem_stalled, load_pipeline;

staller_logic imem_stall
(
	.mem_read(imem_read), .mem_write(imem_write),
	.mem_resp(imem_resp),

	.stalled(imem_stalled)
);

staller_logic dmem_stall
(
	.mem_read(dmem_read), .mem_write(dmem_write),
	.mem_resp(dmem_resp),

	.stalled(dmem_stalled)
);

always_comb
begin
	load_pipeline = ~(imem_stalled || dmem_stalled);

	load_fetch = load_pipeline;
	load_decode = load_pipeline;
	load_execute = load_pipeline;
	load_memory = load_pipeline;	
	load_writeback = load_pipeline;
end

endmodule : staller