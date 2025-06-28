`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/06 11:27:30
// Design Name: 
// Module Name: cpudecoder
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


module cpudecoder(
    input [31:0]inst,
    output reg[31:0]imm,
    output reg[4:0]rs1,
    output reg[4:0]rs2,
    output reg[4:0]rd,
    output reg[2:0]func3,
    output reg[6:0]func7,
    output [6:0]opcode
    );
    parameter B_type = 7'b1100011,
              LUI    = 7'b0110111,
              AUIPC  = 7'b0010111,
              JAL    = 7'b1101111,
              JALR   = 7'b1100111,
              L_type = 7'b0000011,
              S_type = 7'b0100011,
              I_type = 7'b0010011,
              R_type = 7'b0110011;
    wire RS1_en, RS2_en;
    wire func3_en;
    /***************************************************
    Inst 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7  6 5 4 3 2 1 0
         31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12              0 1 1 0 1 1 1/0 0 1 0 1 1 1                                                                       
         20 10 9  8  7  6  5  4  3  2  1  11 19 18 17 16 15 15 14 13 12           1 1 0 1 1 1 1
         11 10 9  8  7  6  5  4  3  2  1  0                                       1 1 0 0 1 1 1
         12 10 9  8  7  6  5                                         4  3  2 1 11 1 1 0 0 0 1 1
         11 10 9  8  7  6  5  4  3  2  1  0                                       0 0 0 0 0 1 1
         11 10 9  8  7  6  5                                         4  3  2 1 0  0 1 0 0 0 1 1   
         11 10 9  8  7  6  5  4  3  2  1  0                                       0 0 1 0 0 1 1   

    Imm  31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0     
    Inst 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 0  0  0  0  0  0  0  0  0  0  0  0 
    Inst 31 31 31 31 31 31 31 31 31 31 31 31 19 18 17 16 15 14 13 12 20 30 29 28 27 26 25 24 23 22 21 0
    Inst 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 30 29 28 27 26 25 24 23 22 21 20
    Inst 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 7  30 29 28 27 26 25 11 10 9  8  0
    Inst 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 30 29 28 27 26 25 24 23 22 21 20
    Inst 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 30 29 28 27 26 25 24 23 22 21 20
    Inst 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 30 29 28 27 26 25 11 10 9  8  7
    Inst 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 31 30 29 28 27 26 25 24 23 22 21 20 
    ***************************************************/




    assign opcode = inst[6:0];


    //Imm的获取
    always @(*) begin
        case(opcode)
        // LUI
        LUI: imm = {inst[31:12], 12'b00000000_0000};  
        // AUIPC
        AUIPC: imm = {inst[31:12], 12'b00000000_0000};
        // JAL
        JAL: imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21],1'b0};
        // JALR
        JALR: imm = {{20{inst[31]}}, inst[31:20]};
        // B-type
        B_type: imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
        // L-type
        L_type: imm = {{20{inst[31]}}, inst[31:20]};
        // I-type
        I_type: imm = {{20{inst[31]}}, inst[31:20]};
        // S-type
        S_type: imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
        default imm = 32'b00000000_00000000_00000000_00000000;
        endcase
    end


    //rs1的获取
    always @(*) begin
        if (RS1_en)
            rs1 = inst[19:15];
        else
            rs1 = 5'b00000;        
    end

    //rs2的获取
    always @(*) begin
        if (RS2_en)
            rs2 = inst[24:20];
        else
            rs2 = 5'b00000;
    end

    //rd的获取
    always @(*) begin
        if(opcode == B_type || opcode == S_type)
            rd = 5'b00000;
        else
            rd = inst[11:7];
    end


    //func3的获取
    always @(*) begin
        if(func3_en)
            func3 = inst[14:12];
        else
            func3 = 3'b000;
    end


    //func7的获取
    always @(*)begin
        if(opcode == R_type||opcode == I_type && func3[1:0] == 2'b01)
            func7 = inst[31:25];
        else func7 = 7'b0000000;
    end


    assign RS1_en = (opcode == JALR) || (opcode == B_type) || (opcode == L_type) || (opcode == S_type) || (opcode == I_type) || (opcode == R_type);
    assign RS2_en = (opcode == B_type) || (opcode == S_type) || (opcode == R_type);
    assign func3_en = RS1_en;
endmodule
