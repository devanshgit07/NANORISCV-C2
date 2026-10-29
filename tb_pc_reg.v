module tb_pc_reg;
    reg clk, reset, pc_load_en;
    reg [31:0] next_pc;
    wire [31:0] pc;

    pc_reg uut (
        .clk(clk), .reset(reset), .pc_load_en(pc_load_en), 
        .next_pc(next_pc), .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; pc_load_en = 0; next_pc = 0;
        #10 reset = 0;
        
        #10;
        if (pc !== 32'h00000004) $display("FAIL: PC normal increment");
        else $display("PASS: PC normal increment");
        
        #10 pc_load_en = 1; next_pc = 32'h00000020;
        #10 pc_load_en = 0;
        
        if (pc !== 32'h00000020) $display("FAIL: PC jump/branch load");
        else $display("PASS: PC jump/branch load");
        
        $finish;
    end
endmodule
