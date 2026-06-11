`timescale 1ns/1ns
module HiLo( clk, reset, write, dataIn, HiOut, LoOut );
    input clk, reset;
    input write;
    input [63:0] dataIn;
    output [31:0] HiOut, LoOut;

    reg [63:0] temp_reg;

    always @(posedge clk or posedge reset) begin
        if (reset)
            temp_reg <= 64'b0;
        else if (write)
            temp_reg <= dataIn;
    end

    assign HiOut = temp_reg[63:32];
    assign LoOut = temp_reg[31:0];

endmodule
