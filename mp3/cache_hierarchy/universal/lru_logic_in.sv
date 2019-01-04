module lru_logic_in #(parameter ways = 2)
(
    // The current lru array we will modify
    input logic [ways-2:0] lru_array_out,
    // Index into the tag array that we are evicting
    input logic [$clog2(ways)-1:0] way_sel,

    // The input to the LRU array (pseudo-LRU = MRU)
    output logic [ways-2:0] lru_array_in
);

    initial
    begin // Bit magic to ensure ways is a power of 2
        pow2: assert(ways && ((ways & (ways-1)) == 0));
    end

    logic [ways-2:0] tree;              // Local variable that will be modified
    logic [$clog2(ways)-1:0] idx;       // idx of bit of interest (current root)
    logic [$clog2(ways)-1:0] cur_div;   // The comparing value for current root

    int temp1, temp2, temp3, temp4;

    logic [$clog2(ways)-1:0] one;
    assign one = 1;

	always_comb
	begin
        tree = lru_array_out;
		temp1 = ways-2; idx = temp1[$clog2(ways)-1:0];
        temp2 = (ways >> 1); cur_div = temp2[$clog2(ways)-1:0];

		for(int i = (ways >> 1); i > 0; i = i >> 1) begin

            // >= : LRU, < : MRU
            if(way_sel >= cur_div)
            begin
                tree[idx] = 1'b0;
				idx -= i[$clog2(ways)-1:0];
                temp3 = i >> 1; cur_div += temp3[$clog2(ways)-1:0];
            end
			else
            begin
                tree[idx] = 1'b1;
				idx -= one; //**
                temp3 = i >> 1; cur_div -= temp3[$clog2(ways)-1:0];
            end
		end

        lru_array_in = tree;
	end

endmodule : lru_logic_in
