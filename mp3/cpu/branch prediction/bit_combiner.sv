module bit_combiner #(parameter width = 4, length = 8) 
(
	// seq_a will probably be pc
	input logic [length-1:0] seq_a,
	// seq_b will probably be sequence of T/NT
	input logic [width-1:0] seq_b,

	// combined sequence
	output logic [length-1:0] seq_out
);


always_comb
begin
	// This line puts msb of pc into sequence and then xors lsb with seq_b (branch history)
	seq_out = {seq_a[length-1:width], seq_a[width-1:0] ^ seq_b};
end

endmodule : bit_combiner