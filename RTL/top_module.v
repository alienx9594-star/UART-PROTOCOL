`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2026 17:11:47
// Design Name: 
// Module Name: top_module
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


module top_module(  input wire clk,
                    input reset,
                    input wire [7:0] tx_data,
                    input wire tx_start,
                    output wire tx_done,
                    output wire [7:0] rx_data,
                    output wire rx_done,
                    output wire error_byte
                   
    );
    wire connector;
    wire baud_clear_rx, baud_clear_tx;
    wire tick_tx, tick_rx;
    wire tick_16_tx, tick_16_rx;
    
    
    UART_BAUD_RATE #(.clk_freq(50000000), 
                        .baud_rate(115200) )
                      tx1 (.clk(clk),.reset(reset),.tick(tick_tx),.tick_16(tick_16_tx),.counter(),
                       .counter_16(),.baud_clear(baud_clear_tx) );
                      
    UART_BAUD_RATE #(.clk_freq(50000000), 
                        .baud_rate(115200) )
                      rx1 (.clk(clk),.reset(reset),.tick(tick_rx),.tick_16(tick_16_rx),.counter(),
                       .counter_16(),.baud_clear(baud_clear_rx) ); 
                      
    UART_TX u1(.clk(clk),.reset(reset),.tx_data(tx_data),.tick(tick_tx),.tx_start(tx_start),
               .baud_clear(baud_clear_tx),.tx(connector),.tx_done(tx_done)     );
               
    UART_RX u2(.clk(clk),.reset(reset),.rx_in1(connector),.tick_16(tick_16_rx),
               .baud_clear(baud_clear_rx),.rx_data(rx_data),.rx_done(rx_done),.error_byte(error_byte));          
               
                                                 
endmodule
