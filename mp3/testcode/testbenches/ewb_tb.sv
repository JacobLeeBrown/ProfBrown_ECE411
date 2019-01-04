module ewb_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;

/* Intermediary Signals */
logic [31:0] mem_address;
logic [255:0] mem_wdata;
logic [255:0] mem_rdata;
logic mem_read;
logic mem_write;
logic mem_resp;

logic [31:0] pmem_address;
logic [255:0] pmem_wdata;
logic [255:0] pmem_rdata;
logic pmem_read;
logic pmem_write;
logic pmem_resp;

/*****   Debug Signals   *****/
logic divider;

// List of states
enum int unsigned {
    nothing,
    normal_read,
    writeback,
    stall
} state;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

/* Signals */
initial
begin
    mem_address = 0;
    mem_wdata = 0;
    mem_read = 0;
    mem_write = 0;
    pmem_rdata = 0;
    pmem_resp = 0;
    #5;
    state = nothing;
    #20;

    // A normal read
    state = normal_read;
    mem_address = 21;
    mem_read = 1;
    #40; // Wait for physical memory
    pmem_rdata = 1;
    pmem_resp = 1;
    #10; // Resp low after 1 cycle
    pmem_resp = 0;
    mem_read = 0;
    #20;

    // Intermission @ 95 ns
    state = nothing;
    mem_address = 0;
    mem_wdata = 0;
    mem_read = 0;
    mem_write = 0;
    pmem_rdata = 0;
    pmem_resp = 0;
    #40;

    // Writeback
    state = writeback;
    mem_address = 22;
    mem_wdata = 2;
    mem_write = 1;
    #20; // Immediate Read
    mem_address = 23;
    mem_wdata = 0;
    mem_write = 0;
    mem_read = 1;
    #40; // Wait for physical memory
    pmem_rdata = 3;
    pmem_resp = 1;
    #10; // Resp low after 1 cycle
    pmem_resp = 0;
    mem_read = 0;
    #40; // Wait for physical memory
    pmem_resp = 1;
    #10; // Resp low after 1 cycle
    pmem_resp = 0;
    #20;

    // Intermission @ 275 ns
    state = nothing;
    mem_address = 0;
    mem_wdata = 0;
    mem_read = 0;
    mem_write = 0;
    pmem_rdata = 0;
    pmem_resp = 0;
    #40;

    // Read during Writeback
    state = stall;
    mem_address = 22;
    mem_wdata = 2;
    mem_write = 1;
    #20; // Immediate Read
    mem_address = 23;
    mem_wdata = 0;
    mem_write = 0;
    mem_read = 1;
    #40; // Wait for physical memory
    pmem_rdata = 3;
    pmem_resp = 1;
    #10; // Resp low after 1 cycle
    pmem_resp = 0;
    mem_read = 0;
    #10; // Another read comes in
    mem_address = 24;
    mem_read = 1;
    #30; // Wait for physical memory (write)
    pmem_resp = 1;
    #10; // Resp low after 1 cycle
    pmem_resp = 0;
    #40; // Wait for physical memory (read)
    pmem_rdata = 4;
    pmem_resp = 1;
    #10; // Resp low after 1 cycle
    pmem_resp = 0;
    mem_read = 0;
    #20;

    // Intermission @ 505 ns
    state = nothing;
    mem_address = 0;
    mem_wdata = 0;
    mem_read = 0;
    mem_write = 0;
    pmem_rdata = 0;
    pmem_resp = 0;
    #40;
end

ewb ewb
(
    .*
);

endmodule : ewb_tb
