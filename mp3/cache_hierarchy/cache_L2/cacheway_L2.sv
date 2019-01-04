import rv32i_types::*;

module cacheway_L2 #(parameter sets = 8)
(
    input clk,

    input logic [32-5-$clog2(sets)-1:0] tag_in,
    input logic [$clog2(sets)-1:0] set,
    //input [4:0] offset,
    input rv32i_cache_line data_word_in,
    input rv32i_cache_line data_line_in,
    input logic load_word,
    input logic load_line,
    //input [3:0] mem_byte_enable,

    output logic [32-5-$clog2(sets)-1:0] tag_out,
    output logic hit,
    output logic dirty,
    //output rv32i_word data_word_out,
    output rv32i_cache_line data_line_out
);

/* Load Logic */
logic load_any;
assign load_any = load_word | load_line;
/* Data Logic */
//rv32i_cache_line din_mod_out;
rv32i_cache_line din_mux_out;
/* Tag and Valid Logic */
logic valid_array_out;
logic cmp_out;


/* ************************ */
/* ****** Data Logic ****** */
/* ************************ */

/* Data-in Logic */

// cache_din_mod din_mod
// (
//     .offset(offset),
//     .mem_byte_enable(mem_byte_enable),
//     .data_word_in(data_word_in),
//     .data_line_in(data_line_out),
//     .dataout(din_mod_out)
// );

mux2 #(.width(256)) din_mux
(
    .sel(load_word),
    .a(data_line_in),
    .b(data_word_in),
    .z(din_mux_out)
);

/* Data Array */

array #(.width(256), .size(sets)) data_array
(
    .clk(clk),

    .write(load_any),
    .index(set),
    .datain(din_mux_out),
    .dataout(data_line_out)
);

/* Data-out Logic */

// cache_dout_mod dout_mod
// (
//     .offset(offset),
//     .data_line_in(data_line_out),
//     .dataout(data_word_out)
// );


/* ************************* */
/* ****** Dirty Logic ****** */
/* ************************* */

array #(.width(1), .size(sets)) dirty_array
(
    .clk(clk),

    .write(load_any),
    .index(set),
    .datain(load_word),
    .dataout(dirty)
);

/* ********************************* */
/* ****** Tag and Valid Logic ****** */
/* ********************************* */

array #(.width(1), .size(sets)) valid_array
(
    .clk(clk),

    .write(load_line),
    .index(set),
    .datain(1'b1),
    .dataout(valid_array_out)
);

array #(.width(32-5-$clog2(sets)), .size(sets)) tag_array
(
    .clk(clk),

    .write(load_line),
    .index(set),
    .datain(tag_in),
    .dataout(tag_out)
);

assign cmp_out = (tag_out == tag_in);
assign hit = (cmp_out & valid_array_out);

endmodule : cacheway_L2
