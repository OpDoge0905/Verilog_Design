`timescale 1ns/1ns
module tb_ALU();
    reg clk;
    reg reset;
    reg [31:0] dataA;
    reg [31:0] dataB;
    reg [5:0]  Signal;
    wire [31:0] dataOut;

    TotalALU uut(
        .clk(clk),
        .dataA(dataA),
        .dataB(dataB),
        .Signal(Signal),
        .dataOut(dataOut),
        .reset(reset)
    );

    always #5 clk = ~clk;

    integer file_in;
    integer scan_count;

    initial begin
        clk = 0;
        reset = 1;
        dataA = 0;
        dataB = 0;
        Signal = 0;

        #15 reset = 0;

        file_in = $fopen("input.txt", "r");
        if (file_in == 0) begin
            $display("??? input.txt");
            $stop;
        end

        while (!$feof(file_in)) begin
            // ?? fscanf ????????
            scan_count = $fscanf(file_in, "%d %d %d\n", Signal, dataA, dataB);
            
            if (scan_count == 3) begin
                if (Signal == 6'd25) begin
                    #350; // MULTU ??????
                end else begin
                    #10;
                end
                $display("Signal=%2d | A=%3d, B=%3d | Out=%3d", Signal, dataA, dataB, dataOut);
            end
        end

        $fclose(file_in);
        $stop;
    end
endmodule