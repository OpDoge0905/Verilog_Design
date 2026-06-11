`timescale 1ns/1ns
module Testbench();
    reg clk;
    reg reset;

    PipelinedCPU CPU(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 1'b1;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1'b1;
        #15;
        reset = 1'b0;

        $readmemh("instr_mem.txt", CPU.imem_inst.mem);
        $readmemh("data_mem.txt", CPU.dmem_inst.mem);
        $readmemh("reg.txt", CPU.reg_inst.reg_file);

        #3000;
        $stop;
    end
endmodule