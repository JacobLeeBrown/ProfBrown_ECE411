module staller_logic (
	// Memory signals
	input logic mem_read, mem_write,
	input logic mem_resp,

	// Stage load signals
	output logic stalled
);

/*
	mem_r/w		mem_resp	stalled
	0			0			0
	0			1			0
	1			0			1
	1			1			0
*/

assign stalled = (mem_read & ~mem_resp) || (mem_write & ~mem_resp);

endmodule : staller_logic