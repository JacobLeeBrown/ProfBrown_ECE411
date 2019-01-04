import rv32i_types::*;

module cache_datapath_L2 #(parameter ways = 4, parameter sets = 8)
(
    input clk,

    input rv32i_word mem_address,
    input rv32i_cache_line mem_wdata,
    input rv32i_cache_line pmem_rdata,
    input logic load_lru,
    input logic [$clog2(ways)-1:0] way_sel,
    input logic load_word,
    input logic load_line,
    input logic tag_sel,

    output rv32i_word pmem_address,
    output rv32i_cache_line pmem_wdata,
    output rv32i_cache_line mem_rdata,
    output logic [ways-1:0] hits,
    output logic dirty,
    output logic [$clog2(ways)-1:0] lru_out
);

typedef struct packed
{
    logic [(32 - $clog2(sets) - 5)-1:0] tag;
    rv32i_cache_line line;
    logic dirty;
} l2_t;

/* Way Input Logic */
//const int tag_width = 32 - set_width - offset_width;
//const int set_width = $clog2(sets);
//const int offset_width = 5;

logic [(32 - $clog2(sets) - 5)-1:0] tag;
logic [$clog2(sets)-1:0] set;

logic [ways-1:0] load_words, load_lines;

/* Way Output Logic */
logic [ways-1:0][(32 - $clog2(sets) - 5)-1:0] tag_outs;
logic [ways-1:0][255:0] data_line_outs;
logic [ways-1:0] dirtys;

logic [(32 - $clog2(sets) - 5)-1:0] tag_mux_out;

l2_t l2_ts [ways];
l2_t l2_tmux_out;

/* LRU Logic */
logic [ways-2:0] lru_array_in;
logic [ways-2:0] lru_array_out;


/********************************/
/* ***** Way Input Logic ****** */
/********************************/

assign tag = mem_address[(32 - $clog2(sets) - 5)-1:($clog2(sets)+5)];
assign set = mem_address[($clog2(sets)+5)-1:5];

cache_load_logic #(.ways(ways)) load_logic
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

// Using a generative-block-like syntax to instantiate several modules at once.
// Vectors will be split across each module based on the width of their
// individual ports.

cacheway_L2 #(.sets(sets)) cacheways[ways-1:0]
(
    .clk(clk),

    .tag_in(tag),
    .set(set),
    .data_word_in(mem_wdata),
    .data_line_in(pmem_rdata),
    .load_word(load_words),
    .load_line(load_lines),
    .tag_out(tag_outs),
    .hit(hits),
    .dirty(dirtys),
    .data_line_out(data_line_outs)
);


/*********************************/
/* ***** Way Output Logic ****** */
/*********************************/

// l2_t_assigner
always_comb
begin
    for(int i = 0; i < ways; i++) begin
        l2_ts[i].tag = tag_outs[i];
        l2_ts[i].line = data_line_outs[i];
        l2_ts[i].dirty = dirtys[i];
    end
end

// mux_l2_t
assign l2_tmux_out.tag = l2_ts[way_sel].tag;
assign l2_tmux_out.line = l2_ts[way_sel].line;
assign l2_tmux_out.dirty = l2_ts[lru_out].dirty;

// hit_logic #(.n(ways)) hit_logic
// (
//     .hits,
//     .hit,
//     .hit_idx
// );

assign mem_rdata = pmem_wdata;
assign pmem_wdata = l2_tmux_out.line;
assign dirty = l2_tmux_out.dirty;


/**************************/
/* ***** Tag Logic ****** */
/**************************/

mux2 #(.width((32 - $clog2(sets) - 5))) tag_mux
(
    .sel(tag_sel),
    .a(tag),
    .b(l2_tmux_out.tag),
    .z(tag_mux_out)
);

assign pmem_address = {tag_mux_out, set, {5{1'b0}}};


/**************************/
/* ***** LRU Logic ****** */
/**************************/

lru_logic_in #(.ways(ways)) lru_logic_in
(
    .lru_array_out(lru_array_out),
    .way_sel(way_sel),
    .lru_array_in(lru_array_in)
); 

array #(.width(ways-1), .size(sets)) lru_array
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
