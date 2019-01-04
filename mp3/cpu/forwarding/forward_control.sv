import rv32i_types::*;
import pipeline_types::*;

module forward_control (

    input control_word cw_execute,
    input storage_t st_execute,

    input control_word cw_memory,
    input storage_t st_memory_forward,

    input control_word cw_writeback,
    input storage_t st_writeback_forward,

    /*
        select decoding
        2'b00: regular
        2'b01: memory forward
        2'b10: writeback forward
        2'b11: dead
    */
    output logic [1:0] aluforwardmux1_sel, aluforwardmux2_sel,
    output logic [1:0] cmpforwardmux1_sel, cmpforwardmux2_sel

);


// 1 = Memory --- 2 = Writeback
logic op_valid1, op_valid2;     // Signifies that opcode modifies reg
logic imm_instr;

always_comb
begin

    // Default is to select original rs1, rs2
    aluforwardmux1_sel = 2'b00;
    aluforwardmux2_sel = 2'b00;

    cmpforwardmux1_sel = 2'b00;
    cmpforwardmux2_sel = 2'b00;

    // Assume both opcodes are valid
    op_valid1 = 1'b1;
    op_valid2 = 1'b1;

    // Check valid opcode (memory)
    case(cw_memory.opcode)
        op_br: op_valid1 = 1'b0;
        op_store: op_valid1 = 1'b0;
        default: ;
    endcase // cw_memory.opcode

    // Check valid opcode (writeback)
    case(cw_writeback.opcode)
        op_br: op_valid2 = 1'b0;    
        op_store: op_valid2 = 1'b0;     
        default: ;
    endcase // cw_writeback.opcode


    // Fill rs1 (alu)
    if(st_execute.rs1 != 0 && cw_execute.alumux1_sel == 0)
    begin
        if(op_valid1 && st_execute.rs1 == st_memory_forward.rd) begin
            aluforwardmux1_sel = 2'b01;
        end
        else if(op_valid2 && st_execute.rs1 == st_writeback_forward.rd) begin
            aluforwardmux1_sel = 2'b10;
        end
    end

    // Fill rs2 (alu)
    if(st_execute.rs2 != 0 && cw_execute.alumux2_sel == 5)
    begin
        if(op_valid1 && st_execute.rs2 == st_memory_forward.rd) begin
            aluforwardmux2_sel = 2'b01;
        end
        else if(op_valid2 && st_execute.rs2 == st_writeback_forward.rd) begin
            aluforwardmux2_sel = 2'b10;
        end
    end

    // Fill rs1 (cmp)
    if(st_execute.rs1 != 0)
    begin
        if(op_valid1 && st_execute.rs1 == st_memory_forward.rd) begin
            cmpforwardmux1_sel = 2'b01;
        end
        else if(op_valid2 && st_execute.rs1 == st_writeback_forward.rd) begin
            cmpforwardmux1_sel = 2'b10;
        end
    end

    // Fill rs2 (cmp)
    if(st_execute.rs2 != 0 && cw_execute.cmpmux_sel == 0)
    begin
        if(op_valid1 && st_execute.rs2 == st_memory_forward.rd) begin
            cmpforwardmux2_sel = 2'b01;
        end
        else if(op_valid2 && st_execute.rs2 == st_writeback_forward.rd) begin
            cmpforwardmux2_sel = 2'b10;
        end
    end 

end

endmodule : forward_control