`timescale 1ns/1ps
module sp_ram (
    clk,   // Clock Input
    addr,  // Address Input
    data,  // Data bi-directional
    cs,    // Chip Select
    we,    // Write Enable
    oe     // Output Enable
);

  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 8;
  parameter RAM_DEPTH  = 2 ** ADDR_WIDTH;

  input clk, cs, we, oe;
  input [ADDR_WIDTH-1:0] addr;

  inout [DATA_WIDTH-1:0] data;

  reg [DATA_WIDTH-1:0] mem [RAM_DEPTH-1:0];
  reg [DATA_WIDTH-1:0] temp_data;

  always @(posedge clk) begin
    if (cs && we)
      mem[addr] <= data;
  end

  always @(posedge clk) begin
    if (cs && !we)
      temp_data <= mem[addr];
  end

  assign data = (cs && oe && !we) ? temp_data : 'hz;

  /*
  initial begin
    $readmemh("/Projects/marmik_project/akshata.annappa/single_port_ram_in_v_seq_with_De/memory_init.txt", mem, 0, 255);
  end
  */

endmodule

