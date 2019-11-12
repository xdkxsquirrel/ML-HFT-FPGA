`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 07/17/2019 08:10:12 PM
// Module Name: stock_weight
// Project Name: MLA on an FPGA
// Target Devices: CMOD S7-25: Spartan 7
// Description: This is where the stock weights are stored and calculated.
//                      It is also where the decision to buy is kept.
// 
//////////////////////////////////////////////////////////////////////////////////


module stock_weight(
      input            clk,
      input            data_valid,
      input            stock_selected,
      input  [47:0]    data, 
      output reg       data_ready,
      output reg [39:0] out
    );
    
parameter SET_WEIGHTS_CMD                   = 4'hA;
parameter GET_WEIGHTS_CMD                   = 4'hB;
parameter CALC_BUY_CMD                      = 4'hC;
parameter CALC_WEIGHTS_POS_CMD              = 4'hD;
parameter CALC_WEIGHTS_NEG_CMD              = 4'hE;

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

parameter EXECUTION_CONFIRMATION            = 40'hCCCCCCCCCC;
parameter EXECUTE_BUY                       = 40'h1111111111;
parameter EXECUTE_SELL                      = 40'h2222222222;

reg [39:0] stock_weight                     = 0;

always @(posedge clk)
    begin
    if (data_valid == 1 && stock_selected == 1)
        begin
        case (data[CMD_END_LOCATION:CMD_START_LOCATION])
            SET_WEIGHTS_CMD :
                begin         
                stock_weight                    <= data[39:0];
                data_ready                      <= 1;
                out                             <= EXECUTION_CONFIRMATION;                           
                end
                
            GET_WEIGHTS_CMD :
                begin         
                data_ready                      <= 1;
                out                             <= stock_weight;                           
                end
                
            CALC_BUY_CMD :
                begin
                if((stock_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION]*data[COMPANY_END_LOCATION:COMPANY_START_LOCATION]) 
                        + (stock_weight[FOUR_END_LOCATION:FOUR_START_LOCATION]*data[FOUR_END_LOCATION:FOUR_START_LOCATION]) 
                        + (stock_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION]*data[PROFIT_END_LOCATION:PROFIT_START_LOCATION])
                        + (stock_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]*data[TWITTER_END_LOCATION:TWITTER_START_LOCATION])
                        + (stock_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]*data[MOVING_END_LOCATION:MOVING_START_LOCATION]) > 
                        (stock_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION] + stock_weight[FOUR_END_LOCATION:FOUR_START_LOCATION] 
                        + stock_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION] + stock_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                        + stock_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]) / 2)
                    begin
                    out                         <= EXECUTE_BUY;
                    end
                else
                    begin
                    out                         <= EXECUTE_SELL;
                    end            
                data_ready                      <= 1;                           
                end
                
            CALC_WEIGHTS_POS_CMD :
                begin
                if(stock_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION] < 255)
                    stock_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]          <= stock_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]
                        + data[COMPANY_END_LOCATION:COMPANY_START_LOCATION];
                                
                if(stock_weight [FOUR_END_LOCATION:FOUR_START_LOCATION] < 255)
                    stock_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                <= stock_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]
                        + data[FOUR_END_LOCATION:FOUR_START_LOCATION];
                        
                if(stock_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION] < 255)
                    stock_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]            <= stock_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]
                        + data[PROFIT_END_LOCATION:PROFIT_START_LOCATION];
                        
                if(stock_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION] < 255)
                    stock_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]          <= stock_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                        + data[TWITTER_END_LOCATION:TWITTER_START_LOCATION];
                        
                if(stock_weight [MOVING_END_LOCATION:MOVING_START_LOCATION] < 255)
                    stock_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]            <= stock_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]
                        + data[MOVING_END_LOCATION:MOVING_START_LOCATION];
                        
                data_ready                      <= 1;
                out                             <= EXECUTION_CONFIRMATION;                           
                end 
                
            CALC_WEIGHTS_NEG_CMD :
                begin
                if(stock_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION] > 0)
                    stock_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]          <= stock_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]
                        - data[COMPANY_END_LOCATION:COMPANY_START_LOCATION];
                                
                if(stock_weight [FOUR_END_LOCATION:FOUR_START_LOCATION] > 0)
                    stock_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                <= stock_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]
                        - data[FOUR_END_LOCATION:FOUR_START_LOCATION];
                        
                if(stock_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION] > 0)
                    stock_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]            <= stock_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]
                        - data[PROFIT_END_LOCATION:PROFIT_START_LOCATION];
                        
                if(stock_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION] > 0)
                    stock_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]          <= stock_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                        - data[TWITTER_END_LOCATION:TWITTER_START_LOCATION];
                        
                if(stock_weight [MOVING_END_LOCATION:MOVING_START_LOCATION] > 0)
                    stock_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]            <= stock_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]
                        - data[MOVING_END_LOCATION:MOVING_START_LOCATION];
                        
                data_ready                      <= 1;
                out                             <= EXECUTION_CONFIRMATION;                           
                end         
                
            default:
                begin
                data_ready                      <= 0;
                out                             <= 0; 
                end  
        endcase
        end
    else
        begin
        data_ready                              <= 0;
        end
    end
endmodule
