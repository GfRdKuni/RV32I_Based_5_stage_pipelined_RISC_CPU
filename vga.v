`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/06 18:08:03
// Design Name: 
// Module Name: vga
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


module vga(
    input clk,
    input rst_n,
    input [31:0] chickenout,
    input [31:0] rabbitout,
    input output_display,
    output hsync,
    output vsync,
    output [11:0] rgb_display
    );
    wire vga_clk;
    wire clock_en;
    wire picture_active;
    wire data_read_active;
    wire picture_over;
    wire [3:0]rdata, gdata, bdata;
    wire [9:0]h_addr,v_addr;


    clk_wiz_0 clk_inst(
        .clk_out1(vga_clk),
        .locked(clock_en),
        .clk_in1(clk)
    );

    colorpart COLORPART(
        .vga_clk(vga_clk),
        .output_display(output_display),
        .rabbitout(rabbitout),
        .chickenout(chickenout),
        .rst_n(rst_n),
        .data_read_active(data_read_active),
        .picture_active(picture_active),
        .h_addr(h_addr),
        .v_addr(v_addr),
        .rdata(rdata),
        .gdata(gdata),
        .bdata(bdata)
    );

    VGA_ctr vgactr(
        .vga_clk_i(vga_clk),
        .rst_i(~rst_n),
        .rdata(rdata),
        .gdata(gdata),
        .bdata(bdata),
        .rgb_display_o(rgb_display),
        .hsync_o(hsync),
        .vsync_o(vsync),
        .data_read_active(data_read_active),
        .picture_active(picture_active),
        .picture_over(picture_over),
        .h_addr(h_addr),
        .v_addr(v_addr)
    );
endmodule

