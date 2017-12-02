`timescale 1ns / 1ps

module firtap
    #(parameter XW = 25, COEFW = 18, OUTW = 48) //max parameters
    (
    input wire clk,
    input wire [XW-1:0] inX,
    output wire [XW-1:0] outX,
    input wire [COEFW-1:0] inCoef,
    input wire [OUTW-1:0] acc,
    output wire [OUTW-1:0] out
    );
    wire [OUTW-1:0] sum;

    shiftby #(.BY(2),.WIDTH(XW)) shiftX (.in(inX), .out(outX), .clk(clk));
    shiftby #(.BY(3-2),.WIDTH(XW)) shiftS (.in(sum), .out(out), .clk(clk));
    
    MACC_MACRO #(
    .DEVICE("7SERIES"),
    .LATENCY(3),
    .WIDTH_A(XW),
    .WIDTH_B(COEFW),
    .WIDTH_P(OUTW)
    ) macc_inst (
    .P(out),
    .A(inX),
    .ADDSUB(1'b1),
    .B(inCoef),
    .CARRYIN(1'b0),
    .CE(1'b1),
    .CLK(clk),
    .LOAD(1'b1),
    .LOAD_DATA(acc),
    .RST(1'b0)
    );

endmodule
