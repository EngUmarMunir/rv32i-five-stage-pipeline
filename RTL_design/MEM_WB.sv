// Module for MEM/WB pipeline register
module MEM_WB (
    input logic clk,
    input logic rest,
    input logic RegWrite_ME,
    input logic [1:0] ResultSrc_ME,
    input logic [31:0] ALU_Result_ME,
    input logic [31:0] pc_plus4_ME,
    input  logic [31:0] Data_r_ME,
    input logic [4:0] rd_ME,
    output logic RegWrite_WB,
    output logic [1:0] ResultSrc_WB,
    output logic [31:0] ALU_Result_WB,
    output logic [31:0] pc_plus4_WB,
    output logic [31:0] Data_r_WB,
    output logic [4:0] rd_WB
);
always_ff @(posedge clk or posedge rest) begin
    if (rest) begin
        RegWrite_WB <= 0;
        ResultSrc_WB <= 2'b00;
        ALU_Result_WB <= 32'b0;
        pc_plus4_WB <= 32'b0;
        Data_r_WB <= 32'b0;
        rd_WB <= 5'b0;
    end else begin
        RegWrite_WB <= RegWrite_ME;
        ResultSrc_WB <= ResultSrc_ME;
        ALU_Result_WB <= ALU_Result_ME;
        pc_plus4_WB <= pc_plus4_ME;
        Data_r_WB <= Data_r_ME;
        rd_WB <= rd_ME;
    end
end
endmodule
