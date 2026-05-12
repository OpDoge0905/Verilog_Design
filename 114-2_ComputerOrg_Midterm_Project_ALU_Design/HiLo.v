`timescale 1ns/1ns
module HiLo( clk, reset, dataIn, HiOut, LoOut );
    input clk, reset;
    input [63:0] dataIn; // 來自 Multiplier 的結果
    output [31:0] HiOut, LoOut;

    reg [63:0] temp_reg;

    // 循序邏輯：僅使用 Clock 正緣觸發
    always @( posedge clk ) begin
        if ( reset ) begin
            temp_reg <= 64'b0;
        end
        else begin
            temp_reg <= dataIn;
        end
    end

    // 將 64-bit 暫存器拆分為 Hi 與 Lo 輸出
    assign HiOut = temp_reg[63:32];
    assign LoOut = temp_reg[31:0];

endmodule