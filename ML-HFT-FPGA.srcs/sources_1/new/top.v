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

parameter TSLA                              = 0;
parameter AAPL                              = 1;
parameter WMT                               = 2;
parameter JNJ                               = 3;
parameter GOOG                              = 4;
parameter XOM                               = 5; 
parameter MSFT                              = 6; 
parameter GE                                = 7; 
parameter JPM                               = 8; 
parameter IBM                               = 9; 
parameter AMZN                              = 10; 

wire data_received_from_UART_is_valid;
wire [7:0] data_received_from_UART;
wire data_ready_for_mla;
wire [7:0] data_for_mla;
wire data_ready_for_weights;
wire [10:0] stock_selected;
wire [47:0] data_for_stock;

wire data_ready_from_TSLA;
wire [39:0] data_from_TSLA;
wire data_ready_from_AAPL;
wire [39:0] data_from_AAPL;
wire data_ready_from_WMT;
wire [39:0] data_from_WMT;
wire data_ready_from_JNJ;
wire [39:0] data_from_JNJ;
wire data_ready_from_GOOG;
wire [39:0] data_from_GOOG;
wire data_ready_from_XOM;
wire [39:0] data_from_XOM;
wire data_ready_from_MSFT;
wire [39:0] data_from_MSFT;
wire data_ready_from_GE;
wire [39:0] data_from_GE;
wire data_ready_from_JPM;
wire [39:0] data_from_JPM;
wire data_ready_from_IBM;
wire [39:0] data_from_IBM;
wire data_ready_from_AMZN;
wire [39:0] data_from_AMZN;

wire [39:0] output_to_hex_to_ascii;
wire mux_data_ready;
wire [7:0] transmit_byte;
wire transmit_data_valid;
wire active;
wire transmit_done;

UART_RX rx(clk, pio48, data_received_from_UART_is_valid, data_received_from_UART);
convert_from_ASCII convert_from(clk, data_received_from_UART_is_valid, data_received_from_UART, data_ready_for_mla, data_for_mla);
MLA mla(clk, data_ready_for_mla, data_for_mla, data_ready_for_weights, stock_selected, data_for_stock);

stock_weight TSLA_weight(clk, data_ready_for_weights, stock_selected[TSLA], data_for_stock, data_ready_from_TSLA, data_from_TSLA);  
stock_weight AAPL_weight(clk, data_ready_for_weights, stock_selected[AAPL], data_for_stock, data_ready_from_AAPL, data_from_AAPL);
stock_weight WMT_weight(clk, data_ready_for_weights, stock_selected[WMT], data_for_stock, data_ready_from_WMT, data_from_WMT);
stock_weight JNJ_weight(clk, data_ready_for_weights, stock_selected[JNJ], data_for_stock, data_ready_from_JNJ, data_from_JNJ);
stock_weight GOOG_weight(clk, data_ready_for_weights, stock_selected[GOOG], data_for_stock, data_ready_from_GOOG, data_from_GOOG);
stock_weight XOM_weight(clk, data_ready_for_weights, stock_selected[XOM], data_for_stock, data_ready_from_XOM, data_from_XOM);
stock_weight MSFT_weight(clk, data_ready_for_weights, stock_selected[MSFT], data_for_stock, data_ready_from_MSFT, data_from_MSFT);
stock_weight GE_weight(clk, data_ready_for_weights, stock_selected[GE], data_for_stock, data_ready_from_GE, data_from_GE);
stock_weight JPM_weight(clk, data_ready_for_weights, stock_selected[JPM], data_for_stock, data_ready_from_JPM, data_from_JPM);
stock_weight IBM_weight(clk, data_ready_for_weights, stock_selected[IBM], data_for_stock, data_ready_from_IBM, data_from_IBM);
stock_weight AMZN_weight(clk, data_ready_for_weights, stock_selected[AMZN], data_for_stock, data_ready_from_AMZN, data_from_AMZN);

mux11to1 MUX(data_ready_from_TSLA, data_ready_from_AAPL, data_ready_from_WMT, data_ready_from_JNJ, data_ready_from_GOOG, data_ready_from_XOM, data_ready_from_MSFT, 
        data_ready_from_GE, data_ready_from_JPM, data_ready_from_IBM, data_ready_from_AMZN, data_from_TSLA, data_from_AAPL, data_from_WMT, data_from_JNJ, data_from_GOOG, data_from_XOM,
        data_from_MSFT, data_from_GE, data_from_JPM, data_from_IBM, data_from_AMZN, stock_selected, output_to_hex_to_ascii, mux_data_ready);

convert_to_ASCII convert_to(clk, active, mux_data_ready, output_to_hex_to_ascii, transmit_data_valid, transmit_byte);
UART_TX tx(clk, transmit_data_valid, transmit_byte, active, pio47, transmit_done);

endmodule