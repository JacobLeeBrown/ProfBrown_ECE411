
module vc_load_logic #(parameter entries = 8)
(
    input logic [$clog2(entries)-1:0] idx,
    input logic load,

    output logic [entries-1:0] loads
);

initial
begin // Bit magic to ensure entries is a power of 2
    pow2: assert(entries && ((entries & (entries-1)) == 0));
end

always_comb
begin
    loads = 0;
    loads[idx] = load;
end

endmodule : vc_load_logic
