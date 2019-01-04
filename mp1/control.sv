import rv32i_types::*; /* Import types defined in rv32i_types.sv */

module control
(
    input clk,

    /* Datapath controls */
    input rv32i_opcode opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input logic br_en,

    output logic load_pc,
    output logic load_ir,
    output logic load_regfile,
    output logic load_mar,
    output logic load_mdr,
    output load_funct3_t mdrop,
    output logic load_data_out,
    output logic [1:0] pcmux_sel,
    output branch_funct3_t cmpop,
    output logic alumux1_sel,
    output logic [2:0] alumux2_sel,
    output logic [2:0] regfilemux_sel,
    output logic marmux_sel,
    output logic cmpmux_sel,
    output alu_ops aluop,

    /* Memory signals */
    input mem_resp,
    output logic mem_read,
    output logic mem_write,
    output rv32i_mem_wmask mem_byte_enable
);

enum int unsigned {
    /* List of states */
    fetch1,
    fetch2,
    fetch3,
    decode,
    s_imm,
    br,
    calc_addr,
    ldr1,
    ldr2,
    str1,
    str2,
    s_auipc,
    s_lui,
    s_reg,
    s_j1,
    s_j2
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    load_pc = 1'b0;
    load_ir = 1'b0;
    load_regfile = 1'b0;
    load_mar = 1'b0;
    load_mdr = 1'b0;
    load_data_out = 1'b0;
    pcmux_sel = 2'b00;
    cmpop = branch_funct3_t'(funct3);
    alumux1_sel = 1'b0;
    alumux2_sel = 3'b000;
    regfilemux_sel = 3'b000;
    marmux_sel = 1'b0;
    cmpmux_sel = 1'b0;
    aluop = alu_ops'(funct3);
    mem_read = 1'b0;
    mem_write = 1'b0;
    mem_byte_enable = 4'b1111;

    // New Additions
    mdrop = load_funct3_t'(funct3);

    /* Actions for each state */
    case(state)
        fetch1: begin
            /* MAR <= PC */
            load_mar = 1;
        end

        fetch2: begin
            /* Read memory */
            mem_read = 1;
            load_mdr = 1;
        end

        fetch3: begin
            /* Load IR */
            load_ir = 1;
        end

        decode: /* Do nothing */;

        /* Where the real fun begins */

        // Register-Immediate Ops
        s_imm: begin
            /* DR <= rs1 OP i_imm */
            load_regfile = 1;

