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
	input      pio48,
	output     led0_r,
	output     led0_g,
	output     led0_b,
	output reg [3:0] led,
	output reg pio47
);

wire received_data_valid;
wire transmit_data_valid;
wire data_ready_for_mla;
wire [7:0] received_byte;
wire [7:0] transmit_byte;
wire [7:0] data_for_mla;
wire active;
wire transmit_done;

UART_RX rx(clk, pio48, received_data_valid, received_byte);
convert_from_ASCII convert(clk, received_data_valid, received_byte, data_ready_for_mla, data_for_mla);
MLA mla(clk, received_data_valid, received_byte, transmit_data_valid, transmit_byte, led0_r, led0_g, led0_b);
UART_TX tx(clk, transmit_data_valid, transmit_byte, active, pio47, transmit_done);

endmodule