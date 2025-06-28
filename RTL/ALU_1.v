`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/12/06 12:00:19
// Design Name:
// Module Name: ALU
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


module ALU(ALU_DA,
           ALU_DB,
           ALU_CTL,
           beq,       //beq指令标志，判断是否跳转的控制信号
	       bne,       //bne指令标志，判断是否跳转的控制信号
	       blt,       //blt指令标志，判断是否跳转的控制信号
	       bge,       //bge指令标志，判断是否跳转的控制信号
	       bltu,      //blyu指令标志，判断是否跳转的控制信号
	       bgeu,      //bgeu指令标志，判断是否跳转的控制信号
           jal,
           jalr,
           B_JUMP,
           ALU_OverFlow,
           ALU_DC);
    input [31:0] ALU_DA;
    input [31:0] ALU_DB;
    input [3:0]  ALU_CTL;
    input beq;       
	input bne;       
	input blt;       
	input bge;       
	input bltu;      
	input bgeu;    
    input jal;    //U型指令标志 进行rs1+4操作
    input jalr;
    output B_JUMP; //ALU_ZERO
    output ALU_OverFlow;
    output reg [31:0] ALU_DC;
    
    //********************generate ctr***********************
    wire SUBctr;
    wire SIGctr;
    wire Ovctr;
    wire ALU_ZERO;
    wire [1:0] Opctr;
    wire [1:0] Logicctr;
    wire [1:0] Shiftctr;
    
    assign SUBctr   = (~ALU_CTL[3] & ~ALU_CTL[2] & ALU_CTL[1]) | (ALU_CTL[3]  & ~ALU_CTL[2]); //001d | 10dd
    assign Opctr    = ALU_CTL[3:2];
    assign Ovctr    = ALU_CTL[0] & ~ ALU_CTL[3]  & ~ALU_CTL[2] ;
    assign SIGctr   = ALU_CTL[0];
    assign Logicctr = ALU_CTL[1:0];
    assign Shiftctr = ALU_CTL[1:0];
    
    //********************************************************
    //*********************logic op***************************
    reg [31:0] logic_result;
    
    always@(*) begin
        case(Logicctr)
            2'b00:logic_result = ALU_DA & ALU_DB;
            2'b01:logic_result = ALU_DA | ALU_DB;
            2'b10:logic_result = ALU_DA ^ ALU_DB;
            2'b11:logic_result = ~(ALU_DA | ALU_DB);
        endcase
    end
    
    //********************************************************
    //************************shift op************************
    wire [4:0]     ALU_SHIFT;
    wire [31:0] shift_result;
    assign ALU_SHIFT = ALU_DB[4:0];
    
    Shifter Shifter1(.ALU_DA(ALU_DA),
    .ALU_SHIFT(ALU_SHIFT),
    .Shiftctr(Shiftctr),
    .shift_result(shift_result));
    
    //********************************************************
    //************************add sub plus4 op**********************
    wire [31:0] BIT_M,XOR_M;
    wire ADD_carry,ADD_OverFlow;
    wire [31:0] ADD_result;
    
    assign BIT_M = {32{SUBctr}};
    assign XOR_M = (jal|jalr) ? 32'd4 : (BIT_M ^ ALU_DB);  ///jal jalr时取4，SUB COMP UCOMP时取反码
    
    Adder Adder1(.A(ALU_DA),
    .B(XOR_M),
    .Cin(SUBctr),
    .ALU_CTL(ALU_CTL),
    .ADD_carry(ADD_carry),
    .ADD_OverFlow(ADD_OverFlow),
    .ADD_zero(ALU_ZERO),
    .ADD_result(ADD_result));
    
    assign ALU_OverFlow = ADD_OverFlow & Ovctr;
    
    //********************************************************
    //**************************slt op************************
    wire [31:0] SLT_result;
    wire LESS_M1,LESS_M2,LESS_S,SLT_M;
    
    assign LESS_M1    = ADD_carry ^ SUBctr;  //无符号
    assign LESS_M2    = ADD_OverFlow ^ ADD_result[31];  //有符号
    assign LESS_S     = (SIGctr == 1'b1) ? LESS_M1 && ~ALU_ZERO : LESS_M2 && ~ALU_ZERO;  // ——————小于为1？——————
    assign SLT_result = (LESS_S) ? 32'h00000001 : 32'h00000000;

    //********************************************************
    //**************************B_type op*********************
    assign B_JUMP = beq ? ALU_ZERO : 
                    bne ? !ALU_ZERO : 
                    (blt | bltu) ? LESS_S :
                    (bge | bgeu) ? !LESS_S : 0; 

    
    //********************************************************
    //**************************ALU result********************
    always @(*)
    begin
        case({jal|jalr , Opctr })
            3'b000:ALU_DC <= ADD_result;
            3'b001:ALU_DC <= logic_result;
            3'b010:ALU_DC <= SLT_result;
            3'b011:ALU_DC <= shift_result;
            3'b100:ALU_DC <= ADD_result;
            3'b101:ALU_DC <= ADD_result;
            3'b110:ALU_DC <= ADD_result;
            3'b111:ALU_DC <= ADD_result;
        endcase
    end
    
    //********************************************************
endmodule
    
    
    //********************************************************
    //*************************shifter************************
    module Shifter(input [31:0] ALU_DA,
    input [4:0] ALU_SHIFT,
    input [1:0] Shiftctr,
    output reg [31:0] shift_result);
    
    
    wire [5:0] shift_n;
    assign shift_n = 6'd32 - Shiftctr;
    always@(*) begin
        case(Shiftctr)
            2'b00:shift_result   = ALU_DA << ALU_SHIFT;
            2'b01:shift_result   = ALU_DA >> ALU_SHIFT;
            2'b10:shift_result   = ({32{ALU_DA[31]}} << shift_n) | (ALU_DA >> ALU_SHIFT);
            default:shift_result = ALU_DA;
        endcase
    end
    
    
    endmodule
    
    //*************************************************************
    //***********************************adder*********************
    module Adder(input [31:0] A,
    input [31:0] B,
    input Cin,
    input [3:0] ALU_CTL,
    output ADD_carry,
    output ADD_OverFlow,
    output ADD_zero,        //1 means result is 0
    output [31:0] ADD_result);
    
    
    cla_adder32 m1(A,B,Cin,ADD_result,ADD_carry);
    assign ADD_zero = ~(|ADD_result);
    assign ADD_OverFlow = ((ALU_CTL == 4'b0001) & ~A[31] & ~B[31] & ADD_result[31])
    | ((ALU_CTL == 4'b0001) & A[31] & B[31] & ~ADD_result[31])
    | ((ALU_CTL == 4'b0011) & A[31] & ~B[31] & ~ADD_result[31])
    | ((ALU_CTL == 4'b0011) & ~A[31] & B[31] & ADD_result[31]);
    endmodule
    
    //4位CLA部件
    module cla_4(p,g,c_in,c,gx,px);
        input[3:0] p,g;
        input c_in;
        output[4:1] c;
        output gx,px;
        
        assign c[1] = p[0]&c_in | g[0];
        assign c[2] = p[1]&p[0]&c_in | p[1]&g[0] | g[1];
        assign c[3] = p[2]&p[1]&p[0]&c_in | p[2]&p[1]&g[0] | p[2]&g[1] | g[2];
        assign c[4] = gx | px&c_in;
        
        assign px = p[3]&p[2]&p[1]&p[0];
        assign gx = g[3] | p[3]&g[2] | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&g[0];
        
    endmodule
        
        //32位全加器
        module cla_adder32(A,B,cin,result,cout);
            
            input [31:0] A;
            input [31:0] B;
            input cin;
            output[31:0] result;
            output cout;
            
            //进位产生信号，进位传递信号
            wire[31:0] TAG,TAP;
            wire[32:1] TAC;
            wire[15:0] TAG_0,TAP_0;
            wire[3:0] TAG_1,TAP_1;
            wire[8:1] TAC_1;
            wire[4:1] TAC_2;
            
            assign result = A ^ B ^ {TAC[31:1],cin};
            
            //进位产生信号，进位传递信号
            assign TAG = A&B;
            assign TAP = A|B;
            
            cla_4 cla_0_0(.p(TAP[3:0]),  .g(TAG[3:0]),  .c_in(cin), .c(TAC[4:1]),  .gx(TAG_0[0]),.px(TAP_0[0]));
            cla_4 cla_0_1(.p(TAP[7:4]),  .g(TAG[7:4]),  .c_in(TAC_1[1]),.c(TAC[8:5]),  .gx(TAG_0[1]),.px(TAP_0[1]));
            cla_4 cla_0_2(.p(TAP[11:8]), .g(TAG[11:8]), .c_in(TAC_1[2]),.c(TAC[12:9]), .gx(TAG_0[2]),.px(TAP_0[2]));
            cla_4 cla_0_3(.p(TAP[15:12]),.g(TAG[15:12]),.c_in(TAC_1[3]),.c(TAC[16:13]),.gx(TAG_0[3]),.px(TAP_0[3]));
            cla_4 cla_0_4(.p(TAP[19:16]),.g(TAG[19:16]),.c_in(TAC_1[4]),.c(TAC[20:17]),.gx(TAG_0[4]),.px(TAP_0[4]));
            cla_4 cla_0_5(.p(TAP[23:20]),.g(TAG[23:20]),.c_in(TAC_1[5]),.c(TAC[24:21]),.gx(TAG_0[5]),.px(TAP_0[5]));
            cla_4 cla_0_6(.p(TAP[27:24]),.g(TAG[27:24]),.c_in(TAC_1[6]),.c(TAC[28:25]),.gx(TAG_0[6]),.px(TAP_0[6]));
            cla_4 cla_0_7(.p(TAP[31:28]),.g(TAG[31:28]),.c_in(TAC_1[7]),.c(TAC[32:29]),.gx(TAG_0[7]),.px(TAP_0[7]));
            
            
            cla_4 cla_1_0(.p(TAP_0[3:0]),  .g(TAG_0[3:0]),  .c_in(cin),.c(TAC_1[4:1]),  .gx(TAG_1[0]),.px(TAP_1[0]));
            cla_4 cla_1_1(.p(TAP_0[7:4]),  .g(TAG_0[7:4]),  .c_in(TAC_1[4]),.c(TAC_1[8:5]),  .gx(TAG_1[1]),.px(TAP_1[1]));
            
            assign TAG_1[3:2] = 2'b00;
            assign TAP_1[3:2] = 2'b00;
            
            cla_4 cla_2_0(.p(TAP_1[3:0]),   .g(TAG_1[3:0]),    .c_in(1'b0), .c(TAC_2[4:1]),  .gx(),.px());
            
            assign cout = TAC_2[2];
            
        endmodule
