`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 08/26/2019 12:12:12 PM
// Module Name: parallel_to_serial_buffer
// Project Name: MLA on an FPGA
// Target Devices: CMOD S7-25: Spartan 7
// Description: Takes the ASCII values from parallel and sends them one byte at 
//              a time to UART.
//
//////////////////////////////////////////////////////////////////////////////////

module parallel_to_serial_buffer(
  input            clk,
  input            uart_active,
  input            data_valid,
  input            uart_done,
  input  [79:0]    data, 
  output reg       ready,
  output reg       active,
  output reg [7:0] current_byte_to_send     
);
  
parameter IDLE                              =  0;  
parameter FIRST_BYTE                        =  1;
parameter SECOND_BYTE                       =  2;
parameter THIRD_BYTE                        =  3;
parameter FOURTH_BYTE                       =  4;
parameter FIFTH_BYTE                        =  5;
parameter SIXTH_BYTE                        =  6;
parameter SEVENTH_BYTE                      =  7;
parameter EIGHTH_BYTE                       =  8;
parameter NINTH_BYTE                        =  9;
parameter TENTH_BYTE                        = 10;
parameter WAIT_FOR_UART                     = 11;

reg [3:0]  state                            =  0;
reg [79:0] data_to_send                     =  0;
integer    i                                =  0;
reg [3:0] next_state                        =  0;
     
always @(posedge clk)
  begin
  case (state)
    IDLE :
      begin
      if(data_valid == 1)
        begin
        data_to_send <= data;
        state <= FIRST_BYTE;
        ready <= 0;
        active <= 1;
        end
      else
        begin
        state <= IDLE;
        ready <= 0;
        active <= 0;
        end
      end
      
    FIRST_BYTE :
      begin
      if(uart_active == 0)
        begin
        current_byte_to_send <= data_to_send[7:0];
        ready <= 1;
        state <= WAIT_FOR_UART;
        next_state <= SECOND_BYTE;
        active <= 1; 
        end
      else
        begin
        ready <= 0;
        active <= 1;
        state <= FIRST_BYTE;
        end
      end
     
    SECOND_BYTE :
      begin
      if(uart_active == 0)
        begin
        current_byte_to_send <= data_to_send[15:8];
        ready <= 1;
        state <= WAIT_FOR_UART;
        next_state <= THIRD_BYTE;
        active <= 1; 
        end
      else
        begin
        ready <= 0;
        active <= 1;
        state <= SECOND_BYTE;
        end
      end
      
    THIRD_BYTE :
      begin
      if(uart_active == 0)
        begin
        current_byte_to_send <= data_to_send[23:16];
        ready <= 1;
        state <= WAIT_FOR_UART;
        next_state <= FOURTH_BYTE;
        active <= 1; 
        end
      else
        begin
        ready <= 0;
        active <= 1;
        state <= THIRD_BYTE;
        end
      end
      
    FOURTH_BYTE :
      begin
      if(uart_active == 0)
        begin
        current_byte_to_send <= data_to_send[31:24];
        ready <= 1;
        state <= WAIT_FOR_UART;
        next_state <= FIFTH_BYTE;
        active <= 1; 
        end
      else
        begin
        ready <= 0;
        active <= 1;
        state <= FOURTH_BYTE;
        end
      end
      
    FIFTH_BYTE :
      begin
      if(uart_active == 0)
        begin
        current_byte_to_send <= data_to_send[39:32];
        ready <= 1;
        state <= WAIT_FOR_UART;
        next_state <= SIXTH_BYTE;
        active <= 1; 
        end
      else
        begin
        ready <= 0;
        active <= 1;
        state <= FIFTH_BYTE;
        end
      end
      
    SIXTH_BYTE :
      begin
      if(uart_active == 0)
        begin
        current_byte_to_send <= data_to_send[47:40];
        ready <= 1;
        state <= WAIT_FOR_UART;
        next_state <= SEVENTH_BYTE;
        active <= 1; 
        end
      else
        begin
        ready <= 0;
        active <= 1;
        state <= SIXTH_BYTE;
        end
      end
      
    SEVENTH_BYTE :
      begin
      if(uart_active == 0)
        begin
        current_byte_to_send <= data_to_send[55:48];
        ready <= 1;
        state <= WAIT_FOR_UART;
        next_state <= EIGHTH_BYTE;
        active <= 1; 
        end
      else
        begin
        ready <= 0;
        active <= 1;
        state <= SEVENTH_BYTE;
        end
      end
      
    EIGHTH_BYTE :
      begin
      if(uart_active == 0)
        begin
        current_byte_to_send <= data_to_send[63:56];
        ready <= 1;
        state <= WAIT_FOR_UART;
        next_state <= NINTH_BYTE;
        active <= 1; 
        end
      else
        begin
        ready <= 0;
        active <= 1;
        state <= EIGHTH_BYTE;
        end
      end
      
    NINTH_BYTE :
      begin
      if(uart_active == 0)
        begin
        current_byte_to_send <= data_to_send[71:64];
        ready <= 1;
        state <= WAIT_FOR_UART;
        next_state <= TENTH_BYTE;
        active <= 1; 
        end
      else
        begin
        ready <= 0;
        active <= 1;
        state <= NINTH_BYTE;
        end
      end
      
    TENTH_BYTE :
      begin
      if(uart_active == 0)
        begin
        current_byte_to_send <= data_to_send[79:72];
        ready <= 1;
        state <= WAIT_FOR_UART;
        next_state <= IDLE;
        active <= 1; 
        end
      else
        begin
        ready <= 0;
        active <= 1;
        state <= TENTH_BYTE;
        end
      end
      
    WAIT_FOR_UART :
      begin
      if(i > 10000)
        begin
        i <= 0;
        ready = 0;
        state <= next_state;
        active <= 1; 
        end
      else
        begin
        i <= i + 1;
        ready <= 0;
        active <= 1;
        state <= WAIT_FOR_UART;
        end
      end
          
    default:
        begin
        state <= IDLE;
        ready <= 0;
        end
    endcase
  end
endmodule