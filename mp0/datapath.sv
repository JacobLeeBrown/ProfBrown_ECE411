import rv32i_types::*;

module datapath
(
    input clk,

    /* control signals */

    // -- Inputs --

    // PC
    input load_pc,
    input pcmux_sel,
    // CMP
    input cmpmux_sel,
    input branch_funct3_t cmpop,
    // ALU
    input alu_ops aluop,
    input alumux1_sel,
    input [2:0] alumux2_sel,
    // MAR
    input load_mar,
    input marmux_sel,
    // MDR
    input load_mdr,
    // IR
    input load_ir,
    // regfile
    input load_regfile,
    input [1:0] regfilemux_sel,
    // mem_data_out
    input load_data_out,

    // -- Outputs --

    output rv32i_opcode opcode,
    output logic [2:0] funct3,
    output logic [6:0] funct7,
    output logic br_en,


    /* memory signals */
    input rv32i_word mem_rdata,
    output rv32i_word mem_address, 
    output rv32i_word mem_wdata
);

/* declare internal signals */

// PC
rv32i_word pcmux_out, pc_out, pc_plus4_out;

// CMP
rv32i_word cmpmux_out;

// ALU
rv32i_word alumux1_out, alumux2_out, alu_out;

// MDR
rv32i_word mdrreg_out;

// MAR
rv32i_word marmux_out;

// IR
rv32i_word i_imm, u_imm, b_imm, s_imm;
rv32i_reg rs1, rs2, rd;

// regfile
rv32i_word regfilemux_out, rs1_out, rs2_out;

// mem_data_out

assign pc_plus4_out = pc_out + 4;

/*
 * PC
 */
mux2 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus4_out),
    .b(alu_out),
    .f(pcmux_out)
);

pc_register pc
(
    .clk(clk),
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

/*
 * CMP
 */
mux2 cmpmux
(
    .sel(cmpmux_sel),
    .a(rs2_out),
    .b(i_imm),
    .f(cmpmux_out)
);

cmp cmp
(
    .cmpop(cmpop),
    .a(rs1_out),
    .b(cmpmux_out),
    .f(br_en)
);

/*
 * ALU
 */
mux2 alumux1
(
    .sel(alumux1_sel),
    .a(rs1_out),
    .b(pc_out),
    .f(alumux1_out)
);

mux8 alumux2
(
    .sel(alumux2_sel),
    .i0(i_imm),
    .i1(u_imm),
    .i2(b_imm),
    .i3(s_imm),
    .i4(rs2_out),
    .i5(),
    .i6(),
    .i7(),
    .f(alumux2_out)
);

alu alu
(
    .aluop(aluop),
    .a(alumux1_out), 
    .b(alumux2_out),
    .f(alu_out)
);

/*
 * MDR
 */
register mdr
(
    .clk(clk),
    .load(load_mdr),
    .in(mem_rdata),
    .out(mdrreg_out)
);

/*
 * MAR
 */
mux2 marmux
(
    .sel(marmux_sel),
    .a(pc_out),
    .b(alu_out),
    .f(marmux_out)
);

register mar
(
    .clk(clk),
    .load(load_mar),
    .in(marmux_out),
    .out(mem_address)
);

/*
 * IR
 */
IR IR
(
    .clk(clk),
    .load(load_ir),
    .in(mdrreg_out),
    .funct3(funct3),
    .funct7(funct7),
    .opcode(opcode),
    .i_imm(i_imm),
    .s_imm(s_imm),
    .b_imm(b_imm),
    .u_imm(u_imm),
    .j_imm(),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd)
);

/*
 * regfile
 */
mux4 regfilemux
(
    .sel(regfilemux_sel),
    .a(alu_out),
    .b({31'h00000000, br_en}),
    .c(u_imm),
    .d(mdrreg_out),
    .f(regfilemux_out)
);

regfile regfile
(
    .clk(clk),
    .load(load_regfile),
    .in(regfilemux_out),
    .src_a(rs1),
    .src_b(rs2),
    .dest(rd),
    .reg_a(rs1_out),
    .reg_b(rs2_out)
);

/*
 * mem_data_out
 */
register mem_data_out
(
    .clk(clk),
    .load(load_data_out),
    .in(rs2_out),
    .out(mem_wdata)
);

endmodule : datapath
