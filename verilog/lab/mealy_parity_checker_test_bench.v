`timescale 1ns / 1ns
module mealy_parity_checker_test_bench();
    reg clk, in, rst;
    wire out, state;

    mealy_parity_checker m(.clk(clk), .in(in), .out(out), .state(state), .rst(rst));

    initial
    begin
        $dumpfile("output.vcd");
        $dumpvars(0, m);

        clk = 1'b0;
        forever
            #10 clk = ~clk;
    end

    initial
    begin
        $monitor("time = %3d, state = %d, in = %d, out = %d\n", $time, state, in, out);
    end

    initial
    begin
        rst = 1;
        in = 0;
        #30 rst = 0;
        #10 in = 1;
        #11 in = 0;
        #10 in = 1;
        #10 in = 1;
        #10 in = 0;
        #10 $finish;
    end
    
endmodule