            case(arith_funct3_t'(funct3))
                slt: begin
                    cmpop = blt;
                    regfilemux_sel = 1;
                    cmpmux_sel = 1;
                end

                sltu: begin
                    cmpop = bltu;
                    regfilemux_sel = 1;
                    cmpmux_sel = 1;
                end

                sr: begin
                    // Check for SRAI vs SRLI
                    if (funct7[5] == 1)
                        aluop = alu_sra;
                    else
                        /* Nothing */;
                end

                // All other ops just follow default signals

            endcase

            /* PC <= PC + 4 */
            load_pc = 1;
        end

        // BR
        br: begin
            /* PC <= PC + (br_en ? b_imm : 4) */
            pcmux_sel = br_en;
            // PC is the first input to the ALU
            alumux1_sel = 1;
            // The b-type immediate is the third input to alumux2
            alumux2_sel = 2;
            // In the case of br, funct3 is some random bits so we
            // must explicitly set the aluop
            aluop = alu_add;
            // Load the PC
            load_pc = 1; 
        end

        /* Memory Instructions */
        calc_addr: begin
            // In the case of lw and sw, funct3 is some random bits so we
            // must explicitly set the aluop
            aluop = alu_add;
            if (opcode[5] == 0)
                begin
                    /* MAR <= rs1 + i_imm */
                    // Nothing since alumux2_sel is already i-type immediate
                end
            else // opcode[5] == 1
                begin
                    /* MAR <= rs1 + s_imm */
                    // s-type immediate is 4th input to alumux2
                    alumux2_sel = 3;
                    /* data_out <= rs2 */
                    load_data_out = 1;
                end
            // alu_out is the 2nd input to the marmux
            marmux_sel = 1;
            load_mar = 1;
        end

        // LW
        ldr1: begin
            /* Read memory */
            mem_read = 1;
            load_mdr = 1;
        end

        ldr2: begin
            /* DR <= MDR */
            load_regfile = 1;

            // By design, mdrop will always be the appropriate value for any of 
            // the 5 load instructions, thus the defaults suffice and no more
            // control logic needs to be added LW

            // mdrmod_out is the 4th input to the regfilemux
            regfilemux_sel = 3;
            /* PC <= PC + 4 */
            load_pc = 1;
        end

        // SW
        str1: begin
            /* Write memory */
            case(store_funct3_t'(funct3))
                sb: mem_byte_enable = 4'b0001;
                sh: mem_byte_enable = 4'b0011;
                //sw: Just uses default signal
            endcase
            
            mem_write = 1;
        end

        str2: begin
            /* PC <= PC + 4 */
            load_pc = 1;
        end

        /***********************/

        // AUIPC
        s_auipc: begin
            /* DR <= PC + u_imm */
            load_regfile = 1;
            // PC is the first input to the ALU
            alumux1_sel = 1;
            // The u-type immediate is the second input to alumux2
            alumux2_sel = 1;
            // In the case of auipc, funct3 is some random bits so we
            // must explicitly set the aluop
            aluop = alu_add;
            /* PC <= PC + 4 */
            load_pc = 1;
        end

        // LUI 
        s_lui: begin
            /* DR <= u_imm */
            load_regfile = 1;
            // the u-type immediate is the third input to the regfile
            regfilemux_sel = 2;
            /* PC <= PC + 4 */
            load_pc = 1;
        end

        // Register-Register Ops
        s_reg: begin
            /* DR <= rs1 OP rs2 */
            load_regfile = 1;
            // rs2 is the 6th input to alumux2
            alumux2_sel = 5;

            case(arith_funct3_t'(funct3))
                add: if (funct7[5]) aluop = alu_sub;

                slt: begin
                    cmpop = blt;
                    regfilemux_sel = 1;
                    // cmpmux_sel is 0 (rs2) by default
                end

                sltu: begin
                    cmpop = bltu;
                    regfilemux_sel = 1;
                    // cmpmux_sel is 0 (rs2) by default
                end

                sr: if (funct7[5]) aluop = alu_sra;

                // All other ops just follow default signals

            endcase

            /* PC <= PC + 4 */
            load_pc = 1;
        end

        /* Jump Instructions */

        // JAL and JALR
        s_j1: begin
            /* DR <= PC + 4 */
            load_regfile = 1;
            // PC+4 is the 5th input to regfilemux
            regfilemux_sel = 4;
        end

        s_j2: begin
            if(opcode[3] == 1) begin
                /* PC <= PC + offset */
                alumux1_sel = 1;
                // The j-type immediate is the 5th input to alumux2
                alumux2_sel = 4;
                // In the case of jal, funct3 is some random bits so we
                // must explicitly set the aluop
                aluop = alu_add;
                // alu_out is 2nd input to pcmux
                pcmux_sel = 1;
            end
            else /* opcode[3] == 0 */ begin
                /* PC <= rs1 + offset */
                // rs1_out is the 1st input to alumux1 (deafult)
                // The i-type immediate is the 1st input to alumux2 (default)
                // In the case of jalr, funct3 is already alu_add
                // Masked alu_out is 3rd input to pcmux
                pcmux_sel = 2;
            end
                // Now load the value into the PC
                load_pc = 1;
        end

        /*********************/

        default: /* Do nothing */;
    endcase
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
    next_state = state;
    case(state)
        fetch1: next_state = fetch2;
        fetch2: if (mem_resp) next_state = fetch3;
        fetch3: next_state = decode;
        
        decode: begin
            case(opcode)
                op_imm: next_state = s_imm;
                op_br: next_state = br;
                op_load: next_state = calc_addr;
                op_store: next_state = calc_addr;
                op_auipc: next_state = s_auipc;
                op_lui: next_state = s_lui;
                op_reg: next_state = s_reg;
                op_jal: next_state = s_j1;
                op_jalr: next_state = s_j1;
                default: $display("Unknown opcode");
            endcase
        end

        // Memory Instruction States
        calc_addr: begin
            if(opcode[5] == 0)
                next_state = ldr1;
            else // opcode[5] == 1
                next_state = str1;
        end
        ldr1: if (mem_resp) next_state = ldr2;
        str1: if (mem_resp) next_state = str2;

        // Jump Instruction States
        s_j1:  next_state = s_j2;

        default: next_state = fetch1;
    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : control
