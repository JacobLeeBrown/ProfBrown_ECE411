transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/klatzco2/ece411/h/given {/home/klatzco2/ece411/h/given/rv32i_types.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cache/arbiter {/home/klatzco2/ece411/h/cache/arbiter/arbiter.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cache/arbiter {/home/klatzco2/ece411/h/cache/arbiter/arb_control.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cache/arbiter {/home/klatzco2/ece411/h/cache/arbiter/arb_datapath.sv}

# testbench files
vlog -sv -work work +incdir+ /home/klatzco2/ece411/h/testcode/testbenches/arbiter/ {/home/klatzco2/ece411/h/testcode/testbenches/arbiter/arb_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L stratixiii_ver -L rtl_work -L work -voptargs="+acc"  arb_tb

radix -h

# add wave *
add wave -position insertpoint sim:/arb_tb/clk
add wave -position insertpoint sim:/arb_tb/ipmem_address
add wave -position insertpoint sim:/arb_tb/dpmem_address

add wave -position insertpoint sim:/arb_tb/ipmem_read
add wave -position insertpoint sim:/arb_tb/dpmem_read

add wave -position insertpoint sim:/arb_tb/l2mem_rdata
add wave -position insertpoint sim:/arb_tb/ipmem_rdata
add wave -position insertpoint sim:/arb_tb/dpmem_rdata
view structure
view signals
run 200 ns
