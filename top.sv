`include "uvm_macros.svh"
import uvm_pkg::*;
`include "SPRAM_pkg.sv"
`include "SPRAM_interface.sv"

module SPRAM_top;
  import SPRAM_pkg::*;

  bit clk;
  bit cs;

  // Declare and instantiate the chip select event for triggering actions on chip select changes 
  uvm_event cs_event = new("cs_event");

  // Instantiate the memory interface to link signals with the DUT (Device Under Test) 
  mem_if myvinf (
      clk,
      cs
  );

  // Instantiate the single-port RAM module (DUT) and connect it to interface signals 
  sp_ram DUT (
      .clk (myvinf.clk),      // Clock input 
      .cs  (myvinf.cs),       // Chip select input 
      .we  (myvinf.we),       // Write enable input 
      .oe  (myvinf.oe),       // Output enable input 
      .addr(myvinf.addr),     // Address bus 
      .data(myvinf.data)      // Data bus 
  );

  initial begin
    clk = 1'b1;               // Initialize clock to 1 
    initial_function();       // Call initial setup function to configure memory and UVM components 
    initial_task();           // Start the initial task which launches test execution 
  end

  always #5 clk = ~clk;       // Clock generation: toggle clock every 5 time units 

  // Task that forks chip_select and runs the specified test 
  task initial_task();
    fork
      chip_select();                      // Trigger the chip select signal sequence 
      run_test("SPRAM_test_extension1");  // Run UVM test named "SPRAM_test_extension1"
    join
  endtask

  // Task to handle chip select signal triggering for synchronization 
  task chip_select();
    cs = 1'b0;                // Set chip select to 0 
    @(posedge clk);           // Wait for a positive clock edge 
    cs = 1'b1;                // Set chip select to 1 
    cs_event.trigger();       // Trigger the chip select event for UVM synchronization 
  endtask

  // Function to read memory initialization file and print memory contents 
  function void memory_read();
    
    $readmemh("memory_init.txt",
              DUT.mem, 0, 255);

    for (int k = 0; k < 256; k = k + 1) begin
      `uvm_info("MEMORY_CONTENT",
                 $sformatf("%0d: %h", k, DUT.mem[k]),
                 UVM_MEDIUM);
    end
  endfunction

  // Function for initial setup tasks 
  function void initial_function();
    memory_read();  // Initialize DUT memory with content from file 

    // Set memory interface in UVM configuration database 
    uvm_config_db#(virtual mem_if)::set(null, "", "myvinf", myvinf);

    // Set chip select event in UVM configuration database 
    uvm_config_db#(uvm_event)::set(null, "", "cs_event", cs_event);
  endfunction

endmodule

