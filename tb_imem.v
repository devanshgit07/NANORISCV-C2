`timescale 1ns / 1ps

module tb_imem;
    reg [31:0] pc;
    wire [31:0] instr;

    imem uut (.pc(pc), .instr(instr));

    initial begin
        // Inject dummy instructions
        uut.RAM[0] = 32'h00A00093; // ADDI x1, x0, 10
        uut.RAM[1] = 32'h00B00113; // ADDI x2, x0, 11
        
        pc = 32'h00000000;
        #10;
        if (instr !== 32'h00A00093) $display("FAIL: Address 0x0 read");
        else $display("PASS: Address 0x0 read");
        
        pc = 32'h00000004;
        #10;
        if (instr !== 32'h00B00113) $display("FAIL: Address 0x4 read");
        else $display("PASS: Address 0x4 read");
        
        $finish;
    end
endmodule