`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/06 11:07:40
// Design Name: 
// Module Name: colorpart
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


module colorpart(
    input vga_clk,
    input output_display,
    input rst_n,
    input data_read_active,
    input [31:0]rabbitout,
    input [31:0]chickenout,
    input picture_active,
    input [9:0]h_addr,
    input [9:0]v_addr,
    output [3:0]rdata,
    output [3:0]gdata,
    output [3:0]bdata
    );
    wire [3:0]outputrdata, outputgdata, outputbdata;
    
    assign rdata = (!rst_n | !output_display) ? 4'b0000 : outputrdata;
    assign gdata = (!rst_n | !output_display) ? 4'b0000 : outputgdata;
    assign bdata = (!rst_n | !output_display) ? 4'b0000 : outputbdata;

    outputpicture OPTP(
        .vga_clk(vga_clk),
        .rst_n(rst_n),
        .data_read_active(data_read_active),
        .picture_active(picture_active),
        .h_addr(h_addr),
        .v_addr(v_addr),
        .outputrdata(outputrdata),
        .outputgdata(outputgdata),
        .outputbdata(outputbdata),
        .rabbitout(rabbitout),
        .chickenout(chickenout)
    );

endmodule
