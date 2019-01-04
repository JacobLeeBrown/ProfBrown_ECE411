module pht_array #(length = 8)
(
	input clk,    // Clock

	// Update value for the current state (real T/NT)
	input logic write,
	input logic [length-1:0] write_index,
	input logic write_in,

	// Prediction based on current state
	input logic [length-1:0] read_index,
	output logic br_predict
);

// bimodal prediction array
logic [1:0] bimodal [(2**length)-1:0];

/* Initialize array */
initial
begin
    for (int i = 0; i < $size(bimodal); i++)
    begin
    	// starting at weakly-taken
        bimodal[i] = 2'b01;
    end
end

always_ff @(posedge clk)
begin
    if (write == 1)
    begin
    	// Increment if no overflow possible
    	if (write_in & bimodal[write_index] != 2'b11)
    		bimodal[write_index] += 1'b1;
    	// Decrement if no underflow possible
    	else if (~write_in & bimodal[write_index] != 2'b00)
    		bimodal[write_index] -= 1'b1;
    end
end

assign br_predict = bimodal[read_index][1];

endmodule : pht_array