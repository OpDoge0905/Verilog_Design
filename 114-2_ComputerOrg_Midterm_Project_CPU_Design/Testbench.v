`timescale 1ns/1ns
module Testbench();
    reg clk;
    reg reset;

    PipelinedCPU CPU(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 1'b1;
        forever #5 clk = ~clk;
    end

    reg [31:0] wb_pc_tracker_0;
    reg [31:0] wb_pc_tracker_1;
    reg [31:0] wb_pc_tracker_2;
    reg [31:0] wb_pc_tracker_3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wb_pc_tracker_0 <= 32'b0;
            wb_pc_tracker_1 <= 32'b0;
            wb_pc_tracker_2 <= 32'b0;
            wb_pc_tracker_3 <= 32'b0;
        end else begin
            wb_pc_tracker_0 <= CPU.pc_out;
            wb_pc_tracker_1 <= wb_pc_tracker_0;
            wb_pc_tracker_2 <= wb_pc_tracker_1;
            wb_pc_tracker_3 <= wb_pc_tracker_2;
        end
    end

    initial begin
        reset = 1'b1;
        #15;
        reset = 1'b0;
        $readmemh("instr_mem.txt", CPU.imem_inst.mem);
        $readmemh("data_mem.txt", CPU.dmem_inst.mem);
        $readmemh("reg.txt", CPU.reg_inst.reg_file);
        #3000;
        $stop;
    end

    always @(negedge clk) begin
        if (~reset) begin
            if (CPU.inst !== 32'hxxxxxxxx) begin
                $write("# Time: %4d ns | [Fetch] PC: %8x | Inst: %8x ", $time, CPU.pc_out, CPU.inst);
                if (CPU.inst == 32'b0) $write("(NOP)");
                else if (CPU.inst[31:26] == 6'd0) begin
                    case (CPU.inst[5:0])
                        6'd32: $write("(ADD)");
                        6'd34: $write("(SUB)");
                        6'd36: $write("(AND)");
                        6'd37: $write("(OR)");
                        6'd2:  $write("(SRL)");
                        6'd42: $write("(SLT)");
                        6'd25: $write("(MULTU)");
                        6'd16: $write("(MFHI)");
                        6'd18: $write("(MFLO)");
                        6'd8:  $write("(JR)");
                    endcase
                end else begin
                    case (CPU.inst[31:26])
                        6'h23: $write("(LW)");
                        6'h2b: $write("(SW)");
                        6'h04: $write("(BEQ)");
                        6'h0a: $write("(SLTI)");
                        6'h02: $write("(J)");
                    endcase
                end
                $display("");
            end

            if (CPU.mem_wb_wb[1] && CPU.mem_wb_write_reg != 5'd0) begin
                $display("#                   -> [WriteBack] (from PC: %8x) Reg[$%0d] = %8x",
                    wb_pc_tracker_3, CPU.mem_wb_write_reg, CPU.wb_data);
            end

            if (CPU.ex_mem_m[0]) begin
                $display("#                   -> [MemWrite ] (from PC: %8x) Mem[%8x] = %8x",
                    wb_pc_tracker_2, CPU.ex_mem_alu_result, CPU.ex_mem_write_data);
            end
        end
    end
endmodule