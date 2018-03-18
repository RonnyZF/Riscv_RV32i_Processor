`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 22:06:49
// Design Name: 
// Module Name: WR
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


module WR(
    input  CRT_WB_IN,
    input [31:0] DATA_M,
    input [31:0] DATA_E,
    output [31:0] DATA_OUT
    );
    
    reg MUX_CRT;
    reg [31:0] DATA;
    assign MUX_CRT = CRT_WB_IN;
    always @ * begin
            case (MUX_CRT)
                1'b0: DATA = DATA_M;
                1'b1: DATA = DATA_E;
                default: DATA = 32'b00000000000000000000000000000000;
            endcase
            end
   assign DATA_OUT = DATA;
endmodule
