module testbench;

timeunit 1ns;
timeprecision 1ns;

// Inputs to CPU
logic clk;
logic imem_resp, dmem_resp;
logic dmem_read; 
logic dmem_write;
logic [3:0] dmem_byte_enable;
logic [31:0] pc_out, dmem_addr;
logic [31:0] instr_base, dmem_rdata;
logic [31:0] dmem_wdata;

/* autograder signals */
logic [31:0] write_data;
logic [31:0] write_address;
logic write;
logic [31:0] registers [32];
logic halt;

/* for performance counting */
logic flush_decode;
logic [6:0] opcode;
logic load_fetch;
logic load_decode;
logic load_execute;
logic load_memory;
logic predict_incorrect_bimodal;


logic divider;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

assign registers = dut.cpu.decode_stage.regfile.data;
assign halt = ((dut.cpu.memory_writeback_reg.st_writeback.instruction_word == 32'h00000063) | (dut.cpu.memory_writeback_reg.st_writeback.instruction_word == 32'h0000006F));

always @(posedge clk)
begin

    // dmem
    if (dmem_write & dmem_resp) begin
        write_address = dmem_addr;
        write_data = dmem_wdata;
        write = 1;
    end else begin
        write_address = 32'hx;
        write_data = 32'hx;
        write = 0;
    end
    if (halt)
    begin
        #50
		// if (halt) $finish; // This pops up a window asking if you want to finish.
        $stop;      // This simply stops.
    end
end


cpu dut(
    .*
);

// switch this between "magic_memory_dp" and "memory" to test instant memory or delayed memory.
magic_memory_dp memory
(
    .clk,

    // IN A
    // TODO: CHANGE TO SIGNAL
    .read_a(1'b1),
    .write_a(1'b0),
    .wmask_a(4'b0000),
    .address_a(pc_out),
    .wdata_a(32'h0000DEAD),

    // OUT A
    .resp_a(imem_resp),
    .rdata_a(instr_base),

    // IN B
    .read_b(dmem_read),
    .write_b(dmem_write),
    .wmask_b(dmem_byte_enable),
    .address_b(dmem_addr),
    .wdata_b(dmem_wdata),

    // OUT B
    .resp_b(dmem_resp),
    .rdata_b(dmem_rdata)
);

endmodule : testbench
