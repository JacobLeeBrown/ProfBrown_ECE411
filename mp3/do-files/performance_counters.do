delete wave *

add wave -position insertpoint sim:/testbench2/clk
add wave -position insertpoint sim:/testbench2/dut/cpu/pc_out

add wave -position insertpoint  \
{sim:/testbench2/registers[1]} \
{sim:/testbench2/registers[2]} \
{sim:/testbench2/registers[3]} \
{sim:/testbench2/registers[4]} \
{sim:/testbench2/registers[5]} \
{sim:/testbench2/registers[6]} \
{sim:/testbench2/registers[7]} \
{sim:/testbench2/registers[8]} \
{sim:/testbench2/registers[9]} \
{sim:/testbench2/registers[10]}\
{sim:/testbench2/registers[11]}\
{sim:/testbench2/registers[12]}\
{sim:/testbench2/registers[13]}

add wave -position insertpoint sim:/testbench2/dut/cpu/decode_stage/opcode

add wave -position insertpoint  \
sim:/testbench2/dut/cache_money/dmem_resp

add wave -position insertpoint sim:/testbench2/dut/cache_money/performance_counter_inst/*

restart -f; radix -h
run 10000ns
