`timescale 1ns/1ns
module Multiplier( clk, reset, dataA, dataB, Signal, dataOut );
    input clk, reset;
    input [31:0] dataA; // 被乘數 (Multiplicand)
    input [31:0] dataB; // 乘數 (Multiplier)
    input [5:0]  Signal;
    output [63:0] dataOut;

    parameter MULTU = 6'd25;

    // 內部暫存器：根據第一版乘法器設計
    reg [63:0] multiplicand;
    reg [31:0] multiplier_reg;
    reg [63:0] product;
    reg [5:0]  counter;
    reg        busy;

    // 僅使用時脈邊緣觸發的循序邏輯，不使用 always @(*)
    always @( posedge clk or posedge reset ) begin
        if ( reset ) begin
            multiplicand   <= 64'b0;
            multiplier_reg <= 32'b0;
            product        <= 64'b0;
            counter        <= 6'd0;
            busy           <= 1'b0;
        end
        else begin
            // 狀態控制：當偵測到 MULTU 訊號且處於閒置時初始化
            if ( Signal == MULTU && !busy ) begin
                multiplicand   <= {32'b0, dataA}; // 第一版：被乘數置於低位，準備左移
                multiplier_reg <= dataB;         // 第一版：乘數準備右移
                product        <= 64'b0;
                counter        <= 6'd0;
                busy           <= 1'b1;
            end
            // 運算邏輯：利用 counter 取代 for 迴圈
            else if ( busy ) begin
                if ( counter < 6'd32 ) begin
                    // 1. 測試乘數最後一位元，若為 1 則相加
                    if ( multiplier_reg[0] ) begin
                        product <= product + multiplicand;
                    end
                    // 2. 被乘數左移 1 位
                    multiplicand <= multiplicand << 1;
                    // 3. 乘數右移 1 位
                    multiplier_reg <= multiplier_reg >> 1;
                    
                    // 手動增加計數器，取代 for(i=0; i<32; i++)
                    counter <= counter + 6'd1;
                end
                else begin
                    busy <= 1'b0; // 32 個週期結束，關閉忙碌旗標
                end
            end
        end
    end

    // 輸出的 product 會在 32 週期後穩定，並由 HiLo 暫存器接走
    assign dataOut = product;

endmodule