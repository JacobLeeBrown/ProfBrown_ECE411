
module hit_logic #(parameter n = 8)
(
    input  logic [n-1:0] hits,
    output logic hit,
    output logic [$clog2(n)-1:0] hit_idx
);

initial
begin // Bit magic to ensure n is a power of 2
    pow2: assert(n && ((n & (n-1)) == 0));
end

assign hit = |hits;

always_comb
begin
    hit_idx = 1'b0;
    for(int i = 0; i < n; i++) begin
        if(hits[i]) hit_idx = i[$clog2(n)-1:0];
    end
end

endmodule : hit_logic