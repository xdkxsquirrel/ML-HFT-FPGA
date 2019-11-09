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
  input            clk,
  input            data_valid,
  input  [7:0]     received_byte, 
  output reg       data_ready,
  output reg [7:0] out,
  output reg       led4_r,
  output reg       led4_g,
  output reg       led4_b
);

parameter SET_COMMAND_AND_STOCK_STATES      = 0;
parameter PERFORM_TASK_STATE                = 1;

parameter SET_WEIGHTS_CMD                   = 1'hA;
parameter GET_WEIGHTS_CMD                   = 1'hB;
parameter CALC_BUY_CMD                      = 1'hC;
parameter CALC_WEIGHTS_POS_CMD              = 1'hD;
parameter CALC_WEIGHTS_NEG_CMD              = 1'hE;

parameter TSLA                              = 1'h0;
parameter AAPL                              = 1'h1;
parameter WMT                               = 1'h2;
parameter JNJ                               = 1'h3;
parameter GOOG                              = 1'h4;
parameter XOM                               = 1'h5; 
parameter MSFT                              = 1'h6; 
parameter GE                                = 1'h7; 
parameter JPM                               = 1'h8; 
parameter IBM                               = 1'h9; 
parameter AMZN                              = 1'hA; 

parameter COMPANY_STATE                     = 0;
parameter FOUR_STATE                        = 1;
parameter PROFIT_STATE                      = 2;
parameter TWITTER_STATE                     = 3;
parameter MOVING_STATE                      = 4;

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

reg [7:0] state                             = 0;   
reg [7:0] cmd_state                         = 0;
reg [7:0] stock_state                       = 0;
reg [7:0] data_state                        = 0;

reg [39:0] tsla_weight                      = 0;
reg [39:0] aapl_weight                      = 0;
reg [39:0] wmt_weight                       = 0;
reg [39:0] jnj_weight                       = 0;
reg [39:0] goog_weight                      = 0;
reg [39:0] xom_weight                       = 0;
reg [39:0] msft_weight                      = 0;
reg [39:0] ge_weight                        = 0;
reg [39:0] jpm_weight                       = 0;
reg [39:0] ibm_weight                       = 0;
reg [39:0] amzn_weight                      = 0;

reg [7:0]  company_buy                      = 0;
reg [7:0]  four_buy                         = 0;
reg [7:0]  profit_buy                       = 0;
reg [7:0]  twitter_buy                      = 0;

reg        ready_to_calculate               = 0;
     
