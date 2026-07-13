module HAZARD_UNIT(
    input [31:0] ID_INSTRUCTION,
    input ID_EX_MEM_READ,
    input [4:0] ID_EX_RD,
    output reg STALL
    );

    reg uses_rs1;
    reg uses_rs2;
    wire [6:0] opcode = ID_INSTRUCTION[6:0];
    wire [4:0] rs1 = ID_INSTRUCTION[19:15];
    wire [4:0] rs2 = ID_INSTRUCTION[24:20];

    always @*
        begin
            uses_rs1 = 1'b0;
            uses_rs2 = 1'b0;
            case (opcode)
                7'b0110011: begin
                    uses_rs1 = 1'b1;
                    uses_rs2 = 1'b1;
                end
                7'b0010011, 7'b0000011: uses_rs1 = 1'b1;
                7'b0100011, 7'b1100011: begin
                    uses_rs1 = 1'b1;
                    uses_rs2 = 1'b1;
                end
                default: begin
                    uses_rs1 = 1'b0;
                    uses_rs2 = 1'b0;
                end
            endcase

            STALL = ID_EX_MEM_READ && (ID_EX_RD != 5'd0) &&
                    ((uses_rs1 && (ID_EX_RD == rs1)) ||
                     (uses_rs2 && (ID_EX_RD == rs2)));
        end
endmodule
