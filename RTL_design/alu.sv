// ALU module
`timescale 1ns/1ps
module alu (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [3:0] control_in,
    output logic [31:0] result,
    output logic zero
);
always_comb begin
    case (control_in)
        4'b0010: result = a + b; // ADD
        4'b0110: result = a - b; // SUB
        4'b0011: result = a << b[4:0]; // SLL
        4'b0100: result = ($signed(a) < $signed(b)) ? 32'h00000001 : 32'h00000000; // SLT
        4'b0101: result = (a < b) ? 32'h00000001 : 32'h00000000; // SLTU
        4'b1110: result = a ^ b; // XOR
        4'b0111: result = a >> b[4:0]; // SRL
        4'b1000: result = $signed(a) >>> b[4:0]; // SRA
        4'b1001: result = a & b; // AND
        4'b1010: result = a | b; // OR
        default: result = 32'b0;
    endcase
end
assign zero = (result == 32'b0) ? 1'b1 : 1'b0;
endmodule