`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/03 11:41:59
// Design Name: 
// Module Name: inst_past
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


module inst_past(
    input clk,
    input rst_n,
    input B_JUMP,

    input [31:0]now_inst,
    input [4:0]rs1_now,
    input [4:0]rs2_now,
    
    output [5:0]forward_EN1,
    output [5:0]forward_EN2,
    output wire stall_EN1,
    output wire stall_EN2
   
    );
    reg[31:0]last_inst;
    reg[31:0]lastlast_inst;
    wire[6:0]opcode;
    //wire[4:0]rs1,rs2;
    //wire[4:0]rd;
    wire last_load;
    //wire stall_EN1,stall_EN2;
    //wire lastlast_load;
    
    
    parameter 
    lui = 7'b0110111,
    auipc = 7'b0010111,
    jal = 7'b1101111,
    jalr = 7'b1100111,
    R_type = 7'b0110011,
    I_type = 7'b0010011,
    L_type = 7'b0000011;




    always@(posedge clk or negedge rst_n)begin

        if(!rst_n)begin
            last_inst <= 32'b00000000_00000000_00000000_00000000;
        end
        else begin
            if(B_JUMP)
            last_inst <= 32'b00000000_00000000_00000000_00000000;
            else 
            last_inst <= now_inst;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            lastlast_inst <= 32'b00000000_00000000_00000000_00000000;
        end
        else begin
            lastlast_inst <= last_inst;
        end 
    end
    /*
    6'b0100000 : imm/now == last rs1 = rd
    6'b0010000 : imm/now == lastlast rs1 = rd
    6'b0001000 : aluout/now == last rs1 = rd
    6'b0000100 : aluout/now == lastlast rs1 = rd
    6'b0000010 : mem/now == last rs1 = rd
    6'b0000001 : mem/now == lastlast rs1 = rd
    */
    assign last_load = (last_inst[6:0] == lui) || (last_inst[6:0] == auipc) || (last_inst[6:0] == jal) || (last_inst[6:0] == jalr) || (last_inst[6:0] == R_type)||(last_inst[6:0] == I_type)||(last_inst[6:0] == L_type);
    //assign lastlast_load = (lastlast_inst[6:0] == lui) || (lastlast_inst[6:0] == auipc) || (lastlast_inst[6:0] == jal) || (lastlast_inst[6:0] == jalr) || (lastlast_inst[6:0] == R_type)||(lastlast_inst[6:0] == I_type)||(lastlast_inst[6:0] == L_type);
    //assign forward_EN[6] = rs2_now == last_inst[11:7] || rs2_now == lastlast_inst[11:7];
    assign forward_EN1[5] = (last_inst[6:0] == lui || last_inst[6:0] == auipc) && (rs1_now == last_inst[11:7]);
    assign forward_EN1[4] = (~last_load || ~(rs1_now == last_inst[11:7])) && (lastlast_inst[6:0] == lui || lastlast_inst[6:0] == auipc) && (rs1_now == lastlast_inst[11:7]);
    assign forward_EN1[3] = (last_inst[6:0] == jal || last_inst[6:0] == jalr || last_inst[6:0] == R_type || last_inst[6:0] == I_type) && (rs1_now == last_inst[11:7]);
    assign forward_EN1[2] = (~last_load || ~(rs1_now == last_inst[11:7])) && (lastlast_inst[6:0] == jal || lastlast_inst[6:0] == jalr || lastlast_inst[6:0] == R_type || lastlast_inst[6:0] == I_type) && (rs1_now == lastlast_inst[11:7]);
    assign forward_EN1[1] = (last_inst[6:0] == L_type) && (rs1_now == last_inst[11:7]); 
    assign forward_EN1[0] = (~last_load || ~(rs1_now == last_inst[11:7])) && (lastlast_inst[6:0] == L_type) &&(rs1_now == lastlast_inst[11:7]);
    assign stall_EN1 = forward_EN1[1];

    assign forward_EN2[5] = (last_inst[6:0] == lui || last_inst[6:0] == auipc) && rs2_now == last_inst[11:7];
    assign forward_EN2[4] = (~last_load || ~(rs2_now == last_inst[11:7]))&& (lastlast_inst[6:0] == lui || lastlast_inst[6:0] == auipc) && rs2_now == lastlast_inst[11:7];
    assign forward_EN2[3] = (last_inst[6:0] == jal || last_inst[6:0] == jalr || last_inst[6:0] == R_type || last_inst[6:0] == I_type) && (rs2_now == last_inst[11:7]);
    assign forward_EN2[2] = (~last_load || ~(rs2_now == last_inst[11:7])) && (lastlast_inst[6:0] == jal || lastlast_inst[6:0] == jalr || lastlast_inst[6:0] == R_type || lastlast_inst[6:0] == I_type) && (rs2_now == lastlast_inst[11:7]);
    assign forward_EN2[1] = (last_inst[6:0] == L_type) && rs2_now == last_inst[11:7]; 
    assign forward_EN2[0] = (~last_load || ~(rs2_now == last_inst[11:7])) && (lastlast_inst[6:0] == L_type) && rs2_now == lastlast_inst[11:7];
    assign stall_EN2 = forward_EN2[1];


endmodule
