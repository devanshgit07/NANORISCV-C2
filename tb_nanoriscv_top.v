module tb_nanoriscv_top;
    reg clk, reset;
    wire [31:0] tb_debug_out; // Added wire to monitor debug output

    nanoriscv_top uut (
        .clk(clk), 
        .reset(reset),
        .debug_out(tb_debug_out) // Added port connection
    );

    always #5 clk = ~clk; 

    initial begin
        clk = 0; reset = 1;
        
        // Machine code strictly testing base minimum verification
        uut.imem_inst.RAM[0] = 32'h00500093; // ADDI x1, x0, 5    (x1 = 5)
        uut.imem_inst.RAM[1] = 32'h00A00113; // ADDI x2, x0, 10   (x2 = 10)
        uut.imem_inst.RAM[2] = 32'h002081B3; // ADD  x3, x1, x2   (x3 = 15)
        uut.imem_inst.RAM[3] = 32'h00302023; // SW   x3, 0(x0)    (mem[0] = 15)
        uut.imem_inst.RAM[4] = 32'h00002203; // LW   x4, 0(x0)    (x4 = 15)
        uut.imem_inst.RAM[5] = 32'h00418463; // BEQ  x3, x4, 8    (15==15, jumps to 0x1C)
        uut.imem_inst.RAM[6] = 32'h00100293; // ADDI x5, x0, 1    (Skipped)
        uut.imem_inst.RAM[7] = 32'hFFCFF36F; // JAL  x6, -4       (Jumps back, x6 = 0x20)
        
        #15 reset = 0; 
        
        #100;
        
        if (uut.reg_inst.registers[3] !== 32'd15) $display("FAIL: Integration ADD");
        else $display("PASS: Integration ADD");

        if (uut.dmem_inst.RAM[0] !== 32'd15) $display("FAIL: Integration SW");
        else $display("PASS: Integration SW");

        if (uut.reg_inst.registers[4] !== 32'd15) $display("FAIL: Integration LW");
        else $display("PASS: Integration LW");

        if (uut.reg_inst.registers[5] === 32'd1) $display("FAIL: Integration BEQ branch failed");
        else $display("PASS: Integration BEQ branch taken");

        if (uut.reg_inst.registers[6] !== 32'h20) $display("FAIL: Integration JAL linkage");
        else $display("PASS: Integration JAL linkage");

        $finish;
    end
endmodule