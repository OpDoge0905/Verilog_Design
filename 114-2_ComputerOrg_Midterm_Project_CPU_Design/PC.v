`timescale 1ns/1ns
module PC(clk, reset, stall, next_pc, pc_out);
    input clk;
    input reset;
    input stall;
    input [31:0] next_pc;
    output reg [31:0] pc_out;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'b0;
        end else if (~stall) begin
            pc_out <= next_pc;
        end
    end
endmodule