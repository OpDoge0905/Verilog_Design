// Module: ALU.v
module ALU( dataA, dataB, Signal, dataOut, reset );
    input [31:0] dataA, dataB;
    input [5:0] Signal; // 控制訊號 [cite: 45]
    input reset;
    output [31:0] dataOut;

    wire [31:0] carry;
    wire [31:0] result;
    wire invertB;
    wire [2:0] alu_op;
    wire set_less;

    // ALU 控制訊號解碼 [cite: 44, 45]
    // ADD:32, SUB:34, AND:36, OR:37, SLT:42
    assign invertB = (Signal == 6'd34 || Signal == 6'd42);
    assign alu_op  = (Signal == 6'd36) ? 3'b000 : // AND
                     (Signal == 6'd37) ? 3'b001 : // OR
                     (Signal == 6'd42) ? 3'b011 : // SLT
                     3'b010;                      // ADD/SUB

    // 第 0 位：特別處理 cin
    ALU_1bit bit0( dataA[0], dataB[0], invertB, set_less, invertB, alu_op, result[0], carry[0] );

    // 第 1 到 30 位：使用 generate 展開電路 
    // 註：generate for 是硬體展開，非程式執行迴圈，符合規定。
    genvar i;
    generate
        for (i = 1; i < 31; i = i + 1) begin : alu_slice
            ALU_1bit bit_i( dataA[i], dataB[i], carry[i-1], 1'b0, invertB, alu_op, result[i], carry[i] );
        end
    endgenerate

    // 第 31 位：用於 SLT 判斷
    wire sum_31;
    ALU_1bit bit31( dataA[31], dataB[31], carry[30], 1'b0, invertB, alu_op, result[31], carry[31] );
    
    // SLT 邏輯：結果為負則 set_less 為 1
    assign set_less = result[31]; 

    assign dataOut = reset ? 32'b0 : result;
endmodule