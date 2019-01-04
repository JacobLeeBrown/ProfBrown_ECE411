module cache_dout_mod
(
    input [4:0] offset,
    input [255:0] data_line_in,
    output logic [31:0] dataout
);

logic [255:0] shift_din;

assign shift_din = data_line_in >> ($unsigned(offset) * 8);
assign dataout = shift_din[31:0];

endmodule : cache_dout_mod
