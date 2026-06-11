`timescale 1ns/1ns
module MultStall(clk, reset, is_multu, busy, start, stall);
    input clk;
    input reset;
    input is_multu;
    input busy;
    output start;
    output stall;

    reg waiting;

    assign start = is_multu & ~waiting & ~busy;
    assign stall = start | busy;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            waiting <= 1'b0;
        end else if (start) begin
            waiting <= 1'b1;
        end else if (waiting & ~busy) begin
            waiting <= 1'b0;
        end
    end
endmodule
