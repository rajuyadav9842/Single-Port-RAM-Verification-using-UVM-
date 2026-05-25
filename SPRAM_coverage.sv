class SPRAM_coverage extends uvm_subscriber #(SPRAM_seq_item);

  `uvm_component_utils(SPRAM_coverage)

  int addr;
  int data;
  bit we;
  bit oe;

  covergroup SPRAM_cov;

    addr_access: coverpoint addr {
      bins low[]  = {[0   : 85]};
      bins med[]  = {[86  : 170]};
      bins high[] = {[171 : 255]};
    }

    we_cp: coverpoint we {
      bins write[] = {0, 1};
    }

    oe_cp: coverpoint oe {
      bins enable_bins[] = {0, 1};
    }

    we_oe_cross: cross we_cp, oe_cp;

    data_access: coverpoint data {
      bins low[]  = {[0   : 85]};
      bins med[]  = {[86  : 170]};
      bins high[] = {[171 : 255]};
    }

  endgroup : SPRAM_cov

  function new(string name = "SPRAM_coverage", uvm_component parent = null);
    super.new(name, parent);
    SPRAM_cov = new();
  endfunction

  virtual function void write(SPRAM_seq_item t);

    `uvm_info("SPRAM_COVERAGE",
              $sformatf("Subscriber received: addr=%0h, data=%0h, we=%b, oe=%b",
                        t.addr, t.data, t.we, t.oe),
                UVM_LOW);

    addr = t.addr;
    data = t.data;
    we   = t.we;
    oe   = t.oe;

    SPRAM_cov.sample();
  endfunction

endclass

