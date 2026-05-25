//------------------------------------------------------------------------ 
//Contents:
//File for SPRAM_environment
//Brief description: This is the SPRAM environment file which connects  
//monitor, virtual sequencer, and scoreboard
//-------------------------------------------------------------------------
//Author: Mactino
//Created on:
//-------------------------------------------------------------------------

class SPRAM_environment extends uvm_env;
  
  // UVM Factory registration for the environment class
  `uvm_component_utils(SPRAM_environment)

  // Declare agents, scoreboard, and virtual sequencer
  SPRAM_write_agent      write_agent;
  SPRAM_scoreboard       scb;
  SPRAM_read_agent       read_agent;
  SPRAM_virtual_sequencer virtual_sqr;
  SPRAM_coverage         cov;

  // Constructor for the environment
  function new(string name = "SPRAM_environment", uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase to create and configure components
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the scoreboard
    scb = SPRAM_scoreboard::type_id::create("scb", this);

    // Create the write agent
    write_agent = SPRAM_write_agent::type_id::create("write_agent", this);

    // Create the read agent
    read_agent = SPRAM_read_agent::type_id::create("read_agent", this);

    // Create the virtual sequencer
    virtual_sqr = SPRAM_virtual_sequencer::type_id::create("virtual_sqr", this);

    // Create the SPRAM coverage
    cov = SPRAM_coverage::type_id::create("cov", this);

    // Set configuration database entries for sequencers
    uvm_config_db#(SPRAM_read_sequencer)::set(null, "*", "r_sqr", read_agent.r_sqr);
    uvm_config_db#(SPRAM_write_sequencer)::set(null, "*", "sqr", write_agent.sqr);
    uvm_config_db#(SPRAM_virtual_sequencer)::set(null, "*", "virtual_sqr", virtual_sqr);

  endfunction

  // Connect phase to wire up components
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect write sequencer to the virtual sequencer
    virtual_sqr.sqr   = write_agent.sqr;

    // Connect read sequencer to the virtual sequencer
    virtual_sqr.r_sqr = read_agent.r_sqr;

    // Connect the monitors to the scoreboard, virtual sequencer and coverage
    if (write_agent != null && scb != null) begin
      write_agent.mon.analysis_port.connect(scb.ap_exp_data_export);
      write_agent.mon.analysis_port.connect(scb.ap_act_data_export);
      write_agent.mon.analysis_port.connect(virtual_sqr.store_addr_in_queue);
      write_agent.mon.analysis_port.connect(cov.analysis_export);
    end

    if (read_agent != null && scb != null) begin
      read_agent.mon2.analysis_port.connect(scb.ap_exp_data_export);
      read_agent.mon2.analysis_port.connect(scb.ap_act_data_export);
      read_agent.mon2.analysis_port.connect(cov.analysis_export);
    end

  endfunction

endclass

