`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/06 11:08:24
// Design Name: 
// Module Name: instr_memory
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


module instr_memory(
    rst_n,
    addr,
	instr
    );
	input rst_n;
    input [7:0]addr;
	output [31:0]instr;

	reg[31:0] rom[63:0];
	
    //rom进行初始�?
    always@(negedge rst_n)begin
        rom[0] =  32'h00c00f13; 
        rom[1] =  32'h02400f93; 
        rom[2] =  32'h03e02223; 
        rom[3] =  32'h03f02423; 
        rom[0] =  32'h02000113;
        rom[1] =  32'hfe112223;
        rom[2] =  32'hfe812423;
        rom[3] =  32'hfe010413;
        rom[4] =  32'h02400793;
        rom[5] =  32'h00100013;
        rom[6] = 32'h00100013;
        rom[7] = 32'h00f02a23;
        rom[8] = 32'h02800793;
        rom[9] = 32'h00100013;
        rom[10] = 32'h00100013;
        rom[11] = 32'h00f02c23;
        rom[12] = 32'h01402783;
        rom[13] = 32'h0007a783;
        rom[14] = 32'h00279713;
        rom[15] = 32'h01842783;
        rom[16] = 32'h0007a783;
        rom[17] = 32'h40f707b3;
        rom[18] = 32'h0017d713;
        rom[19] = 32'h00e42e23;
        rom[20] = 32'h01842783;
        rom[21] = 32'h0007a703;
        rom[22] = 32'h01442783;
        rom[23] = 32'h0007a783;
        rom[24] = 32'h00179793;
        rom[25] = 32'h40f707b3;
        rom[26] = 32'h0017d713;
        rom[27] = 32'h02e42023;

        rom[28] = 32'h00000793;
        rom[29] = 32'h00078513;
        rom[30] = 32'hfe412083;
        rom[31] = 32'hfe812403;
        rom[32] = 32'hfe010113;
        
        // rom[0]  = 32'h00402583;
        // rom[1]  = 32'h00802603;
        // rom[2]  = 32'h00259593;
        // rom[3]  = 32'h40c585b3;
        // rom[4]  = 32'h0015d593;
        // rom[5]  = 32'h00b02623;
        // rom[6]  = 32'h00402583;
        // rom[7]  = 32'h00159593;
        // rom[8]  = 32'h40b60633;
        // rom[9]  = 32'h00165613;
        // rom[10]  = 32'h00c02823;
        // rom[11]  = 32'hfd5ff8ef;

        // rom[0] = 32'h02000113; 
        // rom[1] = 32'hfe112223; 
        // rom[2] = 32'hfe812423; 
        // rom[3] = 32'hfe010413; 
        // rom[4] = 32'h02400793;
        // rom[5] = 32'h00f42a23;
        // rom[6] = 32'h02800793;
        // rom[7] = 32'h00f42c23;
        // rom[8] = 32'h01442783;
        // rom[9] = 32'h0007a783;
        // rom[10] = 32'h00279713;
        // rom[11] = 32'h01842783;
        // rom[12] = 32'h40f707b3;
        // rom[13] = 32'h01f7d713;
        // rom[14] = 32'h00f707b3;
        // rom[15] = 32'h4017d793;
        // rom[16] = 32'h00f42e23;
        // rom[17] = 32'h01842783;
        // rom[18] = 32'h0007a703;
        // rom[19] = 32'h0007a783;
        // rom[20] = 32'h01442783;
        // rom[21] = 32'h0007a783;
        // rom[22] = 32'h00179793;
        // rom[23] = 32'h40f707b3;
        // rom[24] = 32'h01f7d713;
        // rom[25] = 32'h00f707b3;
        // rom[26] = 32'h4017d793;
        // rom[27] = 32'h02f42023;
        // rom[28] = 32'h00000793;
        // rom[29] = 32'h00078513;
        // rom[30] = 32'hfe412083;
        // rom[31] = 32'hfe812403;
        // rom[32] = 32'hfe010113;
        // rom[33] = 32'h00008067;
        // rom[34] = 32'hf79fffef;
        //rom[5]   = 32'haaa0e213;
        //rom[6]   = 32'haaa0f293;
        //rom[7]   = 32'h7ff0a313;
        //rom[8]   = 32'h00209393;
        //rom[9]   = 32'h0020d413;
        //rom[10]  = 32'h4020d493;
        //rom[11]  = 32'h00209533;
        //rom[12]  = 32'h0020d5b3;
        //rom[13]  = 32'h4020d633;
        //rom[14]  = 32'hfff6b713;
        //rom[15]  = 32'h00d0b7b3;
        //rom[2] = 32'h00300193;
        //rom[3] = 32'h00400213;
        //rom[4] = 32'h0f000293;
        //rom[5] = 32'h00218333;
        //rom[6] = 32'h402083b3;
        //rom[7] = 32'h00229293;
        //rom[6] = 32'h402083b3;
        //rom[7] = 32'h00229293;
        //rom[8] = 32'hfe1ff56f;
        //rom[9] = 32'hfddff46f;
 
        //$readmemh("rom_hex_file.txt", rom);
    //test1:
    //begin:
    //0:         abcde0b7        lui x1 0xabcde
    //4:         00200113        addi x2 x0 2
    //8:         00300193        addi x3 x0 3
    //c:         00400213        addi x4 x0 4
    //10:        0f000293        addi x5 x0 240
    //14:        00218333        add x6 x3 x2
    //18:        402083b3        sub x7 x1 x2
    //1c:        00229293        slli x5 x5 2
    //20:        fe1ff56f        jal x10 -32 <begin>


    //test2:
    //0:        00500093        addi x1 x0 5
    //4:        00a00113        addi x2 x0 10
    //8:        00000193        addi x3 x0 0
    //c:        00000513        addi x10 x0 0

    //00000010 <begin>:
    //    10:        00118193        addi x3 x3 1
    //    14:        00208093        addi x1 x1 2
    //    18:        00110113        addi x2 x2 1
    //    1c:        fe209ae3        bne x1 x2 -12 <begin>
    //    20:        00150513        addi x10 x10 1
    
    //test3:
    //0:         abcde0b7        lui x1 0xabcde
    //4:         fff08093        addi x1 x1 -1
    //8:         00100023        sb x1 0 x0
    //c:         00101223        sh x1 4 x0
    //10:        00102423        sw x1 8 x0


    //0:        abcde0b7        10101011110011011110000010110111
    //4:        00fff117        00000000111111111111000100010111
    end
	
    assign instr = rom[addr];

endmodule

