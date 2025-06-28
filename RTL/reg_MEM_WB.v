`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 10:20:05
// Design Name: 
// Module Name: reg_MEM_WB
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


module reg_MEM_WB(
    input clk, 
    input rst_n,

    
    input [31:0]aluout_MEM,
    input [31:0]dataout_MEM,
    input RegWrite_MEM,
    input [4:0]rd_MEM,
    input MemtoReg_MEM,
    input [31:0]imm_MEM,
    input lui_MEM,

    output reg  [31:0]aluout_WB,
    output reg  [31:0]dataout_WB,
    output reg  RegWrite_WB,
    output reg  [4:0]rd_WB,
    output reg  MemtoReg_WB,
    output reg  [31:0]imm_WB,
    output reg  lui_WB
    );


    parameter zero = 32'b00000000_00000000_00000000_00000000;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            rd_WB <= 5'b00000;
            RegWrite_WB <= 1'b0;
            dataout_WB <= zero;
            aluout_WB <= zero;
            MemtoReg_WB <= 1'b0;
            lui_WB <= 1'b0;
            imm_WB <= zero;
            //control signal here

        end

        else begin
            rd_WB <= rd_MEM;
            RegWrite_WB <= RegWrite_MEM;
            dataout_WB <= dataout_MEM;
            aluout_WB <= aluout_MEM;
            MemtoReg_WB <= MemtoReg_MEM;
            lui_WB <= lui_MEM;
            imm_WB <= imm_MEM;
            //control signal here

        end
    end
endmodule
