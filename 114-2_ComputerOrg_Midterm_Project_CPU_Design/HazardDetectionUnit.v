`timescale 1ns/1ns
module HazardDetectionUnit(
    ID_EX_MemRead, ID_EX_rt, IF_ID_rs, IF_ID_rt,
    PCSrc, jump_id, jr_id, mult_stall,
    PCWrite, IF_ID_Write, IF_ID_Flush, ID_EX_Flush, EX_MEM_Flush, stall_id_ex
);
    input ID_EX_MemRead;
    input [4:0] ID_EX_rt;
    input [4:0] IF_ID_rs;
    input [4:0] IF_ID_rt;
    input PCSrc;
    input jump_id;
    input jr_id;
    input mult_stall;
    
    output PCWrite;
    output IF_ID_Write;
    output IF_ID_Flush;
    output ID_EX_Flush;
    output EX_MEM_Flush;
    output stall_id_ex;

    wire lw_stall;

    assign lw_stall = ID_EX_MemRead & ((ID_EX_rt == IF_ID_rs) | (ID_EX_rt == IF_ID_rt));
    
    assign PCWrite = ~(lw_stall | mult_stall);
    assign IF_ID_Write = ~(lw_stall | mult_stall);
    
    assign IF_ID_Flush = PCSrc | jump_id | jr_id;
    assign ID_EX_Flush = PCSrc | lw_stall;
    assign EX_MEM_Flush = PCSrc;
    assign stall_id_ex = mult_stall;
endmodule