module lru_logic_in_tb;

timeunit 1ns;
timeprecision 1ns;

// Inputs to LRU
logic t2i;
logic t2o;
logic w2;

logic [2:0] t4i;
logic [2:0] t4o;
logic [1:0] w4;

logic [6:0] t8i;
logic [6:0] t8o;
logic [2:0] w8;

// Signal naming scheme: [t = 'tree'][# = # of ways][i = in / o = out]
//                     : [w = 'way_sel'][# = # of ways]
//              Ex: t4i - 4-way tree input, w4 - 4-way way_sel input


/* Signals */
initial
begin
    /* LRU */
    // First round (forcing bits)
    t2i = 1'b0;
    w2 = 0;             // t2o = 1'b1       = x1
    t4i = 3'b000;
    w4 = 0;             // t4o = 3'b110     = x6
    t8i = 7'b0000000;
    w8 = 0;             // t8o = 7'b1110000 = x70
    #20;
    t8i = 7'b0010000;
    w8 = 1;             // t8o = 7'b1100000 = x60
    #20;
    t4i = 3'b010;
    w4 = 1;             // t4o = 3'b100     = x4
    t8i = 7'b0100000;
    w8 = 2;             // t8o = 7'b1001000 = x48
    #20;
    t8i = 7'b0101000;
    w8 = 3;             // t8o = 7'b1000000 = x40
    #20;
    t2i = 1'b1;
    w2 = 1;             // t2o = 1'b0       = x0
    t4i = 3'b100;
    w4 = 2;             // t4o = 3'b001     = x1
    t8i = 7'b1000000;
    w8 = 4;             // t8o = 7'b0000110 = x06
    #20;
    t8i = 7'b1000010;
    w8 = 5;             // t8o = 7'b0000100 = x04
    #20;
    t4i = 3'b101;
    w4 = 3;             // t4o = 3'b000     = x0
    t8i = 7'b1000100;
    w8 = 6;             // t8o = 7'b0000001 = x01
    #20;
    t8i = 7'b1000101;
    w8 = 7;             // t8o = 7'b0000000 = x00


    #40;


    // Second round (preserving bits)
    t2i = 1'b1;
    w2 = 0;             // t2o = 1'b1       = x1
    t4i = 3'b001;
    w4 = 0;             // t4o = 3'b111     = x7
    t8i = 7'b0001111;
    w8 = 0;             // t8o = 7'b1111111 = x7F
    #20;
    t8i = 7'b0011111;
    w8 = 1;             // t8o = 7'b1101111 = x6F
    #20;
    t4i = 3'b011;
    w4 = 1;             // t4o = 3'b101     = x5
    t8i = 7'b0110111;
    w8 = 2;             // t8o = 7'b1011111 = x5F
    #20;
    t8i = 7'b0111111;
    w8 = 3;             // t8o = 7'b1010111 = x57
    #20;
    t2i = 1'b0;
    w2 = 1;             // t2o = 1'b0       = x0
    t4i = 3'b110;
    w4 = 2;             // t4o = 3'b011     = x3
    t8i = 7'b1111001;
    w8 = 4;             // t8o = 7'b0111111 = x3F
    #20;
    t8i = 7'b1111011;
    w8 = 5;             // t8o = 7'b0111101 = x3D
    #20;
    t4i = 3'b111;
    w4 = 3;             // t4o = 3'b010     = x2
    t8i = 7'b1111110;
    w8 = 6;             // t8o = 7'b0111011 = x3B
    #20;
    t8i = 7'b1111111;
    w8 = 7;             // t8o = 7'b0111010 = x3A

end

/* First round of tests are to ensure that the bits that should be changed are.
 * For example, 4-way input of 101 with way_sel = 3 should set the msb and lsb
 * to zero, so we'd expect t4o = 3'b000 = x0.
 *
 * Second round is to ensure the bits that should *not* be forced are preserved.
 * For example, from round 1 we should know t4i = 101 and way_sel = 3 should get
 * us t4o = 000. In round 2, we give t4i = 111 with way_sel = 3, expecting t4o =
 * 010 because we know the outside bits are forced and expect the middle one to
 * be preserved. This ensures that our implementation is not forcing any bits it
 * should not be touching.
 */

lru_logic_in #(.ways(2)) lru2
(
    .lru_array_out(t2i),
    .way_sel(w2),
    .lru_array_in(t2o)
);

lru_logic_in #(.ways(4)) lru4
(
    .lru_array_out(t4i),
    .way_sel(w4),
    .lru_array_in(t4o)
);

lru_logic_in #(.ways(8)) lru8
(
    .lru_array_out(t8i),
    .way_sel(w8),
    .lru_array_in(t8o)
);

endmodule : lru_logic_in_tb
