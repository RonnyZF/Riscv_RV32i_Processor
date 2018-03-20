`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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
    output [2:0] CRT_MEM_OUT,
    output [2:0] CRT_EXE_OUT,
    output [6:0] FUNCT7_OUT,
    output [2:0] FUNCT3_OUT
    //output [31:0] rr
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
    reg [2:0] CRT_MEM;
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
    
    always @*
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

    // Instanciación
    CONTROL_UNIT CTRL_UNIT(
        .Opcode_in(OPCODE),
        .RegWrite_out(CRT_WB[0]),
        .MemWrite_out(CRT_MEM[2]), .MemRead_out(CRT_MEM[1]), .MemtoReg_out(CRT_WB[1]),
        .Branch_out(CRT_MEM[0]),
        .AluOp_out(CRT_EXE[2:1]),
        .AluSrc_out(CRT_EXE[0]) 
        );
    //wire [31:0] r
    banco_reg REG_BANK (.RegWrite(CRT_WB_IN), .ReadRegister1(READ1),.ReadRegister2(READ2),
                           .WriteRegister(INST),.rst(rst), .clk(clk), .WriteData(WRITE_DATA),
                           .ReadData1(DATA_A), .ReadData2(DATA_B));
   // assign rr=r;                      
    Ext_Signo SIGN_EXT ( .IN_16(DATA_SE), .OUT_32(DATA_SE_EX));
    
    /*
    RegisterBanc regbank(
            .ReadData1(rdata1),
            .ReadData2(rdata2),
            .WriteData(writedata),
            .ReadAddr1(muxout1),
            .ReadAddr2(muxout2),
            .WriteAddr(writeaddress1),
            .RegWrite(regwrite3),
            .clk(clk),
            .ro(r)
        );    */
    
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

