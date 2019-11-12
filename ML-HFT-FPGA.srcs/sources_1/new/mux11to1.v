`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 07/17/2019 08:10:12 PM
// Module Name: mux11to1
// Project Name: MLA on an FPGA
// Target Devices: CMOD S7-25: Spartan 7
// Description: Takes 11 inputs and outputs the active 1
// 
//////////////////////////////////////////////////////////////////////////////////

module mux11to1 (      input clk,
                       input data_a_ready,
                       input data_b_ready,
                       input data_c_ready,
                       input data_d_ready,
                       input data_e_ready,
                       input data_f_ready,
                       input data_g_ready,
                       input data_h_ready,
                       input data_i_ready,
                       input data_j_ready,
                       input data_k_ready,
                       input [39:0] a,                 
                       input [39:0] b,                 
                       input [39:0] c,                 
                       input [39:0] d,
                       input [39:0] e,
                       input [39:0] f,
                       input [39:0] g,
                       input [39:0] h,
                       input [39:0] i,
                       input [39:0] j,
                       input [39:0] k,                 
                       input [10:0] sel, 
                       output reg [39:0] out,
                       output reg ready);
 
always @ (posedge clk) begin
    case (sel)
        11'b00000000001 : 
            begin
            if(data_a_ready == 1)
                begin
                out <= a;
                ready <= 1;
                end
            else
                begin
                out <= a;
                ready <= 0;
                end
            end
            
        11'b00000000010 : 
            begin
            if(data_b_ready == 1)
                begin
                out <= b;
                ready <= 1;
                end
            else
                begin
                out <= b;
                ready <= 0;
                end
            end
            
        11'b00000000100 : 
            begin
            if(data_c_ready == 1)
                begin
                out <= c;
                ready <= 1;
                end
            else
                begin
                out <= c;
                ready <= 0;
                end
            end
            
        11'b00000001000 : 
            begin
            if(data_d_ready == 1)
                begin
                out <= d;
                ready <= 1;
                end
            else
                begin
                out <= d;
                ready <= 0;
                end
            end
            
        11'b00000010000 : 
            begin
            if(data_e_ready == 1)
                begin
                out <= e;
                ready <= 1;
                end
            else
                begin
                out <= e;
                ready <= 0;
                end
            end
            
        11'b00000100000 : 
            begin
            if(data_f_ready == 1)
                begin
                out <= f;
                ready <= 1;
                end
            else
                begin
                out <= f;
                ready <= 0;
                end
            end
            
        11'b00001000000 : 
            begin
            if(data_g_ready == 1)
                begin
                out <= g;
                ready <= 1;
                end
            else
                begin
                out <= g;
                ready <= 0;
                end
            end
            
        11'b00010000000 : 
            begin
            if(data_h_ready == 1)
                begin
                out <= h;
                ready <= 1;
                end
            else
                begin
                out <= h;
                ready <= 0;
                end
            end
            
        11'b00100000000 : 
            begin
            if(data_i_ready == 1)
                begin
                out <= i;
                ready <= 1;
                end
            else
                begin
                out <= i;
                ready <= 0;
                end
            end
            
        11'b01000000000 : 
            begin
            if(data_j_ready == 1)
                begin
                out <= j;
                ready <= 1;
                end
            else
                begin
                out <= j;
                ready <= 0;
                end
            end
            
        11'b10000000000 : 
            begin
            if(data_k_ready == 1)
                begin
                out <= k;
                ready <= 1;
                end
            else
                begin
                out <= k;
                ready <= 0;
                end
            end
            
        default : 
            begin
            ready <= 0;
            out <= a;
            end
    endcase
end
endmodule

