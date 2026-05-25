//------------------------------------------------------------------------ 
//Contents:
//File for SPRAM_read_agent
//Brief description: This is the SPRAM read agent file which connects driver 
//sequencer and monitor
//-------------------------------------------------------------------------
//Author: Mactino
//Created on:
//-------------------------------------------------------------------------

class SPRAM_read_agent extends uvm_agent;

  // UVM Factory registration for the read agent
  `uvm_component_utils(SPRAM_read_agent)

  // Declare components for the read agent
  SPRAM_read_sequencer r_sqr;
  SPRAM_driver         driv2;
  SPRAM_monitor        mon2;

  // Constructor for the read agent
  function new(string name = "SPRAM_read_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase function to create sub-components
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon2 = SPRAM_monitor::type_id::create("mon2", this);

    // Check if the agent is active
    if (get_is_active() == UVM_ACTIVE) begin
      r_sqr = SPRAM_read_sequencer::type_id::create("r_sqr", this);
      driv2 = SPRAM_driver::type_id::create("driv2", this);
    end

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect the driver's sequencer port to the sequencer's export
    driv2.seq_item_port.connect(r_sqr.seq_item_export);

  endfunction

endclass

