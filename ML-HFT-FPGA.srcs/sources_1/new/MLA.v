`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Utah     
// Engineer:   Donovan Bidlack
// 
// Create Date: 07/17/2019 08:10:12 PM
// Module Name: MLA
// Project Name: MLA on an FPGA
// Target Devices: Arty Z7: APSoC Zynq-7000
// Description: Takes I2C input from the HFT Raspberry PI and returns
//                      the decisions made by the Machine Learning Algorithm
// 
//////////////////////////////////////////////////////////////////////////////////

module MLA(
	input  clk,
	input  operation_code,
	input  company_data,
      input  [6:0] company_weight,
      input  four_data,
      input  [6:0] four_weight,
      input  profit_data,
      input  [6:0] profit_weight,
      input  twitter_data,
      input  [6:0] twitter_weight,
      input  moving_data,
      input  [6:0] moving_weight,
	output decision
);

parameter MAXWEIGHT = 6'h64;
parameter MINWEIGHT = 6'h0;

always@(posedge clk)
      // Decide Trade
      if(operation_code)
            begin

//       def decide_trade(self):
//             tipping_point = (self.company_weight +  self.four_weight + self.profit_weight + self.twitter_weight + self.moving_weight) / 5
//             if(self.company_data * self.company_weight + \
//                         self.moving_data * self.moving_weight + \
//                         self.profit_data * self.profit_weight + \
//                         self.twitter_data * self.twitter_weight) > tipping_point:
//                   return True
//             else:
//                   return False
            end

      // Learn
      else
            begin
            if (company_weight > MINWEIGHT) & (company_weight < MAXWEIGHT)
                  company_weight <= comapny_weight + company_data;
            else
                  company_weight <= company_weight;
            if (four_weight > MINWEIGHT) & (four_weight < MAXWEIGHT)
                  four_weight <= four_weight + four_data;
            else
                  company_weight <= company_weight;
            if (profit_weight > MINWEIGHT) & (profit_weight < MAXWEIGHT)
                  profit_weight <= profit_weight + profit_data;
            else
                  company_weight <= company_weight;
            if (twitter_weight > MINWEIGHT) & (twitter_weight < MAXWEIGHT)
                  twitter_weight <= twitter_weight + twitter_data;
            else
                  company_weight <= company_weight;
            if (moving_weight > MINWEIGHT) & (moving_weight < MAXWEIGHT)
                  moving_weight <= moving_weight + moving_data;
            else
                  company_weight <= company_weight;
            decision <= 0;
            end