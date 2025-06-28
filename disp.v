`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Compssely:
// Engineer:
//
// Create Date: 2023/10/12 23:43:48
// Design Name:
// Module Name: disp
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


module disp(
    input clk,
    input in_out,
    input _rst,
    input [31:0] Q0,
    input [31:0] Q1,
    input [31:0] Q2,
    input [31:0] Q3,
    input [3:0] dp_pos,  //0111,1011,1101,1110
    output reg [3:0] ssel, //digit select
    output reg [6:0] sseg, //number select
    output reg dp
    );
    
    localparam M = 20; //use lower * bits of register regM to divide freq (100MHZ/2^18)
    reg [M-1:0] regM;
    
    always @(posedge clk) begin
        if (!_rst) regM <= 0;
        else regM <= regM + 1;
    end

    wire [31:0] Qleft;
    wire [31:0] Qright;
    wire [3:0] Qleft_ten;
    wire [3:0] Qleft_one;
    wire [3:0] Qright_ten;
    wire [3:0] Qright_one;

    assign Qleft = in_out ? Q3 : Q0;   //in_out = 0, display input numbers
    assign Qright = in_out ? Q2 : Q1;

    bdtrans transleft(.in(Qleft),
            .in_ten(Qleft_ten),
            .in_one(Qleft_one));
    bdtrans transright(.in(Qright),
            .in_ten(Qright_ten),
            .in_one(Qright_one));        


    reg [31:0] Q_in;
    always @ * begin
        case({regM[M-1],regM[M-2]}) //display in turn
            2'b00:begin
                dp <= in_out ? 1'b1 : dp_pos[0];
                ssel <= 4'b1110; //choose the first digital displayer
                Q_in <= Qright_one; //display Q_in, which is Q1 here
            end
            2'b01:begin
                dp <= in_out ? 1'b1 : dp_pos[1];
                ssel <= 4'b1101; //choose the second digital displayer
                Q_in <= Qright_ten;
            end
            2'b10:begin
                dp <= in_out ? 1'b1 : dp_pos[2];
                ssel <= 4'b1011; //choose the third digital displayer
                Q_in <= Qleft_one;
            end
            2'b11:begin
                dp <= in_out ? 1'b1 : dp_pos[3];
                ssel <= 4'b0111; //choose the fourth digital displayer
                Q_in <= Qleft_ten;
            end
        endcase
    end

    always @ * begin
        case(Q_in)
            4'h0: sseg[6:0] = 7'b0000001; //common anode
            4'h1: sseg[6:0] = 7'b1001111;
            4'h2: sseg[6:0] = 7'b0010010;
            4'h3: sseg[6:0] = 7'b0000110;
            4'h4: sseg[6:0] = 7'b1001100;
            4'h5: sseg[6:0] = 7'b0100100;
            4'h6: sseg[6:0] = 7'b0100000;
            4'h7: sseg[6:0] = 7'b0001111;
            4'h8: sseg[6:0] = 7'b0000000;
            4'h9: sseg[6:0] = 7'b0000100;
            4'ha: sseg[6:0] = 7'b0001000;
            4'hb: sseg[6:0] = 7'b1100000;
            4'hc: sseg[6:0] = 7'b0110001;
            4'hd: sseg[6:0] = 7'b1000010;
            4'he: sseg[6:0] = 7'b0110000;
            4'hf: sseg[6:0] = 7'b0111000;
            default: sseg[6:0] = 7'b0111000; //F
        endcase
    end
endmodule