always @(posedge clk)
  begin
  case (state)
    SET_COMMAND_AND_STOCK_STATES :
      begin
      data_ready                    <= 0;           
      if (data_valid == 1'b1)
        begin
        cmd_state                   <= received_byte[3:0];
        stock_state                 <= received_byte[7:4];
        state                       <= PERFORM_TASK_STATE;
        end           

      else
        begin
        state                       <= SET_COMMAND_AND_STOCK_STATES;
        end
      end 
      
    PERFORM_TASK_STATE :
      begin            
      if (data_valid == 1'b1)
        begin
        case (cmd_state)
          
//////////          
          SET_WEIGHTS_CMD:
            begin
            case (stock_state)
              
              TSLA:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    tsla_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    tsla_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    tsla_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    tsla_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    tsla_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              AAPL:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    aapl_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    aapl_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    aapl_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    aapl_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    aapl_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              WMT:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              JNJ:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              GOOG:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              XOM:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              MSFT:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              GE:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              JPM:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              IBM:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                       
              AMZN:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
              
              default:
                stock_state                       <= TSLA;
              endcase
            end

//////////          
          GET_WEIGHTS_CMD: // Currently not implimented. Sending a succession of UART bytes is going to be hard.
            begin
            case (stock_state)
              
              TSLA:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    tsla_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    tsla_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    tsla_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    tsla_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    tsla_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              AAPL:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    aapl_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    aapl_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    aapl_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    aapl_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    aapl_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              WMT:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              JNJ:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              GOOG:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              XOM:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              MSFT:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              GE:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              JPM:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              IBM:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                       
              AMZN:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
              
              default:
                stock_state                       <= TSLA;
              endcase
            end

//////////            
          CALC_BUY_CMD:
            begin
            case (stock_state)
              
              TSLA:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    company_buy                   <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    four_buy                      <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    profit_buy                    <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    twitter_buy                   <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    data_state                    <= COMPANY_STATE;
                    if((tsla_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION]*company_buy) 
                      + (tsla_weight[FOUR_END_LOCATION:FOUR_START_LOCATION]*four_buy) 
                      + (tsla_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION]*profit_buy)
                      + (tsla_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]*twitter_buy)
                      + (tsla_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]*received_byte) > 
                      (tsla_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION] + tsla_weight[FOUR_END_LOCATION:FOUR_START_LOCATION] 
                      + tsla_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION] + tsla_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                      + tsla_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]) / 2)
                      begin
                      out                         <= 1;
                      end
                    else
                      begin
                      out                         <= 0;
                      end
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              AAPL:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    company_buy                   <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    four_buy                      <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    profit_buy                    <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    twitter_buy                   <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    data_state                    <= COMPANY_STATE;
                    if((aapl_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION]*company_buy) 
                      + (aapl_weight[FOUR_END_LOCATION:FOUR_START_LOCATION]*four_buy) 
                      + (aapl_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION]*profit_buy)
                      + (aapl_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]*twitter_buy)
                      + (aapl_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]*received_byte) > 
                      (aapl_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION] + aapl_weight[FOUR_END_LOCATION:FOUR_START_LOCATION] 
                      + aapl_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION] + aapl_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                      + aapl_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]) / 2)
                      begin
                      out                         <= 1;
                      end
                    else
                      begin
                      out                         <= 0;
                      end
                    end

                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              WMT:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    company_buy                   <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    four_buy                      <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    twitter_buy                   <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    twitter_buy                   <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    data_state                    <= COMPANY_STATE;
                    if((wmt_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION]*company_buy) 
                      + (wmt_weight[FOUR_END_LOCATION:FOUR_START_LOCATION]*four_buy) 
                      + (wmt_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION]*profit_buy)
                      + (wmt_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]*twitter_buy)
                      + (wmt_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]*received_byte) > 
                      (wmt_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION] + wmt_weight[FOUR_END_LOCATION:FOUR_START_LOCATION] 
                      + wmt_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION] + wmt_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                      + wmt_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]) / 2)
                      begin
                      out                         <= 1;
                      end
                    else
                      begin
                      out                         <= 0;
                      end
                    end

                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              JNJ:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    company_buy                   <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    four_buy                      <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    profit_buy                    <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    twitter_buy                   <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    data_state                    <= COMPANY_STATE;
                    if((jnj_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION]*company_buy) 
                      + (jnj_weight[FOUR_END_LOCATION:FOUR_START_LOCATION]*four_buy) 
                      + (jnj_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION]*profit_buy)
                      + (jnj_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]*twitter_buy)
                      + (jnj_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]*received_byte) > 
                      (jnj_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION] + jnj_weight[FOUR_END_LOCATION:FOUR_START_LOCATION] 
                      + jnj_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION] + jnj_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                      + jnj_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]) / 2)
                      begin
                      out                         <= 1;
                      end
                    else
                      begin
                      out                         <= 0;
                      end
                    end

                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              GOOG:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    company_buy                   <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    four_buy                      <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    profit_buy                    <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    twitter_buy                   <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    data_state                    <= COMPANY_STATE;
                    if((goog_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION]*company_buy) 
                      + (goog_weight[FOUR_END_LOCATION:FOUR_START_LOCATION]*four_buy) 
                      + (goog_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION]*profit_buy)
                      + (goog_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]*twitter_buy)
                      + (goog_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]*received_byte) > 
                      (goog_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION] + goog_weight[FOUR_END_LOCATION:FOUR_START_LOCATION] 
                      + goog_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION] + goog_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                      + goog_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]) / 2)
                      begin
                      out                         <= 1;
                      end
                    else
                      begin
                      out                         <= 0;
                      end
                    end

                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              XOM:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    company_buy                   <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    four_buy                      <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    profit_buy                    <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    twitter_buy                   <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    data_state                    <= COMPANY_STATE;
                    if((xom_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION]*company_buy) 
                      + (xom_weight[FOUR_END_LOCATION:FOUR_START_LOCATION]*four_buy) 
                      + (xom_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION]*profit_buy)
                      + (xom_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]*twitter_buy)
                      + (xom_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]*received_byte) > 
                      (xom_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION] + xom_weight[FOUR_END_LOCATION:FOUR_START_LOCATION] 
                      + xom_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION] + xom_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                      + xom_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]) / 2)
                      begin
                      out                         <= 1;
                      end
                    else
                      begin
                      out                         <= 0;
                      end
                    end

                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              MSFT:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    company_buy                    <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    four_buy                    <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    profit_buy                    <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    twitter_buy                    <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    data_state                    <= COMPANY_STATE;
                    if((msft_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION]*company_buy) 
                      + (msft_weight[FOUR_END_LOCATION:FOUR_START_LOCATION]*four_buy) 
                      + (msft_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION]*profit_buy)
                      + (msft_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]*twitter_buy)
                      + (msft_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]*received_byte) > 
                      (msft_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION] + msft_weight[FOUR_END_LOCATION:FOUR_START_LOCATION] 
                      + msft_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION] + msft_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                      + msft_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]) / 2)
                      begin
                      out                         <= 1;
                      end
                    else
                      begin
                      out                         <= 0;
                      end
                    end

                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              GE:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    company_buy                    <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    four_buy                    <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    profit_buy                    <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    twitter_buy                    <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    data_state                    <= COMPANY_STATE;
                    if((ge_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION]*company_buy) 
                      + (ge_weight[FOUR_END_LOCATION:FOUR_START_LOCATION]*four_buy) 
                      + (ge_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION]*profit_buy)
                      + (ge_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]*twitter_buy)
                      + (ge_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]*received_byte) > 
                      (ge_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION] + ge_weight[FOUR_END_LOCATION:FOUR_START_LOCATION] 
                      + ge_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION] + ge_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                      + ge_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]) / 2)
                      begin
                      out                         <= 1;
                      end
                    else
                      begin
                      out                         <= 0;
                      end
                    end

                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              JPM:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    company_buy                    <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    four_buy                    <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    profit_buy                    <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    twitter_buy                    <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    data_state                    <= COMPANY_STATE;
                    if((jpm_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION]*company_buy) 
                      + (jpm_weight[FOUR_END_LOCATION:FOUR_START_LOCATION]*four_buy) 
                      + (jpm_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION]*profit_buy)
                      + (jpm_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]*twitter_buy)
                      + (jpm_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]*received_byte) > 
                      (jpm_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION] + jpm_weight[FOUR_END_LOCATION:FOUR_START_LOCATION] 
                      + jpm_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION] + jpm_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                      + jpm_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]) / 2)
                      begin
                      out                         <= 1;
                      end
                    else
                      begin
                      out                         <= 0;
                      end
                    end

                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              IBM:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    company_buy                    <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    four_buy                    <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    profit_buy                    <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    twitter_buy                    <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    data_state                    <= COMPANY_STATE;
                    if((ibm_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION]*company_buy) 
                      + (ibm_weight[FOUR_END_LOCATION:FOUR_START_LOCATION]*four_buy) 
                      + (ibm_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION]*profit_buy)
                      + (ibm_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]*twitter_buy)
                      + (ibm_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]*received_byte) > 
                      (ibm_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION] + ibm_weight[FOUR_END_LOCATION:FOUR_START_LOCATION] 
                      + ibm_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION] + ibm_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                      + ibm_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]) / 2)
                      begin
                      out                         <= 1;
                      end
                    else
                      begin
                      out                         <= 0;
                      end
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                       
              AMZN:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    company_buy                    <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    four_buy                    <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    profit_buy                    <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    twitter_buy                    <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    data_state                    <= COMPANY_STATE;
                    if((amzn_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION]*company_buy) 
                      + (amzn_weight[FOUR_END_LOCATION:FOUR_START_LOCATION]*four_buy) 
                      + (amzn_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION]*profit_buy)
                      + (amzn_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]*twitter_buy)
                      + (amzn_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]*received_byte) > 
                      (amzn_weight[COMPANY_END_LOCATION:COMPANY_START_LOCATION] + amzn_weight[FOUR_END_LOCATION:FOUR_START_LOCATION] 
                      + amzn_weight[PROFIT_END_LOCATION:PROFIT_START_LOCATION] + amzn_weight[TWITTER_END_LOCATION:TWITTER_START_LOCATION]
                      + amzn_weight[MOVING_END_LOCATION:MOVING_START_LOCATION]) / 2)
                      begin
                      out                         <= 1;
                      end
                    else
                      begin
                      out                         <= 0;
                      end
                    end

                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
              
              default:
                stock_state                       <= TSLA;
              endcase
            end
            
