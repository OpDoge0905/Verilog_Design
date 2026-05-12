`timescale 1ns/1ns
module Shifter( dataA, dataB, Signal, dataOut );
    input  [31:0] dataA; // 被位移資料
    input  [31:0] dataB; // 位移量 (shamt)
    input  [5:0]  Signal;
    output [31:0] dataOut;

    wire [31:0] s0, s1, s2, s3, s4;

    // SRL 控制碼為 02 [cite: 54]
    // 使用三元運算子 (? :) 在硬體上對應 2-to-1 Mux
    // 使用位元拼接 ({}) 達成硬體接線的平移

    // Stage 0: 檢查位移量 bit 0，位移 2^0 = 1 位
    assign s0 = dataB[0] ? { 1'b0, dataA[31:1] } : dataA;

    // Stage 1: 檢查位移量 bit 1，位移 2^1 = 2 位
    assign s1 = dataB[1] ? { 2'b0, s0[31:2] } : s0;

    // Stage 2: 檢查位移量 bit 2，位移 2^2 = 4 位
    assign s2 = dataB[2] ? { 4'b0, s1[31:4] } : s1;

    // Stage 3: 檢查位移量 bit 3，位移 2^3 = 8 位
    assign s3 = dataB[3] ? { 8'b0, s2[31:8] } : s2;

    // Stage 4: 檢查位移量 bit 4，位移 2^4 = 16 位
    assign s4 = dataB[4] ? { 16'b0, s3[31:16] } : s3;

    // 最終輸出：僅在 Signal 為 02 時輸出位移結果
    assign dataOut = (Signal == 6'd2) ? s4 : 32'd0;

endmodule