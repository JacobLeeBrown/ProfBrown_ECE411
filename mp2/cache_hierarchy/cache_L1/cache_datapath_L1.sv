import rv32i_types::*;

module cache_datapath_L1
(
    input clk,

    input rv32i_word mem_address,
    input rv32i_word mem_wdata,
    input rv32i_cache_line pmem_rdata,
    input [3:0] mem_byte_enable,
    input load_lru,
    input way_sel,
    input load_word,
    input load_line,
    input tag_sel,

    output rv32i_word pmem_address,
    output rv32i_cache_line pmem_wdata,
    output rv32i_word mem_rdata,
    output [1:0] hits,
    output dirty,
    output lru_out
);

/* Way Input Logic */
logic [23:0] tag;
logic [2:0] set;
logic [4:0] offset;

logic [1:0] load_words, load_lines;

/* Way Output Logic */
logic [1:0][23:0] tag_outs;
logic [23:0] tag_mux_out, way_tag_out;
logic [1:0][31:0] data_word_outs;
logic [1:0][255:0] data_line_outs;
logic [1:0] dirtys;

/* LRU Logic */
logic lru_array_in;
logic lru_array_out;


/********************************/
/* ***** Way Input Logic ****** */
/********************************/

assign tag = mem_address[31:8];
assign set = mem_address[7:5];
assign offset = mem_address[4:0];

// Parameter will change based on # of ways
cache_load_logic #(.ways(2)) load_logic2
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

cacheway cacheway_0
(
    .clk(clk),

    .tag_in(tag),
    .set(set),
    .offset(offset),
    .data_word_in(mem_wdata),
    .data_line_in(pmem_rdata),
    .load_word(load_words[0]),
    .load_line(load_lines[0]),
    .mem_byte_enable(mem_byte_enable),
    .tag_out(tag_outs[0]),
    .hit(hits[0]),
    .dirty(dirtys[0]),
    .data_word_out(data_word_outs[0]),
    .data_line_out(data_line_outs[0])
);

cacheway cacheway_1
(
    .clk(clk),

    .tag_in(tag),
    .set(set),
    .offset(offset),
    .data_word_in(mem_wdata),
    .data_line_in(pmem_rdata),
    .load_word(load_words[1]),
    .load_line(load_lines[1]),
    .mem_byte_enable(mem_byte_enable),
    .tag_out(tag_outs[1]),
    .hit(hits[1]),
    .dirty(dirtys[1]),
    .data_word_out(data_word_outs[1]),
    .data_line_out(data_line_outs[1])
);


/*********************************/
/* ***** Way Output Logic ****** */
/*********************************/

mux2 #(.width(24)) tag_out_mux
(
    .sel(way_sel),
    .a(tag_outs[0]),
    .b(tag_outs[1]),
    .z(way_tag_out)
);

mux2 #(.width(32)) word_out_mux
(
    .sel(way_sel),
    .a(data_word_outs[0]),
    .b(data_word_outs[1]),
    .z(mem_rdata)
);

mux2 #(.width(256)) line_out_mux
(
    .sel(way_sel),
    .a(data_line_outs[0]),
    .b(data_line_outs[1]),
    .z(pmem_wdata)
);

mux2 #(.width(1)) dirty_mux
(
    .sel(lru_out),
    .a(dirtys[0]),
    .b(dirtys[1]),
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

// Parameter will change based on # of ways
lru_logic_in #(.ways(2)) lru_logic_in
(
    .lru_array_out(lru_array_out),
    .way_sel(way_sel),
    .lru_array_in(lru_array_in)
); 

array #(.width(1)) lru_array
(
    .clk(clk),

    .write(load_lru),
    .index(set),
    .datain(lru_array_in),
    .dataout(lru_array_out)
);

// Parameter will change based on # of ways
lru_logic_out #(.ways(2)) lru_logic_out
(
    .lru_array_out(lru_array_out),
    .evict(lru_out)
); 

endmodule : cache_datapath_L1
