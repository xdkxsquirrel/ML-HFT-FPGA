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
        wire       led4_r;
        wire       led4_g;
        wire       led4_b;

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
                .data_ready(ready_from_MLA),
                .out(out_from_MLA),
                .led4_r(led4_r),
                .led4_g(led4_g),
                .led4_b(led4_b)
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
    SendTSLAWeights();
    //GetTSLAWeights();
    //CalcBuyTSLA();
    //CalcWightsPosTSLA();
    //CalcWightsNegTSLA();
    $stop;
end


//////////////////////////////////////////////////////////////////////
// SendTSLAWeights
//////////////////////////////////////////////////////////////////////
task SendTSLAWeights;
begin
  $display("Setting Weights for TSLA");
  
  #5
  
  data_valid = 1;
  transmitted_byte = "A";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "1";
  #2
  data_valid = 0;
  #5
  
  data_valid = 1;
  transmitted_byte = "a";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "b";
  #2
  data_valid = 0;
  #5
  
  data_valid = 1;
  transmitted_byte = "5";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "5";
  #2
  data_valid = 0;
  #5
  
  data_valid = 1;
  transmitted_byte = "3";
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
  transmitted_byte = "1";
  #2
  data_valid = 0;
  #5
  
  data_valid = 1;
  transmitted_byte = "c";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "3";
  #2
  data_valid = 0;
  #5
  
  #20
  
  if(out == "1")
    $display("################################################ SEND TSLA WEIGHTS Passed ######################################");
  else
    $display("################################################ SEND TSLA WEIGHTS Failed ######################################");
  
    $display(" ");

end
endtask

//////////////////////////////////////////////////////////////////////
// GetTSLAWeights
//////////////////////////////////////////////////////////////////////
task GetTSLAWeights;
begin
  $display("Getting Weights for TSLA");
  
  #5
  
  data_valid = 1;
  transmitted_byte = "B";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "1";
  #2
  data_valid = 0;
  #5
  
  data_valid = 1;
  transmitted_byte = "d";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "c";
  #2
  data_valid = 0;
  #5
  
  data_valid = 1;
  transmitted_byte = "d";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "c";
  #2
  data_valid = 0;
  #5
  
  data_valid = 1;
  transmitted_byte = "d";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "c";
  #2
  data_valid = 0;
  #5
  
  data_valid = 1;
  transmitted_byte = "d";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "c";
  #2
  data_valid = 0;
  #5
  
  data_valid = 1;
  transmitted_byte = "d";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "c";
  #2
  data_valid = 0;
  #5
  
  #20
  
  if(out == "1")
    $display("################################################ GET TSLA WEIGHTS Passed #######################################");
  else
    $display("################################################ GET TSLA WEIGHTS Failed #######################################");
  
    $display(" ");

end
endtask


//////////////////////////////////////////////////////////////////////
// CalcBuyTSLA
//////////////////////////////////////////////////////////////////////
task CalcBuyTSLA;
begin
  $display("Calculating Buy for TSLA");
  
  #5
  
  data_valid = 1;
  transmitted_byte = "C";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "1";
  #2
  data_valid = 0;
  #5
  
  data_valid = 1;
  transmitted_byte = "0";
  #2
  data_valid = 0;
  #5

  data_valid = 1;
  transmitted_byte = "1";
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
  transmitted_byte = "1";
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
  
  #20
  
  if(out == "1")
    $display("################################################ Calc Buy TSLA  Passed #########################################");
  else
    $display("################################################ Calc Buy TSLA  Failed #########################################");
  
    $display(" ");

end
endtask

endmodule
