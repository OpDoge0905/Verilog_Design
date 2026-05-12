`timescale 1ns/1ns
module MUX( ALUOut, HiOut, LoOut, ShifterOut, Signal, dataOut );
    input [31:0] ALUOut;
    input [31:0] HiOut;
    input [31:0] LoOut;
    input [31:0] ShifterOut;
    input [5:0]  Signal;
    output [31:0] dataOut;

    // 根據 Signal 選擇輸出 (Data Flow Modeling)
    // SRL (02) -> ShifterOut
    // MFHI (16) -> HiOut
    // MFLO (18) -> LoOut
    // 其他 (ADD, SUB, AND, OR, SLT) -> 預設輸出 ALUOut

    assign dataOut = (Signal == 6'd2)  ? ShifterOut :
                     (Signal == 6'd16) ? HiOut :
                     (Signal == 6'd18) ? LoOut :
                     ALUOut; 

endmodule