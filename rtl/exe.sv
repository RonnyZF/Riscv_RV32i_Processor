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
//    input [31:0] PC_NEXT_IN,
    input [4:0] INST_IN,
    input [4:0] CRT_MEM_IN,
    input [1:0] CRT_WB_IN,
    input [2:0] CRT_EXE_IN,
// Se�ales de control    
    input [6:0] FUNCT7_IN,
    input [2:0] FUNCT3_IN,

// Datos Salida
    output [4:0] CRT_MEM_OUT, 
    output [1:0] CRT_WB_OUT,  
    output [31:0] PC_NEXT_OUT,  
    output ZERO_OUT,  
    output [31:0] ALU_RESULT,
    output [31:0] DATO_B_OUT,  
    output [4:0] INST_OUT  
    );
    
    // REGISTROS UTILIZADOS
    reg [31:0] DATO_A;
    reg [31:0] DATO_B_MUX;
    reg [31:0] DATO_SIGN_EXT;
//    reg [31:0] PC_NEXT;
    reg [31:0] PC_NEXT_REG_OUT;
    reg [4:0] INST_OUT_REG;
    reg [31:0] SHIFT_2_DATA;
    reg ZERO_REG;
    reg [31:0] ALU_DATO;
    reg [6:0] FUNCT7_DATA;
    reg [2:0] FUNCT3_DATA;
    reg [2:0] CRT_EXE;
    reg CRT_MUX_ALU;
    reg [1:0] ALU_OP;

   // INSTANCIA
    SHIFTER INS_SHIFTER ( .In( DATO_SIGN_EXT), .Out(SHIFT_2_DATA));
    
    ALU_FINAL INS_ALU (.clk(clk), .a(DATO_A),.b(DATO_B_MUX), .Alu_op(ALU_OP), .funct7(FUNCT7_DATA), .funct3(FUNCT3_DATA),
                       .zero(ZERO_REG),.result(ALU_DATO));
                       
    // DATOS QUE PASAN SIN CAMBIOS 
    assign CRT_MEM_OUT = CRT_MEM_IN;
    assign CRT_WB_OUT = CRT_WB_IN;
    assign DATO_B_OUT = DATO_B_IN;
    
     // Asignaciones
     assign INST_OUT_REG = INST_IN;
     assign FUNCT7_DATA = FUNCT7_IN;
     assign FUNCT3_DATA = FUNCT3_IN;
     assign CRT_EXE = CRT_EXE_IN;
     assign CRT_MUX_ALU = CRT_EXE[0];
     assign ALU_OP = CRT_EXE[2:1];
     
    always @ (posedge clk)
        begin 
            DATO_A = DATO_A_IN;
            DATO_SIGN_EXT = DATO_SIGN_EXT_IN;
//            PC_NEXT = PC_NEXT_IN;
        end
    
    always @ (posedge clk)
            begin
               case (CRT_MUX_ALU)
                 1'b0: DATO_B_MUX <= DATO_B_IN;
                 1'b1: DATO_B_MUX <= DATO_SIGN_EXT_IN;
//                 default: DATO_B_MUX <= DATO_B_IN;
               endcase
             end
                   
  // PC NEXT
    always @ (posedge clk)
        begin
//            PC_NEXT_REG_OUT = PC_NEXT + SHIFT_2_DATA;  REVISAR
              PC_NEXT_REG_OUT = SHIFT_2_DATA; 
        end
   
   
   assign ZERO_OUT = ZERO_REG;         
   assign INST_OUT = INST_OUT_REG;
   assign PC_NEXT_OUT = PC_NEXT_REG_OUT;         
   assign ALU_RESULT = ALU_DATO;
    
endmodule
