import rv32i_types::*;
import pipeline_types::*;

module writeback_stage (
    input clk,    // Clock
    
    // Inputs (from previous)
    input control_word cw_writeback,
    input storage_t st_writeback,

    // Outputs
    output rv32i_word reg_wdata
);

rv32i_word mem_rdata;
rv32i_word masked_data;
rv32i_word regfilemux_out;

mux8 regfilemux
(
    .sel(cw_writeback.regfilemux_sel),
    .a(st_writeback.alu_out),
    .b(st_writeback.br_en),
    .c(st_writeback.u_imm),
    .d(masked_data),
    .e(st_writeback.pc_plus4),
    .f(),
    .g(),
    .h(),
    .z(regfilemux_out)
);

always_comb
begin

    mem_rdata = st_writeback.mem_rdata;
	 
    case (load_funct3_t'(cw_writeback.funct3))
        lb:   masked_data = {{25{mem_rdata[7]}}, mem_rdata[6:0]};
        lh:   masked_data = {{17{mem_rdata[15]}}, mem_rdata[14:0]};
        lw:   masked_data = mem_rdata;
        lbu:  masked_data = {{24{1'b0}}, mem_rdata[7:0]};
        lhu:  masked_data = {{16{1'b0}}, mem_rdata[15:0]};
		  default: masked_data = 0;
    endcase

    reg_wdata = regfilemux_out;

end

endmodule : writeback_stage