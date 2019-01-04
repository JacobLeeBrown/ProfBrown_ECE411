import rv32i_types::*;
import pipeline_types::*;

module memory_stage (
	input clk,    // Clock

	// Inputs
	input control_word cw_memory,
	input storage_t st_memory,

	// Inputs (from memory)
	// input logic imem_resp, dmem_resp ???
	input logic dmem_resp,
	input rv32i_word dmem_rdata,

	// Outputs
	output logic dmem_read, dmem_write,
	output rv32i_mem_wmask dmem_byte_enable,
	output rv32i_word dmem_addr, dmem_wdata,
	output storage_t st_writeback_
	// output logic WAITING

);

// TODO: STALLING LOGIC

// Set up memory
always_comb
begin
	// Calculated address
	dmem_addr = st_memory.alu_out; 

	// Reads
	dmem_read = cw_memory.mem_read;

	// Writes
	dmem_write = cw_memory.mem_write;
	dmem_byte_enable = cw_memory.mem_byte_enable;
	dmem_wdata = st_memory.rs2_out;
end

// Read data
always_comb
begin
	st_writeback_ = st_memory;
	if(dmem_resp)
		st_writeback_.mem_rdata = dmem_rdata;
end

endmodule : memory_stage