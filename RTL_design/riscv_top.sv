`timescale 1ns/1ps

module riscv_top (
    input logic clk,
    input logic rest
);

// Fetch stage
logic [31:0] pc_out, next_pc;
logic [31:0] instruction;
logic [31:0] pc_if_id, inst_if_id;
logic [4:0] rs1_IF, rs2_IF;
logic [4:0] rs1_ID, rs2_ID;
logic stall;
logic flush;

// Decode stage
logic [4:0] rd;
logic [31:0] read_data1, read_data2;
logic RegWrite_ID, ALUSrc_ID, MemWrite_ID, Branch_ID, Jump_ID;
logic [1:0] ImmSrc, ResultSrc_ID, ALU_op_ID;
logic [31:0] ImmExt;
logic RegWrite_ID_stall, ALUSrc_ID_stall, MemWrite_ID_stall, Branch_ID_stall, Jump_ID_stall;
logic [1:0] ResultSrc_ID_stall, ALU_op_ID_stall;

// Execute stage
logic [31:0] pc_EX, read_data1_EX, read_data2_EX, ImmExt_EX;
logic RegWrite_EX, ALUSrc_EX, MemWrite_EX, Branch_EX, Jump_EX;
logic [1:0] ResultSrc_EX, ALU_op_EX;
logic [31:0] pc_plus4_EX;
logic [2:0] funct3_EX;
logic [6:0] funct7_EX;
logic [4:0] rd_EX;
logic [4:0] rs1_EX, rs2_EX;
logic [1:0] ALUop_unused;
logic [3:0] alu_control;
logic [31:0] alu_src_a, alu_src_b;
logic [31:0] alu_result;
logic [1:0] forwardA, forwardB;
logic [31:0] forward_data_a, forward_data_b;

// Memory stage
logic RegWrite_MEM, MemWrite_MEM;
logic [1:0] ResultSrc_MEM;
logic [31:0] ALU_Result_MEM;
logic [31:0] pc_plus4_MEM;
logic [2:0] funct3_MEM;
logic [31:0] read_data2_MEM;
logic [4:0] rd_MEM;
logic [31:0] mem_data;
logic [31:0] lsu_store_data;

// Writeback stage
logic RegWrite_WB;
logic [1:0] ResultSrc_WB;
logic [31:0] ALU_Result_WB;
logic [31:0] pc_plus4_WB;
logic [31:0] Data_r_WB;
logic [4:0] rd_WB;
logic [31:0] lsu_load_data;
logic [31:0] write_back_data;


// Branch decision
logic branch_taken_EX;

// LSU
logic [3:0] lsu_funct;

// FIELD EXTRACTION
assign rd  = inst_if_id[11:7];
assign rs1_IF = instruction[19:15];
assign rs2_IF = instruction[24:20];
assign lsu_funct = {MemWrite_MEM, funct3_MEM};
assign pc_plus4_EX = pc_EX + 32'd4;

assign RegWrite_ID_stall = RegWrite_ID & ~stall;
assign ALUSrc_ID_stall   = ALUSrc_ID & ~stall;
assign MemWrite_ID_stall = MemWrite_ID & ~stall;
assign Branch_ID_stall   = Branch_ID & ~stall;
assign Jump_ID_stall     = Jump_ID & ~stall;
assign ResultSrc_ID_stall = stall ? 2'b00 : ResultSrc_ID;
assign ALU_op_ID_stall    = stall ? 2'b00 : ALU_op_ID;

// ALU INPUTS
always_comb begin
    case (forwardA)
        2'b10: forward_data_a = ALU_Result_MEM;
        2'b01: forward_data_a = write_back_data;
        default: forward_data_a = read_data1_EX;
    endcase

    case (forwardB)
        2'b10: forward_data_b = ALU_Result_MEM;
        2'b01: forward_data_b = write_back_data;
        default: forward_data_b = read_data2_EX;
    endcase

    alu_src_a = forward_data_a;
    alu_src_b = ALUSrc_EX ? ImmExt_EX : forward_data_b;
end

// NEXT PC // PC Logic
assign next_pc =
    Jump_EX ? (pc_EX + ImmExt_EX) :
    branch_taken_EX ? (pc_EX + ImmExt_EX) :
    stall ? pc_out :
    pc_out + 4;

// PC
program_counter pc (
    .clk(clk),
    .rest(rest),
    .pc_in(next_pc),
    .PC_enable(~stall || flush),
    .pc_out(pc_out)
);

// Instruction memory
inst_mem imem (
    .read_addr(pc_out),
    .inst_out(instruction)
);

// IF/ID pipeline register
IF_ID if_id (
    .clk(clk),
    .rest(rest),
    .pc_in_IF(pc_out),
    .inst_in_IF(instruction),
    .rs1_IF(rs1_IF),
    .rs2_IF(rs2_IF),
    .pc_out_ID(pc_if_id),
    .inst_out_ID(inst_if_id),
    .rs1_ID(rs1_ID),
    .rs2_ID(rs2_ID),
    .flush(flush),
    .stall(stall)
);

// Register file
reg_file rf (
    .clk(clk),
    .rest(rest),
    .rs1(rs1_ID),
    .rs2(rs2_ID),
    .rd(rd_WB),
    .data_w(write_back_data),
    .RegWrite(RegWrite_WB),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

// Control
main_ctrl ctrl (
    .opcode(inst_if_id[6:0]),
    .RegWrite(RegWrite_ID),
    .ImmSrc(ImmSrc),
    .ALUSrc(ALUSrc_ID),
    .MemWrite(MemWrite_ID),
    .ResultSrc(ResultSrc_ID),
    .Branch(Branch_ID),
    .Jump(Jump_ID),
    .ALU_op(ALU_op_ID)
);

// Immediate generation
imm_gen imm_gen_inst (
    .instruction(inst_if_id),
    .ImmExt(ImmExt)
);
// hazard control
hazard_detection hazard_det (
    .rs1_ID(rs1_ID),
    .rs2_ID(rs2_ID),
    .rd_EX(rd_EX),
    .ResultSrc_EX(ResultSrc_EX),
    .stall(stall),
    .Jump_EX(Jump_EX),
    .Branch_taken_EX(branch_taken_EX),
    .flush(flush)
);
// ID/EX pipeline register
// stall and flush logic added
ID_EX id_ex (
    // Inputs from ID stage
    .clk(clk),
    .rest(rest),
    .pc_DE(pc_if_id),
    .RegWrite_DE(RegWrite_ID_stall),
    .ALUSrc_DE(ALUSrc_ID_stall),
    .MemWrite_DE(MemWrite_ID_stall),
    .ResultSrc_DE(ResultSrc_ID_stall),
    .Branch_DE(Branch_ID_stall),
    .Jump_DE(Jump_ID_stall),
    .ALU_op_DE(ALU_op_ID_stall),
    .read_data1_DE(read_data1),
    .read_data2_DE(read_data2),
    .ImmExt_DE(ImmExt),
    .rd_DE(rd),
    .ALUop_DE(2'b00),
    .funct3_DE(inst_if_id[14:12]),
    .funct7_DE(inst_if_id[31:25]),
    .rs1_DE(rs1_ID),
    .rs2_DE(rs2_ID),
    // Outputs to EX stage
    .pc_EX(pc_EX),
    .RegWrite_EX(RegWrite_EX),
    .ALUSrc_EX(ALUSrc_EX),
    .MemWrite_EX(MemWrite_EX),
    .ResultSrc_EX(ResultSrc_EX),
    .Branch_EX(Branch_EX),
    .Jump_EX(Jump_EX),
    .ALU_op_EX(ALU_op_EX),
    .read_data1_EX(read_data1_EX),
    .read_data2_EX(read_data2_EX),
    .ImmExt_EX(ImmExt_EX),
    .rd_EX(rd_EX),
    .ALUop_EX(ALUop_unused),
    .funct3_EX(funct3_EX),
    .funct7_EX(funct7_EX),
    .flush(flush),
    .stall(stall),
    .rs1_EX(rs1_EX),
    .rs2_EX(rs2_EX)
);
// forwarding logic
fwd_logic fwd_logic_inst (
    .rs1_EX(rs1_EX),
    .rs2_EX(rs2_EX),
    .rd_MEM(rd_MEM),
    .rd_WB(rd_WB),
    .RegWrite_MEM(RegWrite_MEM),
    .RegWrite_WB(RegWrite_WB),
    .forwardA(forwardA),
    .forwardB(forwardB)
);
// ALU control
alu_ctrl alu_ctrl_inst (
    .ALUop(ALU_op_EX),
    .funct3(funct3_EX),
    .funct7(funct7_EX),
    .operation(alu_control)
);

// ALU
alu alu_inst (
    .a(alu_src_a),
    .b(alu_src_b),
    .control_in(alu_control),
    .result(alu_result),
    .zero()
);

// Branch compare in EX stage
branch branch_inst (
    .funct3(funct3_EX),
    .rs1(forward_data_a),
    .rs2(forward_data_b),
    .Branch(Branch_EX),
    .branch_taken(branch_taken_EX)
);

// EX/MEM pipeline register
EX_MEM ex_mem (
    .clk(clk),
    .rest(rest),
    .RegWrite_EM(RegWrite_EX),
    .MemWrite_EM(MemWrite_EX),
    .ResultSrc_EM(ResultSrc_EX),
    .ALU_Result_EM(alu_result),
    .pc_plus4_EM(pc_plus4_EX),
    .funct3_EM(funct3_EX),
    .read_data2_EM(forward_data_b),
    .rd_EM(rd_EX),
    .RegWrite_MEM(RegWrite_MEM),
    .MemWrite_MEM(MemWrite_MEM),
    .ResultSrc_MEM(ResultSrc_MEM),
    .ALU_Result_MEM(ALU_Result_MEM),
    .pc_plus4_MEM(pc_plus4_MEM),
    .funct3_MEM(funct3_MEM),
    .read_data2_MEM(read_data2_MEM),
    .rd_MEM(rd_MEM)
);

// Data memory
data_mem dmem (
    .clk(clk),
    .rest(rest),
    .addr(ALU_Result_MEM),
    .data_w(lsu_store_data),
    .mem_write_en(MemWrite_MEM),
    .MemRead(1'b1),
    .data_r(mem_data)
);

// Load/store unit
load_store_unit lsu (
    .funct(lsu_funct),
    .mem_in(Data_r_WB),
    .reg_in(read_data2_MEM),
    .load_data(lsu_load_data),
    .store_data(lsu_store_data)
);

// MEM/WB pipeline register
MEM_WB mem_wb (
    .clk(clk),
    .rest(rest),
    .RegWrite_ME(RegWrite_MEM),
    .ResultSrc_ME(ResultSrc_MEM),
    .ALU_Result_ME(ALU_Result_MEM),
    .pc_plus4_ME(pc_plus4_MEM),
    .Data_r_ME(mem_data),
    .rd_ME(rd_MEM),
    .RegWrite_WB(RegWrite_WB),
    .ResultSrc_WB(ResultSrc_WB),
    .ALU_Result_WB(ALU_Result_WB),
    .pc_plus4_WB(pc_plus4_WB),
    .Data_r_WB(Data_r_WB),
    .rd_WB(rd_WB)
);

// Writeback mux
always_comb begin
    case (ResultSrc_WB)
        2'b00: write_back_data = ALU_Result_WB;
        2'b01: write_back_data = lsu_load_data;
        2'b10: write_back_data = pc_plus4_WB;
        default: write_back_data = 32'b0;
    endcase
end

endmodule
