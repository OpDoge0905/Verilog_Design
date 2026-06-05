`timescale 1ns/1ns
module Control(opcode, funct, RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp, Multu, Mfhi, Mflo, Jr);
    input [5:0] opcode;
    input [5:0] funct;
    
    output RegDst;
    output ALUSrc;
    output MemToReg;
    output RegWrite;
    output MemRead;
    output MemWrite;
    output Branch;
    output Jump;
    output [2:0] ALUOp;
    output Multu;
    output Mfhi;
    output Mflo;
    output Jr;

    wire R_type;
    wire lw;
    wire sw;
    wire beq;
    wire slti;
    wire j;

    assign R_type = (opcode == 6'd0);
    assign lw     = (opcode == 6'h23);
    assign sw     = (opcode == 6'h2B);
    assign beq    = (opcode == 6'h04);
    assign slti   = (opcode == 6'h0A);
    assign j      = (opcode == 6'h02);

    assign RegDst   = R_type;
    assign ALUSrc   = lw | sw | slti;
    assign MemToReg = lw;
    assign RegWrite = (R_type & ~Jr & ~Multu & ~(R_type & funct == 6'd0)) | lw | slti;
    assign MemRead  = lw;
    assign MemWrite = sw;
    assign Branch   = beq;
    assign Jump     = j;
    
    assign ALUOp[2] = 1'b0;
    assign ALUOp[1] = R_type | slti;
    assign ALUOp[0] = beq | slti;

    assign Multu = R_type & (funct == 6'h19);
    assign Mfhi  = R_type & (funct == 6'h10);
    assign Mflo  = R_type & (funct == 6'h12);
    assign Jr    = R_type & (funct == 6'h08);
endmodule