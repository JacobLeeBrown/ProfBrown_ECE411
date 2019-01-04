import rv32i_types::*;
import pipeline_types::*;

module execute_memory_reg (
	input clk,    // Clock
	input logic load,

	// Inputs
	input control_word cw_execute,
	input storage_t st_memory_,

	// Outputs
	output control_word cw_memory,
	output storage_t st_memory

);

control_word_register cw_execute_memory_reg
(
	.clk,
	.load,
	.in(cw_execute),
	.out(cw_memory)
);

storage_register st_execute_memory_reg
(
	.clk,
	.load,
	.in(st_memory_),
	.out(st_memory)
);

endmodule : execute_memory_reg