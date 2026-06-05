`timescale 1ns/1ns
module ALUControl(ALUOp, funct, Signal);
    input [2:0] ALUOp;
    input [5:0] funct;
    output [5:0] Signal;

    assign Signal = (ALUOp == 3'b000) ? 6'd32 :
                    (ALUOp == 3'b001) ? 6'd34 :
                    (ALUOp == 3'b011) ? 6'd42 :
                    funct;
endmodule