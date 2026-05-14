`timescale 1ns/1ns
module MUX( ALUOut, HiOut, LoOut, ShifterOut, Signal, dataOut );
    input [31:0] ALUOut, HiOut, LoOut, ShifterOut;
    input [5:0]  Signal;
    output [31:0] dataOut;

    // 根據 Signal 選擇輸出 [cite: 44-55, 109-110]
    // SRL (02) -> Shifter
    // MFHI (16) -> Hi
    // MFLO (18) -> Lo
    // AND, OR, ADD, SUB, SLT -> ALUOut

    assign dataOut = (Signal == 6'd2)  ? ShifterOut :
                    (Signal == 6'd16) ? HiOut      :
                    (Signal == 6'd18) ? LoOut      :
                    (Signal == 6'd25) ? LoOut      :  // ← 這行有沒有？
                    ALUOut;

endmodule