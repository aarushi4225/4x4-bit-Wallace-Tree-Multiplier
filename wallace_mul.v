`timescale 1ns / 1ps

module wallace_mul (
    input  [3:0] a, b,
    output [7:0] out
);

    // --- 1. Generate Partial Products ---
    wire pp [3:0][3:0];
    genvar i, j;
    generate
        for (i = 0; i < 4; i = i + 1) begin: L1
            for (j = 0; j < 4; j = j + 1) begin: L2
                assign pp[i][j] = a[i] & b[j];
                end
         end
    endgenerate

   // Stage 1
    wire s1_1, c1_2; 
    wire s1_2, c1_3;
    wire s1_3, c1_4; 
    wire s1_4, c1_5;

    // HA for Column 1
    ha ha_1_1 (pp[1][0], pp[0][1], s1_1, c1_2);
    // FA for Column 2
    fa fa_1_2 (pp[2][0], pp[1][1], pp[0][2], s1_2, c1_3);
    // FA for Column 3
    fa fa_1_3 (pp[3][0], pp[2][1], pp[1][2], s1_3, c1_4);
    // HA for Column 4
    ha ha_1_4 (pp[3][1], pp[2][2], s1_4, c1_5);


    //Stage 2
    wire s2_2, c2_3;
    wire s2_3, c2_4;
    wire s2_4, c2_5;
    wire s2_5, c2_6;

    // HA for Column 2
    ha ha_2_2 (s1_2, c1_2, s2_2, c2_3);
    // FA for Column 3
    fa fa_2_3 (s1_3, c1_3, pp[0][3], s2_3, c2_4);
    // FA for Column 4
    fa fa_2_4 (s1_4, c1_4, pp[1][3], s2_4, c2_5);
    // FA for Column 5
    fa fa_2_5 (c1_5, pp[3][2], pp[2][3], s2_5, c2_6);
    
    // Final Carry Propagation Stage
    assign out[0] = pp[0][0];
    assign out[1] = s1_1;     
    assign out[2] = s2_2;
    
    wire c3, c4, c5, c6;
    
    ha final_ha3 (s2_3, c2_3, out[3], c3);
    fa final_fa4 (s2_4, c2_4, c3, out[4], c4);
    fa final_fa5 (s2_5, c2_5, c4, out[5], c5);
    fa final_fa6 (pp[3][3], c2_6, c5, out[6], c6);
    assign out[7] = c6;
    

endmodule

//./././././././././././././././././././././././././././././././././././././././
module fa(input a, b, cin, output sum, cout);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module ha(input a, b, output sum, cout);
    assign sum  = a ^ b;
    assign cout = a & b;
endmodule