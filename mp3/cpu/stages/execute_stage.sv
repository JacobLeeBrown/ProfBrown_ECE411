import rv32i_types::*;
import pipeline_types::*;

module execute_stage (
    input clk,    // Clock
    
    // Inputs (from previous)
    input control_word cw_execute,
    input storage_t st_execute,
    input forward_info fi_execute,

    // Outputs
    output logic is_branch,
    output logic jump_en,
    output rv32i_word jump_addr,
    output storage_t st_memory_
);

rv32i_word alu_out, marmux_out;
rv32i_word aluforwardmux1_out, aluforwardmux2_out;
rv32i_word cmpforwardmux1_out, cmpforwardmux2_out;
logic br_en;

// alu
alu alu
(
    .aluop(cw_execute.aluop),
    .a(aluforwardmux1_out), .b(aluforwardmux2_out),
    .f(alu_out)
);

mux4 aluforwardmux1
(
    .sel(fi_execute.aluforwardmux1_sel),
    .a(st_execute.alumux1_out),
    .b(fi_execute.memory_val),
    .c(fi_execute.writeback_val),
    .d(),
    .z(aluforwardmux1_out)
);

mux4 aluforwardmux2
(
    .sel(fi_execute.aluforwardmux2_sel),
    .a(st_execute.alumux2_out),
    .b(fi_execute.memory_val),
    .c(fi_execute.writeback_val),
    .d(),
    .z(aluforwardmux2_out)
);

// marmux
mux2 marmux
(
    .sel(cw_execute.marmux_sel),
    .a(st_execute.pc),
    .b(alu_out),
    .z(marmux_out)
);

// cmp
cmp cmp
(
    .cmpop(cw_execute.cmpop),
    .a(cmpforwardmux1_out), .b(cmpforwardmux2_out),
    .br_en(br_en)
);

mux4 cmpforwardmux1
(
    .sel(fi_execute.cmpforwardmux1_sel),
    .a(st_execute.rs1_out),
    .b(fi_execute.memory_val),
    .c(fi_execute.writeback_val),
    .d(),
    .z(cmpforwardmux1_out)
);

mux4 cmpforwardmux2
(
    .sel(fi_execute.cmpforwardmux2_sel),
    .a(st_execute.cmpmux_out),
    .b(fi_execute.memory_val),
    .c(fi_execute.writeback_val),
    .d(),
    .z(cmpforwardmux2_out)
);

always_comb
begin
    // Storage
    st_memory_ = st_execute;

    st_memory_.alu_out = alu_out;

    st_memory_.br_en = {31'b0, br_en};

    st_memory_.marmux_out = marmux_out;

    is_branch = 0;

    if(fi_execute.cmpforwardmux1_sel == 2'b01)
        st_memory_.rs1_out = fi_execute.memory_val;
    else if(fi_execute.cmpforwardmux1_sel == 2'b10)
        st_memory_.rs1_out = fi_execute.writeback_val;

    if(fi_execute.cmpforwardmux2_sel == 2'b01)
        st_memory_.rs2_out = fi_execute.memory_val;
    else if(fi_execute.cmpforwardmux2_sel == 2'b10)
        st_memory_.rs2_out = fi_execute.writeback_val;


    // Check if we should jump
    case(cw_execute.jump_type)

        // None
        2'b00: begin
            jump_addr = 32'h0000DEAD;
            jump_en = 0;
        end

        // Branch
        2'b01: begin
            jump_addr = alu_out;
            if(br_en)
                jump_en = 1;
            else
                jump_en = 0;
            is_branch = 1;
        end

        // JAL
        2'b10: begin
            jump_addr = alu_out;
            jump_en = 1;
            is_branch = 1;
        end

        // JALR
        2'b11: begin
            jump_addr = alu_out & 32'hfffe;
            jump_en = 1;
            is_branch = 1;
        end

    endcase // cw_execute.jump_type
end

endmodule : execute_stage