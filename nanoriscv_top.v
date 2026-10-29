module nanoriscv_top (
    input wire clk,
    input wire reset,
    output wire [31:0] debug_out
);
    // Fetch Stage Wires
    wire [31:0] pc_f, next_pc, instr_f;
    
    // Execute/Decode Stage Wires (from Pipeline Register)
    wire [31:0] pc_ex, instr_ex;
    
    // Interconnect wires for Execute stage
    wire [31:0] imm_ext, alu_result, mem_rd, wd, rd1, rd2, alu_b;
    wire [3:0] alu_ctrl;
    wire branch, jump, mem_to_reg, mem_we, alu_src, reg_we, zero, is_bne, pc_load_en, branch_taken;

    // --- STAGE 1: Instruction Fetch ---
    pc_reg pc_inst (
        .clk(clk), .reset(reset), .pc_load_en(pc_load_en), 
        .next_pc(next_pc), .pc(pc_f)
    );
    
    imem imem_inst (
        .pc(pc_f), .instr(instr_f)
    );

    // --- PIPELINE REGISTER (IF/EX) ---
    if_id_reg pipeline_reg (
        .clk(clk), .reset(reset), .flush(pc_load_en),
        .pc_in(pc_f), .instr_in(instr_f),
        .pc_out(pc_ex), .instr_out(instr_ex)
    );

    // --- STAGE 2: Decode, Execute, Memory, Write-back ---
    control_unit ctrl_inst (
        .instr(instr_ex), .branch(branch), .jump(jump), .mem_to_reg(mem_to_reg),
        .mem_we(mem_we), .alu_src(alu_src), .reg_we(reg_we), .alu_ctrl(alu_ctrl), .is_bne(is_bne)
    );

    imm_gen imm_inst (
        .instr(instr_ex), .imm_ext(imm_ext)
    );

    // Write-back multiplexer
    assign wd = jump ? (pc_ex + 32'd4) : (mem_to_reg ? mem_rd : alu_result);
    
    regfile reg_inst (
        .clk(clk), .reg_we(reg_we), 
        .rs1(instr_ex[19:15]), .rs2(instr_ex[24:20]),
        .rd(instr_ex[11:7]), .wd(wd), .rd1(rd1), .rd2(rd2)
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
    assign next_pc = pc_ex + imm_ext;  
    
    // Original combinational debug output
    assign debug_out = alu_result;

endmodule