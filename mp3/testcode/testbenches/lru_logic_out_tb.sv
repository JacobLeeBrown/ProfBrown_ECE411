module lru_logic_out_tb;

timeunit 1ns;
timeprecision 1ns;

// Inputs to LRU
logic t2i;
logic t2o;

logic [2:0] t4i;
logic [1:0] t4o;
logic [6:0] t8i;
logic [2:0] t8o;

// Signal naming scheme: [t = 'tree'][# = # of ways][i = in / o = out]

/* Signals */
initial
begin
    /* MRU */
    // t2i = 1'b0;         // 2: 1
    // t4i = 3'b000;       // 4: 3
    // t8i = 7'b0000000;   // 8: 7
    // #20;
    // t8i = 7'b0000001;   // 8: 6
    // #20;
    // t4i = 3'b011;       // 4: 2
    // t8i = 7'b0000100;   // 8: 5
    // #20;
    // t8i = 7'b0000110;   // 8: 4
    // #20;
    // t2i = 1'b1;         // 2: 0
    // t4i = 3'b100;       // 4: 1
    // t8i = 7'b1000000;   // 8: 3
    // #20;
    // t8i = 7'b1001000;   // 8: 2
    // #20;
    // t4i = 3'b111;       // 4: 0
    // t8i = 7'b1100000;   // 8: 1
    // #20;
    // t8i = 7'b1111111;   // 8: 0

    /* LRU */
    t2i = 1'b0;         // 2: 0
    t4i = 3'b000;       // 4: 0
    t8i = 7'b0000000;   // 8: 0
    #20;
    t8i = 7'b0010000;   // 8: 1
    #20;
    t4i = 3'b010;       // 4: 1
    t8i = 7'b0100000;   // 8: 2
    #20;
    t8i = 7'b0101000;   // 8: 3
    #20;
    t2i = 1'b1;         // 2: 1
    t4i = 3'b100;       // 4: 2
    t8i = 7'b1000000;   // 8: 4
    #20;
    t8i = 7'b1000010;   // 8: 5
    #20;
    t4i = 3'b101;       // 4: 3
    t8i = 7'b1000100;   // 8: 6
    #20;
    t8i = 7'b1111111;   // 8: 7
end

/* You may be asking yourself, "Wtf is he doing?". Well, currently, I'm simply
 * testing only enough inputs to generate 1 output for every possible way. So, 
 * although 4-way LRU has 8 permutations (since it's 3 bits long), there are
 * only 4 tests above to ensure we evict each way for 1 of the 2 permutations
 * that way would be evicted. For example, both 100 and 101 should evict way 1,
 * but only 100 is tested above.
 *
 * They are structure so that the evicted way descends from highest to lowest
 * for MRU interpretation and lowest to highest for LRU implementation, so, for
 * MRU, the output of the 4-way lru logic (t4o) should start at 3, then go to 2,
 * and so on and so forth.
 */

lru_logic_out #(.ways(2)) lru2
(
    // The output of the LRU array (pseudo-LRU = MRU)
    .lru_array_out(t2i),
    // Index into the tag array that we are evicting
    .evict(t2o)
);

lru_logic_out  #(.ways(4)) lru4
(
    // The output of the LRU array (pseudo-LRU = MRU)
    .lru_array_out(t4i),
    // Index into the tag array that we are evicting
    .evict(t4o)
);

lru_logic_out  #(.ways(8)) lru8
(
    // The output of the LRU array (pseudo-LRU = MRU)
    .lru_array_out(t8i),
    // Index into the tag array that we are evicting
    .evict(t8o)
);

endmodule : lru_logic_out_tb

// [0, 0, 0] == 3
// [0, 1, 1] == 2
// [1, 0, 0] == 1
// [1, 1, 1] == 0
// [0,0,0,0,0,0,0] == 7 
// [0,0,0,0,0,0,1] == 6
// [0,0,0,0,1,0,0] == 5
// [0,0,0,0,1,1,0] == 4
// [1,0,0,0,0,0,0] == 3
// [1,0,0,1,0,0,0] == 2
// [1,1,0,0,0,0,0] == 1
// [1,1,1,1,1,1,1] == 0