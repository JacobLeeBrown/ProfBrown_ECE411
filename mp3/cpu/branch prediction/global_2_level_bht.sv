// if changing these change parameters on the array instantiations
typedef logic [3:0] bht_array_width;
typedef logic [7:0] bht_array_length;

module global_2_level_bht (
	input  logic clk,
	input  logic is_branch,
	input  bht_array_length prev_pc,
	input  logic branch_taken, 
	input  bht_array_length curr_pc,
	output logic br_predict
);

/*
	curr_*: Refers to a signal that is controlled by IF stage
			- ie. the current branch (we need to predict)

	prev_*: Refers to a singal that is controlled by EX stage
			- ie. a previous branch (we need to update)
*/

bht_array_length curr_index, prev_index;
bht_array_width curr_hist, prev_hist;
bht_array_width curr_final_out;

// these are the default values; can be tweaked for performance purposes
bht_array #(.width(4), .length(8)) bht_array0 (
	.clk,
	
	.write(is_branch),				// Signifies whether a branch occured
    .write_index(prev_pc),			// Input addr from prev branch pc
    .write_in(branch_taken),		// Input bit of real T/NT for resolved branch

    .read_index(curr_pc),			// Read addr from current branch pc
    .read_out0(curr_hist),			// Output sequence of T/NT (for current read)

    .read_out1(prev_hist)			// Output sequence of T/NT (for current write)
);

// Combine the sequence of bits into a single address (read addr)
bit_combiner #(.width(4), .length(8)) curr_combiner (
	.seq_a(curr_pc),
	.seq_b(curr_hist),
	.seq_out(curr_index)
);

// Combine the sequence of bits into a single address (write addr)
bit_combiner #(.width(4), .length(8)) prev_combiner (
	.seq_a(prev_pc),
	.seq_b(prev_hist),
	.seq_out(prev_index)
);

// Second level bht (if needed)
bht_array #(.width(4), .length(8)) bht_array1 (
	.clk,

	.write(is_branch),
	.write_index(prev_index),
	.write_in(branch_taken),
	
	.read_index(curr_index),
	.read_out0(curr_final_out),

	// Should not have to worry about this
	.read_out1()
);

// Second level pht for predictions
pht_array #(.length(8)) pht_array (
	.clk,

	.write(is_branch),
	.write_index(prev_index),
	.write_in(branch_taken),

	.read_index(curr_index),
	.br_predict
);


endmodule : global_2_level_bht