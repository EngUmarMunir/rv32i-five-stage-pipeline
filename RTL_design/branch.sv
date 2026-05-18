`timescale 1ns/1ps

module branch (
    input  logic [2:0] funct3,
    input  logic [31:0] rs1,
    input  logic [31:0] rs2,
    input  logic Branch,
    output logic branch_taken
);

logic signed [31:0] s_rs1, s_rs2;

assign s_rs1 = rs1;
assign s_rs2 = rs2;

always_comb begin
    branch_taken = 1'b0;

    if (Branch) begin
        case (funct3)
            3'b000: branch_taken = (rs1 == rs2);   // BEQ
            3'b001: branch_taken = (rs1 != rs2);   // BNE
            3'b100: branch_taken = (s_rs1 < s_rs2); // BLT
            3'b101: branch_taken = (s_rs1 >= s_rs2);// BGE
            3'b110: branch_taken = (rs1 < rs2);     // BLTU
            3'b111: branch_taken = (rs1 >= rs2);    // BGEU
            default: branch_taken = 1'b0;
        endcase
    end
end

endmodule
