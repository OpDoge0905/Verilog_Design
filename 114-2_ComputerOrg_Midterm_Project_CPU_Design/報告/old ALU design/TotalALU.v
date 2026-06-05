`timescale 1ns/1ns
module TotalALU( clk, dataA, dataB, Signal, dataOut, reset );
    input clk, reset;
    input [31:0] dataA, dataB;
    input [5:0]  Signal;
    output [31:0] dataOut;

    wire [31:0] w_alu_out, w_hi_out, w_lo_out, w_shifter_out;
    wire [63:0] w_mult_out;

    ALU alu_inst(
        .dataA(dataA), 
        .dataB(dataB), 
        .Signal(Signal), 
        .dataOut(w_alu_out), 
        .reset(reset)
    );

    Multiplier mult_inst(
        .clk(clk), 
        .reset(reset), 
        .dataA(dataA), 
        .dataB(dataB), 
        .Signal(Signal), 
        .dataOut(w_mult_out)
    );

    HiLo hilo_inst(
        .clk(clk), 
        .reset(reset), 
        .dataIn(w_mult_out), 
        .HiOut(w_hi_out), 
        .LoOut(w_lo_out)
    );

    Shifter shifter_inst(
        .dataA(dataA), 
        .dataB(dataB), 
        .Signal(Signal), 
        .dataOut(w_shifter_out)
    );

    MUX mux_inst(
        .ALUOut(w_alu_out), 
        .HiOut(w_hi_out), 
        .LoOut(w_lo_out), 
        .ShifterOut(w_shifter_out), 
        .Signal(Signal), 
        .dataOut(dataOut)
    );
endmodule