#!/bin/bash

echo "Usage: ./testcode/python/run-all-tests.sh"
# Copy rv_load_memory.sh into ./testcode.
# run me from project root (ie, h)

DIRECTORY="/home/"$USER"/ece411/h" # CHANGEME

echo "If things are breaking, delete simulation/modelsim and h/db, and open modelsim from quartus once."

cd $DIRECTORY

function run_tests()
{
	( cd ./testcode/python && python -c 'import run_tests; run_tests.test()' )
}

echo y | ./testcode/rv_load_memory.sh ./testcode/competition/comp1.s 1>/dev/null && printf "comp1.s: " && run_tests
echo y | ./testcode/rv_load_memory.sh ./testcode/competition/comp2.s 1>/dev/null && printf "comp2.s: " && run_tests
echo y | ./testcode/rv_load_memory.sh ./testcode/competition/comp3.s 1>/dev/null && printf "comp3.s: " && run_tests
