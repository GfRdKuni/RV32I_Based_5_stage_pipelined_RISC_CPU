`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/05 14:23:16
// Design Name: 
// Module Name: INPUT_module
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


module INPUT_module(
    input clk,
    input rst_n,
    input up,
    input down,
    input left,
    input right,
    input output_display,
    output reg[31:0]legsin,
    output reg[31:0]headin,
    output [3:0]dotpos_pro
    );
    reg up_pro, down_pro, left_pro, right_pro;
    reg rst_up, rst_down, rst_left, rst_right; 
    reg [3:0]dotpos;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) up_pro <= 1'b0;
        else if(up_pro == 1 || rst_up == 1) up_pro <= 1'b0;
        else up_pro <= up;
    end
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n) rst_up <= 1'b0;
        else if(up == 1) rst_up <= 1'b1;
        else rst_up <= 1'b0;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) down_pro <= 1'b0;
        else if(down_pro == 1 || rst_down == 1) down_pro <= 1'b0;
        else down_pro <= down;
    end
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n) rst_down <= 1'b0;
        else if(down == 1) rst_down <= 1'b1;
        else rst_down <= 1'b0;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) left_pro <= 1'b0;
        else if(left_pro == 1 || rst_left == 1) left_pro <= 1'b0;
        else left_pro <= left;
    end
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n) rst_left <= 1'b0;
        else if(left == 1) rst_left <= 1'b1;
        else rst_left <= 1'b0;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) right_pro <= 1'b0;
        else if(right_pro == 1 || rst_right == 1) right_pro <= 1'b0;
        else right_pro <= right;
    end
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n) rst_right <= 1'b0;
        else if(right == 1) rst_right <= 1'b1;
        else rst_right <= 1'b0;
    end
    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n) down_pro <= 1'b0;
    //     else if(down_pro == 1) down_pro <= 1'b0;
    //     else down_pro <= down;
    // end

    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n) left_pro <= 1'b0;
    //     else if(left_pro == 1) left_pro <= 1'b0;
    //     else left_pro <= left;
    // end

    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n) right_pro <= 1'b0;
    //     else if(right_pro == 1) right_pro <= 1'b0;
    //     else right_pro <= right;
    // end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) dotpos <= 4'b1000;
        else if(right_pro && dotpos != 4'b0001) dotpos <= dotpos >> 1;
        else if(left_pro && dotpos != 4'b1000) dotpos <= dotpos << 1; 
        else dotpos <= dotpos;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) legsin <= 32'b00000000_00000000_00000000_00000000;
        else if(up_pro)begin
            if(dotpos == 4'b1000 && legsin <= 32'd89 && ~output_display) legsin <= legsin + 32'h0000_000a;
            else if(dotpos == 4'b0100 && legsin <= 32'd96 && ~output_display) legsin <= legsin + 32'h0000_0002;
            else legsin <= legsin;
        end
        else if(down_pro)begin
            if(dotpos == 4'b1000 && legsin >= 32'd10 && ~output_display) legsin <= legsin - 32'h0000_000a;
            else if(dotpos == 4'b0100 && legsin >= 32'd2 && ~output_display) legsin <= legsin - 32'h0000_0002;
            else legsin <= legsin;
        end
        else legsin <= legsin;
    end

    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) headin <= 32'b00000000_00000000_00000000_00000000;
        else if(up_pro)begin
            if(dotpos == 4'b0010 && headin <= 32'd89 && ~output_display) headin <= headin + 32'h0000_000a;
            else if(dotpos == 4'b0001 && headin <= 32'd98 && ~output_display) headin <= headin + 32'h0000_0001;
            else headin <= headin;
        end
        else if(down_pro)begin
            if(dotpos == 4'b0010 && headin >= 32'd10 && ~output_display) headin <= headin - 32'h0000_000a;
            else if(dotpos == 4'b0001 && headin >= 32'd1 && ~output_display) headin <= headin - 32'h0000_0001;
            else headin <= headin;
        end
        else headin <= headin;
    end

    assign dotpos_pro = ~dotpos;
endmodule
