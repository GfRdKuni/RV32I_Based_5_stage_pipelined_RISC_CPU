`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/06 11:18:24
// Design Name: 
// Module Name: main_control
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

module CU(
	opcode,    //7位操作码
	func3,
	func7,
	MemRead,   //数据存储器读使能
	MemWrite,  //数据存储器写使能
	MemtoReg,  //写回寄存器的数据选择器控制信号
	RegWrite,  //寄存器的写使能信号
	ALUSrc,    //ALU的数据来源的数据选择器控制信号（选择立即数或寄存器数据）
	lui,       //lui指令标志，写回寄存器的数据选择器的控制信号
	U_type,    //U型指令标志，写回寄存器的数据选择器的控制信号
	jal,       //jal指令标志，选择pc的数据选择器的控制信号，写回寄存器的数据选择器的控制信号
	jalr,      //jalr指令标志，选择pc的数据选择器的控制信号，写回寄存器的数据选择器的控制信号
	beq,       //beq指令标志，判断是否跳转的控制信号
	bne,       //bne指令标志，判断是否跳转的控制信号
	blt,       //blt指令标志，判断是否跳转的控制信号
	bge,       //bge指令标志，判断是否跳转的控制信号
	bltu,      //blyu指令标志，判断是否跳转的控制信号
	bgeu,      //bgeu指令标志，判断是否跳转的控制信号
	B_type,    //B型指令标志，offset产生的控制信号
	RW_type,   //数据存储器的读（写）类型（字节、半字、字、双字）
	ALUctl,     //ALU控制信号 
	auipc
	);
	input [6:0]opcode;
	input [2:0]func3;
	input [6:0]func7;

	output   MemRead;
	output   MemtoReg;
	output   MemWrite;
	output   ALUSrc;
	output   RegWrite;
	output   lui;
	output   U_type;
	output   jal;
	output   jalr;
	output   beq;
	output   bne;
	output   blt;
	output   bge;
	output   bltu;
	output   bgeu;
	output   B_type;
	output   [2:0]RW_type;
	output   [3:0]ALUctl;
	output   auipc;

	wire [1:0] ALUop;

	main_control MC(
		.opcode(opcode),
		.func3(func3),
		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.MemtoReg(MemtoReg),
		.RegWrite(RegWrite),
		.ALUop(ALUop),
		.ALUSrc(ALUSrc),
		.lui(lui),
		.U_type(U_type),
		.jal(jal),
		.jalr(jalr),
		.beq(beq),
		.bne(bne),
		.blt(blt),
		.bge(bge),
		.bltu(bltu),
		.bgeu(bgeu),
		.B_type(B_type),
		.RW_type(RW_type),
		.auipc(auipc)
	);

	alu_control AC(
		.ALUop(ALUop),
		.func3(func3),
		.func7(func7),
		.ALUctl(ALUctl)
	);
endmodule

module main_control(
	opcode,    //7位操作码
	func3,
	MemRead,   //数据存储器读使能
	MemWrite,  //数据存储器写使能
	MemtoReg,  //写回寄存器的数据选择器控制信号
	RegWrite,  //寄存器的写使能信号
	ALUop,     //子控制器的控制信号 
	ALUSrc,    //ALU的数据来源的数据选择器控制信号（选择立即数或寄存器数据）
	lui,       //lui指令标志，写回寄存器的数据选择器的控制信号
	U_type,    //U型指令标志，写回寄存器的数据选择器的控制信号
	jal,       //jal指令标志，选择pc的数据选择器的控制信号，写回寄存器的数据选择器的控制信号
	jalr,      //jalr指令标志，选择pc的数据选择器的控制信号，写回寄存器的数据选择器的控制信号
	beq,       //beq指令标志，判断是否跳转的控制信号
	bne,       //bne指令标志，判断是否跳转的控制信号
	blt,       //blt指令标志，判断是否跳转的控制信号
	bge,       //bge指令标志，判断是否跳转的控制信号
	bltu,      //blyu指令标志，判断是否跳转的控制信号
	bgeu,      //bgeu指令标志，判断是否跳转的控制信号
	B_type,	   //B型指令标志，offset产生的控制信号
	RW_type,    //数据存储器的读（写）类型（字节、半字、字、双字）
	auipc
    );
	input [6:0]opcode;
	input [2:0]func3;
	
	output   MemRead;
	output   MemtoReg;
	output reg [1:0]ALUop;
	output   MemWrite;
	output   ALUSrc;
	output   RegWrite;
	output   lui;
	output   U_type;
	output   jal;
	output   jalr;
	output   beq;
	output   bne;
	output   blt;
	output   bge;
	output   bltu;
	output   bgeu;
	output   B_type;
	output   [2:0]RW_type;
	output   auipc;
	
    wire load, store, jal, jalr, I_type, R_type; //,U_type B_type; 

    assign load = (opcode == 7'b0000011) ? 1 : 0; //LB LH LW LBU LHU
    assign store = (opcode == 7'b0100011) ? 1 : 0; //SB SH SW
    assign jal = (opcode == 7'b1101111) ? 1 : 0; //jal
    assign jalr = (opcode == 7'b1100111) ? 1 : 0; //jalr
    assign U_type = ((opcode == 7'b0110111) | (opcode == 7'b0010111)) ? 1 : 0; //LUI AUIPC
	assign auipc = (opcode == 7'b0010111) ? 1 : 0;
    assign B_type = (opcode == 7'b1100011) ? 1 : 0; //BEQ BNE BLT BGE BLTU BGEW
    assign I_type = (opcode == 7'b0010011) ? 1 : 0; //ADDI SLTI SLTIU XORI ORI ANDI SLLI SRLI SRAI 
    assign R_type = (opcode == 7'b0110011) ? 1 : 0; //ADD  SLT  SLTU  XOR  OR  AND  SLL  SRL  SRA  SUB

    assign MemRead = load;
    assign MemtoReg = load; //从数据存储器中读数据时

	always @(*) begin 
		if(R_type) ALUop = 2'b10;                        //R:10
		else if(I_type) ALUop = 2'b01;                   //I:01
		else if(B_type) ALUop = 2'b11;                   //B:11
		else  ALUop = 2'b00;  //auipc | store | load | jal |jalr :00
	end

    assign MemWrite = store;  //SB SH SW
    assign ALUSrc = load | store | jalr | I_type | auipc ; //1表示给立即数
    assign RegWrite = U_type | jal | jalr | load | I_type | R_type;
    assign lui = (opcode == 7'b0110111) ? 1 : 0;
    assign beq= B_type & (func3==3'b000);
	assign bne= B_type & (func3==3'b001);
	assign blt= B_type & (func3==3'b100);
	assign bge= B_type & (func3==3'b101);
	assign bltu = B_type & (func3==3'b110);
	assign bgeu = B_type & (func3==3'b111);
    assign RW_type = func3;

	// wire branch;
	// wire R_type;
	// wire I_type;
	// wire load;
	// wire store;
	// wire lui;
	// wire auipc;

	
	// assign branch=(opcode==`B_type)?1'b1:1'b0;
	// assign R_type=(opcode==`R_type)?1'b1:1'b0;
	// assign I_type=(opcode==`I_type)?1'b1:1'b0;
	// assign U_type=(lui | auipc)? 1'b1:1'b0;
	// assign load=(opcode==`load)?1'b1:1'b0;
	// assign store=(opcode==`store)?1'b1:1'b0;
	
	// assign jal=(opcode==`jal)?1'b1:1'b0;
	// assign jalr=(opcode==`jalr)?1'b1:1'b0;
	// assign lui=(opcode==`lui)?1'b1:1'b0;
	// assign auipc=(opcode==`auipc)?1'b1:1'b0;
	// assign beq= branch & (func3==3'b000);
	// assign bne= branch & (func3==3'b001);
	// assign blt= branch & (func3==3'b100);
	// assign bge= branch & (func3==3'b101);
	// assign bltu= branch & (func3==3'b110);
	// assign bgeu= branch & (func3==3'b111);
	// assign RW_type=func3;
	
	
	// //enable
	// assign MemRead= load;
	// assign MemWrite= store;
	// assign RegWrite= jal| jalr | load | I_type |R_type | U_type;
	
	// //MUX
	// assign ALUSrc=load | store |I_type | jalr;  //select imme
	// assign MemtoReg= load;  //select datamemory data
	
	// //ALUop
	// assign ALUop[1]= R_type|branch; //R 10 I 01 B 11 add 00
	// assign ALUop[0]= I_type|branch;
