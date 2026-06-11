`timescale 1ns/1ns
module MUX(ALUOut, HiOut, LoOut, ShifterOut, Signal, dataOut);
    input [31:0] ALUOut, HiOut, LoOut, ShifterOut;
    input [5:0] Signal;
    output [31:0] dataOut;

    assign dataOut = (Signal == 6'd16) ? HiOut :
                     (Signal == 6'd18) ? LoOut :
                     ALUOut;
endmodule