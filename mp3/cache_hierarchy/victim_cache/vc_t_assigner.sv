import cache_hierarchy_types::*;

module vc_t_assigner #(parameter entries = 8)
(
    input [entries-1:0][31:0] address_outs,
    input [entries-1:0][255:0] data_outs,

    output vc_t vc_ts [entries]
);

initial
begin // Bit magic to ensure entries is a power of 2
    pow2: assert(entries && ((entries & (entries-1)) == 0));
end

always_comb
begin
    for(int i = 0; i < entries; i++) begin
        vc_ts[i].address = address_outs[i];
        vc_ts[i].data = data_outs[i];
    end
end

endmodule : vc_t_assigner