`timescale 1ns/1ps
module alu_check;
    reg [31:0] a,b;
    reg [3:0] control;
    reg beq=0,bne=0,blt=0,bge=0,bltu=0,bgeu=0;
    wire jump;
    wire [31:0] result;
    ALU dut(.ALU_DA(a),.ALU_DB(b),.ALU_CTL(control),.beq(beq),.bne(bne),
            .blt(blt),.bge(bge),.bltu(bltu),.bgeu(bgeu),.jal(1'b0),.jalr(1'b0),
            .B_JUMP(jump),.ALU_DC(result));
    reg [31:0] samples[0:7];
    reg [31:0] expected;
    integer i,j,k,checks=0;
    task check(input [3:0] op, input [31:0] value);
        begin
            control=op; expected=value; #1;
            if(result !== expected)
                $fatal(1,"ALU op=%h a=%h b=%h result=%h expected=%h",op,a,b,result,expected);
            checks=checks+1;
        end
    endtask
    initial begin
        samples[0]=0; samples[1]=1; samples[2]=32'hffffffff; samples[3]=32'h80000000;
        samples[4]=32'h7fffffff; samples[5]=32'h87654321;
        samples[6]=32'h12345678; samples[7]=32'hfffffff8;
        for(i=0;i<8;i=i+1) begin
            a=samples[i];
            for(k=0;k<32;k=k+1) begin
                b=k;
                check(4'hc,a<<k); check(4'hd,a>>k);
                check(4'he,$signed(a)>>>k);
            end
            for(j=0;j<8;j=j+1) begin
                b=samples[j];
                check(4'h0,a+b); check(4'h3,a-b);
                check(4'h4,a&b); check(4'h5,a|b); check(4'h6,a^b);
                check(4'h8,($signed(a)<$signed(b))?32'd1:32'd0);
                blt=1; #1;
                if(jump !== ($signed(a)<$signed(b))) $fatal(1,"Signed branch comparison");
                blt=0;
                check(4'h9,(a<b)?32'd1:32'd0);
                bltu=1; #1;
                if(jump !== (a<b)) $fatal(1,"Unsigned branch comparison");
                bltu=0;
                control=4'h3; beq=1; #1;
                if(jump !== (a==b)) $fatal(1,"Equality branch comparison");
                beq=0; bne=1; #1;
                if(jump !== (a!=b)) $fatal(1,"Inequality branch comparison");
                bne=0;
            end
        end
        $display("PASS alu_check arithmetic_cases=%0d and branch comparisons",checks);
        $finish;
    end
endmodule
