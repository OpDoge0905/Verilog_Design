`timescale 1ns/1ns
module Registers(clk, reset, RegWrite, read_reg1, read_reg2, write_reg, write_data, read_data1, read_data2);
    input clk;
    input reset;
    input RegWrite;
    input [4:0] read_reg1;
    input [4:0] read_reg2;
    input [4:0] write_reg;
    input [31:0] write_data;
    output [31:0] read_data1;
    output [31:0] read_data2;

    reg [31:0] reg_file [0:31];

    assign read_data1 = (read_reg1 == 5'd0) ? 32'd0 : reg_file[read_reg1];
    assign read_data2 = (read_reg2 == 5'd0) ? 32'd0 : reg_file[read_reg2];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_file[0] <= 32'd0;
            reg_file[1] <= 32'd0;
            reg_file[2] <= 32'd0;
            reg_file[3] <= 32'd0;
            reg_file[4] <= 32'd0;
            reg_file[5] <= 32'd0;
            reg_file[6] <= 32'd0;
            reg_file[7] <= 32'd0;
            reg_file[8] <= 32'd0;
            reg_file[9] <= 32'd0;
            reg_file[10] <= 32'd0;
            reg_file[11] <= 32'd0;
            reg_file[12] <= 32'd0;
            reg_file[13] <= 32'd0;
            reg_file[14] <= 32'd0;
            reg_file[15] <= 32'd0;
            reg_file[16] <= 32'd0;
            reg_file[17] <= 32'd0;
            reg_file[18] <= 32'd0;
            reg_file[19] <= 32'd0;
            reg_file[20] <= 32'd0;
            reg_file[21] <= 32'd0;
            reg_file[22] <= 32'd0;
            reg_file[23] <= 32'd0;
            reg_file[24] <= 32'd0;
            reg_file[25] <= 32'd0;
            reg_file[26] <= 32'd0;
            reg_file[27] <= 32'd0;
            reg_file[28] <= 32'd0;
            reg_file[29] <= 32'd0;
            reg_file[30] <= 32'd0;
            reg_file[31] <= 32'd0;
        end else if (RegWrite && write_reg != 5'd0) begin
            reg_file[write_reg] <= write_data;
        end
    end
endmodule