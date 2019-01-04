import rv32i_types::*;

module ewb_datapath
(
    input  logic clk,

    // Control
    output logic valid_out,
    input  logic valid_in,
    input  logic out_sel,
    input  logic load,

    // Higher level memory
    input  rv32i_word mem_address,
    input  rv32i_cache_line mem_wdata,
    output rv32i_cache_line mem_rdata,

    // Lower level memory
    output rv32i_word pmem_address,
    output rv32i_cache_line pmem_wdata,
    input  rv32i_cache_line pmem_rdata
);

// initial
// begin
//     mem_rdata = 0;
//     pmem_address = 0;
//     pmem_wdata = 0;
// end

// Intermediary Signals
rv32i_word addr_out;
rv32i_cache_line data_out;

assign mem_rdata = pmem_rdata;

register #(.width(1)) valid_buffer
(
    .clk,
    .load,
    .in(valid_in),
    .out(valid_out)
);

register #(.width(32)) address_buffer
(
    .clk,
    .load,
    .in(mem_address),
    .out(addr_out)
);

register #(.width(256)) data_buffer
(
    .clk,
    .load,
    .in(mem_wdata),
    .out(data_out)
);

mux2 #(.width(32)) addrmux
(
    .sel(out_sel),
    .a(mem_address),
    .b(addr_out),
    .z(pmem_address)
);

mux2 #(.width(256)) datamux
(
    .sel(out_sel),
    .a(mem_wdata),
    .b(data_out),
    .z(pmem_wdata)
);

endmodule : ewb_datapath
