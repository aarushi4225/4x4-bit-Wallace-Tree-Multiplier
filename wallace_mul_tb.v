`timescale 1ns / 1ps

module wallace_mul_tb;
    reg [3:0] a, b;
    wire [7:0] out;

    wallace_mul dut (
        .a(a), 
        .b(b), 
        .out(out)
    );

    initial begin
        
        a <= 4'd0; 
        b <= 4'd0;
 
        #10 a <= 4'd2; 
            b <= 4'd3;

        #10 a <= 4'd4; 
            b <= 4'd5;
        
        #10 a <= 4'd6; 
            b <= 4'd9;
        
        #10 a <= 4'd7; 
            b <= 4'd8;
        
        #10 a <= 4'd10; 
            b <= 4'd10;
            
        #10 a <= 4'd13; 
            b <= 4'd12;
        
        #10 a <= 4'd14; 
            b <= 4'd11;
            
        #10 a <= 4'd15; 
            b <= 4'd15;
            
        
        #10 $finish;
    end

endmodule