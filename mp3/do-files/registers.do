delete wave *

add wave -position insertpoint  \
sim:/testbench2/dut/cpu/decode_stage/regfile/data

view structure
view signals
radix -h 
run 10000000 ms
