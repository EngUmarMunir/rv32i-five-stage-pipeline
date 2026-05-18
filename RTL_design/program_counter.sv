// module for program counter
`timescale 1ns/1ps
module program_counter (
    input logic clk,
    input logic rest,
    input logic [31:0] pc_in,
    input logic PC_enable, // input to enable stalling the pipeline
    output logic [31:0] pc_out

);
    always_ff @(posedge clk or posedge rest) begin
        if (rest) begin
            pc_out <= 32'b0; // reset to 0
        end else begin
            if (PC_enable) begin
                pc_out <= pc_in; // update pc_out with pc_in
            end
        end
    end
endmodule
