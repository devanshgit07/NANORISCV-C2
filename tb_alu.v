module tb_alu;
    reg [31:0] a, b;
    reg [3:0] alu_ctrl;
    wire [31:0] alu_result;
    wire zero;

    alu uut (
        .a(a), .b(b), .alu_ctrl(alu_ctrl), 
        .alu_result(alu_result), .zero(zero)
    );

    initial begin
        a = 32'd10; b = 32'd15; alu_ctrl = 4'b0000;
        #10;
        if (alu_result !== 32'd25) $display("FAIL: ALU ADD");
        else $display("PASS: ALU ADD");

        a = 32'd20; b = 32'd20; alu_ctrl = 4'b0001;
        #10;
        if (alu_result !== 32'd0 || zero !== 1'b1) $display("FAIL: ALU SUB / Zero flag");
        else $display("PASS: ALU SUB / Zero flag");
        
        a = 32'd0; b = 32'h87654321; alu_ctrl = 4'b0111; // LUI operation
        #10;
        if (alu_result !== 32'h87654321) $display("FAIL: ALU LUI (Pass B)");
        else $display("PASS: ALU LUI (Pass B)");
        
        $finish;
    end
endmodule