import rv32i_types::*;
import pipeline_types::*;

module forward_val (
	
	input control_word cw_memory,
	input storage_t st_memory_forward,

	output rv32i_word memory_val

);

/*
	op_lui   = 7'b0110111, //load upper immediate (U type)
    op_auipc = 7'b0010111, //add upper immediate PC (U type)
    op_jal   = 7'b1101111, //jump and link (J type)
    op_jalr  = 7'b1100111, //jump and link register (I type)
    op_br    = 7'b1100011, //branch (B type)
    op_load  = 7'b0000011, //load (I type)
    op_store = 7'b0100011, //store (S type)
    op_imm   = 7'b0010011, //arith ops with register/immediate operands (I type)
    op_reg   = 7'b0110011, //arith ops with register operands (R type)
*/

/*
	Possible data comes from
	- alu_out
	- br_en
	- u_imm
	- masked_data
	- pc_plus4
*/

always_comb
begin

	case(cw_memory.regfilemux_sel)

		3'b000: memory_val = st_memory_forward.alu_out;

		3'b001: memory_val = st_memory_forward.br_en;

		3'b010: memory_val = st_memory_forward.u_imm;
				
		3'b011: begin
		    case (load_funct3_t'(cw_memory.funct3))
		        lb:   memory_val = {{25{st_memory_forward.mem_rdata[7]}}, st_memory_forward.mem_rdata[6:0]};
		        lh:   memory_val = {{17{st_memory_forward.mem_rdata[15]}}, st_memory_forward.mem_rdata[14:0]};
		        lw:   memory_val = st_memory_forward.mem_rdata;
		        lbu:  memory_val = {{24{1'b0}}, st_memory_forward.mem_rdata[7:0]};
		        lhu:  memory_val = {{16{1'b0}}, st_memory_forward.mem_rdata[15:0]};
				default: memory_val = 0;
		    endcase		
		end		
		
		3'b100: memory_val = st_memory_forward.pc_plus4;

		default: memory_val = 0;
	endcase // cw_memory.opcode

end

endmodule : forward_val