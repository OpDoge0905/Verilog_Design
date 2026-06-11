`timescale 1ns/1ns
module ForwardingUnit(EX_MEM_RegWrite, EX_MEM_rd, MEM_WB_RegWrite, MEM_WB_rd, ID_EX_rs, ID_EX_rt, ForwardA, ForwardB);
    input EX_MEM_RegWrite;
    input [4:0] EX_MEM_rd;
    input MEM_WB_RegWrite;
    input [4:0] MEM_WB_rd;
    input [4:0] ID_EX_rs;
    input [4:0] ID_EX_rt;
    output [1:0] ForwardA;
    output [1:0] ForwardB;

    wire ex_mem_a;
    wire ex_mem_b;
    wire mem_wb_a;
    wire mem_wb_b;

    assign ex_mem_a = EX_MEM_RegWrite & (EX_MEM_rd != 5'd0) & (EX_MEM_rd == ID_EX_rs);
    assign ex_mem_b = EX_MEM_RegWrite & (EX_MEM_rd != 5'd0) & (EX_MEM_rd == ID_EX_rt);

    assign mem_wb_a = MEM_WB_RegWrite & (MEM_WB_rd != 5'd0) & ~(EX_MEM_RegWrite & (EX_MEM_rd != 5'd0) & (EX_MEM_rd == ID_EX_rs)) & (MEM_WB_rd == ID_EX_rs);
    assign mem_wb_b = MEM_WB_RegWrite & (MEM_WB_rd != 5'd0) & ~(EX_MEM_RegWrite & (EX_MEM_rd != 5'd0) & (EX_MEM_rd == ID_EX_rt)) & (MEM_WB_rd == ID_EX_rt);

    assign ForwardA = ex_mem_a ? 2'b10 : (mem_wb_a ? 2'b01 : 2'b00);
    assign ForwardB = ex_mem_b ? 2'b10 : (mem_wb_b ? 2'b01 : 2'b00);
endmodule