endmodule

module alu_control(
	ALUop,  //00: auipc & store & load(加法)  01:R_type  10:I_type  11:B_type
	func3,
	func7,
	ALUctl
    );
	input [1:0]ALUop;
	input [2:0]func3;
	input [6:0]func7; //实际只用一位
	output [3:0]ALUctl;
	
	reg [3:0]branchop;
	reg [3:0]Rop;
	reg [3:0]Iop;
	
	//ALUctl : 0000 add
	//         0011 sub
	//         0100 and
	//         0101 or
	//         0110 xor
	//         0111 nor
	//         1000 comp   //小于置1
	//         1001 ucomp  //无符号小于置1
	//         1100 lleft  //逻辑左移 低位补0
	//         1101 lright //逻辑右移 高位补0
	//         1110 aright //算数右移 高位补符号位
	//         1010 PC+4   
	localparam ADD = 4'b0000,
	           SUB = 4'b0011,
			   AND = 4'b0100,
	           OR = 4'b0101,
	           XOR = 4'b0110,
	           NOR = 4'b0111,
			   COMP = 4'b1000,
			   UCOMP = 4'b1001,
			   LLEFT = 4'b1100,
			   LRIGHT = 4'b1101,
			   ARIGHT = 4'b1110;

	always @(*) begin //generate branchop
		case(func3)
			3'b000: branchop = SUB;   //BEQ
			3'b001: branchop = SUB;   //BNE
			3'b100: branchop = COMP;  //BLT
			3'b101: branchop = COMP;  //BGE
			3'b110: branchop = UCOMP; //BLTU
			3'b111: branchop = UCOMP; //GBEU
			default branchop = 4'b1111;
		endcase
	end

	always@(*) begin //generate Rop
		case(func3)
			3'b000: if(func7[5]) 
					Rop = SUB;   //SUB
					else         
					Rop = ADD;   //ADD
			3'b001: Rop = LLEFT; //SLL
			3'b010: Rop = COMP;  //SLT
			3'b011: Rop = UCOMP; //SLTU
			3'b100: Rop = XOR;   //XOR
			3'b101: if(func7[5])
					Rop = ARIGHT;//SRA
					else
					Rop = LRIGHT;//SRL  
			3'b110: Rop = OR;    //OR 
			3'b111: Rop = AND;   //AND
			default:Rop = ADD;   //ADD
		endcase
	end

	always@(*) begin //generate Iop
		case(func3)
			3'b000: Iop = ADD;   //ADDI
			3'b001: Iop = LLEFT; //SLLI
			3'b010: Iop = COMP;  //SLTI
			3'b011: Iop = UCOMP; //SLTIU
			3'b100: Iop = XOR;   //XORI
			3'b101: if(func7[5])
					Iop = ARIGHT;//SRAI
					else
					Iop = LRIGHT;//SRLI  
			3'b110: Iop = OR;    //ORI
			3'b111: Iop = AND;   //ANDI
			default:Iop = ADD;   //ADD
		endcase
	end
	
	assign ALUctl=(~ALUop[1] & ALUop[0]) ? Iop :            //ALUop = 01 I_type
				  (ALUop[1] & ~ALUop[0]) ? Rop :          //ALUop = 10 R_type
		          (ALUop[1] & ALUop[0]) ? branchop : ADD;   //ALUop = 11

endmodule
