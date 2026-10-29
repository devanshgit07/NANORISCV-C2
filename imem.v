`timescale 1ns / 1ps

module imem (
    input wire [31:0] pc,
    output wire [31:0] instr
);
    reg [31:0] RAM [0:127]; 
    
    // Initialize all memory to NOP (addi x0, x0, 0) to prevent X values
    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1) begin
            RAM[i] = 32'h00000013;
        end
    end

    // Asynchronous read, word aligned
    assign instr = RAM[pc[31:2]]; 
endmodule