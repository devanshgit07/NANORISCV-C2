module control_unit (
    input wire [31:0] instr,
    output reg branch,
    output reg jump,
    output reg mem_to_reg,
    output reg mem_we,
    output reg alu_src,
    output reg reg_we,
    output reg [3:0] alu_ctrl,
    output reg is_bne
);
    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];

    always @(*) begin
        branch = 0; jump = 0; mem_to_reg = 0; mem_we = 0; 
        alu_src = 0; reg_we = 0; alu_ctrl = 4'b0000; is_bne = 0;
        
        case (opcode)
            7'b0110011: begin // R-type
                reg_we = 1; alu_src = 0; mem_to_reg = 0;
                case (funct3)
                    3'b000: alu_ctrl = (funct7[5]) ? 4'b0001 : 4'b0000; // SUB or ADD
                    3'b100: alu_ctrl = 4'b0100; // XOR
                    3'b110: alu_ctrl = 4'b0011; // OR
                    3'b111: alu_ctrl = 4'b0010; // AND
                    3'b001: alu_ctrl = 4'b0101; // SLL
                    3'b101: alu_ctrl = 4'b0110; // SRL
                    default: alu_ctrl = 4'b0000;
                endcase
            end
            7'b0010011: begin // I-type (ADDI)
                reg_we = 1; alu_src = 1; mem_to_reg = 0; alu_ctrl = 4'b0000;
            end
            7'b0000011: begin // LW
                reg_we = 1; alu_src = 1; mem_to_reg = 1; alu_ctrl = 4'b0000;
            end
            7'b0100011: begin // SW
                mem_we = 1; alu_src = 1; alu_ctrl = 4'b0000;
            end
            7'b1100011: begin // BEQ, BNE
                branch = 1; alu_src = 0; alu_ctrl = 4'b0001;
                if (funct3 == 3'b001) is_bne = 1;
            end
            7'b1101111: begin // JAL
                jump = 1; reg_we = 1; mem_to_reg = 0;
            end
            7'b0110111: begin // LUI
                reg_we = 1; alu_src = 1; mem_to_reg = 0; alu_ctrl = 4'b0111; 
            end
        endcase
    end
endmodule
