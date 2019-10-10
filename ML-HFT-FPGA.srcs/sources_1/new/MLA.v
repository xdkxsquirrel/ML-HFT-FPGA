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
  input        clk,
  input        data_valid,
  input  [7:0] received_byte, 
  output       ready,
  output [7:0] out 
);

parameter COMPANY               = 3'b000;
parameter FOUR                  = 3'b001;
parameter PROFIT                = 3'b010;
parameter TWITTER               = 3'b011;
parameter MOVING                = 3'b100;
parameter TOTALWEIGHT           = 3'b101; 
parameter CALCULATE             = 3'b110; 
   
reg [2:0] state                 = 0;
reg [7:0] company_weight        = 0;
reg [7:0] four_weight           = 0;
reg [7:0] profit_weight         = 0;
reg [7:0] twitter_weight        = 0;
reg [7:0] moving_weight         = 0;
reg [7:0] total_weight          = 0;
reg       ready_reg             = 0;
reg [7:0] output_reg            = 0; 
     
always @(posedge clk)
  begin
  case (state)
    COMPANY :
      begin
      ready_reg                <= 0;
      output_reg               <= output_reg;           
      if (data_valid == 1'b1)
        begin
        company_weight         <= received_byte;
        state                  <= FOUR;
        end           

      else
        begin
        state                  <= COMPANY;
        end
      end 
        
    FOUR :
      begin
      output_reg               <= output_reg;  
      ready_reg                <= 0;           
      if (data_valid == 1'b1)
        begin
        four_weight         <= received_byte;
        state                  <= PROFIT;
        end
      else
        begin
        state                  <= FOUR;
        end
      end
      
    PROFIT :
      begin
      output_reg               <= output_reg;  
      ready_reg                <= 0;           
      if (data_valid == 1'b1)
        begin
        profit_weight         <= received_byte;
        state                  <= TWITTER;
        end
      else
        begin
        state                  <= PROFIT;
        end
      end
      
    TWITTER :
      begin
      output_reg               <= output_reg;  
      ready_reg                <= 0;           
      if (data_valid == 1'b1)
        begin
        twitter_weight         <= received_byte;
        state                  <= MOVING;
        end
      else
        begin
        state                  <= TWITTER;
        end
      end
      
    MOVING :
      begin
      output_reg               <= output_reg;  
      ready_reg                <= 0;           
      if (data_valid == 1'b1)
        begin
        moving_weight         <= received_byte;
        state                  <= TOTALWEIGHT;
        end
      else
        begin
        state                  <= MOVING;
        end
      end
      
   TOTALWEIGHT :
      begin
      output_reg               <= output_reg;  
      ready_reg                <= 0;           
      if (data_valid == 1'b1)
        begin
        total_weight           <= received_byte;
        state                  <= CALCULATE;
        end
      else
        begin
        state                  <= TOTALWEIGHT;
        end
      end

    CALCULATE :
      begin
      if((company_weight + four_weight + profit_weight + twitter_weight + moving_weight) > total_weight)
        begin
        output_reg                <= "1"; 
        end
      else
        begin
        output_reg                <= "0"; 
        end
      ready_reg                 <= 1; 
      state                     <= COMPANY;
      end
         
    default :
      state                     <= COMPANY;   
    endcase
end

assign ready                    = ready_reg;
assign out                      = output_reg;

endmodule

//module MLA(
//	input  clk,
//	input received_data_valid,
//	input [7:0] received_byte,
//	output reg transmit_data_valid,
//	output reg [7:0] transmit_byte
//);

//parameter ZERO      = 8'h30;
//parameter ONE       = 8'h31;
//parameter TWO       = 8'h32;
//parameter THREE     = 8'h33;
//parameter FOUR      = 8'h34;
//parameter FIVE      = 8'h35;

//always@(posedge clk)
//begin
//  if(received_data_valid)
//    begin
//      case (received_byte)
//        ONE :
//          begin
//          transmit_data_valid <= 1'b1;
//          transmit_byte <= 8'h61;
//          end
          
//        TWO :
//          begin
//          transmit_data_valid <= 1'b1;
//          transmit_byte <= 8'h62;
//          end
          
//        THREE :
//          begin
//          transmit_data_valid <= 1'b1;
//          transmit_byte <= 8'h63;
//          end
          
//        FOUR :
//          begin
//          transmit_data_valid <= 1'b1;
//          transmit_byte <= 8'h64;
//          end
          
//        FIVE :
//          begin
//          transmit_data_valid <= 1'b1;
//          transmit_byte <= 8'h65;
//          end
       
//        default:
//          begin
//          transmit_data_valid <= 1'b1;
//          transmit_byte <= 8'h52;
//          end
   
//      endcase
//    end
//  else
//    begin
//    transmit_data_valid <= 1'b0;
//    transmit_byte <= 8'h52;
//    end
//end
//endmodule


