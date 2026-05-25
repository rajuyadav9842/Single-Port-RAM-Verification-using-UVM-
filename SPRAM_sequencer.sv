class SPRAM_write_sequencer extends uvm_sequencer #(SPRAM_seq_item); 

// UVM factory registration for write sequencer 

  `uvm_component_utils(SPRAM_write_sequencer) 

  // Constructor to initialize the sequencer 

  function new(string name = "SPRAM_write_sequencer", uvm_component parent); 

    super.new(name, parent); 

  endfunction 

  function void build_phase(uvm_phase phase); 

    super.build_phase(phase); 

  endfunction 

endclass 
