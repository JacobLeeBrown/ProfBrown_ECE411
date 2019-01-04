module mask_ext
(
    input [3:0] mask_in,
    output logic [31:0] mask_out
);

always_comb
begin
    if (mask_in[3])
        mask_out[31:24] = 8'hff;
    else
        mask_out[31:24] = 8'h00;

    if (mask_in[2])
        mask_out[23:16] = 8'hff;
    else
        mask_out[23:16] = 8'h00;

    if (mask_in[1])
        mask_out[15:8] = 8'hff;
    else
        mask_out[15:8] = 8'h00;

    if (mask_in[0])
        mask_out[7:0] = 8'hff;
    else
        mask_out[7:0] = 8'h00;
end

endmodule : mask_ext