module tb_imm_gen;
    reg [31:0] instr;
    wire [31:0] imm_ext;

    imm_gen uut (.instr(instr), .imm_ext(imm_ext));

    initial begin
        instr = 32'hFFF10093; // ADDI x1, x2, -1
        #10;
        if (imm_ext !== 32'hFFFFFFFF) $display("FAIL: I-type negative immediate");
        else $display("PASS: I-type negative immediate");
        
        instr = 32'h0020A823; // SW x2, 16(x1)
        #10;
        if (imm_ext !== 32'h00000010) $display("FAIL: S-type immediate");
        else $display("PASS: S-type immediate");
        
        $finish;
    end
endmodule
