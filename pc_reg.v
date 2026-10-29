module pc_reg (
    input wire clk,
    input wire reset,
    input wire pc_load_en,
    input wire [31:0] next_pc,
    output reg [31:0] pc
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'h00000000; // Asynchronous reset to 0x00000000
        else if (pc_load_en)
            pc <= next_pc;
        else
            pc <= pc + 32'd4;   // 4-byte aligned
    end
endmodule