`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2024 10:58:22 AM
// Design Name: 
// Module Name: reg_file
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


module reg_file#(parameter REGF_WIDTH=32, DEPTH=32)(
    input clk,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rsW,
    input [REGF_WIDTH-1:0] dataW,
    input RegWEn,
    output logic [REGF_WIDTH-1:0]data1,
    output logic [REGF_WIDTH-1:0]data2
    );

    logic [REGF_WIDTH-1:0] register_file [0:DEPTH-1];
    
    initial
    begin
    $readmemb("test_rf.mem", register_file);    
    end
    
    always_comb
    begin
        data1= (rs1==0)? 0: register_file[rs1];
        data2= (rs2==0)? 0: register_file[rs2];
    end

    always_ff @(posedge clk)
    begin
        if(RegWEn)
            register_file[rsW]<=dataW;
        else
            register_file[rsW]<=register_file[rsW];
    end
endmodule