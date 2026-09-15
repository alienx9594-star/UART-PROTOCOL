`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2026 15:11:34
// Design Name: 
// Module Name: UART_TX
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


module UART_TX(input wire clk,
                        input wire reset,
                        input wire [7:0] tx_data,
                       input wire tick,
                        input wire tx_start,
                        output reg baud_clear,
                       output reg tx,
                        output reg tx_done); 
  localparam idle=2'b00;
  localparam start=2'b01;
  localparam data=2'b10;
  localparam stop=2'b11;
  
  
  reg [1:0]state;
  reg [7:0]data_reg;
  reg [2:0]bit_count;
  
  always@(posedge clk or posedge reset)begin
    if(reset)begin 
    state <= idle;
      data_reg <= 8'b0;
      tx_done <= 1'b0;
      tx <= 1'b1;
      bit_count <= 3'b0;
      baud_clear<=1'b0;
    end
    else begin 
     tx_done<=1'b0;
      case(state)
        
        idle:begin 
        tx<=1'b1;
          if(tx_start) begin 
            state <= start;
            data_reg <= tx_data;
            bit_count <= 3'b0;
             baud_clear<=1'b1;
          end
        end
        start:begin 
       
           baud_clear<=1'b0;
          if(tick) begin
           state <= data;
          tx <= data_reg[bit_count];
          bit_count <= bit_count + 1;
          end
          else  tx<=1'b0;
        end
        data:begin 
         if(tick)begin 
          tx <= data_reg[bit_count];
   
            if(bit_count==7) begin 
              state <= stop;
              bit_count<=0;
            end
            else bit_count <= bit_count + 1;
          end
        end
        stop:begin 
        if(tick) begin
        tx <= 1'b1;
          tx_done <= 1'b1;
            state <= idle;
          end
        end
        default:state <= idle;
      endcase
     
    end
  end
 
endmodule
