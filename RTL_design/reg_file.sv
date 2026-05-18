// module register file
`timescale 1ns/1ps
module reg_file (
    input logic clk,
    input logic rest,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic [31:0] data_w,
    input logic RegWrite,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);
    reg [31:0] registers [32]; // 32 registers of 32 bits each
integer i;

// read data from registers
assign read_data1 = registers[rs1];
assign read_data2 = registers[rs2];

// initialize registers to 0 on reset
always_ff @(negedge clk or posedge rest) begin
    if (rest) begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'b0;
        end
    end else if (RegWrite && rd != 5'b0) begin
        registers[rd] <= data_w; // Don't write to x0 (register 0)
    end
end


endmodule
