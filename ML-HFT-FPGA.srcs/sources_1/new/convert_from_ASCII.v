`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 08/26/2019 12:12:12 PM
// Module Name: convert_from_ASCII
// Project Name: MLA on an FPGA
// Target Devices: CMOD S7-25: Spartan 7
// Description: Takes ASCII from UART and converts it to hex value in FPGA.
// 
// CLKS_PER_UART_CYCLE = 12MHz / 115200
// 12000000 / 115200 = 104
//
//////////////////////////////////////////////////////////////////////////////////

module convert_from_ASCII(
  input        clk,
  input        data_valid,
  input  [7:0] transmitted_byte, 
  output       ready,
  output [7:0] out     
);
  
parameter FIRST                 = 2'b00;
parameter SECOND                = 2'b01;
parameter CALCULATE             = 2'b10; 
   
reg [1:0] state                 = 0;
reg [7:0] first_hex_value       = 0;
reg [7:0] second_hex_value      = 0;
reg       ready_reg             = 0;
reg [7:0] output_reg            = 0; 
     
always @(posedge clk)
  begin
  case (state)
    FIRST :
      begin
      ready_reg                 <= 0;
      output_reg                <= 0;           
      if (data_valid == 1'b1)
        begin
        case(transmitted_byte)
          "0":
            begin
            first_hex_value <= 8'h00;
            end

          "1":
            begin
            first_hex_value <= 8'h01;
            end

          "2":
            begin
            first_hex_value <= 8'h02;
            end

          "3":
            begin
            first_hex_value <= 8'h03;
            end

          "4":
            begin
            first_hex_value <= 8'h04;
            end

          "5":
            begin
            first_hex_value <= 8'h05;
            end

          "6":
            begin
            first_hex_value <= 8'h06;
            end

          "7":
            begin
            first_hex_value <= 8'h07;
            end

          "8":
            begin
            first_hex_value <= 8'h08;
            end

          "9":
            begin
            first_hex_value <= 8'h09;
            end

          "A":
            begin
            first_hex_value <= 8'h0A;
            end

          "B":
            begin
            first_hex_value <= 8'h0B;
            end

          "C":
            begin
            first_hex_value <= 8'h0C;
            end

          "D":
            begin
            first_hex_value <= 8'h0D;
            end

          "E":
            begin
            first_hex_value <= 8'h0E;
            end

          "F":
            begin
            first_hex_value <= 8'h0F;
            end

          default:
            begin
            first_hex_value <= 8'h00;
            end
        endcase
        state                  <= SECOND;
        end           

      else
        begin
        state                  <= FIRST;
        end
      end 
        
    SECOND :
      begin
      ready_reg                 <= 0;
      output_reg                <= 0;             
      if (data_valid == 1'b1)
        begin
        case(transmitted_byte)
          "0":
            begin
            second_hex_value <= 8'h00;
            end

          "1":
            begin
            second_hex_value <= 8'h10;
            end

          "2":
            begin
            second_hex_value <= 8'h20;
            end

          "3":
            begin
            second_hex_value <= 8'h30;
            end

          "4":
            begin
            second_hex_value <= 8'h40;
            end

          "5":
            begin
            second_hex_value <= 8'h50;
            end

          "6":
            begin
            second_hex_value <= 8'h60;
            end

          "7":
            begin
            second_hex_value <= 8'h70;
            end

          "8":
            begin
            second_hex_value <= 8'h80;
            end

          "9":
            begin
            second_hex_value <= 8'h90;
            end

          "A":
            begin
            second_hex_value <= 8'hA0;
            end

          "B":
            begin
            second_hex_value <= 8'hB0;
            end

          "C":
            begin
            second_hex_value <= 8'hC0;
            end

          "D":
            begin
            second_hex_value <= 8'hD0;
            end

          "E":
            begin
            second_hex_value <= 8'hE0;
            end

          "F":
            begin
            second_hex_value <= 8'hF0;
            end

          default:
            begin
            second_hex_value <= 8'h00;
            end
        endcase
        state                  <= CALCULATE;
        end 
      else
        begin
        state                  <= SECOND;
        end
      end

    CALCULATE :
      begin
      output_reg                <= first_hex_value | second_hex_value ; 
      ready_reg                 <= 0; 
      state                     <= FIRST;
      end
         
    default :
      state                     <= FIRST;   
    endcase
end

assign ready                    = ready_reg;
assign out                   = output_reg;
   
endmodule
