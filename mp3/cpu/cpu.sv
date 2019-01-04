import rv32i_types::*;
import pipeline_types::*;

// Top-level module instantiating the various pipeline stages and L1 cache
module cpu (
    input clk,

    // Inputs from memory
    input logic imem_resp, dmem_resp,
    input rv32i_word instr_base, dmem_rdata,

    // Outputs to memory
    output logic dmem_read, dmem_write,
    output rv32i_mem_wmask dmem_byte_enable,
    output rv32i_word pc_out, dmem_addr, dmem_wdata,

    /* for performance counting */
    output logic flush_decode,
    output rv32i_opcode opcode,
    output logic load_fetch,
    output logic load_decode,
    output logic load_execute,
    output logic load_memory,
    output logic predict_incorrect_bimodal
    /* end performance counting */
);

/***** Internal Signals *****/

// Fetch
logic revert_pc, br_predict, br_predict_bimodal;
//storage_t st_fetch; unused
rv32i_word pcmux_out, alu_out;
logic [2:0] funct3;
logic [6:0] funct7;

// Decode
storage_t st_decode;
rv32i_word rs1_out, rs2_out;

// Execute
logic jump_en;
rv32i_word jump_addr;
logic is_branch;
control_word cw_execute_, cw_execute;
storage_t st_execute_, st_execute;
forward_info fi_execute;

// Memory
control_word cw_memory;
storage_t st_memory_, st_memory;

// Writeback
logic load_writeback; // TODO: LATER?
control_word cw_writeback;
storage_t st_writeback_, st_writeback;

rv32i_word reg_wdata;

/*****   End Internal   *****/

/*****  Debug Signals  *****/
rv32i_opcode opcode_fetch;
assign opcode_fetch = rv32i_opcode'(instr_base[6:0]);

// This is the flushing code: it compares jump enable
// with what we predicted.

// jump:    the prediction messed up. we're going to the correct PC now.
// jump_en: is compared prediction via an xor.

// if there's a mismatch, we predicted wrong.
// if they're matching, we predicted right.
// the result of the XOR is `jump`.
always_comb
begin
    // if not jump instr (in execute) -> predict
    // if jump instr -> jump_en
    revert_pc = 1'b0;
    flush_decode = 1'b0;
	 predict_incorrect_bimodal = 1'b0;
    if(cw_execute.jump_type != 2'b00) begin
        
        // Check if we predicted right
        // LHS: computed jump. RHS: predicted jump.
        flush_decode = jump_en ^ st_execute.br_predict;
        predict_incorrect_bimodal = jump_en ^ st_execute.br_predict_bimodal;

        // TODO: ONLY WORKS WITH CURRENT STATIC NOT TAKEN PREDICTION
        // FUTURE: IF PREDICTED JUMP, NEED TO BACKTRACK PC
        revert_pc = flush_decode;

    end
end

// instantiate fetch
fetch_stage fetch_stage
(
    .clk,

    .revert_pc,
    .is_branch,
    .jump_en,
    .jump_addr,
    .pc_out,
    .prev_pc(st_execute.pc),

    .pcmux_out,
    .br_predict,
    .br_predict_bimodal
);
// stage 1 register: fetch / decode
fetch_decode_reg fetch_decode_reg
(
    .clk,
    .load(load_fetch),
    .flush(flush_decode),

    .pcmux_out,
    .instr_base,
    .br_predict,
    .br_predict_bimodal,

    .pc_out,
    .opcode,
    .funct3,
    .funct7,
    .st_decode
);

// instantiate decode
decode_stage decode_stage
(
    .clk,
    .load(load_decode),
    .flush(flush_decode),   // If they do not match, flush

    .opcode,
    .funct3,
    .funct7,
    .st_decode,

    .rd(st_writeback.rd),
    .reg_wdata,
    .load_regfile(cw_writeback.load_regfile),

    .cw_execute_,
    .st_execute_
);
// stage 2 register: decode / execute
decode_execute_reg decode_execute_reg
(
    .clk,
    .load(load_decode),

    .cw_execute_,
    .st_execute_,

    .cw_execute,
    .st_execute
);

// preprocessing for execute
forward_unit forward_execute
(
    .cw_execute,
    .st_execute,

    .cw_memory,
    .st_memory_forward(st_writeback_),

    .cw_writeback,
    .st_writeback_forward(st_writeback),
    .reg_wdata,

    .fi_execute
);

// instantiate execute
execute_stage execute_stage
(
    .clk,

    .cw_execute,
    .st_execute,
    .fi_execute,

    .is_branch,
    .jump_en,
    .jump_addr,
    .st_memory_
);
// stage 3 register: execute / memory
execute_memory_reg execute_memory_reg
(
    .clk,
    .load(load_execute),

    .cw_execute,
    .st_memory_,

    .cw_memory,
    .st_memory
);

// instantiate memory
memory_stage memory_stage
(
    .clk,

    .cw_memory,
    .st_memory,

    .dmem_resp,
    .dmem_rdata,

    .dmem_read, .dmem_write,
    .dmem_byte_enable,
    .dmem_addr, .dmem_wdata,
    .st_writeback_
);
// stage 4 register: memory / writeback
memory_writeback_reg memory_writeback_reg
(
    .clk,
    .load(load_memory),

    .cw_memory,
    .st_writeback_,

    .cw_writeback,
    .st_writeback
);

// instantiate writeback
writeback_stage writeback_stage
(
    .clk,

    .cw_writeback,
    .st_writeback,

    .reg_wdata
);

staller staller
(
    .imem_read(1'b1), .imem_write(1'b0),
    .imem_resp,

    .dmem_read, .dmem_write,
    .dmem_resp,

    .load_fetch, .load_decode, 
    .load_execute, .load_memory, 
    .load_writeback
);

endmodule : cpu