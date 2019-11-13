`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 09/20/2019 10:29:45 AM
// Module Name: MLA_TB
// Project Name: MLA on an FPGA
// Target Devices: CMOD S7-25: Spartan 7
// Description: Full MLA, From UART to UART TestBench
// 
//////////////////////////////////////////////////////////////////////////////////
 
module MLA_TB;

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

parameter EXECUTION_CONFIRMATION            = "CCCCCCCCCC";
parameter EXECUTE_BUY                       = "1111111111";
parameter EXECUTE_SELL                      = "2222222222";
        
        integer has_failed;
        reg [95:0] ASCII_Bytes;
        reg [79:0] Expected_Reply;
        
        reg        clk;
        reg        data_received_from_UART_is_valid;
        reg [7:0]  data_received_from_UART;
        reg        UART_active;
               
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
        wire [79:0] unserialized_data;
        wire unserialized_data_valid;
        wire serializer_active;
        wire serialized_data_ready;
        wire [7:0] transmit_byte;
        wire transmit_done;
        
        convert_from_ASCII  convert_from(
                .clk(clk),
                .data_valid(data_received_from_UART_is_valid),
                .transmitted_byte(data_received_from_UART),
                .ready(data_ready_for_mla),
                .out(data_for_mla)
        );
        
        MLA mla (
                .clk(clk),
                .data_valid(data_ready_for_mla),
                .received_byte(data_for_mla),
                .data_ready(data_ready_for_weights),
                .stock(stock_selected),
                .out(data_for_stock)
        );
        
        stock_weight TSLA_weight (
                .clk(clk),
                .data_valid(data_ready_for_weights),
                .stock_selected(stock_selected[TSLA]),
                .data(data_for_stock),
                .data_ready(data_ready_from_TSLA),
                .out(data_from_TSLA)
        );
        
        stock_weight AAPL_weight (
                .clk(clk),
                .data_valid(data_ready_for_weights),
                .stock_selected(stock_selected[AAPL]),
                .data(data_for_stock),
                .data_ready(data_ready_from_AAPL),
                .out(data_from_AAPL)
        );
        
        stock_weight WMT_weight (
                .clk(clk),
                .data_valid(data_ready_for_weights),
                .stock_selected(stock_selected[WMT]),
                .data(data_for_stock),
                .data_ready(data_ready_from_WMT),
                .out(data_from_WMT)
        );
        
        stock_weight JNJ_weight (
                .clk(clk),
                .data_valid(data_ready_for_weights),
                .stock_selected(stock_selected[JNJ]),
                .data(data_for_stock),
                .data_ready(data_ready_from_JNJ),
                .out(data_from_JNJ)
        );
        
        stock_weight GOOG_weight (
                .clk(clk),
                .data_valid(data_ready_for_weights),
                .stock_selected(stock_selected[GOOG]),
                .data(data_for_stock),
                .data_ready(data_ready_from_GOOG),
                .out(data_from_GOOG)
        );
        
        stock_weight XOM_weight (
                .clk(clk),
                .data_valid(data_ready_for_weights),
                .stock_selected(stock_selected[XOM]),
                .data(data_for_stock),
                .data_ready(data_ready_from_XOM),
                .out(data_from_XOM)
        );
        
        stock_weight MSFT_weight (
                .clk(clk),
                .data_valid(data_ready_for_weights),
                .stock_selected(stock_selected[MSFT]),
                .data(data_for_stock),
                .data_ready(data_ready_from_MSFT),
                .out(data_from_MSFT)
        );
        
        stock_weight GE_weight (
                .clk(clk),
                .data_valid(data_ready_for_weights),
                .stock_selected(stock_selected[GE]),
                .data(data_for_stock),
                .data_ready(data_ready_from_GE),
                .out(data_from_GE)
        );
        
        stock_weight JPM_weight (
                .clk(clk),
                .data_valid(data_ready_for_weights),
                .stock_selected(stock_selected[JPM]),
                .data(data_for_stock),
                .data_ready(data_ready_from_JPM),
                .out(data_from_JPM)
        );
        
        stock_weight IBM_weight (
                .clk(clk),
                .data_valid(data_ready_for_weights),
                .stock_selected(stock_selected[IBM]),
                .data(data_for_stock),
                .data_ready(data_ready_from_IBM),
                .out(data_from_IBM)
        );
        
        stock_weight AMZN_weight (
                .clk(clk),
                .data_valid(data_ready_for_weights),
                .stock_selected(stock_selected[AMZN]),
                .data(data_for_stock),
                .data_ready(data_ready_from_AMZN),
                .out(data_from_AMZN)
        );
        
        mux11to1 MUX (
                .clk(clk),
                .data_a_ready(data_ready_from_TSLA),
                .data_b_ready(data_ready_from_AAPL),
                .data_c_ready(data_ready_from_WMT),
                .data_d_ready(data_ready_from_JNJ),
                .data_e_ready(data_ready_from_GOOG),
                .data_f_ready(data_ready_from_XOM),
                .data_g_ready(data_ready_from_MSFT),
                .data_h_ready(data_ready_from_GE),
                .data_i_ready(data_ready_from_JPM),
                .data_j_ready(data_ready_from_IBM),
                .data_k_ready(data_ready_from_AMZN),
                .a(data_from_TSLA),
                .b(data_from_AAPL),
                .c(data_from_WMT),
                .d(data_from_JNJ),
                .e(data_from_GOOG),
                .f(data_from_XOM),
                .g(data_from_MSFT),
                .h(data_from_GE),
                .i(data_from_JPM),
                .j(data_from_IBM),
                .k(data_from_AMZN),
                .sel(stock_selected),
                .out(output_to_hex_to_ascii),
                .ready(mux_data_ready)
        );
        
        convert_to_ASCII convert_to (
                .clk(clk),
                .active(serializer_active),
                .data_valid(mux_data_ready),
                .data(output_to_hex_to_ascii),
                .ready(unserialized_data_valid),
                .data_to_send(unserialized_data)
        );
        
        parallel_to_serial_buffer serializer (
                .clk(clk),
                .uart_active(UART_active),
                .data_valid(unserialized_data_valid),
                .data(unserialized_data),
                .ready(serialized_data_ready),
                .active(serializer_active),
                .current_byte_to_send(transmit_byte)
        );

//////////////////////////////////////////////////////////////////////
// Main Testbench Procedure
//////////////////////////////////////////////////////////////////////
initial
begin
	clk = 0;
	data_received_from_UART_is_valid = 0;
	data_received_from_UART = 0;
end 

always
    #1 clk = !clk;

initial
begin
    // ASCII_Bytes = |1CMD|1STOCK|2COMPANYWEIGHT|2FOURWEIGHT|2PROFITWEIGHT|2TWITTERWEIGHT|2MOVINGWEIGHT
    // CMDs =   A: Set Weights   B: Get Weights  C: Calc Buy    D: Add to Weights    E: Subtract from Weights
    // Stock is second Byte:    1 TSLA | 2 AAPL | 3 WMT | 4 JNJ | 5 GOOG | 6 XOM | 7 MSFT | 8 GE | 9 JPM | A AMZN
    $display("################################################ Setting Weights for TSLA (10100 Values for a Sell)");
    ASCII_Bytes = "A1AB553321C3";
    Expected_Reply = EXECUTION_CONFIRMATION;
    SendBytes();
    $display(" ");
    
    $display("################################################ Getting Weights for TSLA");
    ASCII_Bytes = "B1DCDCDCDCDC";
    Expected_Reply = "AB553321C3";
    SendBytes();
    $display(" ");
    
    $display("################################################ Calc Buy for TSLA (Should Be Sell)");
    ASCII_Bytes = "C10100010000";
    Expected_Reply = EXECUTE_SELL;
    SendBytes();
    $display(" ");
    
    $display("################################################ Setting Weights for XOM (11100 Values for a BUY)");
    ASCII_Bytes = "A6AB553321C3";
    Expected_Reply = EXECUTION_CONFIRMATION;
    SendBytes();
    $display(" ");
    
    $display("################################################ Calc Buy for XOM (Should Be BUY)");
    ASCII_Bytes = "C60101010000";
    Expected_Reply = EXECUTE_BUY;
    SendBytes();
    $display(" ");
    
    $display("################################################ Decrease TSLA Weights for all by 5 Then Check");
    ASCII_Bytes = "E10101010101";
    Expected_Reply = EXECUTION_CONFIRMATION;
    SendBytes();
    SendBytes();
    SendBytes();
    SendBytes();
    SendBytes();
    ASCII_Bytes = "B1DCDCDCDCDC";
    Expected_Reply = "A6502E1CBE";
    SendBytes();
    $display(" ");
    
    $stop;
end

//////////////////////////////////////////////////////////////////////
// SendBytes
//////////////////////////////////////////////////////////////////////
task SendBytes;
begin
  #6
  // Send the 10 ASCII Bytes
  for(integer i=12; i>0; i=i-1)
    begin
    data_received_from_UART_is_valid = 1;
    data_received_from_UART = ASCII_Bytes[i*8-1 -: 8];
    #2
    data_received_from_UART_is_valid = 0;
    #6;
    end
  
  UART_active = 1;
  #60
  has_failed = 0;
  
  for(integer i=10; i>0; i=i-1)
    begin
    UART_active = 0;
    #2
    //$display("TRANSMITTED BYTE: %s", transmit_byte);
    if(transmit_byte != Expected_Reply[i*8-1 -: 8])
        has_failed = 1;
    UART_active = 1;
    #6;
    end
      
  if(has_failed == 0)
    $display("################################################ Passed");
  else
    $display("################################################ Failed");
end
endtask

endmodule
