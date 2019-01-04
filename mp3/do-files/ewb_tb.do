delete wave *

add wave -position end  sim:/ewb_tb/clk
add wave -position end  sim:/ewb_tb/state

add wave -position end  sim:/ewb_tb/divider


add wave -position end  sim:/ewb_tb/mem_address;
add wave -position end  sim:/ewb_tb/mem_wdata;
add wave -position end  sim:/ewb_tb/mem_rdata;
add wave -position end  sim:/ewb_tb/mem_read;
add wave -position end  sim:/ewb_tb/mem_write;
add wave -position end  sim:/ewb_tb/mem_resp;


add wave -position end  sim:/ewb_tb/divider


add wave -position end  sim:/ewb_tb/pmem_address;
add wave -position end  sim:/ewb_tb/pmem_wdata;
add wave -position end  sim:/ewb_tb/pmem_rdata;
add wave -position end  sim:/ewb_tb/pmem_read;
add wave -position end  sim:/ewb_tb/pmem_write;
add wave -position end  sim:/ewb_tb/pmem_resp;


add wave -position end  sim:/ewb_tb/divider


add wave -position end  sim:/ewb_tb/ewb/ewb_datapath/valid_buffer/data
add wave -position end  sim:/ewb_tb/ewb/ewb_datapath/address_buffer/data
add wave -position end  sim:/ewb_tb/ewb/ewb_datapath/data_buffer/data
add wave -position end  sim:/ewb_tb/ewb/ewb_control/load
add wave -position end  sim:/ewb_tb/ewb/ewb_control/state
add wave -position end  sim:/ewb_tb/ewb/ewb_control/next_state

restart -f; radix -u
run 520ns