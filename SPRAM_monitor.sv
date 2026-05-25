//------------------------------------------------------------------------ 
//Contents:
//File for SPRAM_monitor
//Brief description: This is the SPRAM monitor file which monitors the  
//transaction and connects the analysis port
//-------------------------------------------------------------------------
//Author: Mactino
//Created on:
//-------------------------------------------------------------------------

class SPRAM_monitor extends uvm_monitor;
    
  // UVM Factory registration for the monitor
  `uvm_component_utils(SPRAM_monitor)
  
  // Virtual interface handle to connect with DUT signals
  virtual mem_if myvinf;
  
  uvm_analysis_port #(SPRAM_seq_item) analysis_port; //declaring the analysis port

  SPRAM_seq_item collect_port;   

  // Constructor to initialize the component and create the analysis port
  function new(string name = "SPRAM_monitor", uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);   // Create analysis port for transaction output
  endfunction : new

  // Build phase to set up the virtual interface and initialize collect_port
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual mem_if)::get( this, "", "myvinf", myvinf )) // Retrieve the virtual interface from UVM config DB
      `uvm_fatal("NO myvinf ", "Virtual interface not found");   // Error if interface is not found

    collect_port = SPRAM_seq_item::type_id::create("collect_port", this); // Create the transaction object for data collection
  endfunction : build_phase

  // Run phase to monitor signals and capture transactions
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge myvinf.clk);   // Wait for positive clock edge

      collect_port.we = myvinf.we;   // Capture write enable signal
      collect_port.oe = myvinf.oe;   // Capture output enable signal

      if (myvinf.we) begin   // If write enable is active, capture write data and address
        collect_port.data = myvinf.data;
        collect_port.addr = myvinf.addr;

      end else if (!myvinf.we && myvinf.oe) begin   // If read operation is active
        collect_port.addr = myvinf.addr;   // Capture address for read
        collect_port.data = myvinf.data;   // Capture read data
      end

      analysis_port.write(collect_port);  // Send the collected transaction to the analysis port
    end
  endtask : run_phase

endclass

