#!/bin/bash

# status: this does not work.

/software/altera/13.1/modelsim_ase/linuxaloem/vish -- \
-vsim -i -l msim_transcript \
-do ../../do-files/performance_counters.do
