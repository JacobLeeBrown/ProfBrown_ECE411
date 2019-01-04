package pipeline_types;

import rv32i_types::*;

typedef struct packed
{
    /*** From IR ***/
    rv32i_opcode opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    /*** From Control Rom ***/
    // Fetch Stage

    // Decode Stage
    logic alumux1_sel;
    logic [2:0] alumux2_sel;
    logic cmpmux_sel;

    // Execute Stage
    branch_funct3_t cmpop;
    alu_ops aluop;
    logic [1:0] jump_type;
    // logic pcmux_sel;
    logic marmux_sel;

    // Memory Stage
    logic mem_read, mem_write;
    rv32i_mem_wmask mem_byte_enable;

    // Writeback Stage
    logic [2:0] regfilemux_sel;
    logic load_regfile;

} control_word;

typedef struct packed
{
    rv32i_word pc;
    rv32i_word pc_plus4;
    rv32i_word pcmux_out;

    logic br_predict;
    logic br_predict_bimodal;
    rv32i_word rs1_out;
    rv32i_word rs2_out;

    rv32i_word i_imm;
    rv32i_word s_imm;
    rv32i_word b_imm;
    rv32i_word u_imm;
    rv32i_word j_imm;
    
    rv32i_word alumux1_out;
    rv32i_word alumux2_out;
    rv32i_word alu_out;

    rv32i_word cmpmux_out;
    rv32i_word br_en;

    rv32i_word marmux_out;
    rv32i_word mem_rdata;

    logic [4:0] rs1, rs2, rd;
    rv32i_word instruction_word;
} storage_t;

typedef struct packed
{
    logic [1:0] aluforwardmux1_sel;
    logic [1:0] aluforwardmux2_sel;

    logic [1:0] cmpforwardmux1_sel;
    logic [1:0] cmpforwardmux2_sel;
    
    rv32i_word memory_val;
    rv32i_word writeback_val;
} forward_info;

endpackage : pipeline_types