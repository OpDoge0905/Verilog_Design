`timescale 1ns/1ns
module MultStall(clk, reset, is_multu, stall);
    input clk;
    input reset;
    input is_multu;
    output stall;

    reg [5:0] count;

    assign stall = is_multu & (count != 6'd32);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 6'd0;
        end else if (is_multu) begin
            if (count != 6'd32) begin
                count <= count + 6'd1;
            end
        end else begin
            count <= 6'd0;
        end
    end
endmodule