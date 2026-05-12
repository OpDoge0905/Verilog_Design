module ALU_1bit( a, b, cin, less, invertB, op, out, cout );
    input  a, b, cin, less, invertB;
    input  [2:0] op;
    output out, cout;

    wire b_inv, and_out, or_out, add_out;

    xor  g_inv( b_inv,   b,     invertB );

    and  g_and( and_out, a,     b_inv   );
    or   g_or ( or_out,  a,     b_inv   );

    FullAdder FA( .a(a), .b(b_inv), .cin(cin), .sum(add_out), .cout(cout) );

    assign out = (op == 3'b000) ? and_out :
                 (op == 3'b001) ? or_out  :
                 (op == 3'b010) ? add_out :
                 (op == 3'b011) ? less    : 1'b0;

endmodule