`timescale 1ns/1ns
module IF_ID_Register(clk, reset, flush, stall, pc_plus_4_in, inst_in, pc_plus_4_out, inst_out);
    input clk;
    input reset;
    input flush;
    input stall;
    input [31:0] pc_plus_4_in;
    input [31:0] inst_in;
    output reg [31:0] pc_plus_4_out;
    output reg [31:0] inst_out;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_plus_4_out <= 32'b0;
            inst_out <= 32'b0;
        end else if (flush) begin
            pc_plus_4_out <= 32'b0;
            inst_out <= 32'b0;
        end else if (~stall) begin
            pc_plus_4_out <= pc_plus_4_in;
            inst_out <= inst_in;
        end
    end
endmodule