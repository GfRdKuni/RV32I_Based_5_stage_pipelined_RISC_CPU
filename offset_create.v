`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/06 11:34:03
// Design Name: 
// Module Name: offset_create
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


module offset_create(
    pc_old,
    pc_ID,
    pc_EX,
    offset,
    jal_ID,
    jalr_ID,
    B_JUMP_EX,
    pc_new
    );

    input [31:0]pc_ID;
    input [31:0]pc_EX;
    input [31:0]pc_old;
    input [31:0]offset;
    input jal_ID;
    input jalr_ID;
    input B_JUMP_EX;
    output reg [31:0]pc_new;
    
    always@(*)begin
      if(jal_ID|jalr_ID) pc_new <= pc_ID + offset;
      else if(B_JUMP_EX) pc_new <= pc_EX + offset;
      else pc_new <= pc_old;
    end

    //assign control_pc = jal_ID|jalr_ID|B_JUMP_EX;


    
endmodule
