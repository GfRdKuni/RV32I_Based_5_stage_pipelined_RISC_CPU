`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/06 11:10:58
// Design Name: 
// Module Name: PC
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


module PC(
    clk,
	rst_n,
	pc_new,
	pc_out
    );
    input clk;
	input rst_n;
	input [31:0]pc_new;
	output reg [31:0]pc_out;
    
    always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			pc_out <= 0;
		else
			pc_out <= pc_new + 4;
	end	
endmodule
