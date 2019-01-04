/*
 * Magic memory
 */
module magic_memory
(
    input clk,

    /* Port A */
    input read,
    input write,
    input logic [3:0] wmask,
    input logic [31:0] address,
    input logic [31:0] wdata,
    output logic resp,
    output logic [31:0] rdata
);

timeunit 1ns;
timeprecision 1ns;

logic [7:0] mem [2**(27)]; //only get fraction of 4GB addressable space due to modelsim limits
logic [26:0] internal_address;

/* Initialize memory contents from memory.lst file */
initial
begin
    $readmemh("memory.lst", mem);
end

/* Calculate internal address */
assign internal_address = address[26:0];

/* Read */
always_comb
begin : mem_read
    rdata = {mem[internal_address+3], mem[internal_address+2], mem[internal_address+1], mem[internal_address]};
end : mem_read

/* Write */
always @(posedge clk)
begin : mem_write
    if (write)
    begin
        if (wmask[3])
        begin
            mem[internal_address+3] = wdata[31:24];
        end

        if (wmask[2])
        begin
            mem[internal_address+2] = wdata[23:16];
        end

        if (wmask[1])
        begin
            mem[internal_address+1] = wdata[15:8];
        end

        if (wmask[0])
        begin
            mem[internal_address] = wdata[7:0];
        end
    end
end : mem_write

/* Magic memory responds immediately */
assign resp = read | write;

endmodule : magic_memory
