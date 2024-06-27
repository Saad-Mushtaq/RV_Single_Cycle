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


module Instruction_memory #(parameter IMEM_DEPTH=64)(
    input [31:0] addr,
    output logic [31:0] instr
);

logic [31:0] instr_mem [0:IMEM_DEPTH-1];
logic [31:0] pc_addr;

initial
begin
     $readmemh("test_im.mem", instr_mem);
end

always_comb
begin
    pc_addr=addr>>2;
    instr=instr_mem[pc_addr];
end
endmodule