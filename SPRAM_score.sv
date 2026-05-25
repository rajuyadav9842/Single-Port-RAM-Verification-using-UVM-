//------------------------------------------------------------------------ 
//Contents:
//File for SPRAM_scoreboard
//Brief description: Compares expected data and address with actual data
//-------------------------------------------------------------------------
//Author: Mactino
//-------------------------------------------------------------------------

`uvm_analysis_imp_decl(_exp_data)
`uvm_analysis_imp_decl(_act_data)

class SPRAM_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(SPRAM_scoreboard)

  parameter MEM_DEPTH = 256;
  parameter WIDTH     = 8;

  uvm_analysis_imp_exp_data #(SPRAM_seq_item, SPRAM_scoreboard) ap_exp_data_export;
  uvm_analysis_imp_act_data #(SPRAM_seq_item, SPRAM_scoreboard) ap_act_data_export;

  // Expected memory model
  bit [WIDTH-1:0] exp_mem[MEM_DEPTH-1:0];

  // Queue for actual read transactions
  SPRAM_seq_item act_que[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap_exp_data_export = new("ap_exp_data_export", this);
    ap_act_data_export = new("ap_act_data_export", this);
  endfunction

  function void write_exp_data(input SPRAM_seq_item tr);

    // If write → store to memory
    if (tr.we) begin
      exp_mem[tr.addr] = tr.data;
    end

    // If read → prepare expected output for comparison
    else begin
      tr.data = exp_mem[tr.addr];   
    end

  endfunction
 

  // Collect only READ actual data
  function void write_act_data(input SPRAM_seq_item tr);
    if (!tr.we && tr.oe)
      act_que.push_back(tr);
  endfunction

  function int check_act_data();
    SPRAM_seq_item act_tr;
    bit [WIDTH-1:0] exp_tr;

    act_tr = act_que.pop_front();
    exp_tr = exp_mem[act_tr.addr];

    if (act_tr.data == exp_tr) begin
      $display("MATCH: ACT=%0h EXP=%0h ADDR=%0h TIME=%0t",
                act_tr.data, exp_tr, act_tr.addr, $time);
      return 1;
    end
    else begin
      $display("MISMATCH: ACT=%0h EXP=%0h ADDR=%0h TIME=%0t",
                act_tr.data, exp_tr, act_tr.addr, $time);
      return 0;
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    int result;
    forever begin
      wait (act_que.size() > 0);

      result = check_act_data();

      if (result)
        `uvm_info(get_type_name(), "MATCHED", UVM_LOW)
      else
        `uvm_error(get_type_name(),
                   $sformatf("DATA MISMATCH at time %0t", $time))
    end
  endtask

endclass

