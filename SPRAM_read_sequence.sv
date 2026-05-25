//------------------------------------------------------------------------ 
//Contents: 
//File for SPRAM_sequence 
//Brief description: This is the SPRAM sequence file which consist of 
//read sequence. 
//------------------------------------------------------------------------- 
//Author: Mactino 
//Created on: 
//------------------------------------------------------------------------- 

class read_base_sequence extends uvm_sequence #(SPRAM_seq_item);

  `uvm_object_utils(read_base_sequence)

  parameter int ADDR_WIDTH       = 8;
  parameter int WR_ADDR_SET_SIZE = 4;
    
  SPRAM_seq_item          req;
  SPRAM_virtual_sequencer v_seqr;
  rand int index;

  function new(string name = "read_base_sequence");
    super.new(name);
  endfunction


  // Choose an address (used only for initial read address warmup)
  function bit [ADDR_WIDTH-1:0] select_address();

    if (v_seqr == null)
      `uvm_fatal("NULL_HANDLE", "Virtual sequencer handle is null");

    if (v_seqr.we_addr.size() >= WR_ADDR_SET_SIZE) begin
      index = $urandom % v_seqr.we_addr.size();
      return v_seqr.we_addr[index];
    end

    return $urandom % (1 << ADDR_WIDTH);
  endfunction


  // Called before the sequence body starts
  virtual task pre_body();

    if (!uvm_config_db#(SPRAM_virtual_sequencer)::get(
          null, "top.env.*", "virtual_sqr", v_seqr
        ))
    begin
      `uvm_fatal("SEQ_GET_FAIL", "Failed to get virtual sequencer handle");
    end

    if (v_seqr == null)
      `uvm_fatal("NULL_HANDLE", "Virtual sequencer handle is null");

  endtask

endclass



//-------------------------------------------------------------------------
// Read sequence class
//-------------------------------------------------------------------------
class SPRAM_read_sequence extends read_base_sequence;

  `uvm_object_utils(SPRAM_read_sequence)

  parameter int QUEUE_SIZE = 20;

  function new(string name = "SPRAM_read_sequence");
    super.new(name);
  endfunction


  // Main read operation
  virtual task body();

    req = SPRAM_seq_item::type_id::create("req");

    // Perform reads based on write queue size
    for (int i = 0; i < 2 * QUEUE_SIZE; i++) begin

      int addr_index = i % v_seqr.we_addr.size();
      bit [ADDR_WIDTH-1:0] w_addr = v_seqr.we_addr[addr_index];

      req.operation = SPRAM_seq_item::READ_ONLY;

      start_item(req);
      if (!req.randomize()) begin
        `uvm_error("SPRAM_seq", "Randomization failed for READ_ONLY operation.");
      end
      finish_item(req);

    end

  endtask

endclass

