// Module: ALU_1bit.v
module ALU_1bit( a, b, cin, less, invertB, op, out, cout );
    input a, b, cin, less, invertB;
    input [2:0] op; // 控制訊號：000(AND), 001(OR), 010(ADD/SUB), 011(SLT)
    output out, cout;

    wire b_in, and_out, or_out, add_out;

    // 實作減法邏輯：若為 SUB，將 B 取反 [cite: 27]
    assign b_in = b ^ invertB;

    // 運算單元
    assign and_out = a & b_in;
    assign or_out  = a | b_in;
    
    // 呼叫 Gate-level Full Adder 
    FullAdder fa( a, b_in, cin, add_out, cout );

    // 4-to-1 多工器 (以 Data Flow 實作) [cite: 41]
    assign out = (op == 3'b000) ? and_out :
                 (op == 3'b001) ? or_out  :
                 (op == 3'b010) ? add_out :
                 (op == 3'b011) ? less    : 1'b0;
endmodule