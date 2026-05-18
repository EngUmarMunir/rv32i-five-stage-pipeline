`timescale 1ns/1ps
module data_mem (
    input logic clk,
    input logic rest,
    input logic [31:0] addr,
    input logic [31:0] data_w,
    input logic mem_write_en,
    input logic MemRead,
    output logic [31:0] data_r
);
reg [31:0] memory [256];
integer i;
always_ff @(posedge clk) begin
    if (rest) begin
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] <= 32'b0;
        end
    end else if (mem_write_en) begin
        memory[addr[9:2]] <= data_w;
    end
end
assign data_r = memory[addr[9:2]];
endmodule
