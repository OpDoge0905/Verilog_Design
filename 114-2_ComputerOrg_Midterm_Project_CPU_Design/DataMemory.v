`timescale 1ns/1ns
module DataMemory(clk, MemRead, MemWrite, addr, write_data, read_data);
    input clk;
    input MemRead;
    input MemWrite;
    input [31:0] addr;
    input [31:0] write_data;
    output [31:0] read_data;

    reg [7:0] mem [0:1023];

    assign read_data = MemRead ? {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]} : 32'd0;

    always @(posedge clk) begin
        if (MemWrite) begin
            mem[addr]   <= write_data[31:24];
            mem[addr+1] <= write_data[23:16];
            mem[addr+2] <= write_data[15:8];
            mem[addr+3] <= write_data[7:0];
        end
    end
endmodule