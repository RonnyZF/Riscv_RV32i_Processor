`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 21:58:34
// Design Name: 
// Module Name: Alu_ctrl
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

module Alu_ctrl(
    input [1:0] Alu_op,
    input [6:0] funct7,
    input [2:0] funct3,
    output reg [3:0] ctrl
    );
    initial
     begin
     ctrl = 4'b0000;
     end
    always @*
        begin
            case (Alu_op)
            2'b00: ctrl = 4'b0010;
            2'b01: ctrl = 4'b0110;
            2'b11: ctrl = 4'b0110;
            2'b10: //2'b11: REVISAR
                case(funct7)
                    7'b0000000:
                            case(funct3)
                                3'b000: ctrl = 4'b0010;
                                3'b111: ctrl = 4'b0000;
                                3'b110: ctrl = 4'b0001;
                                default: ctrl = 4'b0000;
                            endcase
                    7'b0100000: ctrl = 4'b0110;
//                    default: ctrl = 4'b0000;
                endcase
//            default: ctrl = 4'b0000;
            endcase
        end            
endmodule
