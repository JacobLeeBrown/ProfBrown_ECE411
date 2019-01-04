import os
path = "/home/" + os.getlogin() + "/ece411/mp3" # changeme

# print("then compile() to compile")
# print("then test() next")

from subprocess import PIPE, Popen
import time
from os import getcwd, chdir

pipe_all = {"stdin" : PIPE, "stdout" : PIPE}#, "stderr" : PIPE}

def compile():
	vsim_pipe = Popen(["/software/altera/13.1/modelsim_ase/bin/vsim", "-c"], **pipe_all)
	chdir(path+"/simulation/modelsim")

	dolines = open(path + "/simulation/modelsim/cpu_run_msim_rtl_verilog.do", 'r').readlines()
	initdo = "".join(dolines[:-2])

	# Opens a command line for modelsim.
	vsim_pipe = Popen(["/software/altera/13.1/modelsim_ase/bin/vsim", "-c"], **pipe_all)
	vsim_pipe.communicate(initdo)
	vsim_pipe.wait()

	print ("\nCompilation complete!\n")
	return

def test():

	chdir(path+"/simulation/modelsim")
	vsim_pipe = Popen(["/software/altera/13.1/modelsim_ase/bin/vsim", "-c"], **pipe_all)

	f = "".join(open("cpu_run_msim_rtl_verilog.do").readlines())
	command1 = \
		'radix hex;'\
		'add list halt ;'\
		'when {halt == "1"} {write list test1.lst} ;'\
		'run -all;exit;\n'

	vsim_pipe.communicate( f+command1 )

	# command2 = \
	# 	'delete list *;'\
	# 	'add list pmem_write;'\
	# 	'restart -f;'\
	# 	'nowhen *;'\
	# 	'when {halt == "1"} {write list test2.lst; exit} ;'\
	# 	'run -all\n'

	time =  open("test1.lst").readlines()[-1].split()[0][0:-3] + " nanoseconds\n"
	print(time)

	return 

	# vsim_pipe.wait()

	# THIS IS REALLY COOL
	# add list -notrigger write_data;\
	# add list write;\
	# add list -notrigger write_address;\




