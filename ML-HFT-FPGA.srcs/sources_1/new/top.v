`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 07/17/2019 08:10:12 PM
// Module Name: top
// Project Name: MLA on an FPGA
// Target Devices: Arty Z7: APSoC Zynq-7000
// Description: Takes UART input from the HFT Raspberry PI and returns
//                      the decisions made by the Machine Learning Algorithm
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
	input      clk,
	input      [3:0] btn,
	input      [1:0] sw,
	input      ck_scl,
	output     led4_r,
	output     led4_g,
	output     led4_b,
	output     led5_r,
	output     led5_g,
	output     led5_b,
	output reg [3:0] led,
	output     ck_sda
);

wire received_data_valid;
wire transmit_data_valid;
wire [7:0] received_byte;
wire [7:0] transmit_byte;
wire active;
wire transmit_done;

UART_RX rx(clk, ck_scl, data_valid, received_byte);
LED ledblock(clk, data_valid, received_byte, led4_r, led4_g, led4_b);
//MLA mla(clk, received_data_valid, received_byte, transmit_data_valid, transmit_byte);
//UART_TX tx(clk, transmit_data_valid, transmit_byte, active, ck_sda, transmit_done);
endmodule