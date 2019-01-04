module vc_tb;

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
    read_miss,
    read_hit,
    writeback_miss,
    writeback_hit,
    fill_vc,
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

    // A normal read with no data in VC
    state = read_miss;
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
    // End @ 135 ns

    // Writeback from higher mem level with no data in VC
    state = writeback_miss;
    mem_address = 22;
    mem_wdata = 2;
    mem_write = 1;
    #30; // Immediate Read
    // Need one cycle to transition to buffer stage from idle
    // Need one cycle to transition to resp stage from buffer
    // Need one cycle for higher level cache to respond to mem_resp signal
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

    // Intermission @ 285 ns
    state = nothing;
    mem_address = 0;
    mem_wdata = 0;
    mem_read = 0;
    mem_write = 0;
    pmem_rdata = 0;
    pmem_resp = 0;
    #40;
    // End @ 325 ns

    // Writeback from higher mem level with hit in VC
    state = writeback_hit;
    mem_address = 22;
    mem_wdata = 22;
    mem_write = 1;
    #20; // Immediate Read
    // Only needs two cycles since idle stage handles setup for write_hit
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
    #20;
    
    // Intermission @ 405 ns
    state = nothing;
    mem_address = 0;
    mem_wdata = 0;
    mem_read = 0;
    mem_write = 0;
    pmem_rdata = 0;
    pmem_resp = 0;
    #40;
    // End @ 445 ns

    // A read with hit in VC
    state = read_hit;
    mem_address = 22;
    mem_read = 1;
    #10; // Wait for VC response
    #10; // Higher level cache stops read after 1 cycle
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
    // End @ 545 ns

    // Filling VC
    state = fill_vc;
    mem_address = 23;
    mem_wdata = 3;
    mem_write = 1;
    #30;
    mem_address = 0;
    mem_wdata = 0;
    mem_write = 0;
    #10;
    mem_address = 24;
    mem_wdata = 4;
    mem_write = 1;
    #30;
    mem_address = 0;
    mem_wdata = 0;
    mem_write = 0;
    #10;
    mem_address = 25;
    mem_wdata = 5;
    mem_write = 1;
    #30;
    mem_address = 0;
    mem_wdata = 0;
    mem_write = 0;
    #10;
    mem_address = 26;
    mem_wdata = 6;
    mem_write = 1;
    #30;
    mem_address = 0;
    mem_wdata = 0;
    mem_write = 0;
    #10;
    mem_address = 27;
    mem_wdata = 7;
    mem_write = 1;
    #30;
    mem_address = 0;
    mem_wdata = 0;
    mem_write = 0;
    #10;
    mem_address = 28;
    mem_wdata = 8;
    mem_write = 1;
    #30;
    mem_address = 0;
    mem_wdata = 0;
    mem_write = 0;
    #10;
    mem_address = 29;
    mem_wdata = 9;
    mem_write = 1;
    #30; // Should see full go high

    // Intermission @ 815 ns
    state = nothing;
    mem_address = 0;
    mem_wdata = 0;
    mem_read = 0;
    mem_write = 0;
    pmem_rdata = 0;
    pmem_resp = 0;
    #40;
    // End @ 855 ns

    // Writeback when VC is full!!!
    state = stall;
    mem_address = 30;
    mem_wdata = 0;
    mem_write = 1;
    #50; // Ruh-roh Shaggy! We gotta get to writeback stage and wait for pmem
    pmem_resp = 1;
    #10; // Resp low after 1 cycle, in buffer state now
    pmem_resp = 0;
    #10; // Now in resp state
    #10; // Higher level cache stops read after 1 cycle
    mem_address = 31;
    mem_wdata = 0;
    mem_write = 0;
    mem_read = 1;
    #40; // Wait for physical memory (read)
    pmem_rdata = 1;
    pmem_resp = 1;
    #10; // Resp low after 1 cycle
    pmem_resp = 0;
    mem_read = 0;
    #20;

    // Intermission @ 1005 ns
    state = nothing;
    mem_address = 0;
    mem_wdata = 0;
    mem_read = 0;
    mem_write = 0;
    pmem_rdata = 0;
    pmem_resp = 0;
    #40;
    // End @ 1045 ns

end

victim_cache vc
(
    .*
);

endmodule : vc_tb
