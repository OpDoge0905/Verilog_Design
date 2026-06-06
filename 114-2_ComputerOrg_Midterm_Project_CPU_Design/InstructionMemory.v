`timescale 1ns/1ns
module InstructionMemory(addr, inst);
    input [31:0] addr;
    output [31:0] inst;

    reg [7:0] mem [0:1023];

    assign inst = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
endmodule