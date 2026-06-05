`timescale 1ns/1ns
module InstructionMemory(addr, inst);
    input [31:0] addr;
    output [31:0] inst;

    reg [31:0] mem [0:255];

    assign inst = mem[addr[9:2]];
endmodule