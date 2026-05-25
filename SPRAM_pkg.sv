`timescale 1ns/1ps
package SPRAM_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  `include "global_utils.sv"
  `include "SPRAM_seq_item.sv"
  `include "SPRAM_sequencer.sv"
  `include "SPRAM_read_sequencer.sv"
  `include "SPRAM_coverage.sv"
  `include "SPRAM_driver.sv"
  `include "SPRAM_monitor.sv"
  `include "SPRAM_write_agent.sv"
  `include "SPRAM_read_agent.sv"
  `include "SPRAM_score.sv"
  `include "SPRAM_virtual_sequencer.sv"
  `include "SPRAM_environment.sv"
  `include "SPRAM_write_sequence.sv"
  `include "SPRAM_read_sequence.sv"

  `include "SPRAM_random_sequence.sv"
  `include "SPRAM_virtual_sequence.sv"
  `include "SPRAM_test.sv"

endpackage : SPRAM_pkg

