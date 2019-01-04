module lru_logic_out #(parameter ways = 2)(
    // The output of the LRU array (pseudo-LRU = MRU)
    input logic [ways-2:0] lru_array_out,

    // Index into the tag array that we are evicting
    output logic [$clog2(ways)-1:0] evict

);

    initial
    begin // Bit magic to ensure ways is a power of 2
        pow2: assert(ways && ((ways & (ways-1)) == 0));
    end

    logic [ways-2:0] tree;
    int num;    // For internal shifting logic
    int lru;    // Local variable for determining which way to evict
    int temp;

    always_comb
    begin
        tree = lru_array_out;
        lru = ways-1;

        for(int i=(ways>>1);i>0;i=i>>1) begin
            
            // Shift depending on the current msb tree bit and update lru
            // NOTE: NOT-ing this changes whether you read bits as MRU or LRU
            //      - With `~` = MRU, without `~` = LRU
            if(tree[ways-2])
            begin
                lru -= i;
                num = i;
            end
            else
            begin
                num = 1;
            end

            // Do the shift for the next iteration
            tree = tree << $unsigned(num);
        end

        temp = (ways - 1 - lru);
        evict = temp[$clog2(ways)-1:0];
    end

endmodule : lru_logic_out
