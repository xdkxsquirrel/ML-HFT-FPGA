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
  input  [79:0]    data, 
  output reg       ready,
  output reg       active,
  output reg [7:0] current_byte_to_send     
);
  
parameter IDLE                              =  0;  
parameter SEND_BYTE                         =  1;


parameter NUMBER_OF_BYTES_TO_SEND           = 10;

reg [3:0]  state                            =  0;
reg [79:0] data_to_send                     =  0;
integer    i                                =  0;
     
always @(posedge clk)
  begin
  case (state)
    IDLE :
      begin
      if(data_valid == 1)
        begin
        data_to_send <= data;
        state <= SEND_BYTE;
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
    SEND_BYTE :
      begin
      if(uart_active == 0)
        begin
        current_byte_to_send <= data_to_send[i*8 +: 8];
        ready <= 1;
        if(i > NUMBER_OF_BYTES_TO_SEND-2)
            begin
            i <= 0;
            state <= IDLE;
            active <= 0; 
            end
        else
            begin
            active <= 1;
            state <= SEND_BYTE;
            i <= i + 1;
            end
        end
      else
        begin
        state <= SEND_BYTE;
        ready <= 0;
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