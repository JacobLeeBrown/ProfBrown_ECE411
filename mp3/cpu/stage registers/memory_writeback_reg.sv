import rv32i_types::*;
import pipeline_types::*;

module memory_writeback_reg (
	input clk,    // Clock
	input load,

	// Inputs
	input control_word cw_memory,
	input storage_t st_writeback_,

	// Outputs
	output control_word cw_writeback,
	output storage_t st_writeback	
);

control_word_register cw_memory_writeback_reg
(
	.clk,
	.load,
	.in(cw_memory),
	.out(cw_writeback)
);

storage_register st_memory_writeback_reg
(
	.clk,
	.load,
	.in(st_writeback_),
	.out(st_writeback)
);

endmodule : memory_writeback_reg