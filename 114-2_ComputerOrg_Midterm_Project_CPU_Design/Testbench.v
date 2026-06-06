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
            if (CPU.inst !== 32'hxx_xx_xx_xx) begin
                $write("Time: %4d ns | [Fetch] PC: %8x | Inst: %8x ", $time, CPU.pc_out, CPU.inst);
                
                if (CPU.inst == 32'b0) $write("(NOP)");
                else if (CPU.inst[31:26] == 6'd0) begin
                    case(CPU.inst[5:0])
                        6'd32: $write("(ADD)");
                        6'd34: $write("(SUB)");
                        6'd36: $write("(AND)");
                        6'd37: $write("(OR)");
                        6'd2 : $write("(SRL)");
                        6'd42: $write("(SLT)");
                        6'd25: $write("(MULTU)");
                        6'd16: $write("(MFHI)");
                        6'd18: $write("(MFLO)");
                        6'd8 : $write("(JR)");
                    endcase
                end
                else case(CPU.inst[31:26])
                    6'h23: $write("(LW)");
                    6'h2b: $write("(SW)");
                    6'h04: $write("(BEQ)");
                    6'h0a: $write("(SLTI)");
                    6'h02: $write("(J)");
                endcase
                $display("");
            end

            if (CPU.mem_wb_wb[1] && CPU.mem_wb_write_reg != 5'd0) begin
                $display("                  -> [WriteBack] Reg[$%0d] = %8x", CPU.mem_wb_write_reg, CPU.wb_data);
            end

            if (CPU.ex_mem_m[0]) begin
                $display("                  -> [MemWrite ] Mem[%8x] = %8x", CPU.ex_mem_alu_result, CPU.ex_mem_write_data);
            end
        end
    end
endmodule