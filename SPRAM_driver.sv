class SPRAM_driver extends uvm_driver #(SPRAM_seq_item);

  `uvm_component_utils(SPRAM_driver)

  SPRAM_seq_item req;
  virtual mem_if myvinf;

  function new(string name = "SPRAM_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    req = SPRAM_seq_item::type_id::create("req");

    if (!uvm_config_db#(virtual mem_if)::get(this, "", "myvinf", myvinf)) begin
      `uvm_fatal("NO myvinf", "Virtual interface not found");
    end
  endfunction

  task run_phase(uvm_phase phase);

    myvinf.we       <= 0;
    myvinf.oe       <= 0;
    myvinf.addr     <= 0;
    myvinf.data_out <= 0;

    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end

  endtask

  task drive();

    @(posedge myvinf.clk);

    myvinf.we   <= req.we;
    myvinf.oe   <= req.oe;
    myvinf.addr <= req.addr;

    if (req.we) begin
      myvinf.data_out <= req.data;
    end
    else if (req.oe) begin
      @(posedge myvinf.clk);
      req.data = myvinf.data;
    end

  endtask

endclass

