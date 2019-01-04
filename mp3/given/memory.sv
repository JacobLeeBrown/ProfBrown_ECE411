/*
 * Magic memory
 */
module memory
(
    input clk,

    /* Port A */
    input read_a,
    input write_a,
    input [3:0] wmask_a,
    input [31:0] address_a,
    input [31:0] wdata_a,
    output logic resp_a,
    output logic [31:0] rdata_a,

    /* Port B */
    input read_b,
    input write_b,
    input [3:0] wmask_b,
    input [31:0] address_b,
    input [31:0] wdata_b,
    output logic resp_b,
    output logic [31:0] rdata_b
);

timeunit 1ns;
timeprecision 1ns;

parameter DELAY_MEM = 30;

logic [7:0] mem [2**(27)]; //only get fraction of 4GB addressable space due to modelsim limits
logic [26:0] internal_address_a;
logic [26:0] internal_address_b;
logic ready_a;
logic ready_b;

/* Initialize memory contents from memory.lst file */
initial
begin
    $readmemh("memory.lst", mem);
end

enum int unsigned {
    idle_a,
    busy_a,
    respond_a
} state_a, next_state_a;

enum int unsigned {
    idle_b,
    busy_b,
    respond_b
} state_b, next_state_b;

/* Calculate internal address */
assign internal_address_a = address_a[26:0];
assign internal_address_b = address_b[26:0];

always @(posedge clk)
begin
    /* Default */
    resp_a = 1'b0;

    next_state_a = state_a;

    case(state_a)
        idle_a: begin
            if (read_a | write_a) begin
                next_state_a = busy_a;
                ready_a <= #DELAY_MEM 1;
            end
        end

        busy_a: begin
            if (ready_a == 1) begin
                    if (write_a)
                    begin
                       if (wmask_a[3])
                           mem[internal_address_a+3] <= wdata_a[31:24];

                       if (wmask_a[2])
                           mem[internal_address_a+2] <= wdata_a[23:16];

                       if (wmask_a[1])
                           mem[internal_address_a+1] <= wdata_a[15:8];

                       if (wmask_a[0])
                           mem[internal_address_a] <= wdata_a[7:0];
                    end

                rdata_a = {mem[internal_address_a+3], mem[internal_address_a+2], mem[internal_address_a+1], mem[internal_address_a]};
                resp_a = 1;

                next_state_a = respond_a;
            end
        end

        respond_a: begin
            ready_a <= 0;
            next_state_a = idle_a;
        end

        default: next_state_a = idle_a;
    endcase
end

always @(posedge clk)
begin
    /* Default */
    resp_b = 1'b0;

    next_state_b = state_b;

    case(state_b)
        idle_b: begin
            if (read_b | write_b) begin
                next_state_b = busy_b;
                ready_b <= #DELAY_MEM 1;
            end
        end

        busy_b: begin
            if (ready_b == 1) begin
                    if (write_b)
                    begin
                       if (wmask_b[3])
                           mem[internal_address_b+3] <= wdata_b[31:24];

                       if (wmask_b[2])
                           mem[internal_address_b+2] <= wdata_b[23:16];

                       if (wmask_b[1])
                           mem[internal_address_b+1] <= wdata_b[15:8];

                       if (wmask_b[0])
                           mem[internal_address_b] <= wdata_b[7:0];
                    end

                rdata_b = {mem[internal_address_b+3], mem[internal_address_b+2], mem[internal_address_b+1], mem[internal_address_b]};
                resp_b = 1;

                next_state_b = respond_b;
            end
        end

        respond_b: begin
            ready_b <= 0;
            next_state_b = idle_b;
        end

        default: next_state_b = idle_b;
    endcase
end

always_ff @(posedge clk)
begin : next_state_assignment
    state_a <= next_state_a;
    state_b <= next_state_b;
end

endmodule : memory
