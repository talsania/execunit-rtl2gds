`timescale 1ns/1ps

module riscv_top #(
    parameter FORWARD = 1
)(
    input  wire        clk_i,
    input  wire        rst_ni,
    // Decode-stage control inputs
    input  wire [4:0]  rs1_addr_i,
    input  wire [4:0]  rs2_addr_i,
    input  wire [4:0]  rd_addr_i,
    input  wire        we_i,            // write-back enable
    input  wire [31:0] imm_i,           // sign-extended immediate
    input  wire        alu_src_b_i,     // 0=rs2  1=immediate
    input  wire [ 3:0] alu_op_i,
    // ALU result / flags (to branch unit, memory, etc.)
    output wire [31:0] alu_result_o,
    output wire        zero_o,
    output wire        neg_o,
    output wire        overflow_o,
    output wire        carry_o,
    // Debug read-back (for TB)
    input  wire [4:0]  dbg_addr_i,
    output wire [31:0] dbg_data_o
);

    wire [31:0] rs1_data, rs2_data;

    riscv_regfile #(.FORWARD(FORWARD)) u_rf (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .we_i       (we_i),
        .rd_addr_i  (rd_addr_i),
        .rd_data_i  (alu_result_o),   // WB from ALU
        .rs1_addr_i (rs1_addr_i),
        .rs1_data_o (rs1_data),
        .rs2_addr_i (rs2_addr_i),
        .rs2_data_o (rs2_data),
        // debug port — synthesis-safe; no hierarchical ref needed
        .dbg_addr_i (dbg_addr_i),
        .dbg_data_o (dbg_data_o)
    );

    wire [31:0] op_b = alu_src_b_i ? imm_i : rs2_data;

    riscv_alu u_alu (
        .op_a_i     (rs1_data),
        .op_b_i     (op_b),
        .alu_op_i   (alu_op_i),
        .result_o   (alu_result_o),
        .zero_o     (zero_o),
        .neg_o      (neg_o),
        .overflow_o (overflow_o),
        .carry_o    (carry_o)
    );

endmodule
