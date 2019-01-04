import rv32i_types::*;

module cmp
(
    input branch_funct3_t cmpop,
    input rv32i_word a, b,
    output logic z
);

logic res;

mux4 #(.width(1)) cmpmux2
(
    .sel(cmpop[2:1]),
    .a((a == b)),
    .b(),
    .c(($signed(a) < $signed(b))),
    .d((a < b)),
    .z(res)
);

assign z = res ^ cmpop[0];

/*
always_comb
begin
    case (cmpop)
        beq:  f = a == b;
        bne:  f = a != b;
        blt:  f = a < b;
        bge:  f = a >= b;
        bltu: f = $signed(a) < $signed(b);
        bgeu: f = $signed(a) >= $signed(b);
    endcase
end
*/

endmodule : cmp