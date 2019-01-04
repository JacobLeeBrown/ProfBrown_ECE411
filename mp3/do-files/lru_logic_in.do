delete wave *

add wave -position end  sim:/lru_logic_in_tb/t2i
add wave -position end  sim:/lru_logic_in_tb/w2
add wave -position end  sim:/lru_logic_in_tb/t2o
add wave -position end  sim:/lru_logic_in_tb/t4i
add wave -position end  sim:/lru_logic_in_tb/w4
add wave -position end  sim:/lru_logic_in_tb/t4o
add wave -position end  sim:/lru_logic_in_tb/t8i
add wave -position end  sim:/lru_logic_in_tb/w8
add wave -position end  sim:/lru_logic_in_tb/t8o

restart -f; radix -h
run 360ns