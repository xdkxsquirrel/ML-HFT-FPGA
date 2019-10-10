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





//reg [7:0] companyWeight;
//reg [7:0] profitWeight;
//reg [7:0] fiveWeight;
//reg [7:0] twitterWeight;
//reg [7:0] movingWeight;
//reg       companyData;
//reg       profitData;
//reg       fiveData;
//reg       twitterData;
//reg       movingData;

//always @(posedge clk)
//begin
//  case(state)
//    ONE:
//      begin
//      companyWeight <= data;



module MLA(
	input  clk,
	input received_data_valid,
	input [7:0] received_byte,
	output reg transmit_data_valid,
	output reg [7:0] transmit_byte
);

parameter ZERO      = 8'h30;
parameter ONE       = 8'h31;
parameter TWO       = 8'h32;
parameter THREE     = 8'h33;
parameter FOUR      = 8'h34;
parameter FIVE      = 8'h35;

always@(posedge clk)
begin
  if(received_data_valid)
    begin
      case (received_byte)
        ONE :
          begin
          transmit_data_valid <= 1'b1;
          transmit_byte <= 8'h61;
          end
          
        TWO :
          begin
          transmit_data_valid <= 1'b1;
          transmit_byte <= 8'h62;
          end
          
        THREE :
          begin
          transmit_data_valid <= 1'b1;
          transmit_byte <= 8'h63;
          end
          
        FOUR :
          begin
          transmit_data_valid <= 1'b1;
          transmit_byte <= 8'h64;
          end
          
        FIVE :
          begin
          transmit_data_valid <= 1'b1;
          transmit_byte <= 8'h65;
          end
       
        default:
          begin
          transmit_data_valid <= 1'b1;
          transmit_byte <= 8'h52;
          end
   
      endcase
    end
  else
    begin
    transmit_data_valid <= 1'b0;
    transmit_byte <= 8'h52;
    end
end
endmodule


