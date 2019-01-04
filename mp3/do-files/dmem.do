transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/branch\ prediction {/home/klatzco2/ece411/h/cpu/branch prediction/pht_array.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/branch\ prediction {/home/klatzco2/ece411/h/cpu/branch prediction/bit_combiner.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/branch\ prediction {/home/klatzco2/ece411/h/cpu/branch prediction/bht_array.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/branch\ prediction {/home/klatzco2/ece411/h/cpu/branch prediction/static_not_taken.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/stalling {/home/klatzco2/ece411/h/cpu/stalling/staller_logic.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/stalling {/home/klatzco2/ece411/h/cpu/stalling/staller.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/given {/home/klatzco2/ece411/h/given/rv32i_types.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/given {/home/klatzco2/ece411/h/given/regfile.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/given {/home/klatzco2/ece411/h/given/pc_reg.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h {/home/klatzco2/ece411/h/muxes.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/branch\ prediction {/home/klatzco2/ece411/h/cpu/branch prediction/global_2_level_bht.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu {/home/klatzco2/ece411/h/cpu/cmp.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/given {/home/klatzco2/ece411/h/given/ir.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/given {/home/klatzco2/ece411/h/given/alu.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h {/home/klatzco2/ece411/h/pipeline_types.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/stages {/home/klatzco2/ece411/h/cpu/stages/writeback_stage.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/stages {/home/klatzco2/ece411/h/cpu/stages/memory_stage.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/stages {/home/klatzco2/ece411/h/cpu/stages/fetch_stage.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/stages {/home/klatzco2/ece411/h/cpu/stages/execute_stage.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/stages {/home/klatzco2/ece411/h/cpu/stages/decode_stage.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/stage\ registers {/home/klatzco2/ece411/h/cpu/stage registers/fetch_decode_reg.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/special\ registers {/home/klatzco2/ece411/h/cpu/special registers/storage_register.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/special\ registers {/home/klatzco2/ece411/h/cpu/special registers/control_word_register.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/forwarding {/home/klatzco2/ece411/h/cpu/forwarding/forward_val.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/forwarding {/home/klatzco2/ece411/h/cpu/forwarding/forward_control.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu {/home/klatzco2/ece411/h/cpu/control_rom.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/stage\ registers {/home/klatzco2/ece411/h/cpu/stage registers/memory_writeback_reg.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/stage\ registers {/home/klatzco2/ece411/h/cpu/stage registers/execute_memory_reg.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/stage\ registers {/home/klatzco2/ece411/h/cpu/stage registers/decode_execute_reg.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu/forwarding {/home/klatzco2/ece411/h/cpu/forwarding/forward_unit.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cpu {/home/klatzco2/ece411/h/cpu/cpu.sv}

vlog -sv -work work +incdir+/home/klatzco2/ece411/h/given {/home/klatzco2/ece411/h/given/rv32i_types.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h {/home/klatzco2/ece411/h/testbench.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/given {/home/klatzco2/ece411/h/given/magic_memory_dual_port.sv}
vlog -sv -work work +incdir+/home/klatzco2/ece411/h/cache_hierarchy/performance_counter {/home/klatzco2/ece411/h/cache_hierarchy/performance_counter/performance_counter.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L stratixiii_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave -position insertpoint  \
sim:/testbench/dut/dmem_addr \
sim:/testbench/dut/dmem_byte_enable \
sim:/testbench/dut/dmem_rdata \
sim:/testbench/dut/dmem_read \
sim:/testbench/dut/dmem_resp \
sim:/testbench/dut/dmem_wdata \
sim:/testbench/dut/dmem_write

view structure
view signals
run 3000 ns
radix -h

WaveRestoreCursors {{fucky wucky} {2295000 ps} 1} {{Cursor 2} {2294527 ps} 0}
quietly wave cursor active 2

WaveRestoreZoom {2167 ns} {2423 ns}
