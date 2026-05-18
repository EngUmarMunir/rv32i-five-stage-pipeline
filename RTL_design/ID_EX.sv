// Instruction Decode to Execute Pipeline Register
// in which register file, immediate generation, and control signal generation will be done
module ID_EX (
    input logic  clk,
    input logic rest,
    input logic [31:0] pc_DE,
    input logic RegWrite_DE,
    input logic ALUSrc_DE,
    input logic MemWrite_DE,
    input logic [1:0] ResultSrc_DE,
    input logic Branch_DE,
    input logic Jump_DE,
    input logic [1:0] ALU_op_DE,
    input logic [31:0] read_data1_DE,
    input logic [31:0] read_data2_DE,
    input logic [31:0] ImmExt_DE,
    input logic [4:0] rd_DE,
    input logic [1:0] ALUop_DE,
    input logic [2:0] funct3_DE,
    input logic [6:0] funct7_DE,
    // for forwarding logic inputs
    input logic [4:0] rs1_DE,
    input logic [4:0] rs2_DE,
    // for hazard detection inputs
    input logic flush,
    input logic stall,
    //output
    output logic [31:0] pc_EX,
    output logic RegWrite_EX,
    output logic ALUSrc_EX,
    output logic MemWrite_EX,
    output logic [1:0] ResultSrc_EX,
    output logic Branch_EX,
    output logic Jump_EX,
    output logic [1:0] ALU_op_EX,
    output logic [31:0] read_data1_EX,
    output logic [31:0] read_data2_EX,
    output logic [31:0] ImmExt_EX,
    output logic [4:0] rd_EX,
    output logic [1:0] ALUop_EX,
    output logic [2:0] funct3_EX,
    output logic [6:0] funct7_EX,
    // for output forwarding logic
    output logic [4:0] rs1_EX,
    output logic [4:0] rs2_EX
);
always_ff @(posedge clk or posedge rest) begin
    if (rest || flush || stall) begin
        pc_EX <= 32'b0;
        RegWrite_EX <= 0;
        ALUSrc_EX <= 0;
        MemWrite_EX <= 0;
        ResultSrc_EX <= 2'b00;
        Branch_EX <= 0;
        Jump_EX <= 0;
        ALU_op_EX <= 2'b00;
        read_data1_EX <= 32'b0;
        read_data2_EX <= 32'b0;
        ImmExt_EX <= 32'b0;
        rd_EX <= 5'b0;
        ALUop_EX <= 2'b00;
        funct3_EX <= 3'b000;
        funct7_EX <= 7'b0000000;
        rs1_EX <= 5'b0;
        rs2_EX <= 5'b0;
    end else begin
        pc_EX <= pc_DE;
        RegWrite_EX <= RegWrite_DE;
        ALUSrc_EX <= ALUSrc_DE;
        MemWrite_EX <= MemWrite_DE;
        ResultSrc_EX <= ResultSrc_DE;
        Branch_EX <= Branch_DE;
        Jump_EX <= Jump_DE;
        ALU_op_EX <= ALU_op_DE;
        read_data1_EX <= read_data1_DE;
        read_data2_EX <= read_data2_DE;
        ImmExt_EX <= ImmExt_DE;
        rd_EX <= rd_DE;
        ALUop_EX <= ALUop_DE;
        funct3_EX <= funct3_DE;
        funct7_EX <= funct7_DE;
        rs1_EX <= rs1_DE;
        rs2_EX <= rs2_DE;
    end
end
endmodule