//////////          
          CALC_WEIGHTS_POS_CMD:
            begin
            case (stock_state)
              
              TSLA:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    tsla_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    tsla_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    tsla_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    tsla_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    tsla_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              AAPL:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    aapl_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    aapl_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    aapl_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    aapl_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    aapl_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              WMT:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    wmt_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              JNJ:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    jnj_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              GOOG:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    goog_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              XOM:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    xom_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              MSFT:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    msft_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              GE:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    ge_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              JPM:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    jpm_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                
              IBM:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    ibm_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
                       
              AMZN:
                begin
                case (data_state)
                
                  COMPANY_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [COMPANY_END_LOCATION:COMPANY_START_LOCATION]             <= received_byte;
                    data_state                    <= FOUR_STATE;
                    end
                    
                  FOUR_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [FOUR_END_LOCATION:FOUR_START_LOCATION]                   <= received_byte;
                    data_state                    <= PROFIT_STATE;
                    end
                    
                  PROFIT_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [PROFIT_END_LOCATION:PROFIT_START_LOCATION]             <= received_byte;
                    data_state                    <= TWITTER_STATE;
                    end
                    
                  TWITTER_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [TWITTER_END_LOCATION:TWITTER_START_LOCATION]             <= received_byte;
                    data_state                    <= MOVING_STATE;
                    end
                    
                  MOVING_STATE:
                    begin
                    data_ready                    <= 0;
                    amzn_weight [MOVING_END_LOCATION:MOVING_START_LOCATION]             <= received_byte;
                    data_state                    <= COMPANY_STATE;
                    end
                    
                  default:
                    data_state                    <= COMPANY_STATE;
                  endcase
                end
              
              default:
                stock_state                       <= TSLA;
              endcase
            end
          
          default:
            cmd_state                             <= SET_WEIGHTS_CMD;
          endcase                  
        state                                     <= SET_COMMAND_AND_STOCK_STATES;
        end
            
      else
        begin
        data_ready                                <= 0;
        state                                     <= PERFORM_TASK_STATE;
        end
      end
         
    default :
      begin
      data_ready                                  <= 0;
      state                                       <= SET_COMMAND_AND_STOCK_STATES;
      end   
    endcase
end

endmodule


