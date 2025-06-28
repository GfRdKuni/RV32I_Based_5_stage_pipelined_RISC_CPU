`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/05 19:59:50
// Design Name: 
// Module Name: time_divider
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


module time_divider(
    input rst_n,
    input clk_in,
    
    output reg clk
    );
    reg [7:0]cnt;
    always @(posedge clk_in or negedge rst_n) begin
        if(!rst_n) cnt <= 8'b0000_0000;
        else if (cnt <= 8'b1111_1111)
        cnt <= cnt + 1;
        else 
        cnt <= 8'b0000_0000; 
    end

    always @(posedge clk_in or negedge rst_n) begin
        if(!rst_n) clk <= 1'b0;
        else if(cnt == 8'b1111_1111) clk <= ~clk;
        else clk <= clk;
    end
endmodule
