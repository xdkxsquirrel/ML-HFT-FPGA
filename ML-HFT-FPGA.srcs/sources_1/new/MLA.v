`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 07/17/2019 08:10:12 PM
// Module Name: MLA
// Project Name: MLA on an FPGA
// Target Devices: CMOD S7-25: Spartan 7
// Description: Takes UART input from the HFT Raspberry PI and returns
//                      the decisions made by the Machine Learning Algorithm
// 
//////////////////////////////////////////////////////////////////////////////////

module MLA(
  input             clk,
  input             data_valid,
  input  [7:0]      received_byte, 
  output reg        data_ready,
  output reg [10:0]  stock,
  output reg [47:0] out
);

parameter TSLA                              = 4'h0;
parameter AAPL                              = 4'h1;
parameter WMT                               = 4'h2;
parameter JNJ                               = 4'h3;
parameter GOOG                              = 4'h4;
parameter XOM                               = 4'h5; 
parameter MSFT                              = 4'h6; 
parameter GE                                = 4'h7; 
parameter JPM                               = 4'h8; 
parameter IBM                               = 4'h9; 
parameter AMZN                              = 4'hA; 

parameter SET_STOCK_AND_CMD_STATE           = 0;
parameter DATA_ONE_STATE                    = 1;
parameter DATA_TWO_STATE                    = 2;
parameter DATA_THREE_STATE                  = 3;
parameter DATA_FOUR_STATE                   = 4;
parameter DATA_FIVE_STATE                   = 5;

parameter COMPANY_START_LOCATION            =  0;
parameter COMPANY_END_LOCATION              =  7;
parameter FOUR_START_LOCATION               =  8;
parameter FOUR_END_LOCATION                 = 15;
parameter PROFIT_START_LOCATION             = 16;
parameter PROFIT_END_LOCATION               = 23;
parameter TWITTER_START_LOCATION            = 24;
parameter TWITTER_END_LOCATION              = 31;
parameter MOVING_START_LOCATION             = 32;
parameter MOVING_END_LOCATION               = 39;
parameter CMD_START_LOCATION                = 40;
parameter CMD_END_LOCATION                  = 47;

reg [7:0] state                             = 0; 

always @(posedge clk)
    begin
    if (data_valid == 1)
        begin
        case (state)
            SET_STOCK_AND_CMD_STATE :
                begin           
                out[CMD_END_LOCATION:CMD_START_LOCATION]        <= {1'h0,received_byte[7:4]};
                case(received_byte[3:0])
                     TSLA : stock <= 11'b00000000001;
                     AAPL : stock <= 11'b00000000010;
                     WMT  : stock <= 11'b00000000100;
                     JNJ  : stock <= 11'b00000001000;
                     GOOG : stock <= 11'b00000010000;
                     XOM  : stock <= 11'b00000100000;
                     MSFT : stock <= 11'b00001000000;
                     GE   : stock <= 11'b00010000000;
                     JPM  : stock <= 11'b00100000000;
                     IBM  : stock <= 11'b01000000000;
                     AMZN : stock <= 11'b10000000000;
                     default : stock <= 11'b00000000000;
                endcase
                data_ready                                      <= 0;
                state                                           <= DATA_ONE_STATE;
                end
                
            DATA_ONE_STATE :
                begin           
                out[COMPANY_END_LOCATION:COMPANY_START_LOCATION]<= received_byte;
                data_ready                                      <= 0;
                state                                           <= DATA_TWO_STATE;
                end
                
            DATA_TWO_STATE :
                begin           
                out[FOUR_END_LOCATION:FOUR_START_LOCATION]      <= received_byte;
                data_ready                                      <= 0;
                state                                           <= DATA_THREE_STATE;
                end
                
            DATA_THREE_STATE :
                begin           
                out[PROFIT_END_LOCATION:PROFIT_START_LOCATION]  <= received_byte;
                data_ready                                      <= 0;
                state                                           <= DATA_FOUR_STATE;
                end
                
            DATA_FOUR_STATE :
                begin           
                out[TWITTER_END_LOCATION:TWITTER_START_LOCATION]<= received_byte;
                data_ready                                      <= 0;
                state                                           <= DATA_FIVE_STATE;
                end
                
            DATA_FIVE_STATE :
                begin           
                out[MOVING_END_LOCATION:MOVING_START_LOCATION]  <= received_byte;
                data_ready                                      <= 1;
                state                                           <= DATA_ONE_STATE;
                end
                
            default:
                begin
                data_ready                                      <= 0;
                out                                             <= 0;
                state                                           <= SET_STOCK_AND_CMD_STATE; 
                end  
        endcase
        end
    else
        begin
        data_ready                                              <= 0;
        end
    end
    
endmodule   