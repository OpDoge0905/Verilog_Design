`timescale 1ns/1ns
module HazardDetectionUnit(
    ID_EX_MemRead, ID_EX_rt, IF_ID_rs, IF_ID_rt,
    IF_ID_UsesRs, IF_ID_UsesRt,
    PCSrc, jump_id, jr_id, mult_stall,
    ID_EX_RegWrite, id_ex_write_reg,
    EX_MEM_MemRead, ex_mem_write_reg,
    PCWrite, IF_ID_Write, IF_ID_Flush, ID_EX_Flush, EX_MEM_Flush, stall_id_ex
);
    input ID_EX_MemRead;
    input [4:0] ID_EX_rt;
    input [4:0] IF_ID_rs;
    input [4:0] IF_ID_rt;
    input IF_ID_UsesRs;
    input IF_ID_UsesRt;
    input PCSrc;
    input jump_id;
    input jr_id;
    input mult_stall;
    input ID_EX_RegWrite;
    input [4:0] id_ex_write_reg;
    input EX_MEM_MemRead;
    input [4:0] ex_mem_write_reg;
    
    output PCWrite;
    output IF_ID_Write;
    output IF_ID_Flush;
    output ID_EX_Flush;
    output EX_MEM_Flush;
    output stall_id_ex;

    wire lw_stall;
    wire jr_stall;

    assign lw_stall = ID_EX_MemRead & (
        (IF_ID_UsesRs & (ID_EX_rt == IF_ID_rs)) |
        (IF_ID_UsesRt & (ID_EX_rt == IF_ID_rt))
    );
    
    assign jr_stall = jr_id & (
        (ID_EX_RegWrite & (id_ex_write_reg != 5'd0) & (id_ex_write_reg == IF_ID_rs)) |
        (EX_MEM_MemRead & (ex_mem_write_reg != 5'd0) & (ex_mem_write_reg == IF_ID_rs))
    );
    
    assign PCWrite = PCSrc | ~(lw_stall | mult_stall | jr_stall);
    assign IF_ID_Write = ~(lw_stall | mult_stall | jr_stall);
    
    assign IF_ID_Flush = PCSrc | jump_id | (jr_id & ~jr_stall);
    assign ID_EX_Flush = PCSrc | jump_id | (jr_id & ~jr_stall) | lw_stall | jr_stall;
    assign EX_MEM_Flush = PCSrc;
    assign stall_id_ex = mult_stall;
endmodule
