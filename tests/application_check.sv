`timescale 1ns/1ps
module application_check;
    reg clk=0;
    always #5 clk=~clk;
    reg rst_n=1;
    reg [31:0] legs=0, heads=0;
    wire [31:0] rabbits, chickens;
    cpu_core dut(.clk(clk),.rst_n(rst_n),.legsin(legs),.headin(heads),
                 .rabbitout(rabbits),.chickenout(chickens));
    integer cases=0, live_updates=0, load_bypasses=0, alu_forwards=0;
    integer head_count, rabbit_count, unused_word;
    always @(posedge clk) if(rst_n) begin
        if(dut.stall_EN1_ID || dut.stall_EN2_ID) load_bypasses=load_bypasses+1;
        if(dut.forward_EN1[3:2] != 0 || dut.forward_EN2[3:2] != 0)
            alu_forwards=alu_forwards+1;
    end
    task run_case(input integer h, input integer l);
        integer cycle;
        begin
            @(negedge clk); rst_n=0; heads=h; legs=l;
            repeat(3) @(negedge clk);
            rst_n=1;
            // The ROM has 33 application instructions; allow pipeline drain.
            repeat(40) @(negedge clk);
            for(cycle=0;cycle<24;cycle=cycle+1) begin
                @(negedge clk);
                if(rabbits !== (l-2*h)/2 || chickens !== (4*h-l)/2)
                    $fatal(1,"Application h=%0d l=%0d rabbits=%h chickens=%h expected=%0d,%0d",
                           h,l,rabbits,chickens,(l-2*h)/2,(4*h-l)/2);
                if((^dut.inst_IF) === 1'bx)
                    $fatal(1,"Embedded program fetches an uninitialized instruction after completion");
            end
            cases=cases+1;
        end
    endtask
    task update_live(input integer h, input integer l);
        begin
            @(negedge clk); heads=h; legs=l;
            repeat(80) @(negedge clk);
            repeat(24) begin
                @(negedge clk);
                if(rabbits !== (l-2*h)/2 || chickens !== (4*h-l)/2)
                    $fatal(1,"Live update h=%0d l=%0d rabbits=%h chickens=%h",h,l,rabbits,chickens);
                if((^dut.inst_IF) === 1'bx) $fatal(1,"Unknown instruction in application loop");
            end
            live_updates=live_updates+1;
        end
    endtask
    initial begin
        #2000000; $fatal(1,"Application timeout cases=%0d",cases);
    end
    initial begin
        run_case(12,36);
        for(unused_word=34;unused_word<64;unused_word=unused_word+1)
            if(dut.INSMEM.rom[unused_word] !== 32'h00000013)
                $fatal(1,"Reserved ROM word %0d is not a defined NOP",unused_word);
        run_case(10,26);
        run_case(300,800);
        run_case(256,512); run_case(256,1024);
        run_case(65535,196606); run_case(65536,196608);
        run_case('h00100000,'h00300000);
        run_case('h01000000,'h03000000);
        run_case('h10000000,'h20000000);
        run_case('h10000000,'h30000000);
        run_case('h10000000,'h40000000);
        // Exhaust the valid UI range (even legs up to 98, heads up to 49).
        for(head_count=0;head_count<=49;head_count=head_count+1)
            for(rabbit_count=0;rabbit_count<=head_count; rabbit_count=rabbit_count+1)
                if(2*head_count+2*rabbit_count<=98)
                    run_case(head_count,2*head_count+2*rabbit_count);
        // The board shell changes counts while the CPU keeps running. A loop
        // must refresh both outputs without requiring reset of those inputs.
        update_live(20,68);
        update_live('h10000,'h30000);
        if(load_bypasses==0 || alu_forwards==0)
            $fatal(1,"Application did not exercise forwarding paths");
        $display("PASS application_check cases=%0d live_updates=%0d load_bypasses=%0d alu_forwards=%0d",
                 cases,live_updates,load_bypasses,alu_forwards);
        $finish;
    end
endmodule
