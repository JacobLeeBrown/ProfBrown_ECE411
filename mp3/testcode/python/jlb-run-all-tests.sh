#!/bin/bash

echo "Usage: ./testcode/python/run-all-tests.sh"
# Copy rv_load_memory.sh into ./testcode.
# run me from project root (ie, h)

DIRECTORY="/home/"$USER"/ece411/mp3" # CHANGEME

echo "If things are breaking, delete simulation/modelsim and h/db, and open modelsim from quartus once."

cd $DIRECTORY

function run_tests()
{
	( cd ./testcode/python && python -c 'import jlb_run_tests; jlb_run_tests.test()' )
}

echo y | ./testcode/jlb_rvlm.sh ./testcode/competition/comp1.s 1>/dev/null && printf "comp1.s: " && run_tests
echo y | ./testcode/jlb_rvlm.sh ./testcode/competition/comp2.s 1>/dev/null && printf "comp2.s: " && run_tests
echo y | ./testcode/jlb_rvlm.sh ./testcode/competition/comp3.s 1>/dev/null && printf "comp3.s: " && run_tests
