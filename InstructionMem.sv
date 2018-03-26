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
    		     4: Word = 32'h00910193; //Addi r3,r2,9
                 8: Word = 32'h00000033; //nop
                12: Word = 32'h00000033; //nop 
                16: Word = 32'h00518213; //Addi r4,r3,5
                20: Word = 32'h00000033; //nop
                24: Word = 32'h00000033; //nop
                28: Word = 32'h00210093; //Addi r1,r2,2
               112: Word = 32'h00000033; //nop
               128: Word = 32'h00000033; //nop
               144: Word = 32'h001182b3; //Add r5,r1,r3
               160: Word = 32'h00000311;
               176: Word = 32'hfed617e3;///////
               192: Word = 32'h006d61063;//beq
               208: Word = 32'h00472283;
               224: Word = 32'h00170713;
               240: Word = 32'h00472303;
                /*
                256: Word =32'h00170713;
                272: Word =32'h00472383;
                288: Word =32'h00170713;
                304: Word =32'h00472e03;
                320: Word =32'h00170713;
                336: Word =32'h00472e83;
                352: Word =32'h00170713;
                368: Word =32'h00472f03;
                384: Word =32'h00170713;
                400: Word =32'h00472f83;*/
	endcase 
end



endmodule


