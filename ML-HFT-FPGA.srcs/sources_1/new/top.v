`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2019 08:10:12 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
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
endmodule