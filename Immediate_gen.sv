`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2024 10:58:22 AM
// Design Name: 
// Module Name: Instruction_memory
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

module Immediate_gen(
    //input [11:0]imm,
    input [31:0] instruction,
    output logic [31:0] out_imm
);

//assign out_imm={{20{imm[11]}},imm};

always_comb
begin
    case (instruction[6:0])
        7'b0010011, 7'b0000011, 7'b1100111: out_imm = {{20{instruction[31]}}, instruction[31:20]}; // I-type
        7'b0100011: out_imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S-type
        7'b0010111, 7'b0110111: out_imm = {instruction[31:12], 12'b0}; // U-type
        7'b1101111: out_imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J-type
        7'b1100011: out_imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B-type
        default: out_imm = 32'bx;
    endcase
end    
endmodule