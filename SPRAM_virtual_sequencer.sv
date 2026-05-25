//------------------------------------------------------------------------ 
//Contents:
//File for SPRAM_virtual_sequencer
//Brief description: This is the SPRAM virtual sequencer file is to connect  
//with the SPRAM sequencer
//-------------------------------------------------------------------------
//Author: Mactino
//Created on:
//-------------------------------------------------------------------------

`uvm_analysis_imp_decl(_in_queue)

class SPRAM_virtual_sequencer extends uvm_sequencer #(SPRAM_seq_item);

  // UVM Factory registration for the virtual sequencer
  `uvm_component_utils(SPRAM_virtual_sequencer)

  parameter ADDR_WIDTH = 8;    // Parameter defining the address width
  parameter QUEUE_SIZE = 4;

  bit [ADDR_WIDTH-1:0] we_addr[$];   // Dynamic queue to store write addresses

  SPRAM_read_sequencer  r_sqr;  // Read sequencer handle
  SPRAM_write_sequencer sqr;    // Write sequencer handle
  virtual mem_if myvinf;        // Virtual interface handle for the memory interface

  uvm_analysis_imp_in_queue #(SPRAM_seq_item, SPRAM_virtual_sequencer) store_addr_in_queue;

  // Constructor for the virtual sequencer
  function new(string name = "SPRAM_virtual_sequencer", uvm_component parent);
    super.new(name, parent);

    // Initialize the analysis imp for the address queue
    store_addr_in_queue = new("store_addr_in_queue", this);
  endfunction

  // Build phase to get configuration settings and sequencer handles
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual mem_if)::get(this, "", "myvinf", myvinf))
      `uvm_fatal("NO_VIF", "Virtual interface not found");

    if (!uvm_config_db#(SPRAM_read_sequencer)::get(this, "*", "r_sqr", r_sqr))
      `uvm_fatal("SEQ_GET_FAIL", "Failed to get read sequencer handle");

    if (!uvm_config_db#(SPRAM_write_sequencer)::get(this, "*", "sqr", sqr))
      `uvm_fatal("SEQ_GET_FAIL", "Failed to get write sequencer handle");
  endfunction

  // Function to process the write operation and update we_addr queue
  function void write_in_queue(input SPRAM_seq_item tr);

    if (tr.we) begin

      if (we_addr.size() < QUEUE_SIZE) begin

        // Check if the address is already in the queue
        foreach (we_addr[i]) begin
          if (we_addr[i] == tr.addr) begin
            return;  // If address already exists, do not add again
          end
        end

        // Add the write address to queue until full
        we_addr.push_back(tr.addr);

      end
    end

  endfunction

endclass

