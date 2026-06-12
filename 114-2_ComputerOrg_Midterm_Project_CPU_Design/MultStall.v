`timescale 1ns/1ns
module MultStall(clk, reset, is_multu, busy, start, stall);
    input clk;
    input reset;
    input is_multu;
    input busy;
    output start;
    output stall;

    reg started;

    assign start = (~reset) & is_multu & ~started & ~busy;
    assign stall = (~reset) & (busy | (is_multu & ~started & ~busy));

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            started <= 1'b0;
        end else if (start) begin
            started <= 1'b1;
        end else if (started & ~busy) begin
            started <= 1'b0;
        end
    end
endmodule