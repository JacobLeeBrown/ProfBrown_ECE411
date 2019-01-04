module zext #(parameter width_in = 16, parameter width_out = 32)
(
    input [width_in-1:0] a,
    output logic [width_out-1:0] f
);

logic [width_out - width_in - 1:0] zeros;
assign zeros = 0;

assign f = {zeros, a};

endmodule : zext