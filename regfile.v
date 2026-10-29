module regfile (
    input wire clk,
    input wire reg_we,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire [31:0] wd,
    output wire [31:0] rd1,
    output wire [31:0] rd2
);
    reg [31:0] registers [0:31];
    
    // Register x0 always reads as zero
    assign rd1 = (rs1 == 5'b0) ? 32'b0 : registers[rs1];
    assign rd2 = (rs2 == 5'b0) ? 32'b0 : registers[rs2];

    always @(posedge clk) begin
        if (reg_we && rd != 5'b0) begin
            registers[rd] <= wd;
        end
    end
endmodule