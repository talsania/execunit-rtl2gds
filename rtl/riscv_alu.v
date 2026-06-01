`timescale 1ns/1ps

module riscv_alu (
    // operands
    input  wire [31:0] op_a_i,      // rs1 or PC
    input  wire [31:0] op_b_i,      // rs2 or immediate
    // operation select
    input  wire [ 3:0] alu_op_i,
    // results
    output reg  [31:0] result_o,
    output wire        zero_o,      // result == 0  (branch compare)
    output wire        neg_o,       // result[31]
    output wire        overflow_o,  // signed overflow
    output wire        carry_o      // unsigned carry-out
);

    localparam ALU_ADD      = 4'b0000;
    localparam ALU_SUB      = 4'b0001;
    localparam ALU_SLL      = 4'b0010;
    localparam ALU_SLT      = 4'b0011;
    localparam ALU_SLTU     = 4'b0100;
    localparam ALU_XOR      = 4'b0101;
    localparam ALU_SRL      = 4'b0110;
    localparam ALU_SRA      = 4'b0111;
    localparam ALU_OR       = 4'b1000;
    localparam ALU_AND      = 4'b1001;
    localparam ALU_LUI      = 4'b1010;
    localparam ALU_COPY_RS1 = 4'b1011;

    wire        do_sub  = (alu_op_i == ALU_SUB) |
                          (alu_op_i == ALU_SLT) |
                          (alu_op_i == ALU_SLTU);
    wire [31:0] op_b_eff = do_sub ? (~op_b_i) : op_b_i;
    wire [32:0] adder_out = {1'b0, op_a_i} + {1'b0, op_b_eff} + {32'd0, do_sub};

    wire [31:0] sum   = adder_out[31:0];
    assign      carry_o    = adder_out[32];                          // unsigned carry
    assign      overflow_o = (op_a_i[31] == op_b_eff[31]) &&
                             (sum[31] != op_a_i[31]);                // signed overflow
    assign      zero_o     = (result_o == 32'b0);
    assign      neg_o      = result_o[31];

    wire [4:0]  shamt = op_b_i[4:0];

    always @(*) begin
        case (alu_op_i)
            ALU_ADD      : result_o = sum;
            ALU_SUB      : result_o = sum;
            ALU_SLL      : result_o = op_a_i << shamt;
            ALU_SLT      : result_o = {31'b0,
                               (sum[31] ^ overflow_o) ? 1'b1 : 1'b0};
            ALU_SLTU     : result_o = {31'b0, ~carry_o};             // borrow = ~carry
            ALU_XOR      : result_o = op_a_i ^ op_b_i;
            ALU_SRL      : result_o = op_a_i >> shamt;
            ALU_SRA      : result_o = $signed(op_a_i) >>> shamt;
            ALU_OR       : result_o = op_a_i | op_b_i;
            ALU_AND      : result_o = op_a_i & op_b_i;
            ALU_LUI      : result_o = op_b_i;
            ALU_COPY_RS1 : result_o = op_a_i;
            default      : result_o = 32'bx;
        endcase
    end

endmodule
