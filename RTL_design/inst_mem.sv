`timescale 1ns/1ps
module inst_mem (
    input logic [31:0] read_addr,
    output logic [31:0] inst_out
);
// read instruction from memory at the given address its name file is fib_im.mem
reg [31:0] memory [0:255]; // 256 words of 32-bit memory
initial begin
    $readmemh("./fib_im.mem", memory); // load instructions from file
end

assign inst_out = memory[read_addr[9:2]];
endmodule
