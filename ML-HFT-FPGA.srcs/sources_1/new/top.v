`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 07/17/2019 08:10:12 PM
// Module Name: top
// Project Name: MLA on an FPGA
// Target Devices: Arty Z7: APSoC Zynq-7000
// Description: Takes I2C input from the HFT Raspberry PI and returns
//                      the decisions made by the Machine Learning Algorithm
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
	input  clk,
	input  [3:0] btn,
	input  [1:0] sw,
	output led4_r,
	output led4_g,
	output led4_b,
	output led5_r,
	output led5_g,
	output led5_b,
	output reg [3:0] led,
	output reg ck_scl,
	output ck_sda
);
	

always @ (posedge clk)
begin
    if(clk)
       begin
        ck_scl = 1;
        led[0] = 1;
       end
    else
       begin
        ck_scl = 0;
        led[1] = 0;
       end
end

always @ (negedge clk)
begin
    if(clk)
       begin
        ck_scl = 1;
        led[0] = 1;
       end
    else
       begin
        ck_scl = 0;
        led[1] = 0;
       end
end
endmodule