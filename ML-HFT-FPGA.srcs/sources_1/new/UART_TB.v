`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 09/20/2019 10:29:45 AM
// Module Name: UART_TB
// Project Name: MLA on an FPGA
// Target Devices: CMOD S7-25: Spartan 7
// Description: UART Protocol TestBench
// 
// CLKS_PER_UART_CYCLE = 12MHz / 115200
// 12000000 / 115200 = 104
//
//////////////////////////////////////////////////////////////////////////////////
`include "UART_TX.v"
`include "UART_RX.v"
 
module UART_TB ();
 
// Testbench uses a 10 MHz clock
// Want to interface to 115200 baud UART
parameter CLOCK_PERIOD_NS = 100;
parameter CLKS_PER_UART_CYCLE    = 104;
parameter BIT_PERIOD      = 8600;

reg testbench_clock = 0;
reg tx_data_valid = 0;
reg rx_serial = 1;
reg [7:0] byte_to_transmit = 0;
reg [7:0] data_to_send = 8'h3F;

wire tx_done;
wire [7:0] received_byte;

integer     loop_iterator;

UART_RX #() UART_RX_INST
    (.clk(testbench_clock),
     .serial(rx_serial),
     .data_valid(),
     .received_byte(received_byte)
     );

UART_TX #() UART_TX_INST
    (.clk(testbench_clock),
     .data_valid(tx_data_valid),
     .trasmit_byte(byte_to_transmit),
     .active(),
     .serial(),
     .transmit_done(tx_done)
     );
 
   
always
    #(CLOCK_PERIOD_NS/2) testbench_clock <= !testbench_clock;


initial
begin   
  @(posedge testbench_clock);
  @(posedge testbench_clock);
  tx_data_valid <= 1'b1;
  byte_to_transmit <= 8'hAB;
  @(posedge testbench_clock);
  tx_data_valid <= 1'b0;
  @(posedge tx_done);
   
  @(posedge testbench_clock);
  rx_serial <= 1'b0;
  #(BIT_PERIOD);
  #1000;
  
  rx_serial <= data_to_send[0];
  #(BIT_PERIOD);
  rx_serial <= data_to_send[1];
  #(BIT_PERIOD);
  rx_serial <= data_to_send[2];
  #(BIT_PERIOD);
  rx_serial <= data_to_send[3];
  #(BIT_PERIOD);
  rx_serial <= data_to_send[4];
  #(BIT_PERIOD);
  rx_serial <= data_to_send[5];
  #(BIT_PERIOD);
  rx_serial <= data_to_send[6];
  #(BIT_PERIOD);
  rx_serial <= data_to_send[7];
  #(BIT_PERIOD);   
  rx_serial <= 1'b1;
  #(BIT_PERIOD);
  @(posedge testbench_clock);
         
  if (received_byte == 8'h3F)
    $display("Test Passed");
  else
    $display("Test Failed");
   
end
   
endmodule
