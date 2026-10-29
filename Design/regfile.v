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
    reg [31:0] registers [31:0]; 

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'd0;
        end
    end

    // Synchronous write
    always @(posedge clk) begin
        if (reg_we && (rd != 5'd0)) begin
            registers[rd] <= wd;
        end
    end

    // Asynchronous read (For Schematic & Waveforms)
    assign rd1 = (rs1 == 5'd0) ? 32'd0 : registers[rs1];
    assign rd2 = (rs2 == 5'd0) ? 32'd0 : registers[rs2];

endmodule
