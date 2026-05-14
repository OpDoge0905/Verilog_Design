`timescale 1ns/1ns
module TotalALU( clk, dataA, dataB, Signal, dataOut, reset );
    input clk;
    input reset;
    input [31:0] dataA;
    input [31:0] dataB;
    input [5:0]  Signal;
    output [31:0] dataOut;

    // 內部線路宣告 (連接各模組用)
    wire [31:0] w_alu_out;
    wire [63:0] w_mult_out;
    wire [31:0] w_shifter_out;
    wire [31:0] w_hi_out;
    wire [31:0] w_lo_out;
    
    // 雖然專案沒有明說，但通常會有讀取 Hi/Lo 的指令 (MFHI=16, MFLO=18)
    // 為了讓 MUX 能正確動作，我們保留這兩個訊號的判斷
    wire is_mfhi = (Signal == 6'd16);
    wire is_mflo = (Signal == 6'd18);

    // 1. 實體化 32-bit ALU (組合邏輯)
    // 處理 AND(36), OR(37), ADD(32), SUB(34), SLT(42)
    ALU alu_inst(
        .dataA(dataA), 
        .dataB(dataB), 
        .Signal(Signal), 
        .dataOut(w_alu_out), 
        .reset(reset)
    );

    // 2. 實體化 Multiplier (循序邏輯)
    // 處理 MULTU(25)
    Multiplier mult_inst(
        .clk(clk), 
        .dataA(dataA), 
        .dataB(dataB), 
        .Signal(Signal), 
        .dataOut(w_mult_out)
    );

    // 3. 實體化 HiLo 暫存器 (循序邏輯)
    // 接收 Multiplier 的結果
    HiLo hilo_inst(
        .clk(clk), 
        .reset(reset), 
        .dataIn(w_mult_out), 
        .HiOut(w_hi_out), 
        .LoOut(w_lo_out)
    );

    // 4. 實體化 Shifter (組合邏輯)
    // 處理 SRL(02)
    // 注意：根據 MIPS 慣例，SRL 通常是對 dataB(rt) 進行移位，位移量在 dataA(shamt) 或其他欄位
    // 但為了簡化，這裡假設 dataA 是被移位的資料，dataB 是位移量
    // (請確認 Testbench 的輸入格式，必要時互換 dataA 和 dataB)
    Shifter shifter_inst(
        .dataA(dataA), 
        .dataB(dataB), 
        .Signal(Signal), 
        .dataOut(w_shifter_out)
    );

    // 5. 實體化 MUX (組合邏輯)
    // 選擇最終輸出
    MUX mux_inst(
        .ALUOut(w_alu_out), 
        .HiOut(w_hi_out), 
        .LoOut(w_lo_out), 
        .ShifterOut(w_shifter_out), 
        .Signal(Signal), 
        .dataOut(dataOut)
    );

endmodule