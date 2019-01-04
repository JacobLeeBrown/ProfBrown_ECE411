import rv32i_types::*;
import pipeline_types::*;

module fetch_decode_reg (
	input clk,    // Clock
	input logic load,
	input logic flush,

	// Inputs
	input rv32i_word pcmux_out,
	input rv32i_word instr_base,
	input logic br_predict,
	input logic br_predict_bimodal,

	// Outputs
	output rv32i_word pc_out,
	output rv32i_opcode opcode,
	output logic [2:0] funct3,
	output logic [6:0] funct7,
	output storage_t st_decode
);

logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rd;
rv32i_opcode pre_opcode;

initial
begin
	st_decode.pc = 0;
	st_decode.pc_plus4 = 0;
	st_decode.pcmux_out = 0;
	
	st_decode.br_predict = 0;
	st_decode.rs1_out = 0;
	st_decode.rs2_out = 0;
	
	st_decode.alumux1_out = 0;
	st_decode.alumux2_out = 0;
	st_decode.alu_out = 0;

	st_decode.cmpmux_out = 0;
	st_decode.br_en = 0;

	st_decode.marmux_out = 0;
	st_decode.mem_rdata = 0;
	st_decode.instruction_word = 0;
end

/* Main Storage Registers */
pc_register pc
(
	.clk,
	.load(load),
	.in(pcmux_out),
	.out(pc_out)
);

ir IR
(
		.clk,
		.load(load),
		.in(instr_base),
		.funct3,
		.funct7,
		.opcode(pre_opcode),
		.i_imm(st_decode.i_imm),
		.s_imm(st_decode.s_imm),
		.b_imm(st_decode.b_imm),
		.u_imm(st_decode.u_imm),
		.j_imm(st_decode.j_imm),
		.rs1(st_decode.rs1),
		.rs2(st_decode.rs2),
		.rd(st_decode.rd)
);

always_comb
begin
	if(flush)
		opcode = rv32i_opcode'(0);
	else
		opcode = pre_opcode;
end


/* Other Storage Registers */
always_ff @(posedge clk)
begin
	if(load) begin
		st_decode.pc = pc_out;
		st_decode.pc_plus4 = pc_out + 4;
		st_decode.pcmux_out = pcmux_out;
		
		st_decode.br_predict = br_predict;
		st_decode.br_predict_bimodal = br_predict_bimodal;
		st_decode.rs1_out = 0;
		st_decode.rs2_out = 0;
		
		st_decode.alumux1_out = 0;
		st_decode.alumux2_out = 0;
		st_decode.alu_out = 0;

		st_decode.cmpmux_out = 0;
		st_decode.br_en = 0;

		st_decode.marmux_out = 0;
		st_decode.mem_rdata = 0;
		st_decode.instruction_word = instr_base;
	end
end

endmodule : fetch_decode_reg