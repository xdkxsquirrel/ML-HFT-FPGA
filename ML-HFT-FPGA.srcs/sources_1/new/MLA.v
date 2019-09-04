`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 07/17/2019 08:10:12 PM
// Module Name: MLA
// Project Name: MLA on an FPGA
// Target Devices: Arty Z7: APSoC Zynq-7000
// Description: Takes UART input from the HFT Raspberry PI and returns
//                      the decisions made by the Machine Learning Algorithm
// 
//////////////////////////////////////////////////////////////////////////////////

module MLA(
	input  clk,
	input received_data_valid,
	input [7:0] received_byte,
	output reg transmit_data_valid,
	output reg [7:0] transmit_byte
);

parameter ZERO      = 8'h30;
parameter ONE       = 8'h31;
parameter TWO       = 8'h32;
parameter THREE     = 8'h33;
parameter FOUR      = 8'h34;
parameter FIVE      = 8'h35;

always@(posedge clk)
begin
  if(received_data_valid)
    begin
      case (received_byte)
        ONE :
          begin
          transmit_data_valid <= 1'b1;
          transmit_byte <= 8'h61;
          end
          
        TWO :
          begin
          transmit_data_valid <= 1'b1;
          transmit_byte <= 8'h62;
          end
          
        THREE :
          begin
          transmit_data_valid <= 1'b1;
          transmit_byte <= 8'h63;
          end
          
        FOUR :
          begin
          transmit_data_valid <= 1'b1;
          transmit_byte <= 8'h64;
          end
          
        FIVE :
          begin
          transmit_data_valid <= 1'b1;
          transmit_byte <= 8'h65;
          end
       
        default:
          begin
          transmit_data_valid <= 1'b1;
          transmit_byte <= 8'h52;
          end
   
      endcase
    end
  else
    begin
    transmit_data_valid <= 1'b0;
    transmit_byte <= 8'h52;
    end
end
endmodule
          


/*

reg cw [6:0];
reg fw [6:0];
reg pw [6:0];
reg tw [6:0];
reg mw [6:0];
integer weight_change_state;

parameter O_O_O_O_O            = 8'h60;
parameter O_O_O_O_mw           = 8'h61;
parameter O_O_O_tw_O           = 8'h62;
parameter O_O_O_tw_mw          = 8'h63;
parameter O_O_pw_O_O           = 8'h64;
parameter O_O_pw_O_mw          = 8'h65;
parameter O_O_pw_tw_O          = 8'h66;
parameter O_O_pw_tw_mw         = 8'h67;
parameter O_fw_O_O_O           = 8'h68;
parameter O_fw_O_O_mw          = 8'h69;
parameter O_fw_O_tw_O          = 8'h6A;
parameter O_fw_O_tw_mw         = 8'h6B;
parameter O_fw_pw_O_O          = 8'h6C;
parameter O_fw_pw_O_mw         = 8'h6D;
parameter O_fw_pw_tw_O         = 8'h6E;
parameter O_fw_pw_tw_mw        = 8'h6F;
parameter cw_O_O_O_O           = 8'h70;
parameter cw_O_O_O_mw          = 8'h71;
parameter cw_O_O_tw_O          = 8'h72;
parameter cw_O_O_tw_mw         = 8'h73;
parameter cw_O_pw_O_O          = 8'h74;
parameter cw_O_pw_O_mw         = 8'h75;
parameter cw_O_pw_tw_O         = 8'h76;
parameter cw_O_pw_tw_mw        = 8'h77;
parameter cw_fw_O_O_O          = 8'h78;
parameter cw_fw_O_O_mw         = 8'h79;
parameter cw_fw_O_tw_O         = 8'h7A;
parameter cw_fw_O_tw_mw        = 8'h7B;
parameter cw_fw_pw_O_O         = 8'h7C;
parameter cw_fw_pw_O_mw        = 8'h7D;
parameter cw_fw_pw_tw_O        = 8'h7E;
parameter cw_fw_pw_tw_mw       = 8'h7F;

// incoming bytes are [1/0][1][1][cw][fw][pw][tw][mw]
always@(posedge clk)
begin
  if(received_data_valid)
    begin
      case (received_byte[7])
        0 :
          begin
          if(((cw * received_byte[4])+(cw * received_byte[3])+
            (cw * received_byte[2])+(cw * received_byte[1])+(cw * received_byte[0]))>
            ((received_byte[4]+received_byte[3]+received_byte[2]+received_byte[1]+received_byte[0])/2))
            begin
              transmit_data_valid <= 1'b1;
              transmit_byte <= ONE;
            end
          else
            begin
            transmit_data_valid <= 1'b1;
            transmit_byte <= ZERO;
            end
          
          
          end
          
        1 :
          begin
          case(weight_change_state)
            0:
              begin

              end
            
            1:
              begin

              end

            2:
              begin

              end

            3:
              begin

              end

            4:
              begin

              end

            5:
              begin

              end

            default:
              begin

              end
          endcase
          end
   
      endcase
    end
  else
    begin
    transmit_data_valid <= 1'b0;
    transmit_byte <= 8'h52;
    end
end
endmodule




/*