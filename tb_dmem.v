module tb_dmem;
    reg clk, mem_we;
    reg [31:0] alu_result, wd;
    wire [31:0] mem_rd;

    dmem uut (
        .clk(clk), .mem_we(mem_we), .alu_result(alu_result), 
        .wd(wd), .mem_rd(mem_rd)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; mem_we = 0; alu_result = 0; wd = 0;
        
        #10 mem_we = 1; alu_result = 32'h00000010; wd = 32'hDEADBEEF; // Store
        #10 mem_we = 0; alu_result = 32'h00000010; // Load
        
        #10;
        if (mem_rd !== 32'hDEADBEEF) $display("FAIL: D-Mem Read/Write");
        else $display("PASS: D-Mem Read/Write");
        
        $finish;
    end
endmodule