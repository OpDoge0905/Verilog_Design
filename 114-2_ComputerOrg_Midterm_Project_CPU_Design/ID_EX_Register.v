`timescale 1ns/1ns
module ID_EX_Register(
    clk, reset, flush, stall,
    wb_in, m_in, ex_in,
    pc_plus_4_in, read_data1_in, read_data2_in, sign_ext_in,
    rs_in, rt_in, rd_in,
    wb_out, m_out, ex_out,
    pc_plus_4_out, read_data1_out, read_data2_out, sign_ext_out,
    rs_out, rt_out, rd_out
);
    input clk;
    input reset;
    input flush;
    input stall;
    input [1:0] wb_in;
    input [2:0] m_in;
    input [4:0] ex_in;
    input [31:0] pc_plus_4_in;
    input [31:0] read_data1_in;
    input [31:0] read_data2_in;
    input [31:0] sign_ext_in;
    input [4:0] rs_in;
    input [4:0] rt_in;
    input [4:0] rd_in;

    output reg [1:0] wb_out;
    output reg [2:0] m_out;
    output reg [4:0] ex_out;
    output reg [31:0] pc_plus_4_out;
    output reg [31:0] read_data1_out;
    output reg [31:0] read_data2_out;
    output reg [31:0] sign_ext_out;
    output reg [4:0] rs_out;
    output reg [4:0] rt_out;
    output reg [4:0] rd_out;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wb_out <= 2'b0;
            m_out <= 3'b0;
            ex_out <= 5'b0;
            pc_plus_4_out <= 32'b0;
            read_data1_out <= 32'b0;
            read_data2_out <= 32'b0;
            sign_ext_out <= 32'b0;
            rs_out <= 5'b0;
            rt_out <= 5'b0;
            rd_out <= 5'b0;
        end else if (flush) begin
            wb_out <= 2'b0;
            m_out <= 3'b0;
            ex_out <= 5'b0;
            pc_plus_4_out <= 32'b0;
            read_data1_out <= 32'b0;
            read_data2_out <= 32'b0;
            sign_ext_out <= 32'b0;
            rs_out <= 5'b0;
            rt_out <= 5'b0;
            rd_out <= 5'b0;
        end else if (~stall) begin
            wb_out <= wb_in;
            m_out <= m_in;
            ex_out <= ex_in;
            pc_plus_4_out <= pc_plus_4_in;
            read_data1_out <= read_data1_in;
            read_data2_out <= read_data2_in;
            sign_ext_out <= sign_ext_in;
            rs_out <= rs_in;
            rt_out <= rt_in;
            rd_out <= rd_in;
        end
    end
endmodule