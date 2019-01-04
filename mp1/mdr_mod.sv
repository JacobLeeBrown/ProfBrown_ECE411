import rv32i_types::*;

module mdr_mod
(
    input load_funct3_t mdrop,
    input rv32i_word in,
    output rv32i_word out
);

always_comb
begin
    case (mdrop)
        lb:   out = {{25{in[7]}}, in[6:0]};
        lh:   out = {{17{in[15]}}, in[14:0]};
        lw:   out = in;
        lbu:  out = {{24{1'b0}}, in[7:0]};
        lhu:  out = {{16{1'b0}}, in[15:0]};
    endcase
end

endmodule : mdr_mod