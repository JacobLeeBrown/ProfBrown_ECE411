import pipeline_types::*;

module control_word_register
(
    input clk,
    input load,
    input control_word in,
    output control_word out
);

control_word data;

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

endmodule : control_word_register
