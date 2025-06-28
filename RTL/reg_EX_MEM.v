`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 10:19:42
// Design Name: 
// Module Name: reg_EX_MEM
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


module reg_EX_MEM(
    input clk,
    input rst_n,
    
    input [31:0]aluout_EX,
    input RegWrite_EX,
    input [4:0]rd_EX,
    input MemRead_EX,
    input MemWrite_EX,
    input MemtoReg_EX,
    input [2:0]RW_type_EX,
    input [31:0]read2_EX,
    input [31:0]imm_EX,
    input lui_EX,


    output reg  [31:0]aluout_MEM,
    output reg  RegWrite_MEM,
    output reg  [4:0]rd_MEM,
    output reg  MemRead_MEM,
    output reg  MemWrite_MEM,
    output reg  [31:0]read2_MEM,
    output reg  [2:0]RW_type_MEM,
    output reg  MemtoReg_MEM,
    output reg  [31:0]imm_MEM,
    output reg  lui_MEM

    );
    parameter zero = 32'b00000000_00000000_00000000_00000000;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            rd_MEM <= 5'b00000;
            RegWrite_MEM <= 1'b0;
            MemRead_MEM <= 1'b0;
            MemWrite_MEM <= 1'b0;
            aluout_MEM <= zero;
            read2_MEM <= zero;
            RW_type_MEM <= 3'b000;
            MemtoReg_MEM <= 1'b0;
            lui_MEM <= 1'b0;
            imm_MEM <= zero;
            //control signal here

        end

        else begin
            rd_MEM <= rd_EX;
            RegWrite_MEM <= RegWrite_EX;
            MemRead_MEM <= MemRead_EX;
            MemWrite_MEM <= MemWrite_EX;
            aluout_MEM <= aluout_EX;
            read2_MEM <= read2_EX;
            RW_type_MEM <= RW_type_EX;
            MemtoReg_MEM <= MemtoReg_EX;
            lui_MEM <= lui_EX;
            imm_MEM <= imm_EX;
            //control signal here

        end
    end



endmodule
