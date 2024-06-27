`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2024 09:41:40 AM
// Design Name: 
// Module Name: WBselmux
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


module WBselmux(
    input [1:0] WBsel,
    input [31:0] ALU_out, // data from ALU
    input [31:0] dataR,   // data from data memory
    input [31:0] adress_jump,
    output logic [31:0] datawrf
    );

    always_comb
    begin
        casex (WBsel)
            2'b00:datawrf=dataR;
            2'b01:datawrf=ALU_out;
            2'b10:datawrf=adress_jump;
            default:datawrf=32'bX;
        endcase
    end
endmodule
