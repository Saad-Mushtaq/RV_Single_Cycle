`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2024 10:55:26 AM
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input reset
    );

    logic [31:0] im_adress;
    logic [31:0] instruction;
    // logic [4:0] rs1=instruction[19:15];
    // logic [4:0] rs2=instruction[24:20];
    // logic [4:0] rsW=instruction[11:7];
    // logic [11:0] imm=instruction[31:20];
    logic [31:0] data1;
    logic [31:0] data2;
    logic [31:0] ALU_out;
    logic [31:0] dataW;
    logic [31:0] out_imm;
    logic [31:0] ALU_in2;
    logic [31:0] ALU_in1;
    logic [31:0] dataR;
    logic [31:0] adress_jump;

    logic [3:0] ALU_sel;
    logic [2:0] Immsel;
    logic Bsel;
    logic Asel;
    logic RegWEn;
    logic MemRW;
    logic [1:0] WBsel;
    logic PCsel;

    logic BrEq;
    logic BrLt;
    logic BrUn;

    assign ALU_in1=(Asel)?im_adress:data1;
    assign ALU_in2=(Bsel)?out_imm:data2; // for selection between immediate and data2 of reg_file
    //assign dataW=(WBsel)?ALU_out:dataR;
    WBselmux mux_1(.WBsel(WBsel),.ALU_out(ALU_out),.dataR(dataR),.adress_jump(adress_jump),.datawrf(dataW));
    
    control_unit CU1 (.instruction(instruction),.Immsel(Immsel),.RegWEn(RegWEn),.Asel(Asel),.Bsel(Bsel),.PCsel(PCsel),.MemRW(MemRW),.ALU_sel(ALU_sel),.WBsel(WBsel),.BrUn(BrUn),.BrEq(BrEq),.BrLt(BrLt));
    branch_comparator branch (.A(data1),.B(data2),.BrUn(BrUn),.BrEq(BrEq),.BrLt(BrLt));
    program_counter #(1024) PC (.reset(reset),.clk(clk),.adress(im_adress),.PCsel(PCsel),.load(ALU_out),.adress_jump(adress_jump));
    Instruction_memory #(64) IMEM (.addr(im_adress),.instr(instruction));
    reg_file #(32,32) reg_f(.clk(clk),.rs1(instruction[19:15]),.rs2(instruction[24:20]),.rsW(instruction[11:7]),.dataW(dataW),.RegWEn(RegWEn),.data1(data1),.data2(data2));
    ALU #(32) ALU_U (.srcA(ALU_in1),.srcB(ALU_in2),.op_code(ALU_sel),.out(ALU_out));
    Immediate_gen immediate (.instruction(instruction),.out_imm(out_imm));
    data_mem #(32,1024) DMEM (.clk(clk),.addr(ALU_out),.dataW(data2),.MemRW(MemRW),.out_32bits_e(dataR),.funct3(instruction[14:12]));

endmodule
