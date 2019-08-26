`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 07/17/2019 08:10:12 PM
// Module Name: MLA
// Project Name: MLA on an FPGA
// Target Devices: Arty Z7: APSoC Zynq-7000
// Description: Takes UART input from the HFT Raspberry PI and returns
//                      the decisions made by the Machine Learning Algorithm
// 
//////////////////////////////////////////////////////////////////////////////////

module MLA(
	input  clk,
	input received_data_valid,
	input [7:0] received_byte,
	output reg transmit_data_valid,
	output reg [7:0] transmit_byte
);

parameter MAXWEIGHT = 6'h64;
parameter MINWEIGHT = 6'h0;
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
          