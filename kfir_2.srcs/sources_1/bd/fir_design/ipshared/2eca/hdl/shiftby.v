`timescale 1ns / 1ps

module shiftby
    #(parameter WIDTH = 8, BY = 2)
    (
        input wire clk,
        input wire [WIDTH-1:0] in,
        output wire [WIDTH-1:0] out
    );
    if(BY < 0)
        $fatal(1,"Fatal elab. error: invalid parameter value %d < 0 in shiftby", BY);

    integer k;

    if(BY > 0) begin
        reg [WIDTH-1:0] shift [BY];
        assign out = shift[BY-1];

        always @(posedge clk) 
        begin
            shift[0] <= in;
            for(k = 1; k < BY; k = k + 1) begin
                shift[k] <= shift[k-1];
            end
        end
    end
    if(BY == 0)
        assign out = in;
endmodule