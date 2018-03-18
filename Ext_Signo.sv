`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 21:38:54
// Design Name: 
// Module Name: Ext_Signo
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
module Ext_Signo(
    input [11:0] IN_16,
    output [31:0] OUT_32
    );
	 
	 //assign OUT_32 = {{20{IN_16[12]}},IN_16[11:0]};
    assign OUT_32 = {20'b00000000000000000000,IN_16[11:0]};

endmodule

