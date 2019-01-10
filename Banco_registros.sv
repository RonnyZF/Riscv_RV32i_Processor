`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Instituto Tecnológico de Costa Rica
// Engineer: Ronny Zárate Ferreto
// 
// Create Date: 16.03.2018 21:34:53
// Design Name: 
// Module Name: Banco_registros
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
module Banco_registros(
    input RegWrite,
    input [4:0] ReadRegister1,
    input [4:0] ReadRegister2,
    input [4:0] WriteRegister,
    input clk,
	input rst,
    input [31:0] WriteData,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2, 
	output reg [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10,
				reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20,
				reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31
	);			 
	
		always @(negedge clk) begin
			if (rst) 
			     begin
                    reg0  = 32'h00000000;
                    reg1  = 32'h00000000;
                    reg2  = 32'h00000000;
                    reg3  = 32'h00000000;
                    reg4  = 32'h00000000;
                    reg5  = 32'h00000000;
                    reg6  = 32'h00000000;
                    reg7  = 32'h00000000;
                    reg8  = 32'h00000000;
                    reg9  = 32'h00000000;
                    reg10 = 32'h00000000;
                    reg11 = 32'h00000000;
                    reg12 = 32'h00000000;
                    reg13 = 32'h00000000;
                    reg14 = 32'h00000000;
                    reg15 = 32'h00000000;
                    reg16 = 32'h00000000;
                    reg17 = 32'h00000000;
                    reg18 = 32'h00000000;
                    reg19 = 32'h00000000;
                    reg20 = 32'h00000000;
                    reg21 = 32'h00000000;
                    reg22 = 32'h00000000;
                    reg23 = 32'h00000000;
                    reg24 = 32'h00000000;
                    reg25 = 32'h00000000;
                    reg26 = 32'h00000000;
                    reg27 = 32'h00000000;
                    reg28 = 32'h00000000;
                    reg29 = 32'h00000000;
                    reg30 = 32'h00000000;
                    reg31 = 32'h00000000;
                end
			else begin
				if (RegWrite)
					case(WriteRegister)
                    5'd0:  reg0  = 32'h00000000;
                    5'd1:  reg1  = WriteData;
                    5'd2:  reg2  = WriteData;
                    5'd3:  reg3  = WriteData;
                    5'd4:  reg4  = WriteData;
                    5'd5:  reg5  = WriteData;
                    5'd6:  reg6  = WriteData;
                    5'd7:  reg7  = WriteData;
                    5'd8:  reg8  = WriteData;
                    5'd9:  reg9  = WriteData;
                    5'd10: reg10 = WriteData;
                    5'd11: reg11 = WriteData;
                    5'd12: reg12 = WriteData;
                    5'd13: reg13 = WriteData;
                    5'd14: reg14 = WriteData;
                    5'd15: reg15 = WriteData;
                    5'd16: reg16 = WriteData;
                    5'd17: reg17 = WriteData;
                    5'd18: reg18 = WriteData;
                    5'd19: reg19 = WriteData;
                    5'd20: reg20 = WriteData;
                    5'd21: reg21 = WriteData;
                    5'd22: reg22 = WriteData;
                    5'd23: reg23 = WriteData;
                    5'd24: reg24 = WriteData;
                    5'd25: reg25 = WriteData;
                    5'd26: reg26 = WriteData;
                    5'd27: reg27 = WriteData;
                    5'd28: reg28 = WriteData;
                    5'd29: reg29 = WriteData;
                    5'd30: reg30 = WriteData;
                    5'd31: reg31 = WriteData;
				endcase
			end
		end
	always @ * begin
                case(ReadRegister1)
                    5'd0: ReadData1 = reg0;  
                    5'd1: ReadData1 = reg1;  
                    5'd2: ReadData1 = reg2;  
                    5'd3: ReadData1 = reg3;  
                    5'd4: ReadData1 = reg4;  
                    5'd5: ReadData1 = reg5;  
                    5'd6: ReadData1 = reg6;  
                    5'd7: ReadData1 = reg7;  
                    5'd8: ReadData1 = reg8;  
                    5'd9: ReadData1 = reg9;  
                    5'd10:ReadData1 =reg10; 
                    5'd11:ReadData1 =reg11; 
                    5'd12:ReadData1 =reg12; 
                    5'd13:ReadData1 =reg13; 
                    5'd14:ReadData1 =reg14; 
                    5'd15:ReadData1 =reg15; 
                    5'd16:ReadData1 =reg16; 
                    5'd17:ReadData1 =reg17; 
                    5'd18:ReadData1 =reg18; 
                    5'd19:ReadData1 =reg19; 
                    5'd20:ReadData1 =reg20; 
                    5'd21:ReadData1 =reg21; 
                    5'd22:ReadData1 =reg22; 
                    5'd23:ReadData1 =reg23; 
                    5'd24:ReadData1 =reg24; 
                    5'd25:ReadData1 =reg25; 
                    5'd26:ReadData1 =reg26; 
                    5'd27:ReadData1 =reg27; 
                    5'd28:ReadData1 =reg28; 
                    5'd29:ReadData1 =reg29; 
                    5'd30:ReadData1 =reg30; 
                    5'd31:ReadData1 =reg31; 
                endcase
                
                case(ReadRegister2)
                    5'd0: ReadData2 = reg0;  
                    5'd1: ReadData2 = reg1;  
                    5'd2: ReadData2 = reg2;  
                    5'd3: ReadData2 = reg3;  
                    5'd4: ReadData2 = reg4;  
                    5'd5: ReadData2 = reg5;  
                    5'd6: ReadData2 = reg6;  
                    5'd7: ReadData2 = reg7;  
                    5'd8: ReadData2 = reg8;  
                    5'd9: ReadData2 = reg9;  
                    5'd10:ReadData2 =reg10; 
                    5'd11:ReadData2 =reg11; 
                    5'd12:ReadData2 =reg12; 
                    5'd13:ReadData2 =reg13; 
                    5'd14:ReadData2 =reg14; 
                    5'd15:ReadData2 =reg15; 
                    5'd16:ReadData2 =reg16; 
                    5'd17:ReadData2 =reg17; 
                    5'd18:ReadData2 =reg18; 
                    5'd19:ReadData2 =reg19; 
                    5'd20:ReadData2 =reg20; 
                    5'd21:ReadData2 =reg21; 
                    5'd22:ReadData2 =reg22; 
                    5'd23:ReadData2 =reg23; 
                    5'd24:ReadData2 =reg24; 
                    5'd25:ReadData2 =reg25; 
                    5'd26:ReadData2 =reg26; 
                    5'd27:ReadData2 =reg27; 
                    5'd28:ReadData2 =reg28; 
                    5'd29:ReadData2 =reg29; 
                    5'd30:ReadData2 =reg30; 
                    5'd31:ReadData2 =reg31; 
                endcase
            end
endmodule