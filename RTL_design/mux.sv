// write mux module
`timescale 1ns/1ps
module mux #(
    parameter int WIDTH = 32
) (
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    input logic sel,
    output logic [WIDTH-1:0] mux_out
);

always_comb begin
    mux_out = sel ? b : a; // if sel is 1, output b, otherwise output a
end
endmodule
