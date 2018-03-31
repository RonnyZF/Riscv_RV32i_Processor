`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 21:46:47
// Design Name: 
// Module Name: InstructionMem
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
module InstructionMem(
    input clk,
    input logic [31:0] Address,
    output logic [31:0] Word
    );

	 always @ (posedge clk)  
	 begin
	case (Address[31:0])
    		     4: Word = 32'h00100093; //Addi r1,zero,1
                 8: Word = 32'h00200113; //Addi r2,zero,2 
                12: Word = 32'h00000033; //NOOP
                20: Word = 32'h00300193; //Addi r3,zero,3
                24: Word = 32'h00400213; //Addi r4,zero,4
                28: Word = 32'h00400F93; //Addi r31,zero,4
                36: Word = 32'h00908293; //Addi r5,r1,9
                44: Word = 32'h01F2F313; //ANDI r6,r5,31 (1010 & 11111 = 01010)
                48: Word = 32'h01F2E393; //ORI  r7,r5,31 (1010 & 11111 = 11111)
                52: Word = 32'h00218433; //ADD r8,r2,r3  2 + 3
                56: Word = 32'h404284B3; //SUB r9,r5,r4  10 - 4
                60: Word = 32'h0032F533; //AND r10,r5,r3  1010 & 0011 
                64: Word = 32'h00522223; //SW r5,4(r4) posición 8 de men tendra un 10
                68: Word = 32'h00821423; //SH r8,8(r4) posición 12 de men tendra un 5 
//                72: Word = 32'h004F8463; //BEQ r31,r4,8
                72: Word = 32'h001F9663; //BNE r31,r1,12 
            default Word = 32'h00000000;
	endcase 
end



endmodule


