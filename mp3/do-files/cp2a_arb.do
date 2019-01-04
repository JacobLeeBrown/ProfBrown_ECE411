delete wave *

add wave -position end sim:/testbench2/dut/cpu/clk

add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[1\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[2\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[3\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[4\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[5\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[6\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[7\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[8\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[9\]

add wave -position end  sim:/testbench2/dut/cache_money/imem_address
add wave -position end  sim:/testbench2/dut/cache_money/dmem_address
add wave -position end  sim:/testbench2/dut/cache_money/ipmem_address
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_address
add wave -position end  sim:/testbench2/dut/cache_money/pmem_address

add wave -position end  sim:/testbench2/dut/cache_money/arb_inst/arb_control_inst/state
add wave -position end  sim:/testbench2/dut/cache_money/arb_inst/arb_control_inst/next_state
add wave -position end  sim:/testbench2/dut/cache_money/arb_inst/arb_mux_sel
add wave -position end  sim:/testbench2/dut/cache_money/arb_inst/load_arb

add wave -position end  sim:/testbench2/dut/cache_money/ipmem_read
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_read
add wave -position end  sim:/testbench2/dut/cache_money/pmem_read
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_write
add wave -position end  sim:/testbench2/dut/cache_money/ipmem_resp
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_resp
add wave -position end  sim:/testbench2/dut/cache_money/pmem_resp

add wave -position end  sim:/testbench2/dut/cache_money/dmem_rdata
add wave -position end  sim:/testbench2/dut/cache_money/imem_rdata
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_rdata
add wave -position end  sim:/testbench2/dut/cache_money/ipmem_rdata

restart -f; radix -h
run 10000ns
