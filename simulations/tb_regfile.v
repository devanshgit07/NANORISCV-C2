module tb_regfile;
    reg clk, reg_we;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rd1, rd2;

    regfile uut (
        .clk(clk), .reg_we(reg_we), .rs1(rs1), .rs2(rs2), 
        .rd(rd), .wd(wd), .rd1(rd1), .rd2(rd2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; reg_we = 0; rs1 = 0; rs2 = 0; rd = 0; wd = 0;
        
        #10 reg_we = 1; rd = 5'd1; wd = 32'hDEADBEEF;
        #10 reg_we = 0; rs1 = 5'd1;
        #5 if (rd1 !== 32'hDEADBEEF) $display("FAIL: Register write/read");
        else $display("PASS: Register write/read");
        
        #10 reg_we = 1; rd = 5'd0; wd = 32'hFFFFFFFF;
        #10 reg_we = 0; rs2 = 5'd0;
        #5 if (rd2 !== 32'h0) $display("FAIL: x0 is not zero");
        else $display("PASS: x0 hardwired to zero");
        
        $finish;
    end
endmodule
