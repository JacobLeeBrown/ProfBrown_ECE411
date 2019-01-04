module cache_din_mod
(
    input [4:0] offset,
    input [3:0] mem_byte_enable,
    input [31:0] data_word_in,
    input [255:0] data_line_in,
    output logic [255:0] dataout
);

logic [7:0] bit_offset;
logic [31:0] mbe;
logic [255:0] zext_mbe, shift_mbe, line_mask;
logic [255:0] zext_word, shift_word, masked_word, masked_line;


assign bit_offset = offset << 3;

mask_ext mbe_ext
(
    .mask_in(mem_byte_enable),
    .mask_out(mbe)
);

zext #(.width_in(32), .width_out(256)) mbe_zext
(
    .a(mbe),
    .f(zext_mbe)
);

assign shift_mbe = zext_mbe << bit_offset;
assign line_mask = ~shift_mbe;
assign masked_line = data_line_in & line_mask;

zext #(.width_in(32), .width_out(256)) word_zext
(
    .a(data_word_in),
    .f(zext_word)
);

assign shift_word = zext_word << bit_offset;
assign masked_word = shift_word & shift_mbe;

assign dataout = masked_line | masked_word;

endmodule : cache_din_mod
