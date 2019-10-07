`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 07/17/2019 08:10:12 PM
// Module Name: top
// Project Name: MLA on an FPGA
// Target Devices: CMOD S7-25: Spartan 7
// Description: Takes UART input from the HFT Raspberry PI and returns
//                      the decisions made by the Machine Learning Algorithm
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
	input      clk,
	input      [1:0] btn,
	input      pio2,
	output     led0_r,
	output     led0_g,
	output     led0_b,
	output reg [3:0] led,
	output reg pio1
);

wire received_data_valid;
wire transmit_data_valid;
wire [7:0] received_byte;
wire [7:0] transmit_byte;
wire active;
wire transmit_done;

UART_RX rx(clk, ck_scl, data_valid, received_byte);
LED ledblock(clk, data_valid, received_byte, led4_r, led4_g, led4_b);
MLA mla(clk, received_data_valid, received_byte, transmit_data_valid, transmit_byte);
UART_TX tx(clk, transmit_data_valid, transmit_byte, active, ck_sda, transmit_done);

endmodule