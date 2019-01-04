delete wave *

add wave -position end sim:/testbench2/dut/cpu/clk

add wave -position end  sim:/testbench2/dut/cpu/pc_out
add wave -position end  sim:/testbench2/dut/cpu/instr_base
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/control_rom/opcode
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/control_rom/funct3
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/control_rom/funct7
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/control_rom/out

add wave -position end  sim:/testbench2/dut/cpu/decode_stage/control_rom/opcode
add wave -position end  sim:/testbench2/dut/cpu/cw_execute.opcode
add wave -position end  sim:/testbench2/dut/cpu/cw_memory.opcode
add wave -position end  sim:/testbench2/dut/cpu/cw_writeback.opcode

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

add wave -position end  sim:/testbench2/dut/cpu/st_decode
add wave -position end  sim:/testbench2/dut/cpu/cw_execute
add wave -position end  sim:/testbench2/dut/cpu/st_execute
add wave -position end  sim:/testbench2/dut/cpu/cw_memory
add wave -position end  sim:/testbench2/dut/cpu/st_memory
add wave -position end  sim:/testbench2/dut/cpu/cw_writeback
add wave -position end  sim:/testbench2/dut/cpu/st_writeback

add wave -position end  sim:/testbench2/dut/cache_money/imem_address
add wave -position end  sim:/testbench2/dut/cache_money/dmem_address
add wave -position end  sim:/testbench2/dut/cache_money/ipmem_address
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_address
add wave -position end  sim:/testbench2/dut/cache_money/pmem_address
add wave -position end  sim:/testbench2/dut/cache_money/imem_read
add wave -position end  sim:/testbench2/dut/cache_money/ipmem_read
add wave -position end  sim:/testbench2/dut/cache_money/dmem_read
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_read
add wave -position end  sim:/testbench2/dut/cache_money/pmem_read
add wave -position end  sim:/testbench2/dut/cache_money/dmem_write
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_write
add wave -position end  sim:/testbench2/dut/cache_money/pmem_write
add wave -position end  sim:/testbench2/dut/cache_money/imem_resp
add wave -position end  sim:/testbench2/dut/cache_money/dmem_resp
add wave -position end  sim:/testbench2/dut/cache_money/ipmem_resp
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_resp
add wave -position end  sim:/testbench2/dut/cache_money/pmem_resp

add wave -position end  sim:/testbench2/dut/cache_money/dmem_rdata
add wave -position end  sim:/testbench2/dut/cache_money/imem_rdata
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_rdata
add wave -position end  sim:/testbench2/dut/cache_money/ipmem_rdata
# add wave -position end  sim:/testbench2/dut/cache_money/  
# 
# add wave -position end  sim:/testbench2/dut/cache_money/arb_inst/arb_mux_sel
# 
# add wave -position end  sim:/testbench2/dut/cpu/staller/load_pipeline

# add wave -position end  sim:/testbench2/dut/cache_money/*

add wave -position end  sim:/testbench2/dut/cache_money/d_cache/datapath/cacheway_0/data_array/data
add wave -position end  sim:/testbench2/dut/cache_money/d_cache/datapath/cacheway_1/data_array/data

restart -f; radix -h
run 10000ns
