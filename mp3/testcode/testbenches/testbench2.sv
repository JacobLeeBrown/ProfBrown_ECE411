module testbench2;

timeunit 1ns;
timeprecision 1ns;

logic clk;

/* Intermediary Signals */
logic [255:0] pmem_rdata;
logic pmem_resp;
logic [31:0] pmem_address;
logic [255:0] pmem_wdata;
logic pmem_read;
logic pmem_write;

/* autograder signals */
logic [31:0] write_data;
logic [31:0] write_address;
logic write;
logic [31:0] registers [32];
logic halt;

/*****   Debug Signals   *****/
logic divider;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

assign registers = dut.cpu.decode_stage.regfile.data;
assign halt = ((dut.cpu.memory_writeback_reg.st_writeback.instruction_word == 32'h00000063) | (dut.cpu.memory_writeback_reg.st_writeback.instruction_word == 32'h0000006F));

always @(posedge clk)
begin
    if (pmem_write & pmem_resp) begin
        write_address = pmem_address[31:5];
        write_data = pmem_wdata;
        write = 1;
    end else begin
        write_address = 27'hx;
        write_data = 256'hx;
        write = 0;
    end
    if (halt)
    begin
        #50
		// if (halt) $finish; // This pops up a window asking if you want to finish.
        $stop;      // This simply stops.
    end
end

toplevel dut
(
    .*
);


physical_memory memory
(
    .clk(clk),
    .read(pmem_read),
    .write(pmem_write),
    .address(pmem_address),
    .wdata(pmem_wdata),
    .resp(pmem_resp),
    .rdata(pmem_rdata)
);

endmodule : testbench2
