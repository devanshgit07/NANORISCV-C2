`timescale 1ns / 1ps

module if_id_reg (
    input wire clk,
    input wire reset,
    input wire flush,
    input wire [31:0] pc_in,
    input wire [31:0] instr_in,
    output reg [31:0] pc_out,
    output reg [31:0] instr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out    <= 32'h00000000;
            instr_out <= 32'h00000013; // Reset to NOP (addi x0, x0, 0) to prevent X propagation
        end else if (flush) begin
            pc_out    <= 32'h00000000;
            instr_out <= 32'h00000013; // Flush with NOP on branch/jump
        end else begin
            pc_out    <= pc_in;
            instr_out <= instr_in;
        end
    end
endmodule
