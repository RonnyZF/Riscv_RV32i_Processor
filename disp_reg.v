`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2018 04:46:50
// Design Name: 
// Module Name: disp_reg
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


module disp_reg(

    input wire clk,rst,
    input wire [4:0] register, //banco de registros
    input [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10,
                reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20,
                reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31,
    input wire tick_r,      //fpga
    input wire tick_l,      //fpga
    output reg [31:0] data_reg,     //módulo display
    output reg [4:0] leds           //fpga

    );
    
    always @*
        begin
            case (register)
                5'd0: leds [4:0] = 5'b00000;    //R0
                5'd1: leds [4:0] = 5'b00001;    //R1
                5'd2: leds [4:0] = 5'b00010;    //R2
                5'd3: leds [4:0] = 5'b00011;    //R3
                5'd4: leds [4:0] = 5'b00100;    //R4    
                5'd5: leds [4:0] = 5'b00101;    //R5    
                5'd6: leds [4:0] = 5'b00110;    //R6
                5'd7: leds [4:0] = 5'b00111;    //R7
                5'd8: leds [4:0] = 5'b01000;    //R8
                5'd9: leds [4:0] = 5'b01001;    //R9
                5'd10: leds [4:0] = 5'b01010;    //R10                           
                5'd11: leds [4:0] = 5'b01011;    //R11                           
                5'd12: leds [4:0] = 5'b01100;    //R12                           
                5'd13: leds [4:0] = 5'b01101;    //R13                           
                5'd14: leds [4:0] = 5'b01110;    //R14                           
                5'd15: leds [4:0] = 5'b01111;    //R15                           
                5'd16: leds [4:0] = 5'b10000;    //R16                           
                5'd17: leds [4:0] = 5'b10001;    //R17                           
                5'd18: leds [4:0] = 5'b10010;    //R18                           
                5'd19: leds [4:0] = 5'b10011;    //R19                           
                5'd20: leds [4:0] = 5'b10100;    //R20                               
                5'd21: leds [4:0] = 5'b10101;    //R21                               
                5'd22: leds [4:0] = 5'b10110;    //R22                               
                5'd23: leds [4:0] = 5'b10111;    //R23                               
                5'd24: leds [4:0] = 5'b11000;    //R24                               
                5'd25: leds [4:0] = 5'b11001;    //R25                               
                5'd26: leds [4:0] = 5'b11010;    //R26                               
                5'd27: leds [4:0] = 5'b11011;    //R27                               
                5'd28: leds [4:0] = 5'b11100;    //R28                               
                5'd29: leds [4:0] = 5'b11101;    //R29
                5'd30: leds [4:0] = 5'b11110;    //R30                               
                5'd31: leds [4:0] = 5'b11111;    //R31
                default: leds [4:0] = 5'b00000;
            endcase
        end
        
    always @(posedge clk or posedge rst)
        begin
            if (rst)
                leds <= 5'b00000;
            else
                if (tick_r)
                    leds <= leds + 5'b00001;
                else
                    if (tick_l)
                        leds <= leds - 5'b00001;
                        
        end
    
    always @*
        begin
            case (leds)
                5'b00000: data_reg=reg0; 
                5'b00001: data_reg=reg1;
                5'b00010: data_reg=reg2;    
                5'b00011: data_reg=reg3;   
                5'b00100: data_reg=reg4;   
                5'b00101: data_reg=reg5;   
                5'b00110: data_reg=reg6;   
                5'b00111: data_reg=reg7;   
                5'b01000: data_reg=reg8;   
                5'b01001: data_reg=reg9;   
                5'b01010: data_reg=reg10;  
                5'b01011: data_reg=reg11;  
                5'b01100: data_reg=reg12;  
                5'b01101: data_reg=reg13;  
                5'b01110: data_reg=reg14;  
                5'b01111: data_reg=reg15;  
                5'b10000: data_reg=reg16;  
                5'b10001: data_reg=reg17;  
                5'b10010: data_reg=reg18;  
                5'b10011: data_reg=reg19;  
                5'b10100: data_reg=reg20;  
                5'b10101: data_reg=reg21;  
                5'b10110: data_reg=reg22;  
                5'b10111: data_reg=reg23;  
                5'b11000: data_reg=reg24;  
                5'b11001: data_reg=reg25;  
                5'b11010: data_reg=reg26;  
                5'b11011: data_reg=reg27;  
                5'b11100: data_reg=reg28;  
                5'b11101: data_reg=reg29;  
                5'b11110: data_reg=reg30;  
                5'b11111: data_reg=reg31;
                default: data_reg=32'b0;
            endcase
        end
            
endmodule
