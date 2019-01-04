import rv32i_types::*;
import pipeline_types::*;

module control_rom (
	input rv32i_opcode opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,

	output control_word out
);

// Set control_word based on opcode

/* NOTE: This is just the cpu control logic from previous mp's but gutted since
 * we aren't worried about loads in the control word. Additionally, note how we
 * are *not* given br_en in this situation, unlike the non-pipelined cpu control
 * so the 1 assignment with it is also commented out.
 * All such comments are made with "//--" so we can easily locate what the
 * control word is not accounting for.
 */
always_comb
begin
    /* Default assignments */
    out.opcode = opcode;
    out.funct3 = funct3;
    out.funct7 = funct7;
    
    out.alumux1_sel = 1'b0;
    out.alumux2_sel = 3'b000;
    out.cmpmux_sel = 1'b0;

    out.cmpop = branch_funct3_t'(funct3);
    out.aluop = alu_ops'(funct3);
    out.jump_type = 2'b00;
    // out.pcmux_sel = 1'b0;

    out.mem_read = 0;
    out.mem_write = 0;
    out.mem_byte_enable = 4'b1111;

    out.regfilemux_sel = 3'b000;
    out.load_regfile = 1'b0;
    out.marmux_sel = 1'b0;


    /* Actions for each opcode */
    case(opcode)

        // Register-Immediate Ops
        op_imm: begin
            /* DR <= rs1 OP i_imm */
            out.load_regfile = 1;

            case(arith_funct3_t'(funct3))
                slt: begin
                    out.cmpop = blt;
                    out.regfilemux_sel = 1;
                    out.cmpmux_sel = 1;
                end

                sltu: begin
                    out.cmpop = bltu;
                    out.regfilemux_sel = 1;
                    out.cmpmux_sel = 1;
                end

                sr: begin
                    // Check for SRAI vs SRLI
                    if (funct7[5])
                        out.aluop = alu_sra;
                    else
                        out.aluop = alu_srl;
                end

                // All other ops just follow default signals
                default: /* Do nothing */;

            endcase

            /* PC <= PC + 4 */
            //--load_pc = 1;
        end

        // BR
        op_br: begin
            /* PC <= PC + (br_en ? b_imm : 4) */
            //--pcmux_sel = br_en;
            out.jump_type = 1;
            // PC is the first input to the ALU
            out.alumux1_sel = 1;
            // The b-type immediate is the third input to alumux2
            out.alumux2_sel = 2;
            // In the case of br, funct3 is some random bits so we
            // must explicitly set the aluop
            out.aluop = alu_add;
            // Load the PC
            //--load_pc = 1; 
        end

        /* Memory Instructions */
        op_load: begin
            // Replaces calc_addr & ldr*

            // Calc_addr
            out.aluop = alu_add;
            out.marmux_sel = 1;

            // ldr1
            out.mem_read = 1;

            // ldr2
            out.regfilemux_sel = 3;
            out.load_regfile = 1;
        end

        op_store: begin
            // Replaces calc_addr & str* 

            // Calc_addr
            out.aluop = alu_add;
            out.alumux2_sel = 3;
            out.marmux_sel = 1;

            // str1
            out.mem_write = 1;
            case(funct3)

                3'b000: out.mem_byte_enable = 4'b0001;

                3'b001: out.mem_byte_enable = 4'b0011;

                3'b010: out.mem_byte_enable = 4'b1111;

                default: out.mem_byte_enable = 4'b1111;
				endcase
				
            // str2
            // Nothing

        end

        // AUIPC
        op_auipc: begin
            /* DR <= PC + u_imm */
            out.load_regfile = 1;
            // PC is the first input to the ALU
            out.alumux1_sel = 1;
            // The u-type immediate is the second input to alumux2
            out.alumux2_sel = 1;
            // In the case of auipc, funct3 is some random bits so we
            // must explicitly set the aluop
            out.aluop = alu_add;
            /* PC <= PC + 4 */
            //--load_pc = 1;
        end

        // LUI 
        op_lui: begin
            /* DR <= u_imm */
            out.load_regfile = 1;
            // the u-type immediate is the third input to the regfile
            out.regfilemux_sel = 2;
            /* PC <= PC + 4 */
            //--load_pc = 1;
        end

        // Register-Register Ops
        op_reg: begin
            /* DR <= rs1 OP rs2 */
            out.load_regfile = 1;
            // rs2 is the 6th input to alumux2
            out.alumux2_sel = 5;

            case(arith_funct3_t'(funct3))
                add: if (funct7[5]) out.aluop = alu_sub;

                slt: begin
                    out.cmpop = blt;
                    out.regfilemux_sel = 1;
                    // cmpmux_sel is 0 (rs2) by default
                end

                sltu: begin
                    out.cmpop = bltu;
                    out.regfilemux_sel = 1;
                    // cmpmux_sel is 0 (rs2) by default
                end

                sr: if (funct7[5]) out.aluop = alu_sra;

                // All other ops just follow default signals
                default: /* Do nothing */;

            endcase

            /* PC <= PC + 4 */
            //--load_pc = 1;
        end

        /* Jump Instructions */
        op_jal: begin
            //--load_pc = 1;
            out.jump_type = 2;
           
            out.alumux1_sel = 1;
            out.alumux2_sel = 4; // select j_imm
            out.aluop = alu_add;

            out.regfilemux_sel = 4; // select pc + 4
            out.load_regfile = 1;

        end // s_jal

        op_jalr: begin
            //--load_pc = 1;
            out.jump_type = 3;

            out.alumux1_sel = 0;
            out.alumux2_sel = 0; // select i_imm
            out.aluop = alu_add;

            out.regfilemux_sel = 4; // select pc + 4
            out.load_regfile = 1;

        end // s_jalr

        /*********************/

        default: out = 0;
    endcase

end

endmodule : control_rom