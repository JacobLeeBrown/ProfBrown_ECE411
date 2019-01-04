import pipeline_types::*;

module storage_register
(
    input clk,
    input load,
    input storage_t in,
    output storage_t out
);

storage_t data;

/* Altera device registers are 0 at power on. Specify this
 * so that Modelsim works as expected.
 */
initial
begin
    data = 0;
end

always_ff @(posedge clk)
begin
    if (load)
    begin
        data = in;
    end
end

always_comb
begin
    out = data;
end

endmodule : storage_register
