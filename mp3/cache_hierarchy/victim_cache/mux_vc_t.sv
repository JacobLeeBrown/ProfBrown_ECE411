import cache_hierarchy_types::*;

module mux_vc_t #(parameter entries = 8)
(
    input  logic [$clog2(entries)-1:0] sel,
    input  vc_t vc_ts [entries],
    output vc_t z
);

assign z = vc_ts[sel];

endmodule : mux_vc_t