`timescale 1ns/1ns
module ALU( dataA, dataB, Signal, dataOut, reset );
    input  [31:0] dataA;
    input  [31:0] dataB;
    input  [5:0]  Signal;
    input         reset;
    output [31:0] dataOut;

    wire [31:0] result;
    wire [32:0] carry;
    wire [2:0]  alu_op;
    wire        invertB;
    wire        set_less;

    assign invertB = (Signal == 6'd34 || Signal == 6'd42); // SUB 或是 SLT 時，B 需取反

    assign alu_op = (Signal == 6'd36) ? 3'b000 : // AND
                    (Signal == 6'd37) ? 3'b001 : // OR
                    (Signal == 6'd42) ? 3'b011 : // SLT
                    3'b010;                      // ADD/SUB 預設

    assign carry[0] = invertB;

    assign set_less = dataA[31] ^ (dataB[31] ^ invertB) ^ carry[31];

    ALU_1bit slice0  ( .a(dataA[0]),  .b(dataB[0]),  .cin(carry[0]),  .less(set_less), .invertB(invertB), .op(alu_op), .out(result[0]),  .cout(carry[1])  );
    ALU_1bit slice1  ( .a(dataA[1]),  .b(dataB[1]),  .cin(carry[1]),  .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[1]),  .cout(carry[2])  );
    ALU_1bit slice2  ( .a(dataA[2]),  .b(dataB[2]),  .cin(carry[2]),  .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[2]),  .cout(carry[3])  );
    ALU_1bit slice3  ( .a(dataA[3]),  .b(dataB[3]),  .cin(carry[3]),  .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[3]),  .cout(carry[4])  );
    ALU_1bit slice4  ( .a(dataA[4]),  .b(dataB[4]),  .cin(carry[4]),  .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[4]),  .cout(carry[5])  );
    ALU_1bit slice5  ( .a(dataA[5]),  .b(dataB[5]),  .cin(carry[5]),  .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[5]),  .cout(carry[6])  );
    ALU_1bit slice6  ( .a(dataA[6]),  .b(dataB[6]),  .cin(carry[6]),  .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[6]),  .cout(carry[7])  );
    ALU_1bit slice7  ( .a(dataA[7]),  .b(dataB[7]),  .cin(carry[7]),  .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[7]),  .cout(carry[8])  );
    ALU_1bit slice8  ( .a(dataA[8]),  .b(dataB[8]),  .cin(carry[8]),  .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[8]),  .cout(carry[9])  );
    ALU_1bit slice9  ( .a(dataA[9]),  .b(dataB[9]),  .cin(carry[9]),  .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[9]),  .cout(carry[10]) );
    ALU_1bit slice10 ( .a(dataA[10]), .b(dataB[10]), .cin(carry[10]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[10]), .cout(carry[11]) );
    ALU_1bit slice11 ( .a(dataA[11]), .b(dataB[11]), .cin(carry[11]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[11]), .cout(carry[12]) );
    ALU_1bit slice12 ( .a(dataA[12]), .b(dataB[12]), .cin(carry[12]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[12]), .cout(carry[13]) );
    ALU_1bit slice13 ( .a(dataA[13]), .b(dataB[13]), .cin(carry[13]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[13]), .cout(carry[14]) );
    ALU_1bit slice14 ( .a(dataA[14]), .b(dataB[14]), .cin(carry[14]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[14]), .cout(carry[15]) );
    ALU_1bit slice15 ( .a(dataA[15]), .b(dataB[15]), .cin(carry[15]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[15]), .cout(carry[16]) );
    ALU_1bit slice16 ( .a(dataA[16]), .b(dataB[16]), .cin(carry[16]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[16]), .cout(carry[17]) );
    ALU_1bit slice17 ( .a(dataA[17]), .b(dataB[17]), .cin(carry[17]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[17]), .cout(carry[18]) );
    ALU_1bit slice18 ( .a(dataA[18]), .b(dataB[18]), .cin(carry[18]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[18]), .cout(carry[19]) );
    ALU_1bit slice19 ( .a(dataA[19]), .b(dataB[19]), .cin(carry[19]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[19]), .cout(carry[20]) );
    ALU_1bit slice20 ( .a(dataA[20]), .b(dataB[20]), .cin(carry[20]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[20]), .cout(carry[21]) );
    ALU_1bit slice21 ( .a(dataA[21]), .b(dataB[21]), .cin(carry[21]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[21]), .cout(carry[22]) );
    ALU_1bit slice22 ( .a(dataA[22]), .b(dataB[22]), .cin(carry[22]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[22]), .cout(carry[23]) );
    ALU_1bit slice23 ( .a(dataA[23]), .b(dataB[23]), .cin(carry[23]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[23]), .cout(carry[24]) );
    ALU_1bit slice24 ( .a(dataA[24]), .b(dataB[24]), .cin(carry[24]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[24]), .cout(carry[25]) );
    ALU_1bit slice25 ( .a(dataA[25]), .b(dataB[25]), .cin(carry[25]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[25]), .cout(carry[26]) );
    ALU_1bit slice26 ( .a(dataA[26]), .b(dataB[26]), .cin(carry[26]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[26]), .cout(carry[27]) );
    ALU_1bit slice27 ( .a(dataA[27]), .b(dataB[27]), .cin(carry[27]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[27]), .cout(carry[28]) );
    ALU_1bit slice28 ( .a(dataA[28]), .b(dataB[28]), .cin(carry[28]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[28]), .cout(carry[29]) );
    ALU_1bit slice29 ( .a(dataA[29]), .b(dataB[29]), .cin(carry[29]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[29]), .cout(carry[30]) );
    ALU_1bit slice30 ( .a(dataA[30]), .b(dataB[30]), .cin(carry[30]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[30]), .cout(carry[31]) );
    ALU_1bit slice31 ( .a(dataA[31]), .b(dataB[31]), .cin(carry[31]), .less(1'b0),     .invertB(invertB), .op(alu_op), .out(result[31]), .cout(carry[32]) );

    assign dataOut = reset ? 32'b0 : result;

endmodule