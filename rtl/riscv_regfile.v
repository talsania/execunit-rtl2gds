module riscv_regfile #(
    parameter FORWARD = 1   // 1=enable bypass, 0=disable
)(
    input  wire        clk_i,
    input  wire        rst_ni,      // active-low synchronous reset
    // Write port
    input  wire        we_i,
    input  wire [4:0]  rd_addr_i,
    input  wire [31:0] rd_data_i,
    // Read port A (rs1)
    input  wire [4:0]  rs1_addr_i,
    output wire [31:0] rs1_data_o,
    // Read port B (rs2)
    input  wire [4:0]  rs2_addr_i,
    output wire [31:0] rs2_data_o,
    // Read port C (debug) — plain async read, no bypass
    input  wire [4:0]  dbg_addr_i,
    output wire [31:0] dbg_data_o
);

    reg [31:0] regs [1:31];         // x1..x31; x0 implicit zero
    integer i;

    always @(posedge clk_i) begin
        if (!rst_ni) begin
            for (i = 1; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end else if (we_i && (rd_addr_i != 5'b0)) begin
            regs[rd_addr_i] <= rd_data_i;
        end
    end

    wire [31:0] raw_rs1 = (rs1_addr_i == 5'b0) ? 32'b0 : regs[rs1_addr_i];
    wire [31:0] raw_rs2 = (rs2_addr_i == 5'b0) ? 32'b0 : regs[rs2_addr_i];

    generate
        if (FORWARD) begin : gen_fwd
            assign rs1_data_o = (we_i && (rd_addr_i != 5'b0) &&
                                 (rd_addr_i == rs1_addr_i))
                                ? rd_data_i : raw_rs1;
            assign rs2_data_o = (we_i && (rd_addr_i != 5'b0) &&
                                 (rd_addr_i == rs2_addr_i))
                                ? rd_data_i : raw_rs2;
        end else begin : gen_nofwd
            assign rs1_data_o = raw_rs1;
            assign rs2_data_o = raw_rs2;
        end
    endgenerate

    assign dbg_data_o = (dbg_addr_i == 5'b0) ? 32'b0 : regs[dbg_addr_i];

endmodule
