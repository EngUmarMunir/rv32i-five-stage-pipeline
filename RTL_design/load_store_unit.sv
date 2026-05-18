module load_store_unit (
    input  logic [3:0] funct,
    input  logic [31:0] mem_in,
    input  logic [31:0] reg_in,

    output logic [31:0] load_data,
    output logic [31:0] store_data
);

always_comb begin

    // LOAD
    case (funct)
        4'b0000: load_data = {{24{mem_in[7]}}, mem_in[7:0]};   // LB
        4'b0001: load_data = {{16{mem_in[15]}}, mem_in[15:0]}; // LH
        4'b0010: load_data = mem_in;                           // LW
        4'b0100: load_data = {24'b0, mem_in[7:0]};             // LBU
        4'b0101: load_data = {16'b0, mem_in[15:0]};            // LHU
        default: load_data = mem_in;
    endcase

    // STORE
    case (funct)
        4'b1000: store_data = {24'b0, reg_in[7:0]};   // SB
        4'b1001: store_data = {16'b0, reg_in[15:0]};  // SH
        4'b1010: store_data = reg_in;                 // SW
        default: store_data = reg_in;
    endcase

end

endmodule
