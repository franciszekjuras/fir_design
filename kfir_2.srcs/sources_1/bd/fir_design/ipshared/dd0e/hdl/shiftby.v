`timescale 1ns / 1ps

module shiftby
    #(parameter WIDTH = 8, BY = 2)
    (
        input wire clk,
        input wire [WIDTH-1:0] in,
        output wire [WIDTH-1:0] out
    );
    integer k;

    reg [WIDTH-1:0] shift [BY-1:0];
    assign out = shift[BY-1];

    always @(posedge clk) 
    begin
        shift[0] <= in;
        for(k = 1; k < BY; k = k + 1) begin
            shift[k] <= shift[k-1];
        end
    end
endmodule
