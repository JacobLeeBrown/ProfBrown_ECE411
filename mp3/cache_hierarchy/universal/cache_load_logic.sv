module cache_load_logic #(parameter ways = 2)
(
    input logic [$clog2(ways)-1:0] way_sel,
    input logic load_word,
    input logic load_line,

    output logic [ways-1:0] load_words,
    output logic [ways-1:0] load_lines
);

initial
begin // Bit magic to ensure n is a power of 2
    pow2: assert(ways && ((ways & (ways-1)) == 0));
end

logic [ways-1:0] lw_mask, ll_mask, way_mask;

assign lw_mask = {ways{load_word}};
assign ll_mask = {ways{load_line}};
assign way_mask = 1'b1 << way_sel;

assign load_words = way_mask & lw_mask;
assign load_lines = way_mask & ll_mask;

endmodule : cache_load_logic
