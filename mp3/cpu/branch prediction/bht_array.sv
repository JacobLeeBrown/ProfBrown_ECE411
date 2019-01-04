// requirements
// left shifting inputs on the write signal
// variable length would be nice too. that's controlled by the number of PC bits that are connected.
// dual port: one read, one write
module bht_array #(parameter width = 4, length = 8)
(
    input clk,

    // write port
    input  logic write,
    input  logic [length-1:0] write_index,
    input  logic write_in,

    // read-read port (for the current read)
    input  logic [length-1:0] read_index,
    output logic [width-1:0] read_out0,

    // write-read port (for the current write)
    output logic [width-1:0] read_out1
);

// w/defautl values: 4 bits with, 8 rows long.
logic [width-1:0] data [(2**length)-1:0] /* synthesis ramstyle = "logic" */;
// logic [width-1:0] data [7:0] /* synthesis ramstyle = "logic" */;

/* Initialize array */
initial
begin
    for (int i = 0; i < $size(data); i++)
    begin
        data[i] = 0;
    end
end

always_ff @(posedge clk)
begin
    if (write == 1)
    begin
        // concatenate the wires to perform a left shift.
        // width-2:0 means everything except the leftmost bit.
        data[write_index] = { data[write_index][width-2:0], write_in };
    end
end

always_comb
begin
    read_out0 = data[read_index];
    read_out1 = data[write_index];
end

endmodule : bht_array