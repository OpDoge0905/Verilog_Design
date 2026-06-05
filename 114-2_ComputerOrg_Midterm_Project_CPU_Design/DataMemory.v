`timescale 1ns/1ns
module DataMemory(clk, MemRead, MemWrite, addr, write_data, read_data);
    input clk;
    input MemRead;
    input MemWrite;
    input [31:0] addr;
    input [31:0] write_data;
    output [31:0] read_data;

    reg [31:0] mem [0:255];

    assign read_data = MemRead ? mem[addr[9:2]] : 32'd0;

    always @(posedge clk) begin
        if (MemWrite) begin
            mem[addr[9:2]] <= write_data;
        end
    end
endmodule