module EX_MEM (
    input logic clk,
    input logic rest,
    input logic RegWrite_EM,
    input logic MemWrite_EM,
    input logic [1:0] ResultSrc_EM,
    input logic [31:0] ALU_Result_EM,
    input logic [31:0] pc_plus4_EM,
    input logic [2:0] funct3_EM,
    input logic [31:0] read_data2_EM,
    input logic [4:0] rd_EM,

    output logic RegWrite_MEM,
    output logic MemWrite_MEM,
    output logic [1:0] ResultSrc_MEM,
    output logic [31:0] ALU_Result_MEM,
    output logic [31:0] pc_plus4_MEM,
    output logic [2:0] funct3_MEM,
    output logic [31:0] read_data2_MEM,
    output logic [4:0] rd_MEM
);

always_ff @(posedge clk or posedge rest) begin
    if (rest) begin
        RegWrite_MEM   <= 0;
        MemWrite_MEM   <= 0;
        ResultSrc_MEM  <= 2'b00;
        ALU_Result_MEM <= 32'b0;
        pc_plus4_MEM   <= 32'b0;
        funct3_MEM     <= 3'b000;
        read_data2_MEM <= 32'b0;
        rd_MEM         <= 5'b0;
    end else begin
        RegWrite_MEM   <= RegWrite_EM;
        MemWrite_MEM   <= MemWrite_EM;
        ResultSrc_MEM  <= ResultSrc_EM;
        ALU_Result_MEM <= ALU_Result_EM;
        pc_plus4_MEM   <= pc_plus4_EM;
        funct3_MEM     <= funct3_EM;
        read_data2_MEM <= read_data2_EM;
        rd_MEM         <= rd_EM;
    end
end

endmodule
