delete wave *

add wave -position end sim:/testbench2/dut/cpu/clk

add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[1\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[2\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[3\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[4\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[5\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[6\]
add wave -position end  sim:/testbench2/dut/cpu/decode_stage/regfile/data\[7\]

add wave -position end  sim:/testbench2/dut/cache_money/imem_address
add wave -position end  sim:/testbench2/dut/cache_money/ipmem_address
add wave -position end  sim:/testbench2/dut/cache_money/dmem_address
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_address
add wave -position end  sim:/testbench2/dut/cache_money/l2mem_address
add wave -position end  sim:/testbench2/dut/cache_money/pmem_address

add wave -position end  sim:/testbench2/dut/cache_money/arb_inst/arb_control_inst/state
add wave -position end  sim:/testbench2/dut/cache_money/arb_inst/arb_control_inst/next_state
add wave -position end  sim:/testbench2/dut/cache_money/arb_inst/arb_mux_sel
add wave -position end  sim:/testbench2/dut/cache_money/arb_inst/load_arb

add wave -position end  sim:/testbench2/dut/cache_money/imem_read
add wave -position end  sim:/testbench2/dut/cache_money/ipmem_read
add wave -position end  sim:/testbench2/dut/cache_money/dmem_read
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_read
add wave -position end  sim:/testbench2/dut/cache_money/l2mem_read
add wave -position end  sim:/testbench2/dut/cache_money/pmem_read

add wave -position end  sim:/testbench2/dut/cache_money/imem_write
add wave -position end  sim:/testbench2/dut/cache_money/ipmem_write
add wave -position end  sim:/testbench2/dut/cache_money/dmem_write
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_write
add wave -position end  sim:/testbench2/dut/cache_money/l2mem_write
add wave -position end  sim:/testbench2/dut/cache_money/pmem_write

add wave -position end  sim:/testbench2/dut/cache_money/imem_resp
add wave -position end  sim:/testbench2/dut/cache_money/ipmem_resp
add wave -position end  sim:/testbench2/dut/cache_money/dmem_resp
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_resp
add wave -position end  sim:/testbench2/dut/cache_money/l2mem_resp
add wave -position end  sim:/testbench2/dut/cache_money/pmem_resp

add wave -position end  sim:/testbench2/dut/cache_money/imem_rdata
add wave -position end  sim:/testbench2/dut/cache_money/ipmem_rdata
add wave -position end  sim:/testbench2/dut/cache_money/dmem_rdata
add wave -position end  sim:/testbench2/dut/cache_money/dpmem_rdata
add wave -position end  sim:/testbench2/dut/cache_money/l2mem_rdata
add wave -position end  sim:/testbench2/dut/cache_money/pmem_rdata

add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/hits
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/dirty
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/lru_out
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/load_lru
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/way_sel
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/load_word
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/load_line

add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/datapath/tag
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/datapath/set

add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/datapath/cacheway_0/data_array/data
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/datapath/cacheway_1/data_array/data
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/datapath/cacheway_2/data_array/data
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/datapath/cacheway_3/data_array/data
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/datapath/cacheway_0/tag_array/data
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/datapath/cacheway_1/tag_array/data
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/datapath/cacheway_2/tag_array/data
add wave -position end  sim:/testbench2/dut/cache_money/l2_cache/datapath/cacheway_3/tag_array/data



restart -f; radix -h
run 10000ns
