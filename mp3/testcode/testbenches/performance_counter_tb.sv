module performance_counter_tb;

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
assign halt = ((dut.cpu.fetch_decode_reg.IR.data == 32'h00000063) | (dut.cpu.fetch_decode_reg.IR.data == 32'h0000006F));

// always @(posedge clk)
// begin

//     // dmem
//     if (dmem_write & dmem_resp) begin
//         write_address = dmem_addr;
//         write_data = dmem_wdata;
//         write = 1;
//     end else begin
//         write_address = 32'hx;
//         write_data = 32'hx;
//         write = 0;
//     end
//     // if (halt) $finish; // This pops up a window asking if you want to finish.
// 	if (halt) $stop;      // This simply stops.
// end

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
    // if (halt) $stop;      // This simply stops.
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

endmodule : performance_counter_tb
