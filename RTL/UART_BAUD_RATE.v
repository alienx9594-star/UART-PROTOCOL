`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2026 15:12:34
// Design Name: 
// Module Name: UART_BAUD_RATE
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


module UART_BAUD_RATE #(parameter clk_freq = 50000000, //50 mhz 
                       parameter baud_rate= 115200 )
 (input wire clk,
  input wire reset,
  output reg tick,
  output reg tick_16,
  output reg [12:0]counter,
  output reg [12:0]counter_16,
  input wire baud_clear
  );

  localparam baud_div = clk_freq / (baud_rate);
  
  localparam baud_div_16 = clk_freq / (16*baud_rate); // oversampling to capture bit in between
  
                       always@ (posedge clk or posedge reset)begin
                         if(reset|baud_clear)begin
                         tick<=1'b0;
                         
                           counter<=13'b0;
                         end
                         else if(counter==(baud_div - 1))begin 
                         tick<=1'b1;
                         counter<=13'b0;
                         end
                         else begin 
                         counter<=counter+1;
                           tick<=1'b0;
                         
                         end
                       end
  
     always@ (posedge clk or posedge reset)begin
                         if(reset|baud_clear)begin
                         tick_16<=1'b0;
                         
                           counter_16<=13'b0;
                         end
       else if(counter_16==(baud_div_16 - 1))begin 
                         tick_16<=1'b1;
                         counter_16<=13'b0;
                         end
                         else begin 
                         counter_16<=counter_16+1;
                           tick_16<=1'b0;
                         
                         end
                       end
                     endmodule