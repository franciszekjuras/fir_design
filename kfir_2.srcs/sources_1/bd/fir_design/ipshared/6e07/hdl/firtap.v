`timescale 1ns / 1ps

module firtap
    #(parameter XW = 18, COEFW = 25, OUTW = 48, SAMPLE_SHIFT = 1, SUM_SHIFT = 2) //max parameters
    (
    input wire clk,
    input wire [XW-1:0] inX,
    output wire [XW-1:0] outX,
    input wire [COEFW-1:0] inCoef,
    input wire [OUTW-1:0] inSum,
    output wire [OUTW-1:0] outSum
    );
    localparam SUM_LATENCY = 2;

    wire [OUTW-1:0] sum;

    shiftby #(.BY(SAMPLE_SHIFT),.WIDTH(XW)) shiftX (.in(inX), .out(outX), .clk(clk));
    shiftby #(.BY(SUM_SHIFT - SUM_LATENCY),.WIDTH(OUTW)) shiftS (.in(sum), .out(outSum), .clk(clk));

    MACC_MACRO #(
    .DEVICE("7SERIES"),
    .LATENCY(3),
    .WIDTH_A(COEFW),
    .WIDTH_B(XW),
    .WIDTH_P(OUTW)
    ) macc_inst (
    .P(sum),
    .A(inCoef),
    .ADDSUB(1'b1),
    .B(inX),
    .CARRYIN(1'b0),
    .CE(1'b1),
    .CLK(clk),
    .LOAD(1'b1),
    .LOAD_DATA(inSum),
    .RST(1'b0)
    );

endmodule
