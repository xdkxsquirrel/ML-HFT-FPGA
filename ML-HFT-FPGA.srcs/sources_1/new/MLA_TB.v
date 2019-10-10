`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 09/20/2019 10:29:45 AM
// Module Name: MLA_TB
// Project Name: MLA on an FPGA
// Target Devices: CMOD S7-25: Spartan 7
// Description: Full MLA, From UART to UART TestBench
// 
//////////////////////////////////////////////////////////////////////////////////
 
module MLA_TB;

        //Inputs
        reg        clk;
        reg        data_valid;
        reg [7:0]  transmitted_byte;

        // Outputs
        wire       ready;
        wire [7:0] out;

        convert_from_ASCII uut1 (
                .clk(clk),
                .data_valid(data_valid),
                .transmitted_byte(transmitted_byte),
                .ready(ready),
                .out(out)
        );

//////////////////////////////////////////////////////////////////////
// Main Testbench Procedure
//////////////////////////////////////////////////////////////////////
initial
begin
	clk = 0;
	data_valid = 0;
	transmitted_byte = 0;
end 

always
    #1 clk = !clk;

initial
begin
    Convert();
    $stop;
end


//////////////////////////////////////////////////////////////////////
// Convert
//////////////////////////////////////////////////////////////////////
task Convert;
begin
	data_valid = 1;
	transmitted_byte = "3";
  #1
  data_valid = 0;
  #5

  data_valid = 1;
	transmitted_byte = "F";
  #1
  data_valid = 0;
  #5

  if(out == 8'h3F)
    $display("Test Passed");
  else
    $display("Test Failed");


end
endtask

endmodule
