`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Saad Mushtaq
// 
// Create Date: 06/18/2024 03:46:23 PM
// Design Name: Single Cycle RV Datapath
// Module Name: data_mem
// Project Name: Single Cycle RISC V implementaiton
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


module data_mem #(parameter DM_WIDTH=32, DM_DEPTH=1024) (
    input [31:0] addr,
    input [31:0] dataW,
    input MemRW,
    input [2:0] funct3,
    input clk,
    output logic [31:0] out_32bits_e
    );

    logic [1:0] byte_sel;
    logic [7:0] out_8bits;
    logic [31:0] out_8bits_e;
    logic [15:0] out_16bits;
    logic [31:0] out_16bits_e;
    logic [31:0] dataR;
    logic [31:0] mem_addr;

    logic [DM_WIDTH-1:0] data_memory [0:DM_DEPTH-1];

    initial
    begin
        $readmemh("test_dm.mem", data_memory);
    end
    assign mem_addr={addr[31:2],2'b00}>>2;
    assign byte_sel=addr[1:0];
    always_comb
    begin
        if(!funct3[1])
        begin
            dataR=data_memory[mem_addr];
        end
        else
            dataR=data_memory[addr>>2];
        case(byte_sel) 
            2'b00:out_8bits=dataR[7:0];
            2'b01:out_8bits=dataR[15:8];
            2'b10:out_8bits=dataR[23:16];
            2'b11:out_8bits=dataR[31:24];
        endcase

        if(byte_sel[1])
        begin
            out_16bits=dataR[31:16];
        end
        else
        begin
            out_16bits=dataR[15:0];
        end
        if(!funct3[2])
        begin
            out_8bits_e={{24{out_8bits[7]}},out_8bits};
            out_16bits_e={{16{out_16bits[15]}},out_16bits};
        end
        else
        begin
            out_8bits_e={{24{1'b0}},out_8bits};
            out_16bits_e={{16{1'b0}},out_16bits};
        end
        
        casex(funct3[1:0])
            2'b00:out_32bits_e=out_8bits_e;
            2'b01:out_32bits_e=out_16bits_e;
            2'b10:out_32bits_e=dataR;
            default:out_32bits_e=dataR;
        endcase
    end

    always_ff@(posedge clk)
    begin
    if(MemRW)
        begin
            casex(funct3[1:0])
            2'b00:begin
                casex(byte_sel)
                    2'b00:data_memory[mem_addr][7:0]<=dataW[7:0];
                    2'b01:data_memory[mem_addr][15:8]<=dataW[7:0];
                    2'b10:data_memory[mem_addr][23:16]<=dataW[7:0];
                    2'b11:data_memory[mem_addr][31:24]<=dataW[7:0];
                endcase
            end
            2'b01:begin
                if(byte_sel[1])
                begin
                    data_memory[mem_addr][31:16]<=dataW[15:0];
                end
                else
                begin
                    data_memory[mem_addr][15:0]<=dataW[15:0];
                end
            end
            2'b10:data_memory[addr>>2]<=dataW;
            endcase
            //data_memory[addr]<=dataW;
        end
    else
        begin
            data_memory[addr>>2]<=data_memory[addr>>2];
        end
    end
endmodule
