delete wave *

add wave -position end  sim:/vc_tb/clk
add wave -position end  sim:/vc_tb/state

add wave -position end  sim:/vc_tb/divider


add wave -position end  sim:/vc_tb/mem_address;
add wave -position end  sim:/vc_tb/mem_wdata;
add wave -position end  sim:/vc_tb/mem_rdata;
add wave -position end  sim:/vc_tb/mem_read;
add wave -position end  sim:/vc_tb/mem_write;
add wave -position end  sim:/vc_tb/mem_resp;


add wave -position end  sim:/vc_tb/divider


add wave -position end  sim:/vc_tb/pmem_address;
add wave -position end  sim:/vc_tb/pmem_wdata;
add wave -position end  sim:/vc_tb/pmem_rdata;
add wave -position end  sim:/vc_tb/pmem_read;
add wave -position end  sim:/vc_tb/pmem_write;
add wave -position end  sim:/vc_tb/pmem_resp;


add wave -position end  sim:/vc_tb/divider


add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[0]/data_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[1]/data_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[2]/data_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[3]/data_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[4]/data_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[5]/data_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[6]/data_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[7]/data_buffer/data}


add wave -position end  sim:/vc_tb/divider


add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[0]/address_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[1]/address_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[2]/address_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[3]/address_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[4]/address_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[5]/address_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[6]/address_buffer/data}
add wave -position end  {sim:/vc_tb/vc/vc_datapath/entrees[7]/address_buffer/data}


add wave -position end  sim:/vc_tb/divider

add wave -position end  sim:/vc_tb/vc/vc_control/full
add wave -position end  sim:/vc_tb/vc/vc_control/hit
add wave -position end  sim:/vc_tb/vc/vc_control/hit_idx
add wave -position end  sim:/vc_tb/vc/vc_control/circular_idx
add wave -position end  sim:/vc_tb/vc/vc_control/idx
add wave -position end  sim:/vc_tb/vc/vc_control/load
add wave -position end  sim:/vc_tb/vc/vc_control/circular_inc
add wave -position end  sim:/vc_tb/vc/vc_control/read_sel
add wave -position end  sim:/vc_tb/vc/vc_control/out_sel
add wave -position end  sim:/vc_tb/vc/vc_control/state
add wave -position end  sim:/vc_tb/vc/vc_control/next_state

restart -f; radix -u
run 1100ns