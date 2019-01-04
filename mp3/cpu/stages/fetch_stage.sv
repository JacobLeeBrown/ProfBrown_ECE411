import rv32i_types::*;
import pipeline_types::*;

module fetch_stage (
	input clk,    // Clock
	
	// Inputs
	input logic revert_pc,
	input logic is_branch,
	input logic jump_en,
	// input rv32i_word alu_out,
	input rv32i_word jump_addr,
	input rv32i_word pc_out,
	input rv32i_word prev_pc,

	// Outputs
	output rv32i_word pcmux_out,
	output logic br_predict,
	output logic br_predict_bimodal
);

rv32i_word pc_plus4;

always_comb
begin
	pc_plus4 = pc_out + 4;
end

// pcmux
mux2 pcmux
(
	.sel(revert_pc | br_predict),
	.a(pc_plus4),
	.b(jump_addr),
	// TODO: ADD IN PREDICTIVE JUMPING
	.z(pcmux_out)
);

/*
mux4 pcmux
	.a(pc_plus4),
	.b(jump_addr),
	.c(backtrack_pc)

	.z(pcmux_out)
*/

// TODO: OTHER IMPLEMENTATIONS NEED OPCODE/INSTR
static_not_taken branch_predict
(
	.br_predict
);

global_2_level_bht global_2_level_bht
(
	.clk,

	// write signals
	.is_branch,
	.prev_pc(prev_pc[7:0]),
	.branch_taken(jump_en), 

	// read siggnals
	.curr_pc(pc_out[7:0]), // type is bht_array_length from bht.sv
	.br_predict(br_predict_bimodal)
);

endmodule : fetch_stage