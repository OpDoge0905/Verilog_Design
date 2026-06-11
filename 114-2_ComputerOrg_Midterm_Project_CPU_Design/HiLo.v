`timescale 1ns/1ns
module HiLo( clk, reset, write, dataIn, HiOut, LoOut );
    input clk, reset;
    input write;
    input [63:0] dataIn; 
    output [31:0] HiOut, LoOut;

    reg [63:0] temp_reg;

    always @( posedge clk ) begin
        if ( reset ) begin
            temp_reg <= 64'b0;
        end
        else if ( write ) begin
            temp_reg <= dataIn;
        end
    end

    assign HiOut = temp_reg[63:32];
    assign LoOut = temp_reg[31:0];

endmodule
