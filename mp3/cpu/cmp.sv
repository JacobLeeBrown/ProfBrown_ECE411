import rv32i_types::*;

module cmp
(
	input branch_funct3_t cmpop,
	input rv32i_word a, b,
	output logic br_en
);

always_comb
begin
		br_en = 1'b0;
		
		// BEQ
		if(cmpop == beq && a == b)
			br_en = 1'b1;
			
		// BNE
		else if(cmpop == bne && a != b)
			br_en = 1'b1;
		
		// BLT
		else if(cmpop == blt && $signed(a) < $signed(b))
			br_en = 1'b1;
		
		// BGE
		else if(cmpop == bge && $signed(a) >= $signed(b))
			br_en = 1'b1;
		
		// BLTU
		else if(cmpop == bltu && a < b)
			br_en = 1'b1;
		
		// BGEU
		else if(cmpop == bgeu && a >= b)
			br_en = 1'b1;
end

endmodule : cmp





