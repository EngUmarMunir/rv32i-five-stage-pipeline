`timescale 1ns/1ps

module fwd_logic (
    // EX stage sources
    input  logic [4:0] rs1_EX,
    input  logic [4:0] rs2_EX,

    // MEM stage
    input  logic [4:0] rd_MEM,
    input  logic       RegWrite_MEM,

    // WB stage
    input  logic [4:0] rd_WB,
    input  logic       RegWrite_WB,

    // Outputs to ALU muxes
    output logic [1:0] forwardA,
    output logic [1:0] forwardB
);

    always_comb begin
        // Forward A (rs1_EX)
        if (RegWrite_MEM && (rd_MEM != 5'd0) && (rd_MEM == rs1_EX))
            forwardA = 2'b10;  // from MEM stage
        else if (RegWrite_WB && (rd_WB != 5'd0) && (rd_WB == rs1_EX))
            forwardA = 2'b01;  // from WB stage
        else
            forwardA = 2'b00;  // no forwarding

        // Forward B (rs2_EX)
        if (RegWrite_MEM && (rd_MEM != 5'd0) && (rd_MEM == rs2_EX))
            forwardB = 2'b10;  // from MEM stage
        else if (RegWrite_WB && (rd_WB != 5'd0) && (rd_WB == rs2_EX))
            forwardB = 2'b01;  // from WB stage
        else
            forwardB = 2'b00;  // no forwarding
    end

endmodule
