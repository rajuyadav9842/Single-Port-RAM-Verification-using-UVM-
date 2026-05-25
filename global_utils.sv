//global task "delay"  

task delay(input int delay_value, input bit clk); 

  // Wait for the specified number of clock cycles 

  for (int i = 0; i < delay_value; i++) begin 

    #delay_value; 

  end 

endtask 
