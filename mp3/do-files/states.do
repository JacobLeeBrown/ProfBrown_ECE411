delete wave *

add wave -position end  sim:/testbench/dut/clk

add wave -position end  sim:/testbench/dut/decode_stage/regfile/data\[1\]
add wave -position end  sim:/testbench/dut/decode_stage/regfile/data\[2\]
add wave -position end  sim:/testbench/dut/decode_stage/regfile/data\[3\]
add wave -position end  sim:/testbench/dut/decode_stage/regfile/data\[4\]
add wave -position end  sim:/testbench/dut/decode_stage/regfile/data\[5\]
add wave -position end  sim:/testbench/dut/decode_stage/regfile/data\[6\]
add wave -position end  sim:/testbench/dut/decode_stage/regfile/data\[7\]
add wave -position end  sim:/testbench/dut/decode_stage/regfile/data\[8\]
add wave -position end  sim:/testbench/dut/decode_stage/regfile/data\[9\]


add wave -position end  -color Blue sim:/testbench/divider


add wave -position end  sim:/testbench/dut/pc_out
add wave -position end  sim:/testbench/dut/opcode_fetch
add wave -position end  -color Blue sim:/testbench/divider
add wave -position end  sim:/testbench/dut/st_decode
add wave -position end  sim:/testbench/dut/cw_execute_
add wave -position end  sim:/testbench/dut/st_execute_
add wave -position end  sim:/testbench/dut/cw_execute
add wave -position end  sim:/testbench/dut/st_execute
add wave -position end  sim:/testbench/dut/st_memory_
add wave -position end  sim:/testbench/dut/cw_memory
add wave -position end  sim:/testbench/dut/st_memory
add wave -position end  sim:/testbench/dut/st_writeback_
add wave -position end  sim:/testbench/dut/cw_writeback
add wave -position end  sim:/testbench/dut/st_writeback


add wave -position end  -color Blue sim:/testbench/divider


add wave -position end  sim:/testbench/dut/dmem_addr
add wave -position end  sim:/testbench/dut/dmem_wdata
add wave -position end  sim:/testbench/dut/dmem_rdata
add wave -position end  sim:/testbench/dut/dmem_read
add wave -position end  sim:/testbench/dut/dmem_write
add wave -position end  sim:/testbench/dut/dmem_byte_enable
add wave -position end  sim:/testbench/dut/dmem_resp



WaveRestoreCursors {{Dmem_write Error} {13075 ns} 1}

restart -f; radix -h
run 20000ns
