//------------------------------------------------------------------------ 
//Contents: 
//File for SPRAM_sequence 
//Brief description: This is the SPRAM sequence file which consist of 
//write sequence. 
//------------------------------------------------------------------------- 
//Author: Mactino 
//Created on: 
//------------------------------------------------------------------------- 

class write_base_sequence extends uvm_sequence #(SPRAM_seq_item);

  `uvm_object_utils(write_base_sequence)

  parameter int ADDR_WIDTH       = 8;
  parameter int WR_ADDR_SET_SIZE = 4;
    
  SPRAM_seq_item          req;
  SPRAM_virtual_sequencer v_seqr;
  rand int index;

  function new(string name = "write_base_sequence");
    super.new(name);
  endfunction


  // Select a write address
  function bit [ADDR_WIDTH-1:0] select_address();

    if (v_seqr == null)
      `uvm_fatal("NULL_HANDLE", "Virtual sequencer handle is null");

    // If enough addresses collected → pick from queue
    if (v_seqr.we_addr.size() >= WR_ADDR_SET_SIZE) begin
      index = $urandom % v_seqr.we_addr.size();
      return v_seqr.we_addr[index];
    end

    // Otherwise generate a new address
    return $urandom % (1 << ADDR_WIDTH);
  endfunction


  // Get virtual sequencer handle
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
// Write sequence class
//-------------------------------------------------------------------------
class SPRAM_write_sequence extends write_base_sequence;

  `uvm_object_utils(SPRAM_write_sequence)

  parameter int QUEUE_SIZE = 20;

  function new(string name = "SPRAM_write_sequence");
    super.new(name);
  endfunction


  // Main write operation
  virtual task body();
    bit [ADDR_WIDTH-1:0] w_addr;

    req = SPRAM_seq_item::type_id::create("req");

    // Perform write transactions
    for (int i = 0; i < 2 * QUEUE_SIZE; i++) begin

      w_addr = select_address();

      req.operation = SPRAM_seq_item::WRITE_ONLY;

      start_item(req);
      if (!req.randomize()) begin
        `uvm_error("SPRAM_seq", "Randomization failed for WRITE_ONLY operation.");
      end
      finish_item(req);

    end

  endtask

endclass

