// if changing these change parameters on the array instantiations
typedef logic [3:0] bht_array_width;
typedef logic [7:0] bht_array_length;

module bht (
	input  logic clk,
	input  logic bht_array0_load,
	input  bht_array_length bht_array0_write_addr,
	input  logic bht_array0_write_in, 
	input  bht_array_length bht_array0_read_addr,
	output bht_array_width bht_array0_read_out
);

// these are the default values; can be tweaked for performance purposes
bht_array #(.width(4), .length(8)) bht_array0 (
	.clk,
	.write(bht_array0_load),
    .write_index(bht_array0_write_addr),
    .write_in(bht_array0_write_in),
    .read_index(bht_array0_read_addr),
    .read_out(bht_array0_read_out)
);

endmodule