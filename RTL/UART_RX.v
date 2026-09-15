`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2026 15:12:03
// Design Name: 
// Module Name: UART_RX
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


module UART_RX(input wire clk,
                    input wire reset,
                    input wire rx_in1,
                  
                    input wire tick_16,
                     output reg baud_clear,
                     output reg [7:0]rx_data,
                     output reg rx_done,
                     output reg error_byte);
  localparam idle=2'b00;
  localparam start=2'b01;
  localparam data=2'b10;
  localparam stop=2'b11;
  
  reg [1:0]state;
  reg [7:0]data_reg;
  reg [3:0]rx_tick;
  reg [2:0]bit_count;
  reg rx_in2,rx;
  
  always@(posedge clk or posedge reset)begin
  rx_in2 <= rx_in1; 
  rx <= rx_in2;
    if(reset)begin 
    state<=idle;
      data_reg<=8'b0;
      bit_count<=3'b0;
      rx_tick<=4'b0;
      rx_data<=8'b0;
      rx_done<=0;
      baud_clear<=0;
      error_byte <= 0;
    end
    else begin 
      case(state)
        idle:begin 
          rx_done<=0;
           data_reg<=8'b0;
      bit_count<=3'b0;
      rx_tick<=4'b0;
      error_byte<=0;
   
      
          if(rx==0)begin 
          state<=start;
            baud_clear <= 1;
          end
          else begin
          state <= idle;
          end
        end
        start: begin
        baud_clear <= 0; 
          if(tick_16) begin 
            if(rx_tick==7)begin
            if(rx==0)begin 
            rx_tick<=4'b0;
              state <= data;
              end 
              else begin 
              state <= idle;
              rx_tick <= 0;
              end   
            end
            
            else rx_tick<=rx_tick+1;
          end
        end
        
        data: begin 
          if(tick_16)begin
            if(rx_tick==15)begin 
            rx_tick<=0;
              data_reg[bit_count] <= rx;
            
            if(bit_count==7)begin 
            state<=stop;
            end
              
            else bit_count <= bit_count+1;
          end
            else rx_tick <= rx_tick + 1;
        end
        end
        stop: begin 
          if(tick_16)begin 
            if(rx_tick==15) begin 
             rx_tick<=0;
              if(rx==1)  begin 
                state<=idle;
              rx_done<=1;
                 rx_data<=data_reg;
              end
              else error_byte <= 1;
            end
            else rx_tick<=rx_tick+1;
          end
        end
        default:state<=idle;
      endcase
    end
  end
endmodule
