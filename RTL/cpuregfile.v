`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/06 11:28:06
// Design Name: 
// Module Name: cpuregfile
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


module cpuregfile(

    input clk,
    input [4:0]rs1,
    input [4:0]rs2,      // Read Addr
    input [4:0]rd,       // Write Addr
    input reg_we,        // Read Enable
    input [31:0]aluout,  // Data from ALU
    input [31:0]dataout, // Data from data_ram
    input [31:0]imm_WB,
    input [31:0]imm_EX,
    input [31:0]imm_MEM,
    input [31:0]aluout_EX,
    input [31:0]aluout_MEM,
    input [31:0]dataout_MEM,
    

    input MemtoReg,      //Control Signal
    input lui_WB,
    input [5:0]forward_EN1,
    input [5:0]forward_EN2,

    output reg[31:0]read1,//Read1 Message
    output reg[31:0]read2 //Read2 Message

    );

    reg [31:0]regfile [31:0];
    reg [31:0]data_in;
    wire[31:0]w_now_reg;
    reg [31:0]read1_true, read2_true;



    always @(negedge clk) begin
        if(reg_we && rd != 5'b00000)
            regfile[rd] = data_in;
        else if(rd == 5'b00000)
            regfile[rd] = 32'b00000000_00000000_00000000_000000000;
        else
            regfile[rd] = w_now_reg; 
    end

    always @(*) begin
        if(rs1 != 5'b00000)
            read1 = read1_true;
            //read1 = regfile[rs1];
        else
            read1 = 32'b00000000_00000000_000000000_00000000;
    end    

    always @(*) begin
        if(rs2 != 5'b00000)
            read2 = read2_true;
            //read2 = regfile[rs2];
        else
            read2 = 32'b00000000_00000000_000000000_00000000;
    end 

    always@(*)begin
        if(lui_WB) data_in = imm_WB;
        else if(MemtoReg) data_in = dataout;
        else data_in = aluout;
    end

    always@(*)begin
        if(forward_EN1 == 6'b100000) read1_true = imm_EX;
        else if(forward_EN1 == 6'b010000) read1_true = imm_MEM;
        else if(forward_EN1 == 6'b001000) read1_true = aluout_EX;
        else if(forward_EN1 == 6'b000100) read1_true = aluout_MEM;
        else if(forward_EN1 == 6'b000010 || forward_EN1 == 6'b000001) read1_true = dataout_MEM;
        else read1_true = regfile[rs1];
    end

    always@(*)begin
        if(forward_EN2 == 7'b100000) read2_true = imm_EX;
        else if(forward_EN2 == 7'b010000) read2_true = imm_MEM;
        else if(forward_EN2 == 7'b001000) read2_true = aluout_EX;
        else if(forward_EN2 == 7'b000100) read2_true = aluout_MEM;
        else if(forward_EN2 == 7'b000010 || forward_EN2 == 7'b000001) read2_true = dataout_MEM;
        else read2_true = regfile[rs2];
    end


    assign w_now_reg = regfile[rd];
// The period and addr for the module is isolated, so no conflicts will happen.





endmodule
