//write alu control module
`timescale 1ns/1ps
module alu_ctrl (
    input logic [1:0] ALUop,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output logic [3:0] operation
);
always_comb begin
    case (ALUop)
        2'b00: operation = 4'b0010; // load/store (add)
        2'b01: operation = 4'b0110; // branch (subtract)
        2'b10: begin // R-type
            case ({funct7, funct3})
                10'b0000000_000: operation = 4'b0010; // ADD
                10'b0100000_000: operation = 4'b0110; // SUB
                10'b0000000_001: operation = 4'b0011; // SLL
                10'b0000000_010: operation = 4'b0100; // SLT
                10'b0000000_011: operation = 4'b0101; // SLTU
                10'b0000000_100: operation = 4'b1110; // XOR
                10'b0000000_101: operation = 4'b0111; // SRL
                10'b0100000_101: operation = 4'b1000; // SRA
                10'b0000000_111: operation = 4'b1001; // AND
                10'b0000000_110: operation = 4'b1010; // OR
                default: operation = 4'b0000; // default to AND
            endcase
        end
        2'b11: begin // I-type
            case (funct3)
                3'b000: operation = 4'b0010; // ADDI
                3'b001: operation = 4'b0011; // SLLI
                3'b010: operation = 4'b0100; // SLTI
                3'b011: operation = 4'b0101; // SLTIU
                3'b100: operation = 4'b1110; // XORI
                3'b110: operation = 4'b1010; // ORI
                3'b111: operation = 4'b1001; // ANDI
                default: operation = 4'b0000; // default to AND
            endcase
            if (funct3 == 3'b101) begin // SRLI/SRAI
                if (funct7 == 7'b0000000) begin
                    operation = 4'b0111; // SRLI
                end else if (funct7 == 7'b0100000) begin
                    operation = 4'b1000; // SRAI
                end
            end
        end
        default: operation = 4'b0000; // default to AND
    endcase
end
endmodule