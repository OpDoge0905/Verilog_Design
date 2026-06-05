`timescale 1ns/1ns
module PC_Adder(pc_in, pc_out);
    input [31:0] pc_in;
    output [31:0] pc_out;

    assign pc_out = pc_in + 32'd4;
endmodule