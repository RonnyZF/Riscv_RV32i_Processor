`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Instituto Tecnológico de Costa Rica
// Engineer:  Ronny Zárate Ferreto
// 
// Create Date: 16.03.2018 21:28:38
// Design Name: 
// Module Name: DECO
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


module DECO(
    input rst,
    input clk,
    input [31:0] INSTRUCTION,
    input [31:0] WRITE_DATA,
    input [4:0] INST,
    input  CRT_WB_IN,

    output [31:0] DATA_A_OUT,
    output [31:0] DATA_B_OUT,
    output [31:0] DATA_SE_OUT,
    output [4:0] INST_OUT,
    output [1:0] CRT_WB_OUT,
    output [4:0] CRT_MEM_OUT,
    output [2:0] CRT_EXE_OUT,
    output [6:0] FUNCT7_OUT,
    output [2:0] FUNCT3_OUT,
    
    output reg [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10,
                    reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20,
                    reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31
    );
    
    reg [6:0] OPCODE;
    reg [4:0] READ1;
    reg [4:0] READ2;
    reg [11:0] DATA_SE; 
    reg [31:0] DATA_SE_EX;
    reg [4:0] INST_DATA;
    reg [31:0] DATA_A;
    reg [31:0] DATA_B;
    reg [1:0] CRT_WB;
    reg [4:0] CRT_MEM;
    reg [2:0] CRT_EXE;
    reg [6:0] FUNCT7_DATA;
    reg [2:0] FUNCT3_DATA;
    reg [11:0] IMM_I;
    reg [11:0] IMM_S;
    reg [11:0] IMM_B;
    reg [11:0] IMM;
    
    assign IMM_I = INSTRUCTION[31:20];
    assign IMM_S = {INSTRUCTION[31:25],INSTRUCTION[11:7]};
    assign IMM_B = {INSTRUCTION[31:25],INSTRUCTION[11:7]};
    assign DATA_SE = IMM;
    assign OPCODE = INSTRUCTION[6:0];
    assign READ1 =  INSTRUCTION[19:15];
    assign READ2 =  INSTRUCTION[24:20];
    assign INST_DATA = INSTRUCTION[11:7];
    assign FUNCT7_DATA = INSTRUCTION [31:25];
    assign FUNCT3_DATA = INSTRUCTION [14:12];
    
    always @ *
        begin
            case(OPCODE)
            7'b0010011: // TIPO I
                begin
                IMM = IMM_I;
                end
            7'b0100011: // TIPO S
                begin
                IMM = IMM_S;
                end
            7'b1100011: // TIPO B
                begin
                IMM = IMM_B;
                end
            default: 
                begin
                   IMM = IMM_I;
                end
            endcase
       end
       
    always @ *
           begin
               case(FUNCT3_DATA)
               3'b000: 
                   CRT_MEM [4:3] = 2'b01; //BEQ
               3'b001:
                   CRT_MEM [4:3] = 2'b10; //BNE
               3'b100: 
                   CRT_MEM [4:3] = 2'b11; //BLT
               default: 
                   CRT_MEM [4:3] = 2'b00;
               endcase
          end
//            always @ *
//                begin
//                if (FUNCT3_DATA==000)
//                    CRT_MEM [4:3] = 2'b01;
//                else if (FUNCT3_DATA==001)
//                    CRT_MEM [4:3] = 2'b10;            
//                else if (FUNCT3_DATA==100)
//                    CRT_MEM [4:3] = 2'b11;
//                end
    // Instanciaci�n
    CONTROL_UNIT CTRL_UNIT(
        .Opcode_in(OPCODE),
        .RegWrite_out(CRT_WB[0]),
        .MemWrite_out(CRT_MEM[2]), .MemRead_out(CRT_MEM[1]), .MemtoReg_out(CRT_WB[1]),
        .Branch_out(CRT_MEM[0]),
        .AluOp_out(CRT_EXE[2:1]),
        .AluSrc_out(CRT_EXE[0]) 
        );
    Banco_registros Banco_registros (.RegWrite(CRT_WB_IN), .ReadRegister1(READ1),.ReadRegister2(READ2),
                           .WriteRegister(INST),.rst(rst), .clk(clk), .WriteData(WRITE_DATA),
                           .ReadData1(DATA_A), .ReadData2(DATA_B),
                           .reg0(reg0), .reg1(reg1), .reg2(reg2), .reg3(reg3), .reg4(reg4), .reg5(reg5), .reg6(reg6), .reg7(reg7), .reg8(reg8), .reg9(reg9), .reg10(reg10),
                           .reg11(reg11), .reg12(reg12), .reg13(reg13), .reg14(reg14), .reg15(reg15), .reg16(reg16), .reg17(reg17), .reg18(reg18), .reg19(reg19), .reg20(reg20),
                           .reg21(reg21), .reg22(reg22), .reg23(reg23), .reg24(reg24), .reg25(reg25), .reg26(reg26), .reg27(reg27), .reg28(reg28), .reg29(reg29), .reg30(reg30), .reg31(reg31));
                   
    Ext_Signo SIGN_EXT ( .IN_16(DATA_SE), .OUT_32(DATA_SE_EX));
    
    assign DATA_A_OUT = DATA_A;
    assign DATA_B_OUT = DATA_B;
    assign DATA_SE_OUT = DATA_SE_EX;
    assign INST_OUT = INST_DATA;
    assign CRT_WB_OUT = CRT_WB;
    assign CRT_MEM_OUT = CRT_MEM;
    assign CRT_EXE_OUT = CRT_EXE;
    assign FUNCT7_OUT = FUNCT7_DATA;
    assign FUNCT3_OUT = FUNCT3_DATA;
    
endmodule