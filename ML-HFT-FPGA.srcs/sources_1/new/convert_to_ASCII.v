`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 08/26/2019 12:12:12 PM
// Module Name: convert_to_ASCII
// Project Name: MLA on an FPGA
// Target Devices: CMOD S7-25: Spartan 7
// Description: Takes hex values from FPGA and converts them to ASCII to be sent over UART.
//
//////////////////////////////////////////////////////////////////////////////////

module convert_to_ASCII(
  input             clk,
  input             active,
  input             data_valid,
  input  [39:0]     data, 
  output reg        ready,
  output reg [79:0] data_to_send     
);
  
parameter IDLE                  = 0;  
parameter CONVERT               = 1;

parameter COMPANY_HEX_LOCATION              =  0;
parameter FOUR_HEX_LOCATION                 =  8;
parameter PROFIT_HEX_LOCATION               = 16;
parameter TWITTER_HEX_LOCATION              = 24;
parameter MOVING_HEX_LOCATION               = 32;

parameter COMPANY_BYTE_LOCATION             =  0;
parameter FOUR_BYTE_LOCATION                = 16;
parameter PROFIT_BYTE_LOCATION              = 32;
parameter TWITTER_BYTE_LOCATION             = 48;
parameter MOVING_BYTE_LOCATION              = 64;

reg        state                = 0;
reg [39:0] temp_data            = 0;
reg [3:0]  hex                  = 0;

    function [7:0] convert_from_hex;
        input [3:0] hex;
        begin
        case (hex)
            4'h0: convert_from_hex = "0"; 
            4'h1: convert_from_hex = "1";
            4'h2: convert_from_hex = "2";
            4'h3: convert_from_hex = "3";
            4'h4: convert_from_hex = "4";
            4'h5: convert_from_hex = "5";
            4'h6: convert_from_hex = "6";
            4'h7: convert_from_hex = "7";
            4'h8: convert_from_hex = "8";
            4'h9: convert_from_hex = "9";
            4'hA: convert_from_hex = "A";
            4'hB: convert_from_hex = "B";
            4'hC: convert_from_hex = "C";
            4'hD: convert_from_hex = "D";
            4'hE: convert_from_hex = "E";
            4'hF: convert_from_hex = "F";
         endcase
         end
      endfunction        
 
always @(posedge clk)
  begin
  case (state)
    IDLE :
      begin
      if(data_valid == 1)
        begin
        state <= CONVERT;
        ready <= 0;
        end
      else
        begin
        state <= IDLE;
        ready <= 0;
        end
      end
      
    CONVERT:
      begin
      if(active == 0)
        begin
        data_to_send[COMPANY_BYTE_LOCATION+7:COMPANY_BYTE_LOCATION] <= convert_from_hex(data[COMPANY_HEX_LOCATION+7:COMPANY_HEX_LOCATION+4]);
        data_to_send[COMPANY_BYTE_LOCATION+15:COMPANY_BYTE_LOCATION+8] <= convert_from_hex(data[COMPANY_HEX_LOCATION+3:COMPANY_HEX_LOCATION]);
        
        data_to_send[FOUR_BYTE_LOCATION+7:FOUR_BYTE_LOCATION] <= convert_from_hex(data[FOUR_HEX_LOCATION+7:FOUR_HEX_LOCATION+4]);
        data_to_send[FOUR_BYTE_LOCATION+15:FOUR_BYTE_LOCATION+8] <= convert_from_hex(data[FOUR_HEX_LOCATION+3:FOUR_HEX_LOCATION]);
        
        data_to_send[PROFIT_BYTE_LOCATION+7:PROFIT_BYTE_LOCATION] <= convert_from_hex(data[PROFIT_HEX_LOCATION+7:PROFIT_HEX_LOCATION+4]);
        data_to_send[PROFIT_BYTE_LOCATION+15:PROFIT_BYTE_LOCATION+8] <= convert_from_hex(data[PROFIT_HEX_LOCATION+3:PROFIT_HEX_LOCATION]);
        
        data_to_send[TWITTER_BYTE_LOCATION+7:TWITTER_BYTE_LOCATION] <= convert_from_hex(data[TWITTER_HEX_LOCATION+7:TWITTER_HEX_LOCATION+4]);
        data_to_send[TWITTER_BYTE_LOCATION+15:TWITTER_BYTE_LOCATION+8] <= convert_from_hex(data[TWITTER_HEX_LOCATION+3:TWITTER_HEX_LOCATION]);
        
        data_to_send[MOVING_BYTE_LOCATION+7:MOVING_BYTE_LOCATION] <= convert_from_hex(data[MOVING_HEX_LOCATION+7:MOVING_HEX_LOCATION+4]);
        data_to_send[MOVING_BYTE_LOCATION+15:MOVING_BYTE_LOCATION+8] <= convert_from_hex(data[MOVING_HEX_LOCATION+3:MOVING_HEX_LOCATION]);
        state <= IDLE;
        ready <= 1;
        end
      else
        begin
        data_to_send <= 0;
        state <= CONVERT;
        ready <= 0;
        end
      end
   endcase
   end
endmodule
