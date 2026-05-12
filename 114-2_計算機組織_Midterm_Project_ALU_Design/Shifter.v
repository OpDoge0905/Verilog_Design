`timescale 1ns/1ns
module Shifter( dataA, dataB, Signal, dataOut );
    input [31:0] dataA; // 假設 dataA 為被位移的資料
    input [31:0] dataB; // 假設 dataB[4:0] 為位移量 (Shift Amount)
    input [5:0] Signal;
    output [31:0] dataOut;

    wire [31:0] s0, s1, s2, s3, s4;

    // SRL 控制碼為 6'd2
    // 使用位元拼接 {} 實作硬體線路的平移，並用 ? : 實作 160 個 MUX

    // Stage 0: 判斷位移量的 bit 0，若為 1 則右移 1 位 (左邊補 1 個 0)
    assign s0 = dataB[0] ? { 1'b0, dataA[31:1] } : dataA;

    // Stage 1: 判斷位移量的 bit 1，若為 1 則右移 2 位 (左邊補 2 個 0)
    assign s1 = dataB[1] ? { 2'b0, s0[31:2] } : s0;

    // Stage 2: 判斷位移量的 bit 2，若為 1 則右移 4 位 (左邊補 4 個 0)
    assign s2 = dataB[2] ? { 4'b0, s1[31:4] } : s1;

    // Stage 3: 判斷位移量的 bit 3，若為 1 則右移 8 位 (左邊補 8 個 0)
    assign s3 = dataB[3] ? { 8'b0, s2[31:8] } : s2;

    // Stage 4: 判斷位移量的 bit 4，若為 1 則右移 16 位 (左邊補 16 個 0)
    assign s4 = dataB[4] ? { 16'b0, s3[31:16] } : s3;

    // 最後判斷控制訊號：如果 Signal 是 SRL (02)，才輸出結果，否則輸出 0
    assign dataOut = (Signal == 6'd2) ? s4 : 32'd0;

endmodule