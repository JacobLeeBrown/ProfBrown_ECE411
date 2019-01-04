module mux8 #(parameter width = 32)
(
    input [2:0] sel,
    input [width-1:0] i0, i1, i2, i3, i4, i5, i6, i7,
    output logic [width-1:0] f
);

always_comb
begin
    case(sel)
        0: f = i0;
        1: f = i1;
        2: f = i2;
        3: f = i3;
        4: f = i4;
        5: f = i5;
        6: f = i6;
        7: f = i7;
    endcase
end

endmodule : mux8