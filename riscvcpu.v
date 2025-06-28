`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/05 18:25:26
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk_in,
    input wire rst_n,
    input up,
    input down,
    input left,
    input right,
    input output_display,//1：output 0: input 
    output wire [3:0]led_sel, 
    output wire [7:0]led_ctr,
    output wire [11:0]rgb_display,
    output wire hsync,
    output wire vsync
    );
    wire clk;
    wire [31:0]rabbitout, chickenout;
    wire [31:0]legsin, headin;
    wire [3:0]dotpos;

    time_divider TD(
        .rst_n(rst_n),
        .clk_in(clk_in),
        .clk(clk)
    );


    INPUT_module INPUTMODULE(
        .clk(clk),
        .rst_n(rst_n),
        .output_display(output_display),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .legsin(legsin),
        .headin(headin),
        .dotpos_pro(dotpos)
    );

    cpu_core RISCVCPU(
        .clk(clk),
        .rst_n(rst_n),
        .rabbitout(rabbitout),
        .chickenout(chickenout),
        .headin(headin),
        .legsin(legsin)
    );

    disp LEDPART(
        .clk(clk_in),
        .in_out(output_display),
        ._rst(rst_n),
        .Q0(legsin),
        .Q1(headin),
        .Q2(rabbitout),
        .Q3(chickenout),
        .dp_pos(dotpos),
        .ssel(led_sel),
        .sseg(led_ctr[6:0]),
        .dp(led_ctr[7])
    );

    VGAoutput OUTMODULE(
        .clk(clk_in),
        .rst_n(rst_n),
        .chickenout(chickenout),
        .rabbitout(rabbitout),
        .output_display(output_display),
        .rgb_display(rgb_display),
        .hsync(hsync),
        .vsync(vsync)
    );
endmodule
