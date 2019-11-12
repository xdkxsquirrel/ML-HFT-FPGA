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
  input        clk,
  input        active,
  input        data_valid,
  input  [39:0] data, 
  output reg      ready,
  output reg [7:0] current_byte_to_send     
);
  
parameter IDLE                  = 0;  
parameter FIRST                 = 1;
parameter SECOND                = 2;
parameter THIRD                 = 3;
parameter FOURTH                = 4;
parameter FIFTH                 = 5;
parameter SIXTH                 = 6;
parameter SEVENTH               = 7;
parameter EIGHTH                = 8;
parameter NINTH                 = 9;
parameter TENTH                 = 10;

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

reg [3:0] state                 = 0;
reg [39:0] data_to_send         = 0;
     
always @(posedge clk)
  begin
  case (state)
    IDLE :
      begin
      if(data_valid == 1)
        begin
        data_to_send <= data;
        state <= FIRST;
        ready <= 0;
        end
      else
        begin
        data_to_send <= 0;
        state <= IDLE;
        ready <= 0;
        end
      end
      
    FIRST:
      begin
      if(active == 0)
        begin
        current_byte_to_send <= data_to_send[COMPANY_END_LOCATION-4:COMPANY_START_LOCATION];
        state <= SECOND;
        ready <= 1;
        end
      else
        begin
        current_byte_to_send <= data_to_send[COMPANY_END_LOCATION-4:COMPANY_START_LOCATION];
        state <= FIRST;
        ready <= 0;
        end
      end
      
        
        
        
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
            
          "a":
            begin
            MSB_hex_value <= 8'hA0;
            end

          "b":
            begin
            MSB_hex_value <= 8'hB0;
            end

          "c":
            begin
            MSB_hex_value <= 8'hC0;
            end

          "d":
            begin
            MSB_hex_value <= 8'hD0;
            end

          "e":
            begin
            MSB_hex_value <= 8'hE0;
            end

          "f":
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
            
          "a":
            begin
            LSB_hex_value <= 8'h0A;
            end

          "b":
            begin
            LSB_hex_value <= 8'h0B;
            end

          "c":
            begin
            LSB_hex_value <= 8'h0C;
            end

          "d":
            begin
            LSB_hex_value <= 8'h0D;
            end

          "e":
            begin
            LSB_hex_value <= 8'h0E;
            end

          "f":
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
