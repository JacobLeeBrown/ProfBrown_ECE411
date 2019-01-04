module mp1_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic mem_resp;
logic mem_read;
logic mem_write;
logic [3:0] mem_byte_enable;
logic [31:0] mem_address;
logic [31:0] mem_rdata;
logic [31:0] mem_wdata;
logic [31:0] write_data;
logic [31:0] write_address;
logic write;
logic [31:0] registers [32];

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

assign registers = dut.datapath.regfile.data;
assign halt = ((dut.datapath.IR.data == 32'h00000063) | (dut.datapath.IR.data == 32'h0000006F));

always @(posedge clk)
begin
    if (mem_write & mem_resp) begin
        write_address = mem_address;
        write_data = mem_wdata;
        write = 1;
    end else begin
        write_address = 32'hx;
        write_data = 32'hx;
        write = 0;
    end
    if (halt) $finish;
end

mp1 dut
(
    .clk,
    .mem_resp,
    .mem_rdata,
    .mem_read,
    .mem_write,
    .mem_byte_enable,
    .mem_address,
    .mem_wdata
);

memory memory
(
    .clk,
    .read(mem_read),
    .write(mem_write),
    .wmask(mem_byte_enable),
    .address(mem_address),
    .wdata(mem_wdata),
    .resp(mem_resp),
    .rdata(mem_rdata)
);

endmodule : mp1_tb
