//------------------------------------------------------------------------ 
//Contents: 
//File for SPRAM_Interface 
//Brief description: This is the SPRAM Interface file which encapsulates the 
//communication between blocks 
//------------------------------------------------------------------------- 
//Author: Mactino 
//Created on: 
//-------------------------------------------------------------------------

interface mem_if(input logic clk, logic cs);

  //---------------------------------------
  // Declaring the signals
  //---------------------------------------
  logic [7:0] addr;
  logic       we;
  logic       oe;
  wire [7:0]  data;

  reg  [7:0]  data_out;

  // If write enable (we) is active, send data_out to RAM
  // Otherwise put high-impedance on data bus
  assign data = we ? data_out : 'hz;

endinterface

