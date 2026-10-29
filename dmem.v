module dmem (
    input wire clk,
    input wire mem_we,
    input wire [31:0] alu_result,
    input wire [31:0] wd,
    output wire [31:0] mem_rd
);
    reg [31:0] RAM [0:127];
    
    assign mem_rd = RAM[alu_result[31:2]];

    always @(posedge clk) begin
        if (mem_we) begin
            RAM[alu_result[31:2]] <= wd;
        end
    end
endmodule