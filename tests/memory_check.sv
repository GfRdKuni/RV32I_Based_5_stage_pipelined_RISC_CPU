`timescale 1ns/1ps
module memory_check;
    reg clk=0;
    always #5 clk=~clk;
    reg [31:0] data_i=0,addr=0;
    reg wr_en=0,rd_en=0;
    reg [2:0] kind=0;
    wire [31:0] data_out;
    wire [31:0] rabbit_count,chicken_count;
    DATAMEM dut(.clk(clk),.data_i(data_i),.wr_en(wr_en),.rd_en(rd_en),
                .addr(addr),.RW_type(kind),.data_out(data_out),
                .legsin(32'h89abcdef),.headin(32'h12345678),
                .rabbitout(rabbit_count),.chickenout(chicken_count));
    reg [7:0] bytes[0:255];
    reg [31:0] expected,pattern;
    integer offset,width,i,j,test_kind,checks=0;
    task store(input integer address,input integer size,input [31:0] value);
        begin
            @(posedge clk); #1;
            addr=address; data_i=value; kind=(size==1)?0:(size==2)?1:2; wr_en=1;
            @(negedge clk); #1; wr_en=0;
            for(j=0;j<size;j=j+1) bytes[address+j]=value>>(8*j);
        end
    endtask
    task load(input integer address,input integer size,input sign_extend);
        begin
            addr=address; rd_en=1;
            kind=(size==4)?2:(size==2)?(sign_extend?1:5):(sign_extend?0:4);
            expected=0;
            for(j=0;j<size;j=j+1) expected=expected | (32'(bytes[address+j])<<(8*j));
            if(sign_extend && size==1) expected={{24{expected[7]}},expected[7:0]};
            if(sign_extend && size==2) expected={{16{expected[15]}},expected[15:0]};
            #1;
            if(data_out !== expected)
                $fatal(1,"Memory addr=%0d size=%0d signed=%0d got=%h expected=%h",address,size,sign_extend,data_out,expected);
            checks=checks+1; rd_en=0;
        end
    endtask
    initial begin
        #100000; $fatal(1,"Memory timeout");
    end
    initial begin
        // Use ordinary RAM above the application I/O region; initialize only
        // through writes, with an independent byte-array reference.
        for(i=64;i<84;i=i+4) store(i,4,32'h12345678 ^ (i*32'h1020304));
        // The public count ports must agree with CPU load/store word values,
        // independently of the internal reversed byte-lane representation.
        for(i=0;i<4;i=i+1) begin
            bytes[36+i]=32'h12345678>>(8*i);
            bytes[40+i]=32'h89abcdef>>(8*i);
        end
        load(36,4,0); load(40,4,0);
        store(28,4,32'h89abcdef); store(32,4,32'h12345678);
        if(chicken_count !== 32'h89abcdef || rabbit_count !== 32'h12345678)
            $fatal(1,"Output count port byte order: %h,%h",rabbit_count,chicken_count);
        load(28,4,0); load(32,4,0);
        for(width=1;width<=4;width=width*2)
            for(offset=0;offset<4;offset=offset+1) begin
                pattern=32'h80fe91a7 ^ (offset*32'h1020408);
                store(68+offset,width,pattern);
                for(i=64;i<80;i=i+1) begin
                    load(i,1,0); load(i,1,1);
                    load(i,2,0); load(i,2,1); load(i,4,0);
                end
            end
        rd_en=0; #1;
        if(data_out !== 0) $fatal(1,"Disabled memory read output");
        $display("PASS memory_check loads=%0d (byte offsets, sign extension and MMIO)",checks);
        $finish;
    end
endmodule
