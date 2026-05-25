//------------------------------------------------------------------------ 
//Contents: 
//File for SPRAM_virtual_sequence 
//Brief description: This is the SPRAM sequence file which consist of 
//virtual sequence. 
//------------------------------------------------------------------------- 
//Author: Mactino 
//Created on: 
//------------------------------------------------------------------------- 

class SPRAM_vseq extends uvm_sequence #(SPRAM_seq_item);

  // UVM Factory registration for the virtual sequence  
  `uvm_object_utils(SPRAM_vseq)
   
  //Declare a pointer to virtual sequencer 
  `uvm_declare_p_sequencer(SPRAM_virtual_sequencer)   

  // Declare pointers to sequences used in the main body 
  SPRAM_write_sequence w;   
  SPRAM_read_sequence  r;   
  random_sequence      w_r;   

  // Constructor for the SPRAM_vseq class 
  function new(string name = "SPRAM_vseq");
    super.new(name);
  endfunction

  task pre_body();
    // Create instances of the write, read, and random sequences using factory 
    w   = SPRAM_write_sequence::type_id::create("w");
    r   = SPRAM_read_sequence::type_id::create("r");
    w_r = random_sequence::type_id::create("w_r");
  endtask

  task body();
    begin
      // Raise an objection to keep the simulation running during sequence execution 
      if (starting_phase != null) starting_phase.raise_objection(this);

      // Start the write sequence  
      w.start(p_sequencer.sqr);

      // Start the random sequence 
      w_r.start(p_sequencer.sqr);

      // Start the read sequence 
      r.start(p_sequencer.r_sqr);

      // Drop the objection once the sequence is completed 
      if (starting_phase != null) starting_phase.drop_objection(this);
    end
  endtask

endclass

