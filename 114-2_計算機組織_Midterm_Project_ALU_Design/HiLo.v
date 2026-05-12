`timescale 1ns/1ns
module HiLo( clk, reset, dataIn, HiOut, LoOut );
    input clk;
    input reset;
    input [63:0] dataIn; // 來自 Multiplier 的 64-bit 結果
    output [31:0] HiOut;
    output [31:0] LoOut;

    reg [31:0] hi_reg;
    reg [31:0] lo_reg;

    // 循序邏輯：僅使用 Clock 正緣觸發
    always @(posedge clk) begin
        if (reset) begin
            hi_reg <= 32'd0;
            lo_reg <= 32'd0;
        end else begin
            // 將 64-bit 資料切半分裝
            hi_reg <= dataIn[63:32];
            lo_reg <= dataIn[31:0];
        end
    end

    // 輸出連接
    assign HiOut = hi_reg;
    assign LoOut = lo_reg;

endmodule