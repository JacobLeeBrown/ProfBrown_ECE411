import rv32i_types::*;
import pipeline_types::*;

module decode_stage (
    input clk,    // Clock
    input logic load,
    input logic flush,
    
    // Inputs (from previous)
    input rv32i_opcode opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input storage_t st_decode,

    // Inputs (from future)
    input logic [4:0] rd,
    input rv32i_word reg_wdata,
    input logic load_regfile,

    // Outputs
    output control_word cw_execute_,
    output storage_t st_execute_
);

rv32i_word cmpmux_out, alumux1_out, alumux2_out, rs1_out, rs2_out;
control_word cw;
logic flush_delay;
logic wbforwardmux1_sel, wbforwardmux2_sel;
rv32i_word rs1_valid, rs2_valid;

initial
begin
    flush_delay = 0;
end

// FORWARD FROM WB STAGE 

always_comb
begin
    wbforwardmux1_sel = 0;
    wbforwardmux2_sel = 0;

    // check rs1 forward
    if(st_decode.rs1 != 0) begin
        if(st_decode.rs1 == rd && load_regfile)
            wbforwardmux1_sel = 1;
    end // if(st_decode.rs1 != 0)


    // check rs2 forward
    if(st_decode.rs2 != 0) begin
        if(st_decode.rs2 == rd && load_regfile)
            wbforwardmux2_sel = 1;
    end // if(st_decode.rs2 != 0)
end

mux2 wbforwardmux1
(
    .sel(wbforwardmux1_sel),
    .a(rs1_out),
    .b(reg_wdata),
    .z(rs1_valid)
);

mux2 wbforwardmux2
(
    .sel(wbforwardmux2_sel),
    .a(rs2_out),
    .b(reg_wdata),
    .z(rs2_valid)
);

// END FORWARD

mux2 cmpmux
(
    .sel(cw_execute_.cmpmux_sel),
    .a(rs2_valid),
    .b(st_decode.i_imm),
    .z(cmpmux_out)
);

mux2 alumux1
(
    .sel(cw_execute_.alumux1_sel),
    .a(rs1_valid),
    .b(st_decode.pc),
    .z(alumux1_out)
);

mux8 alumux2
(
    .sel(cw_execute_.alumux2_sel),
    .a(st_decode.i_imm),
    .b(st_decode.u_imm),
    .c(st_decode.b_imm),
    .d(st_decode.s_imm),
    .e(st_decode.j_imm),
    .f(rs2_valid),
    .g(),
    .h(),
    .z(alumux2_out)
);

regfile regfile
(
    .clk,

    .load(load_regfile),
    .in(reg_wdata),
    .src_a(st_decode.rs1), .src_b(st_decode.rs2), .dest(rd),

    .reg_a(rs1_out), .reg_b(rs2_out)
);

control_rom control_rom
(
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .out(cw)
);

always_ff @(posedge clk)
begin
    if(load) begin
        if(flush)
            flush_delay = 1;
        else
            flush_delay = 0;
    end
end

always_comb
begin
    if(flush | flush_delay) begin
        cw_execute_ = 0;
        st_execute_ = 0;
    end
    else begin
        cw_execute_ = cw;
        st_execute_ = st_decode;
        
        st_execute_.rs1_out = rs1_valid;
        st_execute_.rs2_out = rs2_valid;

        st_execute_.alumux1_out = alumux1_out;
        st_execute_.alumux2_out = alumux2_out;

        st_execute_.cmpmux_out = cmpmux_out;
    end
end

endmodule : decode_stage