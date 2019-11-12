`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 09/20/2019 10:29:45 AM
// Module Name: stock_weight_TB
// Project Name: MLA on an FPGA
// Target Devices: CMOD S7-25: Spartan 7
// Description: Testbench for the stock weight system
// 
//////////////////////////////////////////////////////////////////////////////////
 
module stock_weight_TB;

        //Inputs
        reg        clk;
        reg        data_valid;
        reg [47:0]  data;
        reg        stock_selected;

        // Outputs
        wire       data_ready;
        wire [39:0]out;

        stock_weight uut1 (
                .clk(clk),
                .data_valid(data_valid),
                .stock_selected(stock_selected),
                .data(data),
                .data_ready(data_ready),
                .out(out)
        );
        
parameter EXECUTION_CONFIRMATION            = 40'hCCCCCCCCCC;
parameter EXECUTE_BUY                       = 40'h1111111111;
parameter EXECUTE_SELL                      = 40'h2222222222;

//////////////////////////////////////////////////////////////////////
// Main Testbench Procedure
//////////////////////////////////////////////////////////////////////
initial
begin
	clk = 0;
	data_valid = 0;
	data = 0;
	stock_selected = 0;
end 

always
    #1 clk = !clk;

initial
begin
    SendStockWeights();
    GetStockWeights();
    CalcBuyStock();
    CalcWightsPos();
    CalcWightsNeg();
    $stop;
end


//////////////////////////////////////////////////////////////////////
// SendStockWeights
//////////////////////////////////////////////////////////////////////
task SendStockWeights;
begin
  $display("Setting Weights for Stock");
  
  #5
  
  data_valid = 1;
  stock_selected = 1;
  data = 48'h0AFF00FF21C3;
  #2
  data_valid = 0;
  #5
  
  #20
  
  if(out == EXECUTION_CONFIRMATION)
    $display("################################################ SEND WEIGHTS Passed ######################################");
  else
    $display("################################################ SEND WEIGHTS Failed ######################################");
  
    $display(" ");

end
endtask

//////////////////////////////////////////////////////////////////////
// GetStockWeights
//////////////////////////////////////////////////////////////////////
task GetStockWeights;
begin
  $display("Getting Weights for Stock");
  
  #5
  
  data_valid = 1;
  data = 48'h0B1111111111;
  #2
  data_valid = 0;
  #5
  
  #20
  
  if(out == 40'hFF00FF21C3)
    $display("################################################ GET WEIGHTS Passed #######################################");
  else
    $display("################################################ GET WEIGHTS Failed #######################################");
  
    $display(" ");

end
endtask

//////////////////////////////////////////////////////////////////////
// CalcBuyStock
//////////////////////////////////////////////////////////////////////
task CalcBuyStock;
begin
  $display("Calculating Buy for Stock");
  
  #5
  
  data_valid = 1;
  data = 48'h0C0100010000;
  #2
  data_valid = 0;
  #5
  
  #20
  
  if(out == EXECUTE_BUY)
    $display("################################################ CalcBuy Passed #######################################");
  else
    $display("################################################ CalcBuy Failed #######################################");
  
    $display(" ");

end
endtask

//////////////////////////////////////////////////////////////////////
// CalcWightsPos
//////////////////////////////////////////////////////////////////////
task CalcWightsPos;
begin
  $display("Calculating weights for Stock");
  
  #5
  
  data_valid = 1;
  data = 48'h0D0100010000;
  #2
  data_valid = 0;
  #5
  
  #20
  
  if(out == EXECUTION_CONFIRMATION)
    $display("################################################ CalcWeightsPOS Passed #######################################");
  else
    $display("################################################ CalcWeightsPOS Failed #######################################");
  
    $display(" ");

end
endtask

//////////////////////////////////////////////////////////////////////
// CalcWightsNeg
//////////////////////////////////////////////////////////////////////
task CalcWightsNeg;
begin
  $display("Calculating weights for Stock");
  
  #5
  
  data_valid = 1;
  data = 48'h0E0100010000;
  #2
  data_valid = 0;
  #5
  
  #20
  
  if(out == EXECUTION_CONFIRMATION)
    $display("################################################ CalcWeightsNEG Passed #######################################");
  else
    $display("################################################ CalcWeightsNEG Failed #######################################");
  
    $display(" ");

end
endtask

endmodule
