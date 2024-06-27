`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Saad Mushtaq
// 
// Create Date: 06/10/2024 10:58:22 AM
// Design Name: 
// Module Name: control_unit
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

module control_unit(
    input [31:0] instruction,
    input BrEq,
    input BrLt,
    output logic BrUn,
    output logic [2:0] Immsel,
    output logic RegWEn,
    output logic Asel,
    output logic Bsel,
    output logic PCsel,
    output logic MemRW,
    output logic [3:0] ALU_sel,
    output logic [1:0] WBsel
);

logic R_type;
logic I_type;
logic I_type_lw;
logic I_type_jalr;
logic S_type;
logic J_type;
logic B_type;
logic U_type_auipc;
logic U_type_lui;

// identifying type of instruction:

assign R_type=(~instruction[6])&(instruction[5])&(instruction[4])&(~instruction[3])&(~instruction[2]);
assign I_type=(~instruction[6])&(~instruction[5])&(instruction[4])&(~instruction[3])&(~instruction[2]);
assign I_type_lw=(~instruction[6])&(~instruction[5])&(~instruction[4])&(~instruction[3])&(~instruction[2]);
assign I_type_jalr=(instruction[6])&(instruction[5])&(~instruction[4])&(~instruction[3])&(instruction[2]);
assign S_type=(~instruction[6])&(instruction[5])&(~instruction[4])&(~instruction[3])&(~instruction[2]);
assign J_type=(instruction[6])&(instruction[5])&(~instruction[4])&(instruction[3])&(instruction[2]);
assign B_type=(instruction[6])&(instruction[5])&(~instruction[4])&(~instruction[3])&(~instruction[2]);
assign U_type_auipc=(~instruction[6])&(~instruction[5])&(instruction[4])&(~instruction[3])&(instruction[2]);
assign U_type_lui=(~instruction[6])&(instruction[5])&(instruction[4])&(~instruction[3])&(instruction[2]);

//____________________________________

always_comb
begin
    if(B_type)
    begin
        Immsel=3'b000;
        RegWEn=1'b0;
        Asel=1'b1;
        Bsel=1'b1;
        ALU_sel=4'b0000;
        MemRW=1'b0;      // read
        WBsel=2'bxx;
        BrUn=instruction[13]?1:0;
        case({instruction[14],instruction[12]})
        2'b00:begin
            if(BrEq)
                PCsel=1'b1;
            else
                PCsel=1'b0;
        end

        2'b01:begin
            if(!BrEq)
                PCsel=1'b1;
            else
                PCsel=1'b0;
        end

        2'b10:begin
            if(BrLt)
                PCsel=1'b1;
            else
                PCsel=1'b0;
        end

        2'b11:begin
            if(!BrLt)
                PCsel=1'b1;
            else
                PCsel=1'b0;
        end
        endcase
    end

else if(J_type)
begin
    BrUn=1'bx;
    Immsel=3'b100;
    RegWEn=1'b1;
    Asel=1'b1;
    Bsel=1'b1;
    ALU_sel=4'b0000;
    MemRW=1'b0;
    WBsel=2'b10;
    PCsel=1'b1;
end

else if(S_type)
begin
    BrUn=1'bx;
    PCsel=1'b0;
    Immsel=3'b010;
    RegWEn=1'b0;
    Asel=1'b0;
    Bsel=1'b1;
    ALU_sel=4'b0000;
    MemRW=1'b1;
    WBsel=2'bxx;
    // add control for sh and sb     
end

else if (I_type_lw)
begin
    BrUn=1'bx;
    PCsel=1'b0;
    Immsel=3'b001;
    RegWEn=1'b1;
    Asel=1'b0;
    Bsel=1'b1;
    ALU_sel=4'b0000;
    MemRW=1'b0;      // read
    WBsel=2'b00;
end

else if (I_type_jalr)
begin
    BrUn=1'bx;
    PCsel=1'b1;
    Immsel=3'b001;
    RegWEn=1'b1;
    Asel=1'b0;
    Bsel=1'b1;
    ALU_sel=4'b0000;
    MemRW=1'b0;      // read
    WBsel=2'b10;
end

else if (I_type)
begin
    BrUn=1'bx;
    PCsel=1'b0;
    Immsel=3'b001;
    RegWEn=1'b1;
    Asel=1'b0;
    Bsel=1'b1;
    MemRW=1'b0;      // read
    WBsel=2'b01;
    case({instruction[14:12]})
        3'b000:ALU_sel=4'b0000;
        3'b001:ALU_sel=4'b0010;
        3'b010:ALU_sel=4'b0011;
        3'b011:ALU_sel=4'b0100;
        3'b100:ALU_sel=4'b0101;
        3'b101:begin
            if(!instruction[30])
                ALU_sel=4'b0110;
            else
                ALU_sel=4'b0111;
        end
        3'b110:ALU_sel=4'b1000;
        3'b111:ALU_sel=4'b1001;
    endcase
end

else if (R_type)
begin
    BrUn=1'bx;
    PCsel=1'b0;
    Immsel=3'bxxx;
    RegWEn=1'b1;
    Asel=1'b0;
    Bsel=1'b0;
    MemRW=1'b0;      // read
    WBsel=2'b01;
    case({instruction[14:12]})
        3'b000:begin
            if(!instruction[30])
                ALU_sel=4'b0000;
            else
                ALU_sel=4'b0001;
        end
        3'b001:ALU_sel=4'b0010;
        3'b010:ALU_sel=4'b0011;
        3'b011:ALU_sel=4'b0100;
        3'b100:ALU_sel=4'b0101;
        3'b101:begin
            if(!instruction[30])
                ALU_sel=4'b0110;
            else
                ALU_sel=4'b0111;
        end
        3'b110:ALU_sel=4'b1000;
        3'b111:ALU_sel=4'b1001;
    endcase
end

else if(U_type_auipc)
begin
    BrUn=1'bx;
    PCsel=1'b0;
    Immsel=3'b011;
    RegWEn=1'b1;
    Asel=1'b1;
    Bsel=1'b1;
    ALU_sel=4'b0000;
    MemRW=1'b0;      // read
    WBsel=2'b01;
end

else //if(U_type_lui)
begin
    BrUn=1'bx;
    PCsel=1'b0;
    Immsel=3'b011;
    RegWEn=1'b1;
    Asel=1'bx;
    Bsel=1'b1;
    ALU_sel=4'b1010;
    MemRW=1'b0;      // read
    WBsel=2'b01;
end
end
endmodule