`timescale 1ns / 1ps

module flag_cross_domain(
    input CA,
    input FA,
    output BusyA,
    input CB,
    output FB
    );

    reg FlagToggle_clkA;
    always @(posedge CA) FlagToggle_clkA <= FlagToggle_clkA ^ (FA & ~BusyA);

    reg [2:0] SyncA_clkB;
    always @(posedge CB) SyncA_clkB <= {SyncA_clkB[1:0], FlagToggle_clkA};

    reg [1:0] SyncB_clkA;
    always @(posedge CA) SyncB_clkA <= {SyncB_clkA[0], SyncA_clkB[2]};

    assign FB = (SyncA_clkB[2] ^ SyncA_clkB[1]);
    assign BusyA = FlagToggle_clkA ^ SyncB_clkA[1];
endmodule