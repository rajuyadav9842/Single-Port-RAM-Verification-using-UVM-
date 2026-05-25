//------------------------------------------------------------------------ 
//Contents:
//File for SPRAM_write_agent
//Brief description: This is the SPRAM write agent file which connects driver 
//sequencer and monitor
//-------------------------------------------------------------------------
//Author: Mactino
//Created on:
//-------------------------------------------------------------------------

class SPRAM_write_agent extends uvm_agent;

  // UVM Factory registration for the write agent
  `uvm_component_utils(SPRAM_write_agent)

  // Declare components for the write agent
  SPRAM_write_sequencer sqr;
  SPRAM_driver          driv;
  SPRAM_monitor         mon;

  function new(string name = "SPRAM_write_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase function to create sub-components
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon = SPRAM_monitor::type_id::create("mon", this);

    // Check if the agent is active
    if (get_is_active() == UVM_ACTIVE) begin

      sqr  = SPRAM_write_sequencer::type_id::create("sqr", this);

      driv = SPRAM_driver::type_id::create("driv", this);

    end

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect the driver's sequencer port to the sequencer's export
    driv.seq_item_port.connect(sqr.seq_item_export);

  endfunction

endclass

