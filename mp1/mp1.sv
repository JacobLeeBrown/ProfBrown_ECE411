import rv32i_types::*;

module mp1
(
    input clk,

    /* Memory signals */
    input mem_resp,
    input [31:0] mem_rdata,
    output mem_read,
    output mem_write,
    output [3:0] mem_byte_enable,
    output [31:0] mem_address,
    output [31:0] mem_wdata
);

rv32i_opcode opcode;
logic [2:0] funct3;
logic [6:0] funct7;
logic bit30;
logic br_en;
logic load_pc;
logic load_ir;
logic load_regfile;
logic load_mar;
logic load_mdr;
logic [1:0] pcmux_sel;
logic [2:0] regfilemux_sel;
logic marmux_sel;
alu_ops aluop;
logic alumux1_sel;
logic [2:0] alumux2_sel;
branch_funct3_t cmpop;
logic cmpmux_sel;
logic load_data_out;
logic jalr;

// New Additions
load_funct3_t mdrop;


/* Instantiate MP 0 top level blocks here */

control control
(
    .clk(clk),

    /* Datapath controls */
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .br_en(br_en),

    .load_pc(load_pc),
    .load_ir(load_ir),
    .load_regfile(load_regfile),
    .load_mar(load_mar),
    .load_mdr(load_mdr),
    .mdrop(mdrop),
    .load_data_out(load_data_out),
    .pcmux_sel(pcmux_sel),
    .cmpop(cmpop),
    .alumux1_sel(alumux1_sel),
    .alumux2_sel(alumux2_sel),
    .regfilemux_sel(regfilemux_sel),
    .marmux_sel(marmux_sel),
    .cmpmux_sel(cmpmux_sel),
    .aluop(aluop),

    /* Memory signals */
    .mem_resp(mem_resp),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_byte_enable(mem_byte_enable)
);

datapath datapath
(
    .clk(clk),

    /* Control Signals */
    // -- Inputs --
    .load_pc(load_pc),
    .pcmux_sel(pcmux_sel),
    .cmpmux_sel(cmpmux_sel),
    .cmpop(cmpop),
    .aluop(aluop),
    .alumux1_sel(alumux1_sel),
    .alumux2_sel(alumux2_sel),
    .load_mar(load_mar),
    .marmux_sel(marmux_sel),
    .load_mdr(load_mdr),
    .mdrop(mdrop),
    .load_ir(load_ir),
    .load_regfile(load_regfile),
    .regfilemux_sel(regfilemux_sel),
    .load_data_out(load_data_out),

    // -- Outputs --
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .br_en(br_en),

    /* Memory Signals */
    .mem_rdata(mem_rdata),
    .mem_address(mem_address), 
    .mem_wdata(mem_wdata)
);

endmodule : mp1
