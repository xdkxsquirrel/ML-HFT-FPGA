`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 08/26/2019 12:12:12 PM
// Module Name: UART_TX
// Project Name: MLA on an FPGA
// Target Devices: CMOD S7-25: Spartan 7
// Description: UART Protocol Transmitter of baudrate of 115200
// 
// CLKS_PER_UART_CYCLE = 12MHz / 115200
// 12000000 / 115200 = 104
//
//////////////////////////////////////////////////////////////////////////////////

module UART_TX(
  input       clk,
  input       data_valid,
  input [7:0] trasmit_byte, 
  output      active,
  output reg  serial,
  output      transmit_done
);
  
parameter CLKS_PER_UART_CYCLE   = 104;  
parameter IDLE_STATE            = 3'b000;
parameter START_BIT_STATE       = 3'b001;
parameter DATA_BITS_STATE       = 3'b010;
parameter STOP_BIT_STATE        = 3'b011;
parameter CLEANUP_STATE         = 3'b100;
   
reg [2:0] state                 = 0;
reg [7:0] clock_count_register  = 0;
reg [2:0] bit_index_register    = 0;
reg [7:0] data_register         = 0;
reg       done_register         = 0;
reg       active_register       = 0;
     
always @(posedge clk)
  begin
  case (state)
    IDLE_STATE :
      begin
      serial                   <= 1'b1;
      done_register            <= 1'b0;
      clock_count_register     <= 0;
      bit_index_register       <= 0;
            
      if (data_valid == 1'b1)
        begin
        active_register        <= 1'b1;
        data_register          <= trasmit_byte;
        state                  <= START_BIT_STATE;
        end
      else
        state                  <= IDLE_STATE;
      end 
        
    START_BIT_STATE :
      begin
      serial                   <= 1'b0;
            
      if (clock_count_register < CLKS_PER_UART_CYCLE-1)
        begin
        clock_count_register   <= clock_count_register + 1;
        state                  <= START_BIT_STATE;
        end
      else
        begin
        clock_count_register   <= 0;
        state                  <= DATA_BITS_STATE;
        end
      end
                
    DATA_BITS_STATE :
      begin
      serial                   <= data_register[bit_index_register];
            
      if (clock_count_register < CLKS_PER_UART_CYCLE-1)
        begin
        clock_count_register   <= clock_count_register + 1;
        state                  <= DATA_BITS_STATE;
        end
      else
        begin
        clock_count_register   <= 0;
                
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
      serial                   <= 1'b1;
            
      if (clock_count_register < CLKS_PER_UART_CYCLE-1)
        begin
        clock_count_register   <= clock_count_register + 1;
        state                  <= STOP_BIT_STATE;
        end
      else
        begin
        done_register          <= 1'b1;
        clock_count_register   <= 0;
        state                  <= CLEANUP_STATE;
        active_register        <= 1'b0;
        end
      end
        
    CLEANUP_STATE :
      begin
      done_register            <= 1'b1;
      state                    <= IDLE_STATE;
      end
         
    default :
      state                    <= IDLE_STATE;
        
    endcase
end

assign active                   = active_register;
assign transmit_done            = done_register;
   
endmodule
