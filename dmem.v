module dmem (
    input wire clk,
    input wire mem_we,
    input wire [31:0] alu_result,
    input wire [31:0] wd,
    output wire [31:0] mem_rd 
);
    reg [31:0] RAM [255:0]; 

    // Synchronous write
    always @(posedge clk) begin
        if (mem_we) begin
            RAM[alu_result[31:2]] <= wd;
        end
    end
    
    // Asynchronous read (For Schematic & Waveforms)
    assign mem_rd = RAM[alu_result[31:2]];

endmodule