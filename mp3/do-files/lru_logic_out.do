delete wave *

add wave -position end  sim:/lru_logic_tb/t2i
add wave -position end  sim:/lru_logic_tb/t2o
add wave -position end  sim:/lru_logic_tb/t4i
add wave -position end  sim:/lru_logic_tb/t4o
add wave -position end  sim:/lru_logic_tb/t8i
add wave -position end  sim:/lru_logic_tb/t8o

restart -f; radix -unsigned
run 160ns