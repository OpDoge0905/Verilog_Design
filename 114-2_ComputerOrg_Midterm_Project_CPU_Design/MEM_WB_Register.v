`timescale 1ns/1ns
module MEM_WB_Register(clk, reset, wb_in, read_data_in, alu_result_in, write_reg_in, wb_out, read_data_out, alu_result_out, write_reg_out);
    input clk, reset;
    input [1:0] wb_in;
    input [31:0] read_data_in;
    input [31:0] alu_result_in;
    input [4:0] write_reg_in;

    output reg [1:0] wb_out;
    output reg [31:0] read_data_out;
    output reg [31:0] alu_result_out;
    output reg [4:0] write_reg_out;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wb_out <= 2'b0;
            read_data_out <= 32'b0;
            alu_result_out <= 32'b0;
            write_reg_out <= 5'b0;
        end else begin
            wb_out <= wb_in;
            read_data_out <= read_data_in;
            alu_result_out <= alu_result_in;
            write_reg_out <= write_reg_in;
        end
    end
endmodule