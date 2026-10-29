module nanoriscv_top (
    input wire clk,
    input wire reset,
    output wire [31:0] debug_out
);
    // Shared Interconnect Variables
    (* dont_touch = "true" *) wire [31:0] pc, next_pc, instr, imm_ext, alu_result, mem_rd, wd, rd1, rd2, alu_b;
    (* dont_touch = "true" *) wire [3:0] alu_ctrl;
    (* dont_touch = "true" *) wire branch, jump, mem_to_reg, mem_we, alu_src, reg_we, zero, is_bne, pc_load_en, branch_taken;

    // Stage 1: Instruction Fetch
    pc_reg pc_inst (.clk(clk), .reset(reset), .pc_load_en(pc_load_en), .next_pc(next_pc), .pc(pc));
    imem imem_inst (.pc(pc), .instr(instr));

    // Stage 2: Decode, Execute, Memory, Write-back
    control_unit ctrl_inst (
        .instr(instr), .branch(branch), .jump(jump), .mem_to_reg(mem_to_reg),
        .mem_we(mem_we), .alu_src(alu_src), .reg_we(reg_we), .alu_ctrl(alu_ctrl), .is_bne(is_bne)
    );

    imm_gen imm_inst (.instr(instr), .imm_ext(imm_ext));

    // Write-back multiplexer
    assign wd = jump ? (pc + 32'd4) : (mem_to_reg ? mem_rd : alu_result);
    
    regfile reg_inst (
        .clk(clk), .reg_we(reg_we), .rs1(instr[19:15]), .rs2(instr[24:20]),
        .rd(instr[11:7]), .wd(wd), .rd1(rd1), .rd2(rd2)
    );

    // ALU input multiplexer
    assign alu_b = alu_src ? imm_ext : rd2;
    
    alu alu_inst (
        .a(rd1), .b(alu_b), .alu_ctrl(alu_ctrl), .alu_result(alu_result), .zero(zero)
    );

    dmem dmem_inst (
        .clk(clk), .mem_we(mem_we), .alu_result(alu_result), .wd(rd2), .mem_rd(mem_rd)
    );

    // Branch & Jump Target Logic
    assign branch_taken = branch & (is_bne ? ~zero : zero);
    assign pc_load_en = branch_taken | jump;
    assign next_pc = pc + imm_ext; 
    assign debug_out = alu_result;

endmodule