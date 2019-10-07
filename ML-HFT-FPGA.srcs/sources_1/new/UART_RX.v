`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 08/26/2019 12:12:12 PM
// Module Name: UART_RX
// Project Name: MLA on an FPGA
// Target Devices: CMOD S7-25: Spartan 7
// Description: UART Protocol Receiver of baudrate of 115200
// 
// CLKS_PER_UART_CYCLE = 12MHz / 115200
// 12000000 / 115200 = 104
//
//////////////////////////////////////////////////////////////////////////////////

module UART_RX(
  input        clk,
  input        serial,
  output       data_valid,
  output [7:0] received_byte
);
  
parameter CLKS_PER_UART_CYCLE   = 104;  
parameter IDLE_STATE            = 3'b000;
parameter START_BIT_STATE       = 3'b001;
parameter DATA_BITS_STATE       = 3'b010;
parameter STOP_BIT_STATE        = 3'b011;
parameter CLEANUP_STATE         = 3'b100;
  
reg       data_register         = 1'b1;
reg       received_bit_register = 1'b1;
  
reg [7:0] clock_count_register  = 0;
reg [2:0] bit_index_register    = 0;
reg [7:0] byte_register         = 0;
reg       data_valid_register   = 0;
reg [2:0] state                 = 0;
   
always @(posedge clk)
  begin
    data_register              <= serial;
    received_bit_register      <= data_register;
  end
   
always @(posedge clk)
  begin 
  case (state)
    IDLE_STATE :
      begin
      data_valid_register      <= 1'b0;
      clock_count_register     <= 0;
      bit_index_register       <= 0;
        
      if (received_bit_register == 1'b0)
        state                  <= START_BIT_STATE;
      else
        state                  <= IDLE_STATE;
      end
      
    START_BIT_STATE :
      begin
      if (clock_count_register == (CLKS_PER_UART_CYCLE-1)/2)
        begin
        if (received_bit_register == 1'b0)
          begin
          clock_count_register <= 0; 
          state                <= DATA_BITS_STATE;
          end
        else
          state                <= IDLE_STATE;
        end
      else
        begin
        clock_count_register   <= clock_count_register + 1;
        state                  <= START_BIT_STATE;
        end
      end

    DATA_BITS_STATE :
      begin
      if (clock_count_register < CLKS_PER_UART_CYCLE-1)
        begin
        clock_count_register   <= clock_count_register + 1;
        state                  <= DATA_BITS_STATE;
        end
      else
        begin
        clock_count_register   <= 0;
        byte_register[bit_index_register] <= received_bit_register;
          
        if (bit_index_register < 7)
          begin
          bit_index_register   <= bit_index_register + 1;
          state                <= DATA_BITS_STATE;
          end
        else
          begin
          bit_index_register   <= 0;
          state                <= STOP_BIT_STATE;
          end
        end
      end
  
    STOP_BIT_STATE :
      begin
      if (clock_count_register < CLKS_PER_UART_CYCLE-1)
        begin
        clock_count_register  <= clock_count_register + 1;
        state                 <= STOP_BIT_STATE;
        end
      else
        begin
        data_valid_register   <= 1'b1;
        clock_count_register  <= 0;
        state                 <= CLEANUP_STATE;
        end
      end
  
    CLEANUP_STATE :
      begin
      state                   <= IDLE_STATE;
      data_valid_register     <= 1'b0;
      end
      
      
    default :
      state                   <= IDLE_STATE;
      
  endcase
end   
  
assign data_valid              = data_valid_register;
assign received_byte           = byte_register;
   
endmodule