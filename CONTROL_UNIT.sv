`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 21:30:19
// Design Name: 
// Module Name: CONTROL_UNIT
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


module CONTROL_UNIT(

    input [6:0] Opcode_in,
    output  RegWrite_out,
    output  MemWrite_out, MemRead_out, MemtoReg_out,
    output  Branch_out,
    output  [1:0] AluOp_out,
    output  AluSrc_out
    );
    reg RegWrite;
    reg MemWrite, MemRead, MemtoReg;
    reg Branch;
    reg [1:0] AluOp;
    reg AluSrc;
//Inicialización
    always @ * begin
        
end
always @*
            begin
// Instrucciones Tipo R    
        case(Opcode_in)
        7'b0110011: //opcode tipo R
        begin
            RegWrite = 1'b1;
            MemWrite=1'b0;
            MemRead=1'b0;
            MemtoReg=1'b1;//
            Branch=1'b0;
            AluOp=2'b10;
            AluSrc=1'b0;

        end
             
// Instrucciones Tipo I
        7'b0010011: //opcode tipo I
            begin  
                RegWrite = 1'b1;
                MemWrite=1'b0;
                MemRead=1'b1;
                MemtoReg=1'b1;
                Branch=1'b0;
                AluOp=2'b00;
                AluSrc=1'b1; 
            end
// Instruccion LW
        7'b0000011: //opcode tipo I
            begin  
                RegWrite = 1'b1;
                MemWrite=1'b0;
                MemRead=1'b1;
                MemtoReg=1'b0;
                Branch=1'b0;
                AluOp=2'b00;
                AluSrc=1'b1; 
            end
// Instrucciones Tipo S
          
        7'b0100011:  //opcode tipo S
            begin  
                RegWrite = 1'b0;
                MemWrite=1'b1;
                MemRead=1'b0;
                MemtoReg=1'b1;
                Branch=1'b0;
                AluOp=2'b00;
                AluSrc=1'b1; 
            end
            
// Instrucciones Tipo B
           
        7'b1100011:  //opcode tipo B
            begin  
                RegWrite = 1'b0;
                MemWrite=1'b0;
                MemRead=1'b0;
                MemtoReg=1'b1;
                Branch=1'b1;
                AluOp=2'b01;
                AluSrc=1'b0; 
            end
        default:
           begin  
                        RegWrite = 1'b0;
                        MemWrite=1'b0;
                        MemRead=1'b0;
                        MemtoReg=1'b0;
                        Branch=1'b0;
                        AluOp=2'b00;
                        AluSrc=1'b0; 
                    end
        endcase
        end
    assign RegWrite_out = RegWrite;
    assign MemWrite_out = MemWrite;
    assign MemRead_out = MemRead;
    assign MemtoReg_out = MemtoReg;
    assign Branch_out = Branch;
    assign AluOp_out = AluOp;
    assign AluSrc_out = AluSrc;
endmodule
