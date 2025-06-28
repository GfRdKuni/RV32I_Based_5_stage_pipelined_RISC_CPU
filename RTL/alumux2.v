`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/12 20:39:48
// Design Name: 
// Module Name: alumux2
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


module alumux2(
    input [31:0]imm,
    input [31:0]read2,
    input ALUSrc,

    output [31:0]alu_in2 
    );
    
    assign alu_in2 = (ALUSrc) ? imm : read2; 
endmodule
