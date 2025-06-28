`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 10:18:23
// Design Name: 
// Module Name: reg_IF_ID
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


module reg_IF_ID(
    input clk,
    input rst_n,
    
    input [31:0]inst_IF,
    input [31:0]PC_IF,

    output reg[31:0]inst_ID,
    output reg[31:0]PC_ID
    );

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) begin
            inst_ID <= 32'b00000000_00000000_00000000_00000000;
            PC_ID <= 32'b00000000_00000000_00000000_00000000;
        end
        else begin
            inst_ID <= inst_IF;
            PC_ID <= PC_IF;
        end
    end
endmodule
