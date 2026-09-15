`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2026 22:36:43
// Design Name: 
// Module Name: UART_TB
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


module UART_TB(

    );
    reg clk,reset,tx_start;
    reg [7:0] tx_data;
    wire tx_done,rx_done;
    wire [7:0] rx_data;
    wire error_byte;
    top_module dut(.clk(clk),.reset(reset),.tx_data(tx_data),.tx_start(tx_start),
                   .tx_done(tx_done),.rx_data(rx_data),.rx_done(rx_done),.error_byte(error_byte));
                   
    initial clk=0;
    
    always #10 clk = ~clk;    // 50mhz clock
    
    initial begin
    reset=1; tx_start=0;
    
    #40 reset=0; 
    #40 tx_data=8'b01101000;
    #40 tx_start=1;
    #40 tx_start=0;
    #90000 tx_data=8'b11111111;
    #40 tx_start=1;
    #40 tx_start=0;
    

    end              
    
endmodule
