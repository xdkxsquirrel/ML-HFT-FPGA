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

module LED(
	input  clk,
	input received_data_valid,
	input [7:0] received_byte,
	output reg led4_r,
	output reg led4_g,
	output reg led4_b
);

parameter ONE       = 8'h31;
parameter TWO       = 8'h32;
parameter THREE     = 8'h33;
parameter FOUR      = 8'h34;
parameter FIVE      = 8'h35;

initial
begin
    led4_r <= 1;
    led4_g <= 0;
    led4_b <= 0;
end

always@(posedge clk)
begin
  if(received_data_valid)
    begin
      case (received_byte)
        ONE :
          begin
          led4_r <= 0;
          led4_g <= 1;
          led4_b <= 0;
          end
          
        TWO :
          begin
          led4_r <= 0;
          led4_g <= 0;
          led4_b <= 1;
          end
          
        THREE :
          begin
          led4_r <= 1;
          led4_g <= 1;
          led4_b <= 0;
          end
          
        FOUR :
          begin
          led4_r <= 0;
          led4_g <= 1;
          led4_b <= 1;
          end
          
        FIVE :
          begin
          led4_r <= 0;
          led4_g <= 0;
          led4_b <= 0;
          end
       
        default:
          begin
          led4_r <= 1;
          led4_g <= 1;
          led4_b <= 1;
          end
   
      endcase
    end
  else
    begin
        led4_r <= led4_r;
        led4_g <= led4_g;
        led4_b <= led4_b;
    end
end
endmodule
          