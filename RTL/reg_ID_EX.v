`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 10:18:47
// Design Name: 
// Module Name: reg_ID_EX
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


module reg_ID_EX(
    input clk,
    input rst_n,

    
    input [31:0]imm_ID,
    input [4:0]rd_ID,
    input [31:0]PC_ID,
    input [31:0]read1_ID,
    input [31:0]read2_ID,
    input   MemRead_ID,
	input   MemtoReg_ID,
	input   MemWrite_ID,
	input   ALUSrc_ID,
	input   RegWrite_ID,
	input   lui_ID,
	input   U_type_ID,
	input   jal_ID,
	input   jalr_ID,
	input   beq_ID,
	input   bne_ID,
	input   blt_ID,
	input   bge_ID,
	input   bltu_ID,
	input   bgeu_ID,
	input   B_type_ID,
	input   [2:0]RW_type_ID,
	input   [3:0]ALUctl_ID,
	input   B_JUMP,
	input   stall_EN1_ID,
	input   stall_EN2_ID,
	input   auipc_ID,




    output reg   MemRead_EX,
	output reg   MemtoReg_EX,
	output reg   MemWrite_EX,
	output reg   ALUSrc_EX,
	output reg   RegWrite_EX,
	output reg   lui_EX,
	output reg   U_type_EX,
	output reg   jal_EX,
	output reg   jalr_EX,
	output reg   beq_EX,
	output reg   bne_EX,
	output reg   blt_EX,
	output reg   bge_EX,
	output reg   bltu_EX,
	output reg   bgeu_EX,
	output reg   B_type_EX,
	output reg   [2:0]RW_type_EX,
	output reg   [3:0]ALUctl_EX,
    output reg   [31:0]imm_EX,
    output reg   [4:0]rd_EX,
    output reg   [31:0]PC_EX,
    output reg   [31:0]read1_EX,
    output reg   [31:0]read2_EX,
	output reg   stall_EN1_EX,
	output reg   stall_EN2_EX,
	output reg   auipc_EX
    );
    parameter zero = 32'b00000000_00000000_00000000_00000000;
	wire RST;


    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            imm_EX <= zero;        // 立即数，在EX阶段就可以使用完毕
            rd_EX <= 5'b00000;     // 目标寄存器的地址,需要一直传到WB阶段
            PC_EX <= zero;         // 本条指令的PC，在EX阶段就可以使用完毕
            read1_EX <= zero;      // 从寄存器rs1中取得的操作数，在EX中一定会使用完毕
            read2_EX <= zero;      // 从寄存器rs2中取得的操作数，有可能会传到MEM阶段
            MemRead_EX <= 1'b0;    // 要传到MEM阶段使用
	        MemtoReg_EX <= 1'b0;   // 要传到WB阶段使用
	        MemWrite_EX <= 1'b0;   // 要传到MEM阶段使用
	        ALUSrc_EX <= 1'b0;     // ALU输入数据的选择信号（选择rs2和imm）
	        RegWrite_EX <= 1'b0;   // 要传到WB阶段使用
	        lui_EX <= 1'b0;        // 貌似用不上，后面会删掉
	        U_type_EX <= 1'b0;     // 貌似也用不上
	        jal_EX <= 1'b0;        // 产生offset的控制信号；alu的控制信号，alu的数据选择信号
	        jalr_EX <= 1'b0;       // offset新地址产生的数据选择；产生offset的跳转信号；alu的控制信号，alu的数据选择信号
	        beq_EX <= 1'b0;          
	        bne_EX <= 1'b0;
	        blt_EX <= 1'b0;
            bge_EX <= 1'b0;
	        bltu_EX <= 1'b0;
	        bgeu_EX <= 1'b0;       // 输出给alu用来产生比较结果，在EX阶段就会用完
	        B_type_EX <= 1'b0;     // 产生offset的跳转信号，在EX阶段就可以用完
	        RW_type_EX <= 3'b000;  // 实际是func3，用在MEM阶段
            ALUctl_EX <= 4'b0000;  // 输出给alu用的控制信号，用在EX阶段
			stall_EN1_EX <= 1'b0;
			stall_EN2_EX <= 1'b0;
			auipc_EX <= 1'b0;
        end

        else if(B_JUMP)begin
            imm_EX <= zero;        // 立即数，在EX阶段就可以使用完毕
            rd_EX <= 5'b00000;     // 目标寄存器的地址,需要一直传到WB阶段
            PC_EX <= zero;         // 本条指令的PC，在EX阶段就可以使用完毕
            read1_EX <= zero;      // 从寄存器rs1中取得的操作数，在EX中一定会使用完毕
            read2_EX <= zero;      // 从寄存器rs2中取得的操作数，有可能会传到MEM阶段
            MemRead_EX <= 1'b0;    // 要传到MEM阶段使用
	        MemtoReg_EX <= 1'b0;   // 要传到WB阶段使用
	        MemWrite_EX <= 1'b0;   // 要传到MEM阶段使用
	        ALUSrc_EX <= 1'b0;     // ALU输入数据的选择信号（选择rs2和imm）
	        RegWrite_EX <= 1'b0;   // 要传到WB阶段使用
	        lui_EX <= 1'b0;        // 貌似用不上，后面会删掉
	        U_type_EX <= 1'b0;     // 貌似也用不上
	        jal_EX <= 1'b0;        // 产生offset的控制信号；alu的控制信号，alu的数据选择信号
	        jalr_EX <= 1'b0;       // offset新地址产生的数据选择；产生offset的跳转信号；alu的控制信号，alu的数据选择信号
	        beq_EX <= 1'b0;          
	        bne_EX <= 1'b0;
	        blt_EX <= 1'b0;
            bge_EX <= 1'b0;
	        bltu_EX <= 1'b0;
	        bgeu_EX <= 1'b0;       // 输出给alu用来产生比较结果，在EX阶段就会用完
	        B_type_EX <= 1'b0;     // 产生offset的跳转信号，在EX阶段就可以用完
	        RW_type_EX <= 3'b000;  // 实际是func3，用在MEM阶段
            ALUctl_EX <= 4'b0000;  // 输出给alu用的控制信号，用在EX阶段
			stall_EN1_EX <= 1'b0;
			stall_EN2_EX <= 1'b0;
			auipc_EX <= 1'b0;
        end

        else 
		begin
            imm_EX <= imm_ID;
            rd_EX <= rd_ID;
            PC_EX <= PC_ID;
            read1_EX <= read1_ID;
            read2_EX <= read2_ID;
            MemRead_EX <= MemRead_ID;
	        MemtoReg_EX <= MemRead_ID;
	        MemWrite_EX <= MemWrite_ID;
	        ALUSrc_EX <= ALUSrc_ID;
	        RegWrite_EX <= RegWrite_ID;
	        lui_EX <= lui_ID;
	        U_type_EX <= U_type_ID;
	        jal_EX <= jal_ID;
	        jalr_EX <= jalr_ID;
	        beq_EX <= beq_ID;
	        bne_EX <= bne_ID;
	        blt_EX <= blt_ID;
            bge_EX <= bge_ID;
	        bltu_EX <= bltu_ID;
	        bgeu_EX <= bgeu_ID;
	        B_type_EX <= B_type_ID;
	        RW_type_EX <= RW_type_ID;
            ALUctl_EX <= ALUctl_ID;
			stall_EN1_EX <= stall_EN1_ID;
			stall_EN2_EX <= stall_EN2_ID;
			auipc_EX <= auipc_ID;
        end

    end



endmodule
