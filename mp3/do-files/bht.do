delete wave *

add wave -position end  sim:/testbench2/dut/cpu/fetch_stage/global_2_level_bht/br_predict
add wave -position end  sim:/testbench2/dut/cpu/fetch_stage/global_2_level_bht/bht_array0/read_index
add wave -position end  sim:/testbench2/dut/cpu/fetch_stage/global_2_level_bht/bht_array0/read_out0
add wave -position end  sim:/testbench2/dut/cpu/fetch_stage/global_2_level_bht/bht_array0/read_out1

restart -f; radix -h
run 10000ns
