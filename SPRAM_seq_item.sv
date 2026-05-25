class SPRAM_seq_item extends uvm_sequence_item;

  parameter int DATA_WIDTH = 8;
  parameter int ADDR_WIDTH = 8;

  rand bit                  we;
  rand bit                  oe;
       bit                  cs = 1;
  rand bit [ADDR_WIDTH-1:0] addr;
  rand bit [DATA_WIDTH-1:0] data;

  parameter int WE_RANDOMIZE_CONTROL = 50;
  parameter int OE_RANDOMIZE_CONTROL = 50;

  int we_control;
  int oe_control;

  typedef enum { WRITE_ONLY, READ_ONLY, RANDOM } operation_e;
  operation_e operation = RANDOM;

  `uvm_object_utils_begin(SPRAM_seq_item)
    `uvm_field_int(we,   UVM_DEC)
    `uvm_field_int(oe,   UVM_DEC)
    `uvm_field_int(addr, UVM_DEC)
    `uvm_field_int(data, UVM_DEC)
    `uvm_field_enum(operation_e, operation, UVM_ENUM)
  `uvm_object_utils_end

  function new(string name="SPRAM_seq_item");
    super.new(name);
  endfunction

  
  function void pre_randomize();
    super.pre_randomize();

    case (operation)

      WRITE_ONLY: begin
        if (!uvm_config_db#(int)::get(null, "", "WE_RANDOMIZE_CONTROL", we_control))
          we_control = WE_RANDOMIZE_CONTROL;

        oe_control = 0;  
      end

      READ_ONLY: begin
        if (!uvm_config_db#(int)::get(null, "", "OE_RANDOMIZE_CONTROL", oe_control))
          oe_control = OE_RANDOMIZE_CONTROL;

        we_control = 0;   
      end

      default: begin  
        we_control = WE_RANDOMIZE_CONTROL;
        oe_control = OE_RANDOMIZE_CONTROL;
      end

    endcase
  endfunction

 

  constraint cb_we {
    we dist { 1 := we_control, 0 := 100 - we_control };
  }

  constraint cb_oe {
    oe dist { 1 := oe_control, 0 := 100 - oe_control };
  }

  constraint cb_addr {
    addr inside { [0:255] };
  }

  constraint cb_data {
    data inside { [0:255] };
  }

endclass

