`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Instituto Tecnológico de Costa Rica
// Engineer: Ronny Zárate Ferreto
// 
// Create Date: 16.03.2018 21:51:07
// Design Name: 
// Module Name: EXE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module EXE(
// DATOS de entrada
    input clk,
    input [31:0] DATO_A_IN,
    input [31:0] DATO_B_IN,
    input [31:0] DATO_SIGN_EXT_IN,
    input [31:0] PC_IN,
    input [4:0] RS1_IN,
    input [4:0] RS2_IN,
    input [4:0] INST_IN,
    input [4:0] CRT_MEM_IN,
    input [1:0] CRT_WB_IN,
    input [2:0] CRT_EXE_IN,
// Se�ales de control    
    input [6:0] FUNCT7_IN,
    input [2:0] FUNCT3_IN,
    input [31:0] EX_MEM_RESULT_IN,
    input [4:0] EX_MEM_RD_IN,
    input EX_MEM_REG_WRITE_IN,
    input EX_MEM_MEM_TO_REG_IN,
    input [31:0] MEM_WB_DATA_IN,
    input [4:0] MEM_WB_RD_IN,
    input MEM_WB_REG_WRITE_IN,

// Datos Salida
    output [4:0] CRT_MEM_OUT, 
    output [1:0] CRT_WB_OUT,  
    output [31:0] PC_NEXT_OUT,  
    output reg BRANCH_TAKEN_OUT,
    output ZERO_OUT,  
    output [31:0] ALU_RESULT,
    output [31:0] DATO_B_OUT,  
    output [4:0] INST_OUT  
    );
    
    // REGISTROS UTILIZADOS
    reg [31:0] DATO_B_MUX;
    reg [31:0] PC_NEXT_REG_OUT;
    reg [31:0] SHIFT_2_DATA;
    reg [31:0] FORWARDED_A;
    reg [31:0] FORWARDED_B;

   // INSTANCIA
    SHIFTER INS_SHIFTER ( .In(DATO_SIGN_EXT_IN), .Out(SHIFT_2_DATA));
    
    ALU_FINAL INS_ALU (.clk(clk), .a(FORWARDED_A),.b(DATO_B_MUX), .Alu_op(CRT_EXE_IN[2:1]), .funct7(FUNCT7_IN), .funct3(FUNCT3_IN),
                       .zero(ZERO_OUT),.result(ALU_RESULT));
                       
    // DATOS QUE PASAN SIN CAMBIOS 
    assign CRT_MEM_OUT = CRT_MEM_IN;
    assign CRT_WB_OUT = CRT_WB_IN;
    assign DATO_B_OUT = FORWARDED_B;
    assign INST_OUT = INST_IN;
                   
    always @*
        begin
            FORWARDED_A = DATO_A_IN;
            FORWARDED_B = DATO_B_IN;

            if (EX_MEM_REG_WRITE_IN && !EX_MEM_MEM_TO_REG_IN &&
                (EX_MEM_RD_IN != 5'd0) && (EX_MEM_RD_IN == RS1_IN))
                FORWARDED_A = EX_MEM_RESULT_IN;
            else if (MEM_WB_REG_WRITE_IN && (MEM_WB_RD_IN != 5'd0) &&
                     (MEM_WB_RD_IN == RS1_IN))
                FORWARDED_A = MEM_WB_DATA_IN;

            if (EX_MEM_REG_WRITE_IN && !EX_MEM_MEM_TO_REG_IN &&
                (EX_MEM_RD_IN != 5'd0) && (EX_MEM_RD_IN == RS2_IN))
                FORWARDED_B = EX_MEM_RESULT_IN;
            else if (MEM_WB_REG_WRITE_IN && (MEM_WB_RD_IN != 5'd0) &&
                     (MEM_WB_RD_IN == RS2_IN))
                FORWARDED_B = MEM_WB_DATA_IN;

            if (CRT_EXE_IN[0])
                DATO_B_MUX = DATO_SIGN_EXT_IN;
            else
                DATO_B_MUX = FORWARDED_B;

            PC_NEXT_REG_OUT = PC_IN + SHIFT_2_DATA;
            case (FUNCT3_IN)
                3'b000: BRANCH_TAKEN_OUT = CRT_MEM_IN[0] && (FORWARDED_A == FORWARDED_B);
                3'b001: BRANCH_TAKEN_OUT = CRT_MEM_IN[0] && (FORWARDED_A != FORWARDED_B);
                3'b100: BRANCH_TAKEN_OUT = CRT_MEM_IN[0] && ($signed(FORWARDED_A) < $signed(FORWARDED_B));
                3'b101: BRANCH_TAKEN_OUT = CRT_MEM_IN[0] && ($signed(FORWARDED_A) >= $signed(FORWARDED_B));
                3'b110: BRANCH_TAKEN_OUT = CRT_MEM_IN[0] && (FORWARDED_A < FORWARDED_B);
                3'b111: BRANCH_TAKEN_OUT = CRT_MEM_IN[0] && (FORWARDED_A >= FORWARDED_B);
                default: BRANCH_TAKEN_OUT = 1'b0;
            endcase
        end
   
   assign PC_NEXT_OUT = PC_NEXT_REG_OUT;         
    
endmodule
