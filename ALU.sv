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

module ALU #(parameter ALU_WIDTH=32)(
    input [ALU_WIDTH-1:0] srcA,
    input [ALU_WIDTH-1:0] srcB,
    input [3:0] op_code,
    output logic [ALU_WIDTH-1:0] out
    );

always_comb
    begin
        casex(op_code)
            4'b0000:out=srcA+srcB;
            4'b0001:out=srcA-srcB;
            4'b0010:out=srcA<<srcB[4:0];
            4'b0011:out=(srcA<srcB)?1:0;    // for set less than
            4'b0100:out=($signed(srcA)<$signed(srcB))?1:0;    // set less than unsigned
            4'b0101:out=srcA^srcB;
            4'b0110:out=srcA>>srcB[4:0];
            4'b0111:out=$signed(srcA)>>>srcB[4:0];
            4'b1000:out=srcA | srcB;
            4'b1001:out=srcA & srcB;
            4'b1010:out=srcB;
            default:out=32'bx;   
        endcase    
    end
endmodule