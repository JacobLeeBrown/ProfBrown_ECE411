import rv32i_types::*;

// NOTE: This datapath is not fully parameterized! The 'ways' parameter is to
// just ensure the fully parameterized components get the correct value.
module cache_datapath_L2 #(parameter ways = 4)
(
    input clk,

    input rv32i_word mem_address,
    input rv32i_cache_line mem_wdata,
    input rv32i_cache_line pmem_rdata,
    //input [3:0] mem_byte_enable,
    input load_lru,
    input [1:0] way_sel,
    input load_word,
    input load_line,
    input tag_sel,

    output [31:0] pmem_address,
    output rv32i_cache_line pmem_wdata,
    output rv32i_cache_line mem_rdata,
    output [ways-1:0] hits,
    output dirty,
    output [1:0] lru_out
);

/* Way Input Logic */
logic [23:0] tag;
logic [2:0] set;
//logic [4:0] offset;

logic [ways-1:0] load_words, load_lines;

/* Way Output Logic */
logic [ways-1:0][23:0] tag_outs;
logic [23:0] tag_mux_out, way_tag_out;
//logic [3:0]rv32i_word data_word_outs;
logic [ways-1:0][255:0] data_line_outs;
logic [ways-1:0] dirtys;

/* LRU Logic */
logic [ways-2:0] lru_array_in;
logic [ways-2:0] lru_array_out;


/********************************/
/* ***** Way Input Logic ****** */
/********************************/

assign tag = mem_address[31:8];
assign set = mem_address[7:5];
//assign offset = mem_address[4:0];

// Parameter will change based on # of ways
cache_load_logic #(.ways(ways)) load_logic4
(
    .way_sel(way_sel),
    .load_word(load_word),
    .load_line(load_line),

    .load_words(load_words),
    .load_lines(load_lines)
);

/**************************/
/* ****** The Wayz ****** */
/**************************/

cacheway_L2 cacheway_0
(
    .clk(clk),

    .tag_in(tag),
    .set(set),
    //.offset(offset),
    .data_word_in(mem_wdata),
    .data_line_in(pmem_rdata),
    .load_word(load_words[0]),
    .load_line(load_lines[0]),
    //.mem_byte_enable(mem_byte_enable),
    .tag_out(tag_outs[0]),
    .hit(hits[0]),
    .dirty(dirtys[0]),
    //.data_word_out(data_word_outs[0]),
    .data_line_out(data_line_outs[0])
);

cacheway_L2 cacheway_1
(
    .clk(clk),

    .tag_in(tag),
    .set(set),
    //.offset(offset),
    .data_word_in(mem_wdata),
    .data_line_in(pmem_rdata),
    .load_word(load_words[1]),
    .load_line(load_lines[1]),
    //.mem_byte_enable(mem_byte_enable),
    .tag_out(tag_outs[1]),
    .hit(hits[1]),
    .dirty(dirtys[1]),
    //.data_word_out(data_word_outs[1]),
    .data_line_out(data_line_outs[1])
);

cacheway_L2 cacheway_2
(
    .clk(clk),

    .tag_in(tag),
    .set(set),
    //.offset(offset),
    .data_word_in(mem_wdata),
    .data_line_in(pmem_rdata),
    .load_word(load_words[2]),
    .load_line(load_lines[2]),
    //.mem_byte_enable(mem_byte_enable),
    .tag_out(tag_outs[2]),
    .hit(hits[2]),
    .dirty(dirtys[2]),
    //.data_word_out(data_word_outs[2]),
    .data_line_out(data_line_outs[2])
);

cacheway_L2 cacheway_3
(
    .clk(clk),

    .tag_in(tag),
    .set(set),
    //.offset(offset),
    .data_word_in(mem_wdata),
    .data_line_in(pmem_rdata),
    .load_word(load_words[3]),
    .load_line(load_lines[3]),
    //.mem_byte_enable(mem_byte_enable),
    .tag_out(tag_outs[3]),
    .hit(hits[3]),
    .dirty(dirtys[3]),
    //.data_word_out(data_word_outs[3]),
    .data_line_out(data_line_outs[3])
);


/*********************************/
/* ***** Way Output Logic ****** */
/*********************************/

mux4 #(.width(24)) tag_out_mux
(
    .sel(way_sel),
    .a(tag_outs[0]),
    .b(tag_outs[1]),
    .c(tag_outs[2]),
    .d(tag_outs[3]),
    .z(way_tag_out)
);

// mux4 #(.width(32)) word_out_mux
// (
//     .sel(way_sel),
//     .a(data_word_outs[0]),
//     .b(data_word_outs[1]),
//     .c(data_word_outs[2]),
//     .d(data_word_outs[3]),
//     .z(mem_rdata)
// );

assign mem_rdata = pmem_wdata;

mux4 #(.width(256)) line_out_mux
(
    .sel(way_sel),
    .a(data_line_outs[0]),
    .b(data_line_outs[1]),
    .c(data_line_outs[2]),
    .d(data_line_outs[3]),
    .z(pmem_wdata)
);

mux4 #(.width(1)) dirty_mux
(
    .sel(lru_out),
    .a(dirtys[0]),
    .b(dirtys[1]),
    .c(dirtys[2]),
    .d(dirtys[3]),
    .z(dirty)
);

/**************************/
/* ***** Tag Logic ****** */
/**************************/

mux2 #(.width(24)) tag_mux
(
    .sel(tag_sel),
    .a(tag),
    .b(way_tag_out),
    .z(tag_mux_out)
);

assign pmem_address = {tag_mux_out, set, 5'h00};

/**************************/
/* ***** LRU Logic ****** */
/**************************/

lru_logic_in #(.ways(ways)) lru_logic_in
(
    .lru_array_out(lru_array_out),
    .way_sel(way_sel),
    .lru_array_in(lru_array_in)
); 

array #(.width(ways-1)) lru_array
(
    .clk(clk),

    .write(load_lru),
    .index(set),
    .datain(lru_array_in),
    .dataout(lru_array_out)
);

lru_logic_out #(.ways(ways)) lru_logic_out
(
    .lru_array_out(lru_array_out),
    .evict(lru_out)
); 

endmodule : cache_datapath_L2
