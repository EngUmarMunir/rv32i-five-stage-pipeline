`timescale 1ns/1ps

module hazard_detection (
    // ID stage
    input  logic [4:0] rs1_ID,
    input  logic [4:0] rs2_ID,

    // EX stage
    input  logic [4:0] rd_EX,
    input  logic [1:0] ResultSrc_EX,   // 01 = LOAD

    // Control flow
    input  logic Jump_EX,
    input  logic Branch_taken_EX,

    // Outputs
    output logic stall,
    output logic flush
);

    logic lwStall;

    // LOAD-USE HAZARD DETECTION
    assign lwStall =
        (ResultSrc_EX == 2'b01) &&     // LOAD instruction
        (rd_EX != 5'd0) &&
        ((rd_EX == rs1_ID) || (rd_EX == rs2_ID));

    // STALL CONTROL
    assign stall = lwStall;

    // FLUSH CONTROL
    assign flush = Jump_EX || Branch_taken_EX;

endmodule
