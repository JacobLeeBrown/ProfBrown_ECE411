from subprocess import PIPE, Popen
import parse

pipe_all = {"stdin" : PIPE}#, "stdout" : PIPE, "stderr" : PIPE}
parser = parse.compile("{: >.d}{:s}+{:d}{:s}{{{tags0}}}{:s}{{{tags1}}}{:s}{{{data0}}}{:s}{{{data1}}}{write_data: >64.S}{write: >1.S}{write_address: >7.S}{:s}{{{REGS}}}{}") #riscv

def sim(vsim_command):
	vsim_sim = Popen(["/software/altera/13.1/modelsim_ase/bin/vsim", "-c"], **pipe_all)
	command = 'vlib rtl_work; vmap work rtl_work; ' + vsim_command + '; radix hex; add list tags0; add list tags1; add list data0; add list data1; add list -notrigger write_data; add list write; add list -notrigger write_address; add list registers; when {halt == "1"} {write list out.lst; exit} ; run 50000ns'
	vsim_sim.communicate(command)
	vsim_sim.wait()
	with open("out.lst", 'r') as out:
		sim_out = [tuple(val for key,val in sorted(parsed.named.items())) for parsed in (parser.parse(line) for line in out) if parsed]
	return sim_out

dolines = 'vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L stratixiii_ver -L rtl_work -L work -voptargs="+acc"  mp2_tb'
sim_trace = sim(dolines)
for x in sim_trace:
    print x

