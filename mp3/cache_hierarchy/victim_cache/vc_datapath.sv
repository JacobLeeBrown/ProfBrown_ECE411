import rv32i_types::*;
import cache_hierarchy_types::*;

module vc_datapath #(parameter entries = 8)
(
    input  logic clk,

    // Control
    output logic full,
    output logic hit,
    output logic [$clog2(entries)-1:0] hit_idx,
	output logic [$clog2(entries)-1:0] circular_idx,
    input  logic [$clog2(entries)-1:0] idx,
    input  logic load,
	input  logic circular_inc,
    input  logic read_sel,
    input  logic out_sel,

    // Higher level memory
    input  rv32i_word mem_address,
    input  rv32i_cache_line mem_wdata,
    output rv32i_cache_line mem_rdata,

    // Lower level memory
    output rv32i_word pmem_address,
    output rv32i_cache_line pmem_wdata,
    input  rv32i_cache_line pmem_rdata
);

// Intermediary Signals
logic [entries-1:0] valid_outs;
logic [entries-1:0] hits;
logic [entries-1:0][31:0] address_outs;
logic [entries-1:0][255:0] data_outs;
logic [entries-1:0] loads;

vc_t vc_ts [entries];
vc_t vc_tmux_out;

initial
begin // Bit magic to ensure entries is a power of 2
    pow2: assert(entries && ((entries & (entries-1)) == 0));
	circular_idx = 0;
end

/*** Load Logic ***/
// Handles assigning load to the appropriate bit in the loads bit vector

vc_load_logic #(.entries(entries)) load_logic
(
    .idx,
    .load,

    .loads
);

/* End Load Logic */

/*** The Entries ***/
// Using a generative-block-like syntax to instantiate several modules at once.
// Vectors will be split across each module based on the width of their
// individual ports.

vc_entry entrees[entries-1:0]
(
    .clk(clk),

    .load(loads),

    .address_in(mem_address),
    .data_in(mem_wdata),

    .valid_out(valid_outs),
    .hit(hits),
    .address_out(address_outs),
    .data_out(data_outs)
);

/* End Entries */

/*** Selection Logic ***/
// Handles selecting the appropriate address and data from the entries array

vc_t_assigner struct_it_up
(
    .address_outs,
    .data_outs,

    .vc_ts
);

mux_vc_t #(.entries(entries)) vc_tmux
(
    .sel(idx),
    .vc_ts(vc_ts),
    .z(vc_tmux_out)
);

/* End Selection Logic */

/*** Final Assignments ***/
// All logic for assigning the correct values to the outputs.

assign full = &valid_outs;

hit_logic #(.n(entries)) hit_logic
(
    .hits,
    .hit,
    .hit_idx
);

mux2 #(.width(32)) addressmux
(
    .sel(out_sel),
    .a(mem_address),
    .b(vc_tmux_out.address),
    .z(pmem_address)
);

mux2 #(.width(256)) wdatamux
(
    .sel(out_sel),
    .a(mem_wdata),
    .b(vc_tmux_out.data),
    .z(pmem_wdata)
);

mux2 #(.width(256)) rdatamux
(
    .sel(read_sel),
    .a(pmem_rdata),
    .b(vc_tmux_out.data),
    .z(mem_rdata)
);

/* End Final Assignments */

/*** Circular Idx Logic ***/
// This idx tracks which entry will be filled/replaced next

logic [$clog2(entries)-1:0] one;
assign one = 1;

always_ff @(posedge clk)
begin

    if(circular_inc) circular_idx <= (circular_idx + one);
end

/* End Circular Idx Logic */

endmodule : vc_datapath
