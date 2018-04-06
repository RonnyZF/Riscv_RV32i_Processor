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
    input MUX_CRT_IN,
//    input  [4:0]INST_IN,
//    output reg [4:0] INST_OUT,
    output [31:0] DATA_OUT,
    output reg MUX_CRT_OUT
    );
    
    reg MUX_CRT;
    reg [31:0] DATA;
    assign MUX_CRT = CRT_WB_IN;
    assign MUX_CRT_OUT = MUX_CRT_IN;
//    assign INST_OUT = INST_IN;

    always @ * begin
            case (MUX_CRT)
                1'b0: DATA = DATA_M;
                1'b1: DATA = DATA_E;
//                default: DATA = 32'd0;
            endcase
            end
   assign DATA_OUT = DATA;
endmodule
