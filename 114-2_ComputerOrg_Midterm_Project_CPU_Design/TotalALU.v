`timescale 1ns/1ns
module TotalALU(clk, reset, mult_start, dataA, dataB, Signal, dataOut, busy, mult_done, HiOut, LoOut, ALUOut_raw);
    input clk, reset, mult_start;
    input [31:0] dataA, dataB;
    input [5:0] Signal;
    output [31:0] dataOut;
    output busy, mult_done;
    output [31:0] HiOut, LoOut, ALUOut_raw;

    wire [31:0] w_alu_out, w_shifter_out;
    wire [63:0] w_mult_out;

    assign ALUOut_raw = w_alu_out;

    ALU alu_inst(.dataA(dataA), .dataB(dataB), .Signal(Signal), .dataOut(w_alu_out), .reset(reset));
    Multiplier mult_inst(.clk(clk), .reset(reset), .start(mult_start), .dataA(dataA), .dataB(dataB), .Signal(Signal), .dataOut(w_mult_out), .busy(busy), .done(mult_done));
    HiLo hilo_inst(.clk(clk), .reset(reset), .write(mult_done), .dataIn(w_mult_out), .HiOut(HiOut), .LoOut(LoOut));
    Shifter shifter_inst(.dataA(dataA), .dataB(dataB), .Signal(Signal), .dataOut(w_shifter_out));
    MUX mux_inst(.ALUOut(w_alu_out), .HiOut(HiOut), .LoOut(LoOut), .ShifterOut(w_shifter_out), .Signal(Signal), .dataOut(dataOut));
endmodule