`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/29 08:34:48
// Design Name: 
// Module Name: addrmux
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


module addrmux(
    input jal_ID,
    input jalr_ID,
    input B_JUMP_EX,
    input [31:0]pc_out_IF,
    input [31:0]pc_new_IF,

    output [31:0]pc_now
    );
    wire addr_ctr;
    assign addr_ctr = jal_ID|jalr_ID|B_JUMP_EX;
    assign pc_now = addr_ctr ? pc_new_IF : pc_out_IF; 

endmodule
