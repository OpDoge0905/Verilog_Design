`timescale 1ns/1ns
module PipelinedCPU(clk, reset);
    input clk;
    input reset;

    wire [31:0] pc_out, pc_next, pc_plus_4, inst;

    wire [31:0] if_id_pc_plus_4, if_id_inst;
    wire [4:0] rs, rt, rd;
    wire [31:0] read_data1, read_data2, sign_ext;
    wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump, Multu, Mfhi, Mflo, Jr;
    wire [2:0] ALUOp;
    wire if_id_r_type, if_id_add, if_id_sub, if_id_and, if_id_or, if_id_srl, if_id_slt;
    wire if_id_lw, if_id_sw, if_id_beq, if_id_slti, if_id_multu, if_id_jr;
    wire IF_ID_UsesRs, IF_ID_UsesRt;

    wire PCWrite, IF_ID_Write, IF_ID_Flush, ID_EX_Flush, EX_MEM_Flush, stall_id_ex;
    wire mult_stall;
    wire mult_busy;
    wire mult_start;
    wire mult_done;
    wire PCSrc;
    wire [31:0] jump_target, jr_target, ex_mem_branch_target;
    wire ex_mem_zero;
    wire [2:0] ex_mem_m;

    wire [1:0] id_ex_wb;
    wire [2:0] id_ex_m;
    wire [4:0] id_ex_ex;
    wire [31:0] id_ex_pc_plus_4, id_ex_read_data1, id_ex_read_data2, id_ex_sign_ext;
    wire [4:0] id_ex_rs, id_ex_rt, id_ex_rd;

    wire [1:0] ForwardA, ForwardB;
    wire [31:0] fwd_data1, fwd_data2, alu_dataA, alu_dataB;
    wire [5:0] ex_signal;
    wire [31:0] alu_result, branch_target;
    wire zero, is_multu;
    wire [4:0] write_reg;

    wire [1:0] ex_mem_wb;
    wire [31:0] ex_mem_alu_result, ex_mem_write_data;
    wire [4:0] ex_mem_write_reg;

    wire [31:0] mem_read_data;

    wire [1:0] mem_wb_wb;
    wire [31:0] mem_wb_read_data, mem_wb_alu_result;
    wire [4:0] mem_wb_write_reg;
    wire [31:0] wb_data;

    assign jump_target = {if_id_pc_plus_4[31:28], if_id_inst[25:0], 2'b00};

    assign jr_target = (ex_mem_wb[1] && (ex_mem_write_reg != 5'd0) && (ex_mem_write_reg == rs)) ? ex_mem_alu_result :
                       (mem_wb_wb[1] && (mem_wb_write_reg != 5'd0) && (mem_wb_write_reg == rs)) ? wb_data :
                       read_data1;

    assign pc_next = PCSrc ? ex_mem_branch_target :
                     Jump ? jump_target :
                     Jr ? jr_target :
                     pc_plus_4;

    PC pc_inst(.clk(clk), .reset(reset), .stall(~PCWrite), .next_pc(pc_next), .pc_out(pc_out));
    PC_Adder pc_add_inst(.pc_in(pc_out), .pc_out(pc_plus_4));
    InstructionMemory imem_inst(.addr(pc_out), .inst(inst));

    IF_ID_Register if_id_inst_reg(
        .clk(clk), .reset(reset), .flush(IF_ID_Flush), .stall(~IF_ID_Write),
        .pc_plus_4_in(pc_plus_4), .inst_in(inst),
        .pc_plus_4_out(if_id_pc_plus_4), .inst_out(if_id_inst)
    );

    assign rs = if_id_inst[25:21];
    assign rt = if_id_inst[20:16];
    assign rd = if_id_inst[15:11];

    assign if_id_r_type = (if_id_inst[31:26] == 6'd0);
    assign if_id_add   = if_id_r_type & (if_id_inst[5:0] == 6'd32);
    assign if_id_sub   = if_id_r_type & (if_id_inst[5:0] == 6'd34);
    assign if_id_and   = if_id_r_type & (if_id_inst[5:0] == 6'd36);
    assign if_id_or    = if_id_r_type & (if_id_inst[5:0] == 6'd37);
    assign if_id_srl   = if_id_r_type & (if_id_inst[5:0] == 6'd2);
    assign if_id_slt   = if_id_r_type & (if_id_inst[5:0] == 6'd42);
    assign if_id_multu = if_id_r_type & (if_id_inst[5:0] == 6'd25);
    assign if_id_jr    = if_id_r_type & (if_id_inst[5:0] == 6'd8);
    assign if_id_lw    = (if_id_inst[31:26] == 6'h23);
    assign if_id_sw    = (if_id_inst[31:26] == 6'h2B);
    assign if_id_beq   = (if_id_inst[31:26] == 6'h04);
    assign if_id_slti  = (if_id_inst[31:26] == 6'h0A);

    assign IF_ID_UsesRs = if_id_add | if_id_sub | if_id_and | if_id_or | if_id_slt |
                          if_id_multu | if_id_jr | if_id_lw | if_id_sw | if_id_beq | if_id_slti;
    assign IF_ID_UsesRt = if_id_add | if_id_sub | if_id_and | if_id_or | if_id_srl |
                          if_id_slt | if_id_multu | if_id_sw | if_id_beq;

    Control ctrl_inst(
        .opcode(if_id_inst[31:26]), .funct(if_id_inst[5:0]),
        .RegDst(RegDst), .ALUSrc(ALUSrc), .MemToReg(MemToReg), .RegWrite(RegWrite),
        .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), .Jump(Jump),
        .ALUOp(ALUOp), .Multu(Multu), .Mfhi(Mfhi), .Mflo(Mflo), .Jr(Jr)
    );

    Registers reg_inst(
        .clk(clk), .reset(reset), .RegWrite(mem_wb_wb[1]),
        .read_reg1(rs), .read_reg2(rt), .write_reg(mem_wb_write_reg),
        .write_data(wb_data), .read_data1(read_data1), .read_data2(read_data2)
    );

    SignExtend sign_ext_inst(.in(if_id_inst[15:0]), .out(sign_ext));

    assign write_reg = id_ex_ex[0] ? id_ex_rd : id_ex_rt;

    HazardDetectionUnit hazard_inst(
        .ID_EX_MemRead(id_ex_m[1]), .ID_EX_rt(id_ex_rt), .IF_ID_rs(rs), .IF_ID_rt(rt),
        .IF_ID_UsesRs(IF_ID_UsesRs), .IF_ID_UsesRt(IF_ID_UsesRt),
        .PCSrc(PCSrc), .jump_id(Jump), .jr_id(Jr), .mult_stall(mult_stall),
        .ID_EX_RegWrite(id_ex_wb[1]), .id_ex_write_reg(write_reg),
        .EX_MEM_MemRead(ex_mem_m[1]), .ex_mem_write_reg(ex_mem_write_reg),
        .PCWrite(PCWrite), .IF_ID_Write(IF_ID_Write), .IF_ID_Flush(IF_ID_Flush),
        .ID_EX_Flush(ID_EX_Flush), .EX_MEM_Flush(EX_MEM_Flush), .stall_id_ex(stall_id_ex)
    );

    ID_EX_Register id_ex_inst_reg(
        .clk(clk), .reset(reset), .flush(ID_EX_Flush), .stall(stall_id_ex),
        .wb_in({RegWrite, MemToReg}), .m_in({Branch, MemRead, MemWrite}), .ex_in({ALUOp, ALUSrc, RegDst}),
        .pc_plus_4_in(if_id_pc_plus_4), .read_data1_in(read_data1), .read_data2_in(read_data2),
        .sign_ext_in(sign_ext), .rs_in(rs), .rt_in(rt), .rd_in(rd),
        .wb_out(id_ex_wb), .m_out(id_ex_m), .ex_out(id_ex_ex),
        .pc_plus_4_out(id_ex_pc_plus_4), .read_data1_out(id_ex_read_data1), .read_data2_out(id_ex_read_data2),
        .sign_ext_out(id_ex_sign_ext), .rs_out(id_ex_rs), .rt_out(id_ex_rt), .rd_out(id_ex_rd)
    );

    ALUControl alu_ctrl_inst(.ALUOp(id_ex_ex[4:2]), .funct(id_ex_sign_ext[5:0]), .Signal(ex_signal));

    ForwardingUnit fwd_inst(
        .EX_MEM_RegWrite(ex_mem_wb[1]), .EX_MEM_rd(ex_mem_write_reg),
        .MEM_WB_RegWrite(mem_wb_wb[1]), .MEM_WB_rd(mem_wb_write_reg),
        .ID_EX_rs(id_ex_rs), .ID_EX_rt(id_ex_rt),
        .ForwardA(ForwardA), .ForwardB(ForwardB)
    );

    assign fwd_data1 = (ForwardA == 2'b10) ? ex_mem_alu_result : (ForwardA == 2'b01) ? wb_data : id_ex_read_data1;
    assign fwd_data2 = (ForwardB == 2'b10) ? ex_mem_alu_result : (ForwardB == 2'b01) ? wb_data : id_ex_read_data2;

    assign alu_dataA = (ex_signal == 6'd2) ? {27'b0, id_ex_sign_ext[10:6]} : fwd_data1;
    assign alu_dataB = id_ex_ex[1] ? id_ex_sign_ext : fwd_data2;

    wire [31:0] w_hi_out, w_lo_out, raw_alu_out;

    TotalALU total_alu_inst(
        .clk(clk),
        .reset(reset),
        .mult_start(mult_start),
        .dataA(alu_dataA),
        .dataB(alu_dataB),
        .Signal(ex_signal),
        .dataOut(alu_result),
        .busy(mult_busy),
        .mult_done(mult_done),
        .HiOut(w_hi_out),
        .LoOut(w_lo_out),
        .ALUOut_raw(raw_alu_out)
    );

    assign zero = (raw_alu_out == 32'd0);
    assign is_multu = (ex_signal == 6'd25) & ~PCSrc;

    MultStall mult_stall_inst(
        .clk(clk), .reset(reset), .is_multu(is_multu), .busy(mult_busy),
        .start(mult_start), .stall(mult_stall)
    );

    assign branch_target = id_ex_pc_plus_4 + (id_ex_sign_ext << 2);

    EX_MEM_Register ex_mem_inst_reg(
        .clk(clk), .reset(reset), .flush(EX_MEM_Flush),
        .wb_in(id_ex_wb), .m_in(id_ex_m), .zero_in(zero),
        .alu_result_in(alu_result), .write_data_in(fwd_data2), .write_reg_in(write_reg), .branch_target_in(branch_target),
        .wb_out(ex_mem_wb), .m_out(ex_mem_m), .zero_out(ex_mem_zero),
        .alu_result_out(ex_mem_alu_result), .write_data_out(ex_mem_write_data), .write_reg_out(ex_mem_write_reg), .branch_target_out(ex_mem_branch_target)
    );

    assign PCSrc = ex_mem_m[2] & ex_mem_zero;

    DataMemory dmem_inst(
        .clk(clk), .MemRead(ex_mem_m[1]), .MemWrite(ex_mem_m[0]),
        .addr(ex_mem_alu_result), .write_data(ex_mem_write_data), .read_data(mem_read_data)
    );

    MEM_WB_Register mem_wb_inst_reg(
        .clk(clk), .reset(reset), .wb_in(ex_mem_wb),
        .read_data_in(mem_read_data), .alu_result_in(ex_mem_alu_result), .write_reg_in(ex_mem_write_reg),
        .wb_out(mem_wb_wb), .read_data_out(mem_wb_read_data), .alu_result_out(mem_wb_alu_result), .write_reg_out(mem_wb_write_reg)
    );

    assign wb_data = mem_wb_wb[0] ? mem_wb_read_data : mem_wb_alu_result;

endmodule
