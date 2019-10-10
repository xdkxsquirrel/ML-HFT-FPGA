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
        wire       ready_from_MLA;
        wire [7:0] out_from_MLA;

        convert_from_ASCII uut1 (
                .clk(clk),
                .data_valid(data_valid),
                .transmitted_byte(transmitted_byte),
                .ready(ready),
                .out(out)
        );
        
        MLA uut2 (
                .clk(clk),
                .data_valid(ready),
                .received_byte(out),
                .ready(ready_from_MLA),
                .out(out_from_MLA)
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
    //Convert();
    SendValues();
    $stop;
end


//////////////////////////////////////////////////////////////////////
// Convert
//////////////////////////////////////////////////////////////////////
task Convert;
begin
  $display("Send a full packet that is how it will be sent from the PI. -HEX 32 28 28 12 00 -DEC 50 40 40 18 0");

  data_valid = 1;
  transmitted_byte = "3";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "2";
  #2
  data_valid = 0;
  #5
  
  if(out == 8'h32)
    $display("################################################ 32 Test Passed ################################################");
  else
    $display("################################################ 32 Test Failed ################################################");
  
  data_valid = 1;
  transmitted_byte = "2";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "8";
  #2
  data_valid = 0;
  #5
  
  if(out == 8'h28)
    $display("################################################ 28 Test Passed ################################################");
  else
    $display("################################################ 28 Test Failed ################################################");
  
  data_valid = 1;
  transmitted_byte = "2";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "8";
  #2
  data_valid = 0;
  #5
  
  if(out == 8'h28)
    $display("################################################ 28 Test Passed ################################################");
  else
    $display("################################################ 28 Test Failed ################################################");
    
  data_valid = 1;
  transmitted_byte = "1";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "2";
  #2
  data_valid = 0;
  #5
  
  if(out == 8'h12)
    $display("################################################ 12 Test Passed ################################################");
  else
    $display("################################################ 12 Test Failed ################################################");
  
  data_valid = 1;
  transmitted_byte = "0";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "0";
  #2
  data_valid = 0;
  #2

  if(out == 8'h00)
    $display("################################################ 00 Test Passed ################################################");
  else
    $display("################################################ 00 Test Failed ################################################");
  $display(" ");


end
endtask

//////////////////////////////////////////////////////////////////////
// Send Values to MLA and expect output
//////////////////////////////////////////////////////////////////////
task SendValues;
begin
  $display("Send a full packet that is how it will be sent from the PI. -HEX 32 32 32 00 00 FA");

  data_valid = 1;
  transmitted_byte = "3";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "2";
  #2
  data_valid = 0;
  #5
  
  data_valid = 1;
  transmitted_byte = "3";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "2";
  #2
  data_valid = 0;
  #5
  
  data_valid = 1;
  transmitted_byte = "3";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "2";
  #2
  data_valid = 0;
  #5
    
  data_valid = 1;
  transmitted_byte = "0";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "0";
  #2
  data_valid = 0;
  #5
    
  data_valid = 1;
  transmitted_byte = "0";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "0";
  #2
  data_valid = 0;
  #5
  
  data_valid = 1;
  transmitted_byte = "7";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "D";
  #2
  data_valid = 0;
  #10

  if(out_from_MLA == "1")
    $display("################################################ Test Passed ################################################");
  else
    $display("################################################ Test Failed ################################################");
  $display(" ");


end
endtask

endmodule
