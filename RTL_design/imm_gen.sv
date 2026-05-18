`timescale 1ns/1ps
module imm_gen (
    input logic [31:0] instruction,
    output logic [31:0] ImmExt
);

logic [6:0] opcode;
assign opcode = instruction[6:0];

always_comb begin
    case (opcode)
        // I-Type
        7'b0010011, 7'b0000011, 7'b1100111: begin
            ImmExt = {{20{instruction[31]}}, instruction[31:20]};
        end
        
        // S-Type
        7'b0100011: begin
            ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        end
        
        // B-Type - Construct 13-bit immediate then sign extend
        7'b1100011: begin
            logic [12:0] b_imm;
            b_imm = {instruction[31],     // bit 12
                     instruction[7],       // bit 11
                     instruction[30:25],   // bits 10-5
                     instruction[11:8],    // bits 4-1
                     1'b0};               // bit 0 = 0
            ImmExt = {{19{b_imm[12]}}, b_imm};
        end
        
        // J-Type - Construct 21-bit immediate then sign extend
        7'b1101111: begin
            logic [20:0] j_imm;
            j_imm = {instruction[31],      // bit 20
                     instruction[19:12],    // bits 19-12
                     instruction[20],       // bit 11
                     instruction[30:21],    // bits 10-1
                     1'b0};                // bit 0 = 0
            ImmExt = {{11{j_imm[20]}}, j_imm};
        end
        
        // U-Type
        7'b0110111, 7'b0010111: begin
            ImmExt = {instruction[31:12], 12'b0};
        end
        
        default: begin
            ImmExt = 32'b0;
        end
    endcase
end

endmodule