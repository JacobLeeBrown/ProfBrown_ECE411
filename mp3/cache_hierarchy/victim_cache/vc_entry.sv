import rv32i_types::*;

module vc_entry
(
    input  logic clk,

    input  logic load,

    input  rv32i_word address_in,
    input  rv32i_cache_line data_in,

    output logic valid_out,
    output logic hit,
    output rv32i_word address_out,
    output rv32i_cache_line data_out
);

// Intermediary Signals
logic cmp_out;

register #(.width(1)) valid_buffer
(
    .clk,
    .load,
    .in(1'b1),
    .out(valid_out)
);

register #(.width(32)) address_buffer
(
    .clk,
    .load,
    .in(address_in),
    .out(address_out)
);

register #(.width(256)) data_buffer
(
    .clk,
    .load,
    .in(data_in),
    .out(data_out)
);

assign cmp_out = (address_in == address_out);
assign hit = valid_out & cmp_out; 

endmodule : vc_entry
