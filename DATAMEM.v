`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/05 18:27:06
// Design Name: 
// Module Name: DATAMEM
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


module DATAMEM(
    input clk,
    input [31:0]data_i, // DATA IN
    input wr_en, // Writing Enable
    input rd_en, // Reading Enable
    input [31:0]addr, // Read/Write Address
    input [2:0]RW_type,
    input [31:0]legsin,
    input [31:0]headin,
    //input LB,
    //input LH,
    //input LW,
    //input LBU,
    //input LHU,
    //input SB,
    //input SH,
    //input SW, //Control Signal
    
    output reg [31:0]data_out, // DATA OUT
    output [31:0]rabbitout,
    output [31:0]chickenout
    );
    reg [31:0]datamem [63:0];
    wire [31:0]pr_now, pr_next; //Processed Now and Next
    wire [31:0]addr_next; 
    /*********************************************************
    *
    *   Addr[31:0] 00000000_00000000_000000[9:2]word_select [1:0]Byte_select
    *   L_Type address from aluout[31:0] = imm[31:0](offset, only 2 bits are used) + (rs1)[31:0](base address)  
    *   S_Type address from aluout[31:0] = imm[31:0](offset, only 2 bits are used) + (rs1)[31:0]
    *   S_Type data_i from (rs2)[31:0]
    *
    *********************************************************/
    /********************************************************
    *    
    *   大端读写：高地址存低字节，低地址存高字节
    *
    *
    *   小端读写：高地址存高字节，低地址存低字节
    *
    *
    *   在RV32-I指令集的RISC—V CPU中，存储器使用小端读�?
    *
    *
    *   如将数据 data[31:0] = 32'h aa_bb_cc_dd 存在存储器中的方式是
    *
    *     
    *   Byte         1            2            3           4
    *   ADDR       8'hdd        8'hcc        8'hbb       8'haa   
    *
    *
    *********************************************************/


    // 新的"地址，读使能，写使能和控制信�?"到来了，我们现在要干�?�?
    // 首先我们要取出我们要操作的数,好像还要取下�?个字
    assign pr_now = datamem[addr[31:2]];
    assign addr_next = addr + 4;
    assign pr_next = datamem[addr_next[31:2]];
    assign rabbitout = datamem[8];
    assign chickenout = datamem[7];
    //assign rabbitout = datamem[4];
    //assign chickenout = datamem[3];
    // 然后我们要根据控制信号来确定我要读还是要�?



    //Write Block
    always @(negedge clk)
    begin
        datamem[10] = legsin;
        datamem[9] = headin;
        //datamem[2] = legsin;
        //datamem[1] = headin;
        if (wr_en)begin //如果是要写，那应该�?�么写呢�?
        //如果是SB指令，我�?要将进来的数的低8位存到相应的地址，这个地�?由谁决定呢？是由addr的低两位决定�?
            if(RW_type == 3'b000)begin
                if(addr[1:0] == 2'b00) datamem[addr[31:2]] = {data_i[7:0], pr_now[23:0]};
                else if(addr[1:0] == 2'b01) datamem[addr[31:2]] = {pr_now[31:24], data_i[7:0], pr_now[15:0]};
                else if(addr[1:0] == 2'b10) datamem[addr[31:2]] = {pr_now[31:16], data_i[7:0], pr_now[7:0]};
                else datamem[addr[31:2]] = {pr_now[31:8], data_i[7:0]}; 
            end
        //如果是SH指令，我�?要将进来的数的低16位存到相应的地址，这个地�?由谁决定呢？是由addr的低两位决定�?
            else if(RW_type == 3'b001)begin
                if(addr[1:0] == 2'b00) datamem[addr[31:2]] = {data_i[7:0], data_i[15:8], pr_now[15:0]};
                else if(addr[1:0] == 2'b01) datamem[addr[31:2]] = {pr_now[31:24], data_i[7:0], data_i[15:8], pr_now[7:0]};
                else if(addr[1:0] == 2'b10) datamem[addr[31:2]] = {pr_now[31:16], data_i[7:0], data_i[15:8]};
                else begin                    
                    datamem[addr_next[31:2]] = {data_i[15:8], pr_next[23:0]};
                    datamem[addr[31:2]] = {pr_now[31:8], data_i[7:0]};
                end
            end
        //如果是SW指令，我�?要将进来的字存到相应的地�?，这个地�?由谁决定呢？是由addr的低两位决定�?
            else begin
                if(addr[1:0] == 2'b00) datamem[addr[31:2]] = {data_i[7:0], data_i[15:8], data_i[23:16], data_i[31:24]};
                else if(addr[1:0] == 2'b01)begin
                    datamem[addr_next[31:2]] = {data_i[31:24], pr_next[23:0]};
                    datamem[addr[31:2]] = {pr_now[31:24], data_i[7:0], data_i[15:8], data_i[23:16]};
                end
                else if(addr[1:0] == 2'b10)begin
                    datamem[addr_next[31:2]] = {data_i[23:16], data_i[31:24], pr_next[15:0]};
                    datamem[addr[31:2]] = {pr_now[31:16], data_i[7:0], data_i[15:8]};
                end
                else begin
                    datamem[addr_next[31:2]] = {data_i[15:8], data_i[23:16], data_i[31:24], pr_next[7:0]};
                    datamem[addr[31:2]] = {pr_now[31:8], data_i[7:0]};
                end
            end

        end
        else datamem[addr[31:2]] = pr_now; //如果不要写，则保持原来的�?
    end



    //Read Block
    always @(*) begin
        if(rd_en) begin //如果是要读，应该怎么读呢
        //如果是LB指令，读�?个字节，并且做算术拓�?
            if(RW_type == 3'b000)begin
                if(addr[1:0] == 2'b00) data_out = {{24{pr_now[31]}}, pr_now[31:24]};
                else if(addr[1:0] == 2'b01) data_out = {{24{pr_now[23]}},pr_now[23:16]};
                else if(addr[1:0] == 2'b10) data_out = {{24{pr_now[15]}},pr_now[15:8]};
                else data_out = {{24{pr_now[7]}}, pr_now[7:0]};
            end
        //如果是LH指令，读�?个半字，并且做算术拓�?
            else if(RW_type == 3'b001)begin
                if(addr[1:0] == 2'b00) data_out = {{16{pr_now[23]}}, pr_now[23:16], pr_now[31:24]};
                else if(addr[1:0] == 2'b01) data_out = {{16{pr_now[15]}},pr_now[15:8], pr_now[23:16]};
                else if(addr[1:0] == 2'b10) data_out = {{16{pr_now[7]}},pr_now[7:0],pr_now[15:8]};
                else data_out = {{16{pr_next[31]}}, pr_next[31:24], pr_now[7:0]};
            end
        //如果是LW指令，读�?个字
            else if(RW_type == 3'b010)begin
                if(addr[1:0] == 2'b00) data_out = {pr_now[7:0], pr_now[15:8], pr_now[23:16], pr_now[31:24]};
                else if(addr[1:0] == 2'b01) data_out = {pr_next[31:24], pr_now[7:0], pr_now[15:8], pr_now[23:16]};
                else if(addr[1:0] == 2'b10) data_out = {pr_next[23:16], pr_next[31:24], pr_now[7:0], pr_now[15:8]};
                else data_out = {pr_next[15:8], pr_next[23:16], pr_next[31:24], pr_now[7:0]};
            end
        //如果是LBU指令，读�?个字节，并且做�?�辑拓展
            else if(RW_type == 3'b100)begin
                if(addr[1:0] == 2'b00) data_out = {24'b00000000_00000000_00000000, pr_now[31:24]};
                else if(addr[1:0] == 2'b01) data_out = {24'b00000000_00000000_00000000,pr_now[23:16]};
                else if(addr[1:0] == 2'b10) data_out = {24'b00000000_00000000_00000000,pr_now[15:8]};
                else data_out = {24'b00000000_00000000_00000000, pr_now[7:0]};
            end
        //如果是LHU指令，读�?个半字，并且做算术拓�?
            else begin
                if(addr[1:0] == 2'b00) data_out = {16'b00000000_00000000, pr_now[23:16], pr_now[31:24]};
                else if(addr[1:0] == 2'b01) data_out = {16'b00000000_00000000,pr_now[15:8], pr_now[23:16]};
                else if(addr[1:0] == 2'b10) data_out = {16'b00000000_00000000,pr_now[7:0],pr_now[15:8]};
                else data_out = {16'b00000000_00000000, pr_next[31:24], pr_now[7:0]};
            end
        end
        else
            data_out = 32'b00000000_00000000_00000000_00000000; //如果不要读，随便给一个�?�，在本轮用不到
    end
endmodule
//控制器和译码器要同时发挥作用（译码周期），在执行阶段译码器的fun3和控制器的wr_en/rd_en要同时到达后续模块，在执行阶段控制相应模块的工作
//时钟边沿到来了，上一级给我们送来了新的地�?，我们现在要干什么？
//取指阶段：在时钟边沿到来时pc更新，指令寄存器的输出立马更新，指令寄存器原来的输出被�?�往下一级；
//译码阶段：译码器在接收到新的�?条指令后，开始译码找出opcode，fun3，fun7, imm, rs1, rs2, rd, 控制器根据这些信号立马更新（控制信号即时产生，传播到后一级发挥作用），产生控制信号，寄存器根据译码的结果和控制信号来找寄存器中的操作数，某些控制信号要传到下�?级去�?
//（可能有跳转回去的问题，大概的想法就是，译码器和控制器在发现要跳转的时�?�要及时止损，此时后�?条指令已经取出，不能让这�?条指令传播到后一级，因此在发现前�?条指令是跳转指令时，立马要算出新的地�?，返回到InsMem来取�?个新的指令，因此InsMem的输入地�?可能�?要一个数据�?�择器，由前�?条指令译码的结果来进行�?�择�?
//执行阶段：ALU收到前一级的数据后，立马根据aluctr来进行计算操作，产生alu_out，作为写回的数据或存数的地址，传给下�?级；
//访存阶段：接收到前一级的aluout，wr_en/rd_en和一些寄存器的数据之后进行访存，进行读取或写入操作；
//写回阶段：收到新的数据和地址之后，进行写回操作，这里会存在的�?个问题是有可能某�?条指令在这条指令写回之前就取了要被写入新值的寄存器的值，可能会导致读数的错误�?
//(这个问题貌似有点难解�?)
//个人理解的写流水线的关键：着眼于自己拿到新的数据后要干什么，除了第一级的整体控制之外，其余级次都是组合�?�辑，只要在�?个时钟周期里安安心心把自己的事情做好，在下一个时钟周期到来之前，都不会有人抢走自己的数据，自己干的活也不会影响后级的数据�?