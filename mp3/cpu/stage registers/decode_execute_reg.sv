import rv32i_types::*;
import pipeline_types::*;

module decode_execute_reg (
	input clk,    // Clock
	input logic load,

	// Inputs
	input control_word cw_execute_,
	input storage_t st_execute_,

	// Outputs
	output control_word cw_execute,
	output storage_t st_execute
);

control_word_register cw_decode_execute_reg
(
	.clk,
	.load,
	.in(cw_execute_),
	.out(cw_execute)
);

storage_register st_decode_execute_reg
(
	.clk,
	.load,
	.in(st_execute_),
	.out(st_execute)
);

endmodule