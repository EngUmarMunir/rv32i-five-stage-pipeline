// write main control module
`timescale 1ns/1ps
module main_ctrl (
    input logic [6:0] opcode,
    output logic RegWrite,
    output logic [1:0] ImmSrc,
    output logic ALUSrc,
    output logic MemWrite,
    output logic [1:0] ResultSrc,
    output logic Branch,
    output logic Jump,
    output logic [1:0] ALU_op
);
always_comb begin
    case (opcode)
        7'b0000011: begin // Load
            RegWrite = 1;
            ImmSrc = 2'b00;
            ALUSrc = 1;
            MemWrite = 0;
            ResultSrc = 2'b01;
            Branch = 0;
            ALU_op = 2'b00;
            Jump = 0;
        end
        7'b0100011: begin // S-type store
            RegWrite = 0;
            ImmSrc = 2'b01;
            ALUSrc = 1;
            MemWrite = 1;
            ResultSrc = 2'b00;
            Branch = 0;
            ALU_op = 2'b00;
            Jump = 0;
        end
        7'b0110011: begin // R-type
            RegWrite = 1;
            ImmSrc = 2'b00;
            ALUSrc = 0;
            MemWrite = 0;
            ResultSrc = 2'b00;
            Branch = 0;
            ALU_op = 2'b10;
            Jump = 0;
        end
        7'b1100011: begin // B-type branch
            RegWrite = 0;
            ImmSrc = 2'b10;
            ALUSrc = 0;
            MemWrite = 0;
            ResultSrc = 2'b00;
            Branch = 1;
            ALU_op = 2'b01;
            Jump = 0;
        end
        7'b0010011: begin // I-type immediate
            RegWrite = 1;
            ImmSrc = 2'b00;
            ALUSrc = 1;
            MemWrite = 0;
            ResultSrc = 2'b00;
            Branch = 0;
            ALU_op = 2'b11;
            Jump = 0;
        end
        7'b1101111: begin // J-type JAL
            RegWrite = 1;
            ImmSrc = 2'b11;
            ALUSrc = 1'b0;
            MemWrite = 0;
            ResultSrc = 2'b10;
            Branch = 0;
            ALU_op = 2'b00;
            Jump = 1;
        end
        7'b0110111: begin // U-type LUI
            RegWrite = 1;
            ImmSrc = 2'b11;
            ALUSrc = 1;
            MemWrite = 0;
            ResultSrc = 2'b00;
            Branch = 0;
            ALU_op = 2'b00;
            Jump = 0;
        end
        7'b0010111: begin // U-type AUIPC
            RegWrite = 1;
            ImmSrc = 2'b11;
            ALUSrc = 1;
            MemWrite = 0;
            ResultSrc = 2'b00;
            Branch = 0;
            ALU_op = 2'b00;
            Jump = 0;
        end
        default: begin
            RegWrite = 0;
            ImmSrc = 2'b00;
            ALUSrc = 0;
            MemWrite = 0;
            ResultSrc = 2'b00;
            Branch = 0;
            ALU_op = 2'b00;
            Jump = 0;
        end
    endcase
end
endmodule
