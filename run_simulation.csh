#!/bin/csh

source /home/install/cshrc

xrun \
-clean \
-coverage functional \
-covoverwrite \
-covtest SPRAM_coverage_cov \
-uvm \
-access +rwc \
+assert \
./single_port_ram.sv \
./top.sv \
-input probe.tcl

