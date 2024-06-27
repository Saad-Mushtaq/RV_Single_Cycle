`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AQL Tech Solutions
// Engineer: Saad Mushtaq
// 
// Create Date: 06/10/2024 10:58:22 AM
// Design Name: 
// Module Name: program_counter
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


module program_counter #(parameter PROG_VALUE=1024)(
    input reset,
    input clk,
    input PCsel,
    input [31:0] load,
    output logic [31:0] adress,
    output logic [31:0] adress_jump
    );

assign adress_jump=adress+4;

always_ff@(posedge clk,negedge reset)
begin
if(!reset)
begin
   adress<=0;
end
else if(adress==PROG_VALUE-1)
begin
   adress<=0; 
end
else
begin
    if(PCsel)
    begin
       adress<=load; 
    end
    else
    begin
        adress<=adress+4;
    end
end
end
endmodule