`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/12 20:42:17
// Design Name: 
// Module Name: offsetmux
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


module offsetmux(
    input jalr,
    input jal,
    input B_JUMP,
    input [31:0]imm_ID,
    input [31:0]imm_EX,
    input [31:0]read1,

    output [31:0]offset
    );

    assign offset = B_JUMP ? imm_EX : (jalr ? read1 : imm_ID);
endmodule
