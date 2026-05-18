// Instruction Fetch to Instruction Decode Pipeline Register
module IF_ID (
    input logic clk,
    input logic rest,
    input logic [31:0] pc_in_IF,
    input logic [31:0] inst_in_IF,
    input logic [4:0] rs1_IF,
    input logic [4:0] rs2_IF,
    input logic flush,
    input logic stall,
    output logic [31:0] pc_out_ID,
    output logic [31:0] inst_out_ID,
    output logic [4:0] rs1_ID,
    output logic [4:0] rs2_ID
);

always_ff @(posedge clk or posedge rest) begin
    if (rest || flush) begin
        pc_out_ID <= 32'b0;
        inst_out_ID <= 32'b0;
        rs1_ID <= 5'b0;
        rs2_ID <= 5'b0;
    end else if (!stall) begin
        pc_out_ID <= pc_in_IF;
        inst_out_ID <= inst_in_IF;
        rs1_ID <= rs1_IF;
        rs2_ID <= rs2_IF;
    end
end
endmodule
