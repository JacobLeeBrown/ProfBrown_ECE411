delete wave *

add wave -position end sim:/testbench2/dut/cpu/clk

add wave -position end  sim:/testbench2/dut/cpu/decode_stage/control_rom/opcode
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/control_rom/funct3
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/control_rom/funct7
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/control_rom/out

add wave -position end  sim:/testbench2/dut/cpu/decode_stage/control_rom/opcode
add wave -position end  sim:/testbench2/dut/cpu/cw_execute.opcode
add wave -position end  sim:/testbench2/dut/cpu/cw_memory.opcode
add wave -position end  sim:/testbench2/dut/cpu/cw_writeback.opcode


add wave -position end  sim:/testbench2/divider


add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[1\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[2\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[3\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[4\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[5\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[6\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[7\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[8\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[9\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[10\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[11\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[12\]


add wave -position end  sim:/testbench2/divider


add wave -position end  sim:/testbench2/dut/cpu/pc_out
add wave -position end  sim:/testbench2/dut/cpu/opcode_fetch


add wave -position end  sim:/testbench2/divider


add wave -position end  sim:/testbench2/dut/cpu/st_decode
add wave -position end  sim:/testbench2/dut/cpu/cw_execute_
add wave -position end  sim:/testbench2/dut/cpu/st_execute_
add wave -position end  sim:/testbench2/dut/cpu/cw_execute
add wave -position end  sim:/testbench2/dut/cpu/st_execute
add wave -position end  sim:/testbench2/dut/cpu/st_memory_
add wave -position end  sim:/testbench2/dut/cpu/cw_memory
add wave -position end  sim:/testbench2/dut/cpu/st_memory
add wave -position end  sim:/testbench2/dut/cpu/st_writeback_
add wave -position end  sim:/testbench2/dut/cpu/cw_writeback
add wave -position end  sim:/testbench2/dut/cpu/st_writeback


add wave -position end  sim:/testbench2/divider


add wave -position end  sim:/testbench2/dut/cpu/staller/load_pipeline
add wave -position end  sim:/testbench2/dut/cpu/flush_decode


add wave -position end  sim:/testbench2/divider


add wave -position end  sim:/testbench2/dut/cpu/forward_execute/aluforwardmux1_sel
add wave -position end  sim:/testbench2/dut/cpu/forward_execute/aluforwardmux2_sel
add wave -position end  sim:/testbench2/dut/cpu/forward_execute/cmpforwardmux1_sel
add wave -position end  sim:/testbench2/dut/cpu/forward_execute/cmpforwardmux2_sel

add wave -position end  sim:/testbench2/dut/cpu/execute_stage/aluforwardmux1_out
add wave -position end  sim:/testbench2/dut/cpu/execute_stage/aluforwardmux2_out
add wave -position end  sim:/testbench2/dut/cpu/execute_stage/cmpforwardmux1_out
add wave -position end  sim:/testbench2/dut/cpu/execute_stage/cmpforwardmux2_out

restart -f; radix -h
run 10000ns
