`timescale 1ns / 1ps

module tb_if_id_reg;
    // Inputs
    reg clk;
    reg reset;
    reg flush;
    reg [31:0] pc_in;
    reg [31:0] instr_in;

    // Outputs
    wire [31:0] pc_out;
    wire [31:0] instr_out;

    // Instantiate the Unit Under Test (UUT)
    if_id_reg uut (
        .clk(clk), 
        .reset(reset), 
        .flush(flush), 
        .pc_in(pc_in), 
        .instr_in(instr_in), 
        .pc_out(pc_out), 
        .instr_out(instr_out)
    );

    // Clock generation (10ns period -> 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        flush = 0;
        pc_in = 32'h00000000;
        instr_in = 32'h00000000;

        // Hold reset for 15ns
        #15;
        reset = 0;

        // Cycle 1: Send first instruction
        #10;
        pc_in = 32'h00000004;
        instr_in = 32'h00500113; // Example: addi x2, x0, 5

        // Cycle 2: Send second instruction
        #10;
        pc_in = 32'h00000008;
        instr_in = 32'h00a101b3; // Example: add x3, x2, x1

        // Cycle 3: Test flush (simulating a branch/jump taken)
        #10;
        flush = 1;
        pc_in = 32'h0000000C;
        instr_in = 32'h0000006f; // Example: jal x0, target

        // Cycle 4: Release flush and continue normal fetch
        #10;
        flush = 0;
        pc_in = 32'h00000010;
        instr_in = 32'h00414283; // Example: lwu x5, 4(x2)

        // Run for some more time and finish
        #30;
        $finish;
    end
       
endmodule