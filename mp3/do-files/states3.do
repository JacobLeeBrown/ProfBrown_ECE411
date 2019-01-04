delete wave *

add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data

add wave -position end  -color Blue sim:/testbench2/divider

add wave -position end  sim:/testbench2/dut/cpu/pc_out
add wave -position end  sim:/testbench2/dut/cpu/opcode_fetch


restart -f; radix -h
run 2ms