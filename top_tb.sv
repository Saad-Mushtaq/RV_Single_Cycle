`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2024 10:44:38 PM
// Design Name: 
// Module Name: top_tb
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


 module top_tb;

    logic clk;
    logic reset;

    top DUT (.clk(clk),.reset(reset));
    integer i=0;
    integer j=0;
    initial
    begin
        clk=1'b1;
        forever #20 clk=~clk;    
    end

    initial
    begin
        reset=1'b0;
        #40
        reset=1'b1;
        #1500
        $stop;
    end

//    initial begin
//        reset=1'b1;
//        #1000
//        $finish;
//    end
endmodule
