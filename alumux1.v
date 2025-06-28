`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/12 20:39:06
// Design Name: 
// Module Name: alumux1
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


module alumux1(
    input [31:0]read1,
    input [31:0]PC,
    input jal,
    input jalr,
    input auipc,

    output [31:0]alu_in1 
    );

    assign alu_in1 = (jal|jalr|auipc) ? PC : read1;
endmodule
