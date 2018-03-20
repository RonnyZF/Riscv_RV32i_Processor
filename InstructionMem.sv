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
    input logic [7:0] Address,
    output logic [31:0] Word
    );

	 always @* begin
	case (Address)
			     8: Word = 32'h00030333; 
                16: Word = 32'h00868693; 
                32: Word =32'h00070733;  
                48: Word =32'h00050533;
                64: Word =32'h00158593; 
                80: Word =32'h00a58633; 
                96: Word =32'h00050593; //salto del branch
                112: Word =32'h00060513; 
                128: Word =32'h00130313;
                144: Word =32'h00a58633;
                160: Word =32'h00b32223;
                176: Word =32'h00130313;
                192: Word =32'h006d61063;//beq
                208: Word =32'h00472283;
                224: Word =32'h00170713;
                240: Word =32'h00472303;
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


