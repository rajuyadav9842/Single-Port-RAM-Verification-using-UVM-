//------------------------------------------------------------------------ 
//Contents: 
//File for SPRAM_test 
//Brief description: This is the SPRAM test file which connects 
//environment,virtual sequence  
//------------------------------------------------------------------------- 
//Author: Mactino 
//Created on: 
//------------------------------------------------------------------------- 

class SPRAM_test extends uvm_test;

  // UVM Factory registration for the testbench 
  `uvm_component_utils(SPRAM_test)

  SPRAM_environment env_h;   // Handle for the SPRAM environment 
  SPRAM_vseq        vseq_h;  // Handle for the virtual sequence 
  uvm_event         cs_event; // Event for chip select signal

  virtual mem_if    myvinf;

  bit               clk;

  // Constructor to initialize the SPRAM test 
  function new(string name = "SPRAM_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase to instantiate and configure environment and virtual sequence 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the SPRAM environment and check for null 
    env_h = SPRAM_environment::type_id::create("env_h", this);
    if (env_h == null) begin
      `uvm_fatal("BUILD_ERROR", "Failed to create SPRAM_environment")
    end

    // Create the virtual sequence and check for null 
    vseq_h = SPRAM_vseq::type_id::create("vseq_h", this);
    if (vseq_h == null) begin
      `uvm_fatal("BUILD_ERROR", "Failed to create SPRAM_seq")
    end

    // Retrieve the chip select event (cs_event) from the UVM configuration database 
    if (!uvm_config_db#(uvm_event)::get(null, "", "cs_event", cs_event)) begin
      `uvm_fatal("CS_EVENT_ERROR", "Failed to retrieve cs_event")
    end

  endfunction

  // Run phase to start the virtual sequence after waiting for the chip select event 
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    // Wait for the chip select event to be triggered before starting the virtual sequence 
    cs_event.wait_trigger();
    vseq_h.start(env_h.virtual_sqr);  // Start the virtual sequence on the environment's sequencer 

    //cov.sample(myvinf);
    phase.drop_objection(this);
  endtask

endclass


//-------------------------------------------------------------------------
// Test extension class
//-------------------------------------------------------------------------

class SPRAM_test_extension1 extends SPRAM_test;

  // UVM Factory registration for the testbench extension 
  `uvm_component_utils(SPRAM_test_extension1)

  // Declare parameters for WE_CONTROL and OE_CONTROL for customization 
  int WE_CONTROL;
  int OE_CONTROL;

  // Constructor for test extension 
  function new(string name = "SPRAM_test_extension1", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Retrieve WE_CONTROL from the command line or use default value 
    if ($value$plusargs("WE_CONTROL=%d", WE_CONTROL)) begin
      `uvm_info("CONFIG_CONTROL", 
                $sformatf("WE_CONTROL set from command line: %0d", WE_CONTROL),
                UVM_LOW);
    end else begin
      `uvm_info("CONFIG_CONTROL", 
                $sformatf("WE_CONTROL default: %0d", WE_CONTROL), 
                UVM_LOW);
    end

    // Set WE_CONTROL value in the UVM configuration database 
    uvm_config_db#(int)::set(null, "*", "WE_RANDOMIZE_CONTROL", WE_CONTROL);

    // Retrieve OE_CONTROL from the command line or use default value 
    if ($value$plusargs("OE_CONTROL=%d", OE_CONTROL)) begin
      `uvm_info("CONFIG_CONTROL", 
                $sformatf("OE_CONTROL set from command line: %0d", OE_CONTROL),
                UVM_LOW);
    end else begin
      `uvm_info("CONFIG_CONTROL", 
                $sformatf("OE_CONTROL default: %0d", OE_CONTROL), 
                UVM_LOW);
    end

    // Set OE_CONTROL value in the UVM configuration database 
    uvm_config_db#(int)::set(null, "*", "OE_RANDOMIZE_CONTROL", OE_CONTROL);

  endfunction

endclass

