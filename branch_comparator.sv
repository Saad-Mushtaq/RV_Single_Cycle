`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2024 09:44:48 PM
// Design Name: 
// Module Name: branch_comparator
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


module branch_comparator(
    input [31:0] A,
    input [31:0] B,
    input BrUn,
    output logic BrEq,
    output logic BrLt
    );

    always_comb
    begin
        BrEq=(A==B);
        if (BrUn)
        begin
            BrLt = (A < B); // Unsigned comparison
        end
        else
        begin
            BrLt = ($signed(A) < $signed(B)); // Signed comparison
        end    
    end
endmodule
