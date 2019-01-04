delete wave *

add wave -position end sim:/testbench2/dut/cpu/clk

add wave -position end  sim:/testbench2/dut/cpu/revert_pc
add wave -position end  sim:/testbench2/dut/cpu/dmem_read
add wave -position end 	sim:/testbench2/dut/cpu/dmem_resp
add wave -position end  sim:/testbench2/dut/cpu/dmem_rdata

add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[1\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[2\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[3\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[4\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[5\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[6\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[7\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[8\]

add wave -position end  sim:/testbench2/dut/cpu/st_execute_
add wave -position end  sim:/testbench2/dut/cpu/cw_execute_

add wave -position end  sim:/testbench2/dut/cpu/st_execute
add wave -position end  sim:/testbench2/dut/cpu/cw_execute

add wave -position end  sim:/testbench2/dut/cpu/decode_stage/reg_wdata
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/rd
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/load_regfile

add wave -position end  sim:/testbench2/dut/cpu/st_writeback
add wave -position end  sim:/testbench2/dut/cpu/cw_writeback

restart -f; radix -h
run 10000ns
