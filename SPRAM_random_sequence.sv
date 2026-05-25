//------------------------------------------------------------------------ 
//Contents: 
//File for SPRAM_sequence 
//Brief description: This is the SPRAM sequence file which consist of 
//random sequence. 
//------------------------------------------------------------------------- 
//Author: Mactino 
//Created on: 
//------------------------------------------------------------------------- 

class rand_base_sequence extends uvm_sequence #(SPRAM_seq_item);

  `uvm_object_utils(rand_base_sequence)

  parameter int ADDR_WIDTH       = 8;
  parameter int WR_ADDR_SET_SIZE = 4;
    
  SPRAM_seq_item          req;        // Sequence item for each transaction 
  SPRAM_virtual_sequencer v_seqr;     // Virtual sequencer handle
  rand int index;                      // Random index 

  function new(string name = "rand_base_sequence");
    super.new(name);
  endfunction

  // Select a write address
  function bit [ADDR_WIDTH-1:0] select_address();

    if (v_seqr == null)
      `uvm_fatal("NULL_HANDLE", "Virtual sequencer handle is null");

    // If queue is full → pick from queue
    if (v_seqr.we_addr.size() >= WR_ADDR_SET_SIZE) begin
      index = $urandom % v_seqr.we_addr.size();
      return v_seqr.we_addr[index];
    end
    else begin
      // Queue not full → generate new random address
      return $urandom % (1 << ADDR_WIDTH);
    end

  endfunction


  // Get virtual sequencer handle
  virtual task pre_body();

    // Retrieve the virtual sequencer
    if (!uvm_config_db#(SPRAM_virtual_sequencer)::get(
           null, "top.env.*", "virtual_sqr", v_seqr
        ))
    begin
      `uvm_fatal("SEQ_GET_FAIL", "Failed to get virtual sequencer handle");
    end

    if (v_seqr == null) begin
      `uvm_fatal("NULL_HANDLE", "Virtual sequencer handle is null");
    end

  endtask

endclass



//-------------------------------------------------------------------------
// Random sequence class
//-------------------------------------------------------------------------
class random_sequence extends rand_base_sequence;

  `uvm_object_utils(random_sequence)

  int unsigned repeat_count;

  function new(string name = "random_sequence");
    super.new(name);
  endfunction


  virtual task body();
    bit [ADDR_WIDTH-1:0] random_addr;

    // Get repeat_count from command line or default
    if (!$value$plusargs("repeat_count=%d", repeat_count))
      repeat_count = 2000;

    req = SPRAM_seq_item::type_id::create("req");

    repeat (repeat_count) begin

      random_addr = select_address();

      req.operation = SPRAM_seq_item::RANDOM;

      start_item(req);
      if (!req.randomize()) begin
        `uvm_error("SPRAM_seq", "Randomization failed for RANDOM operation.");
      end
      finish_item(req);

    end

  endtask

endclass

