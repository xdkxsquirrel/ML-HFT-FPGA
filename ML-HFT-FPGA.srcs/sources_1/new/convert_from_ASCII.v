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
reg [7:0] LSB_hex_value         = 0;
reg [7:0] MSB_hex_value         = 0;
reg       ready_reg             = 0;
reg [7:0] output_reg            = 0; 
     
always @(posedge clk)
  begin
  case (state)
    FIRST :
      begin
      ready_reg                 <= 0;
      output_reg                <= output_reg;           
      if (data_valid == 1'b1)
        begin
        case(transmitted_byte)
          "0":
            begin
            MSB_hex_value <= 8'h00;
            end

          "1":
            begin
            MSB_hex_value <= 8'h10;
            end

          "2":
            begin
            MSB_hex_value <= 8'h20;
            end

          "3":
            begin
            MSB_hex_value <= 8'h30;
            end

          "4":
            begin
            MSB_hex_value <= 8'h40;
            end

          "5":
            begin
            MSB_hex_value <= 8'h50;
            end

          "6":
            begin
            MSB_hex_value <= 8'h60;
            end

          "7":
            begin
            MSB_hex_value <= 8'h70;
            end

          "8":
            begin
            MSB_hex_value <= 8'h80;
            end

          "9":
            begin
            MSB_hex_value <= 8'h90;
            end

          "A":
            begin
            MSB_hex_value <= 8'hA0;
            end

          "B":
            begin
            MSB_hex_value <= 8'hB0;
            end

          "C":
            begin
            MSB_hex_value <= 8'hC0;
            end

          "D":
            begin
            MSB_hex_value <= 8'hD0;
            end

          "E":
            begin
            MSB_hex_value <= 8'hE0;
            end

          "F":
            begin
            MSB_hex_value <= 8'hF0;
            end

          default:
            begin
            MSB_hex_value <= 8'h00;
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
      output_reg                <= output_reg;  
      ready_reg                 <= 0;           
      if (data_valid == 1'b1)
        begin
        case(transmitted_byte)
          "0":
            begin
            LSB_hex_value <= 8'h00;
            end

          "1":
            begin
            LSB_hex_value <= 8'h01;
            end

          "2":
            begin
            LSB_hex_value <= 8'h02;
            end

          "3":
            begin
            LSB_hex_value <= 8'h03;
            end

          "4":
            begin
            LSB_hex_value <= 8'h04;
            end

          "5":
            begin
            LSB_hex_value <= 8'h05;
            end

          "6":
            begin
            LSB_hex_value <= 8'h06;
            end

          "7":
            begin
            LSB_hex_value <= 8'h07;
            end

          "8":
            begin
            LSB_hex_value <= 8'h08;
            end

          "9":
            begin
            LSB_hex_value <= 8'h09;
            end

          "A":
            begin
            LSB_hex_value <= 8'h0A;
            end

          "B":
            begin
            LSB_hex_value <= 8'h0B;
            end

          "C":
            begin
            LSB_hex_value <= 8'h0C;
            end

          "D":
            begin
            LSB_hex_value <= 8'h0D;
            end

          "E":
            begin
            LSB_hex_value <= 8'h0E;
            end

          "F":
            begin
            LSB_hex_value <= 8'h0F;
            end

          default:
            begin
            LSB_hex_value <= 8'h00;
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
      output_reg                <= MSB_hex_value | LSB_hex_value; 
      ready_reg                 <= 1; 
      state                     <= FIRST;
      end
         
    default :
      state                     <= FIRST;   
    endcase
end

assign ready                    = ready_reg;
assign out                      = output_reg;
   
endmodule
