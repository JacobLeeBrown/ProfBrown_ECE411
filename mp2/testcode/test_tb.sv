
module test_tb;

timeunit 1ns;
timeprecision 1ns;

logic [2:0] test;

initial test = 0;
always #5 test++;

endmodule : test_tb

