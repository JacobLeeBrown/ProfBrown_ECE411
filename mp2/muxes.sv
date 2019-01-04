// Regular 2:1 MUX
module mux2 #(parameter width = 32)
(
	input logic sel,
	input logic [width-1:0] a, b,
	output logic [width-1:0] z
);
always_comb
begin
	if (sel == 0)
		z = a;
	else
		z = b;
end
endmodule : mux2

// Regular 4:1 MUX
module mux4 #(parameter width = 32)
(
	input logic [1:0] sel,
	input logic [width-1:0] a, b, c, d,
	output logic [width-1:0] z
);
always_comb
begin
	if (sel == 0)
		z = a;
	else if (sel == 1)
		z = b;
	else if (sel == 2)
		z = c;
	else
		z = d;
end
endmodule : mux4

// Regular 8:1 MUX
module mux8 #(parameter width = 32)
(
	input logic [2:0] sel,
	input logic [width-1:0] a, b, c, d, e, f, g, h,
	output logic [width-1:0] z
);
always_comb
begin
	case(sel)
        0: z = a;
        1: z = b;
        2: z = c;
        3: z = d;
        4: z = e;
        5: z = f;
        6: z = g;
        7: z = h;
    endcase

end
endmodule : mux8