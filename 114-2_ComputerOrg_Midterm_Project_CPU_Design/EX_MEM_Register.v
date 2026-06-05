`timescale 1ns/1ns
module EX_MEM_Register(
    clk, reset, flush,
    wb_in, m_in, zero_in, alu_result_in, write_data_in, write_reg_in, branch_target_in,
    wb_out, m_out, zero_out, alu_result_out, write_data_out, write_reg_out, branch_target_out
);
    input clk, reset, flush;
    input [1:0] wb_in;
    input [2:0] m_in;
    input zero_in;
    input [31:0] alu_result_in;
    input [31:0] write_data_in;
    input [4:0] write_reg_in;
    input [31:0] branch_target_in;

    output reg [1:0] wb_out;
    output reg [2:0] m_out;
    output reg zero_out;
    output reg [31:0] alu_result_out;
    output reg [31:0] write_data_out;
    output reg [4:0] write_reg_out;
    output reg [31:0] branch_target_out;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wb_out <= 2'b0;
            m_out <= 3'b0;
            zero_out <= 1'b0;
            alu_result_out <= 32'b0;
            write_data_out <= 32'b0;
            write_reg_out <= 5'b0;
            branch_target_out <= 32'b0;
        end else if (flush) begin
            wb_out <= 2'b0;
            m_out <= 3'b0;
            zero_out <= 1'b0;
            alu_result_out <= 32'b0;
            write_data_out <= 32'b0;
            write_reg_out <= 5'b0;
            branch_target_out <= 32'b0;
        end else begin
            wb_out <= wb_in;
            m_out <= m_in;
            zero_out <= zero_in;
            alu_result_out <= alu_result_in;
            write_data_out <= write_data_in;
            write_reg_out <= write_reg_in;
            branch_target_out <= branch_target_in;
        end
    end
endmodule