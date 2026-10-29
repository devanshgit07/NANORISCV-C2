`timescale 1ns / 1ps

module imem (
    input wire [31:0] pc,
    output wire [31:0] instr
);
    reg [31:0] RAM [0:127]; 
    
    // Asynchronous read, word aligned
    assign instr = RAM[pc[31:2]]; 
endmodule
