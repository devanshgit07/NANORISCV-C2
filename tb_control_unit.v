module tb_control_unit;
    reg [31:0] instr;
    wire branch, jump, mem_to_reg, mem_we, alu_src, reg_we, is_bne;
    wire [3:0] alu_ctrl;

    control_unit uut (
        .instr(instr), .branch(branch), .jump(jump), .mem_to_reg(mem_to_reg),
        .mem_we(mem_we), .alu_src(alu_src), .reg_we(reg_we), 
        .alu_ctrl(alu_ctrl), .is_bne(is_bne)
    );

    initial begin
        instr = 32'h002081B3; // ADD x3, x1, x2
        #10;
        if (!reg_we || mem_to_reg || alu_src) $display("FAIL: Control R-type ADD");
        else $display("PASS: Control R-type ADD");

        instr = 32'h0000A283; // LW x5, 0(x1)
        #10;
        if (!reg_we || !mem_to_reg || !alu_src) $display("FAIL: Control LW");
        else $display("PASS: Control LW");

        $finish;
    end
endmodule