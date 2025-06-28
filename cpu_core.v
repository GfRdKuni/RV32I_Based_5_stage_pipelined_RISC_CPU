`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/12 21:01:35
// Design Name: 
// Module Name: cpu_core
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


module cpu_core(
    input wire clk,
    input wire rst_n,
    input [31:0]legsin,
    input [31:0]headin,
    output wire [31:0]rabbitout,
    output wire [31:0]chickenout
    );

    wire [31:0]pc_new_IF;
    wire [31:0]pc_out_IF,pc_out_ID, pc_out_EX;
    wire [31:0]inst_IF, inst_ID;
    wire [31:0]imm_ID, imm_EX, imm_MEM, imm_WB;
    wire [4:0]rs1_ID;
    wire [4:0]rs2_ID;
    wire [4:0]rd_ID,rd_EX,rd_MEM,rd_WB;
    wire [2:0]func3_ID;
    wire [6:0]func7_ID;
    wire [6:0]opcode_ID; 
    wire RegWrite_ID,RegWrite_WB,RegWrite_EX,RegWrite_MEM;
    wire [31:0]aluout_EX, aluout_MEM, aluout_WB;
    wire [31:0]dataout_MEM, dataout_WB;
    wire MemtoReg_ID, MemtoReg_EX, MemtoReg_MEM, MemtoReg_WB; 
    wire [31:0]read1_ID, read1_EX, read1_EX_pro;
    wire [31:0]read2_ID, read2_EX, read2_EX_pro, read2_MEM;
    wire MemRead_ID, MemRead_EX, MemRead_MEM;
    wire MemWrite_ID, MemWrite_EX, MemWrite_MEM;
    wire ALUSrc_ID, ALUSrc_EX;
    wire lui_ID, lui_EX, lui_MEM, lui_WB;
    wire U_type_ID, U_type_EX;
    wire jal_ID, jal_EX;
    wire jalr_ID, jalr_EX;
    wire beq_ID, beq_EX;
    wire bne_ID, bne_EX;
    wire blt_ID, blt_EX;
    wire bge_ID, bge_EX;
    wire bltu_ID, bltu_EX;
    wire bgeu_ID, bgeu_EX;
    wire B_type_ID, B_type_EX;
    wire [2:0]RW_type_ID, RW_type_EX, RW_type_MEM;
    wire [3:0]ALUctl_ID, ALUctl_EX;
    wire [31:0]offset;
    wire [31:0]aluin1, aluin2;
    wire B_JUMP_EX;
    wire ALU_Overflow;
    wire [31:0]pc_fetching_now;
    wire [5:0]forward_EN1,forward_EN2;
    wire stall_EN1_ID, stall_EN1_EX;
    wire stall_EN2_ID, stall_EN2_EX;
    wire auipc_ID, auipc_EX;












 



    /***********************************IF****************************/
    PC PCREG(
        .clk(clk),
        .rst_n(rst_n),
        .pc_new(pc_fetching_now),
        .pc_out(pc_out_IF) 
    );
    
    addrmux inst_addr_mux(
        .pc_new_IF(pc_new_IF),
        .pc_out_IF(pc_out_IF),
        .jal_ID(jal_ID),
        .jalr_ID(jalr_ID),
        .B_JUMP_EX(B_JUMP_EX),
        .pc_now(pc_fetching_now)
    );
    
    instr_memory INSMEM(
        .rst_n(rst_n),
        .addr(pc_fetching_now[9:2]),
        .instr(inst_IF)
    );


    /*********************************IF/ID***************************/
    reg_IF_ID rFD(
        .clk(clk),
        .rst_n(rst_n),
        
        .inst_ID(inst_ID),
        .inst_IF(inst_IF),

        .PC_ID(pc_out_ID),
        .PC_IF(pc_fetching_now)
    );



    /*********************************ID*****************************/
    cpudecoder DECODER(
        .inst(inst_ID),
        .imm(imm_ID),
        .rs1(rs1_ID),
        .rs2(rs2_ID),
        .rd(rd_ID),
        .func3(func3_ID),
        .func7(func7_ID),
        .opcode(opcode_ID)
    );

    cpuregfile REGFILE(
        .clk(clk),
        .rs1(rs1_ID),
        .rs2(rs2_ID),
        .rd(rd_WB),
        .reg_we(RegWrite_WB),
        .aluout(aluout_WB),
        .dataout(dataout_WB),
        .imm_EX(imm_EX),
        .imm_MEM(imm_MEM),
        .aluout_EX(aluout_EX),
        .aluout_MEM(aluout_MEM),
        .dataout_MEM(dataout_MEM),
        .MemtoReg(MemtoReg_WB),
        .imm_WB(imm_WB),
        .lui_WB(lui_WB),
        .read1(read1_ID),
        .read2(read2_ID),
        .forward_EN1(forward_EN1),
        .forward_EN2(forward_EN2)
    );

    CU CU_main(
        .opcode(opcode_ID),
        .func3(func3_ID),
        .func7(func7_ID),
        .MemRead(MemRead_ID),
        .MemWrite(MemWrite_ID),
        .MemtoReg(MemtoReg_ID),
        .RegWrite(RegWrite_ID),
        .ALUSrc(ALUSrc_ID),
        .lui(lui_ID),
        .U_type(U_type_ID),
        .jal(jal_ID),
        .jalr(jalr_ID),
        .beq(beq_ID),
        .bne(bne_ID),
        .blt(blt_ID),
        .bge(bge_ID),
        .bltu(bltu_ID),
        .bgeu(bgeu_ID),
        .B_type(B_type_ID),
        .RW_type(RW_type_ID),
        .ALUctl(ALUctl_ID),
        .auipc(auipc_ID)
    );



    offsetmux OFFSETMUX(
        .jalr(jalr_ID),
        .jal(jal_ID),
        .B_JUMP(B_JUMP_EX),
        .imm_ID(imm_ID),
        .imm_EX(imm_EX),
        .read1(read1_ID),
        .offset(offset)
    );


    offset_create OFFSETCREATE(
        .pc_old(pc_out_IF),
        .pc_ID(pc_out_ID),
        .pc_EX(pc_out_EX),
        .pc_new(pc_new_IF),
        .offset(offset),
        .jal_ID(jal_ID),
        .jalr_ID(jalr_ID),
        .B_JUMP_EX(B_JUMP_EX)
    );

    inst_past INSP(
        .clk(clk),
        .rst_n(rst_n),
        .B_JUMP(B_JUMP_EX),
        .now_inst(inst_ID),
        .rs1_now(rs1_ID),
        .rs2_now(rs2_ID),
        .forward_EN1(forward_EN1),
        .forward_EN2(forward_EN2),
        .stall_EN1(stall_EN1_ID),
        .stall_EN2(stall_EN2_ID)
    );

    /******************************ID/EX***********************/
    reg_ID_EX rIE(
        .clk(clk),
        .rst_n(rst_n),

        .imm_ID(imm_ID),
        .rd_ID(rd_ID),
        .PC_ID(pc_out_ID),
        .read1_ID(read1_ID),
        .read2_ID(read2_ID),
        .MemRead_ID(MemRead_ID),
        .MemtoReg_ID(MemtoReg_ID),
        .MemWrite_ID(MemWrite_ID),
        .ALUSrc_ID(ALUSrc_ID),
        .RegWrite_ID(RegWrite_ID),
        .lui_ID(lui_ID),
        .U_type_ID(U_type_ID),
        .jal_ID(jal_ID),
        .jalr_ID(jalr_ID),
        .beq_ID(beq_ID),
        .bne_ID(bne_ID),
        .blt_ID(blt_ID),
        .bge_ID(bge_ID),
        .bltu_ID(bltu_ID),
        .bgeu_ID(bgeu_ID),
        .B_type_ID(B_type_ID),
        .RW_type_ID(RW_type_ID),
        .ALUctl_ID(ALUctl_ID),
        .B_JUMP(B_JUMP_EX),
        .stall_EN1_ID(stall_EN1_ID),
        .stall_EN2_ID(stall_EN2_ID),
        .auipc_ID(auipc_ID),

        .imm_EX(imm_EX),
        .rd_EX(rd_EX),
        .PC_EX(pc_out_EX),
        .read1_EX(read1_EX),
        .read2_EX(read2_EX),
        .MemRead_EX(MemRead_EX),
        .MemtoReg_EX(MemtoReg_EX),
        .MemWrite_EX(MemWrite_EX),
        .ALUSrc_EX(ALUSrc_EX),
        .RegWrite_EX(RegWrite_EX),
        .lui_EX(lui_EX),
        .U_type_EX(U_type_EX),
        .jal_EX(jal_EX),
        .jalr_EX(jalr_EX),
        .beq_EX(beq_EX),
        .bne_EX(bne_EX),
        .blt_EX(blt_EX),
        .bge_EX(bge_EX),
        .bltu_EX(bltu_EX),
        .bgeu_EX(bgeu_EX),
        .B_type_EX(B_type_EX),
        .RW_type_EX(RW_type_EX),
        .ALUctl_EX(ALUctl_EX),
        .stall_EN1_EX(stall_EN1_EX),
        .stall_EN2_EX(stall_EN2_EX),
        .auipc_EX(auipc_EX)
    ); 
    /************************************EX***********************/
    readmux READMUX1(
        .read1_EX(read1_EX),
        .read2_EX(read2_EX),
        .read1_EX_pro(read1_EX_pro),
        .read2_EX_pro(read2_EX_pro),
        .stall_EN1_EX(stall_EN1_EX),
        .stall_EN2_EX(stall_EN2_EX),
        .dataout_MEM(dataout_MEM)
    );



    
    alumux1 ALUMUX1(
        .read1(read1_EX_pro),
        .PC(pc_out_EX),
        .jal(jal_EX),
        .jalr(jalr_EX),
        .auipc(auipc_EX),
        .alu_in1(aluin1)
    );

    alumux2 ALUMUX2(
        .imm(imm_EX),
        .read2(read2_EX_pro),
        .ALUSrc(ALUSrc_EX),
        .alu_in2(aluin2)
    );

    ALU ALUALU(
        .ALU_DA(aluin1),
        .ALU_DB(aluin2),
        .ALU_CTL(ALUctl_EX),
        .beq(beq_EX),
        .bne(bne_EX),
        .blt(blt_EX),
        .bge(bge_EX),
        .bltu(bltu_EX),
        .bgeu(bgeu_EX),
        .jal(jal_EX),
        .jalr(jalr_EX),
        .B_JUMP(B_JUMP_EX),
        .ALU_OverFlow(ALU_OverFlow),
        .ALU_DC(aluout_EX)
    );


    /**********************************EX/MEM**********************/
    reg_EX_MEM rEM(
        .clk(clk),
        .rst_n(rst_n),

        .aluout_EX(aluout_EX),
        .RegWrite_EX(RegWrite_EX),
        .rd_EX(rd_EX),
        .MemRead_EX(MemRead_EX),
        .MemWrite_EX(MemWrite_EX),
        .MemtoReg_EX(MemtoReg_EX),
        .RW_type_EX(RW_type_EX),
        .read2_EX(read2_EX_pro),
        .lui_EX(lui_EX),
        .imm_EX(imm_EX),

        .aluout_MEM(aluout_MEM),
        .RegWrite_MEM(RegWrite_MEM),
        .rd_MEM(rd_MEM),
        .MemRead_MEM(MemRead_MEM),
        .MemWrite_MEM(MemWrite_MEM),
        .MemtoReg_MEM(MemtoReg_MEM),
        .RW_type_MEM(RW_type_MEM),
        .read2_MEM(read2_MEM),
        .lui_MEM(lui_MEM),
        .imm_MEM(imm_MEM)
    );

    /**********************************MEM*************************/
    DATAMEM DATAMEMORY(
        .clk(clk),
        .data_i(read2_MEM),
        .wr_en(MemWrite_MEM),
        .rd_en(MemRead_MEM),
        .addr(aluout_MEM),
        .RW_type(RW_type_MEM),
        .data_out(dataout_MEM),
        .rabbitout(rabbitout),
        .chickenout(chickenout),
        .legsin(legsin),
        .headin(headin)
    );

    /**********************************MEM/WB*********************/
    reg_MEM_WB rMW(
        .clk(clk),
        .rst_n(rst_n), 
        .aluout_MEM(aluout_MEM),
        .dataout_MEM(dataout_MEM),
        .RegWrite_MEM(RegWrite_MEM),
        .rd_MEM(rd_MEM),
        .MemtoReg_MEM(MemtoReg_MEM),
        .lui_MEM(lui_MEM),
        .imm_MEM(imm_MEM),

        .aluout_WB(aluout_WB),
        .dataout_WB(dataout_WB),
        .RegWrite_WB(RegWrite_WB),
        .rd_WB(rd_WB),
        .MemtoReg_WB(MemtoReg_WB),
        .lui_WB(lui_WB),
        .imm_WB(imm_WB)
    );



endmodule
