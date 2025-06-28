`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/04 21:37:37
// Design Name: 
// Module Name: readmux
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


module readmux(
    input [31:0]read1_EX,
    input [31:0]read2_EX,
    input stall_EN1_EX,
    input stall_EN2_EX,
    input [31:0]dataout_MEM,

    output [31:0]read1_EX_pro,
    output [31:0]read2_EX_pro
    );

    assign read1_EX_pro = stall_EN1_EX ? dataout_MEM : read1_EX;
    assign read2_EX_pro = stall_EN2_EX ? dataout_MEM : read2_EX;
endmodule
