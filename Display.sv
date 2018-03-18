`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 22:08:41
// Design Name: 
// Module Name: Display
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


module Display
	(
	input wire clk, reset,
	input reg [31:0]register,
	//input wire [3:0] reg_a, reg_b, reg_c, reg_d,reg_e, reg_f, reg_g, reg_h,
	output reg an0, an1, an2, an3,an4, an5, an6, an7,
	output reg [6:0] out_disp
    );
	reg an00, an11, an22, an33,an44, an55, an66, an77;
	reg [3:0] reg_disp;
	reg [26:0] count1;
	reg [1:0] count2;
	reg [2:0] count;
	reg [3:0] reg_a, reg_b, reg_c, reg_d,reg_e, reg_f, reg_g, reg_h;
	
	assign reg_a=register[31:28];
    assign reg_b=register[27:24];
    assign reg_c=register[23:20];
    assign reg_d=register[19:16];
    assign reg_e=register[15:12];
    assign reg_f=register[11:8];
    assign reg_g=register[7:4];
    assign reg_h=register[3:0];
	 //contador

//contador1
	always @ (posedge clk or posedge reset)
	
		if (reset)
			begin
				count1<=0;
				
			end
		else
			begin
				if (count1==27'b000000001011110000100000000)
					count1<=27'b000000000000000000000000000;
				else 
					count1<=count1 + 27'b000000000000000000000000001;
			end


//contador2	
	always @ (posedge clk or posedge reset)

		if (reset) 
			begin
				count2 <= 3'b000;
			end 
		else 
			begin
				if (count1==27'b000000001011110000100000000)
					count2 <= count2 + 3'b001;
				//else if ( count2 == 2'b11)
					//begin
				//		count2 <= 2'b00;
				//		count2 <= count2 + 2'b01;
					//end
			end
	
// modulo salida de encendido display	

   always @(posedge clk or posedge reset)
		if (reset)
			begin
				an0 <= 1'b1;
				an1 <= 1'b1;
				an2 <= 1'b1;
				an3 <= 1'b1;
				an4 <= 1'b1;
                an5 <= 1'b1;
                an6 <= 1'b1;
                an7 <= 1'b1;
			end
			
      else 
			if(count2 == 3'b000)
				begin
					an0 <= 1'b0;
					an1 <= 1'b1;
					an2 <= 1'b1;
					an3 <= 1'b1;
					an4 <= 1'b1;
                    an5 <= 1'b1;
                    an6 <= 1'b1;
                    an7 <= 1'b1;
					reg_disp=reg_h;
				end
			else 
				if (count2 == 3'b001)
					begin
					
						an0 <= 1'b1;
						an1 <= 1'b0;
						an2 <= 1'b1;
						an3 <= 1'b1;
						an4 <= 1'b1;
                        an5 <= 1'b1;
                        an6 <= 1'b1;
                        an7 <= 1'b1;
						reg_disp=reg_g;
					end
                else 
                    if (count2 == 3'b010)
                        begin
                            an0 <= 1'b1;
                            an1 <= 1'b1;
                            an2 <= 1'b0;
                            an3 <= 1'b1;
                            an4 <= 1'b1;
                            an5 <= 1'b1;
                            an6 <= 1'b1;
                            an7 <= 1'b1;
                            reg_disp=reg_f;
                        end
                    else
                        if (count2 == 3'b011)
                            begin
                                an0 <= 1'b1;
                                an1 <= 1'b1;
                                an2 <= 1'b1;
                                an3 <= 1'b0;
                                an4 <= 1'b1;
                                an5 <= 1'b1;
                                an6 <= 1'b1;
                                an7 <= 1'b1;
                                reg_disp=reg_e;
                            end
                        else
                            if (count2 == 3'b100)
                                begin
                                    an0 <= 1'b1;
                                    an1 <= 1'b1;
                                    an2 <= 1'b1;
                                    an3 <= 1'b1;
                                    an4 <= 1'b0;
                                    an5 <= 1'b1;
                                    an6 <= 1'b1;
                                    an7 <= 1'b1;
                                    reg_disp=reg_d;
                                end
                            else
                                if (count2 == 3'b101)
                                    begin
                                        an0 <= 1'b1;
                                        an1 <= 1'b1;
                                        an2 <= 1'b1;
                                        an3 <= 1'b1;
                                        an4 <= 1'b1;
                                        an5 <= 1'b0;
                                        an6 <= 1'b1;
                                        an7 <= 1'b1;
                                        reg_disp=reg_c;
                                  
                                    end

                                 else
                                      if (count2 == 3'b110)
                                           begin
                                               an0 <= 1'b1;
                                               an1 <= 1'b1;
                                               an2 <= 1'b1;
                                               an3 <= 1'b1;
                                               an4 <= 1'b1;
                                               an5 <= 1'b1;
                                               an6 <= 1'b0;
                                               an7 <= 1'b1;
                                               reg_disp=reg_b;
                                           
                                           end
                                    else
                                        if (count2 == 3'b111)
                                            begin
                                              an0 <= 1'b1;
                                              an1 <= 1'b1;
                                              an2 <= 1'b1;
                                              an3 <= 1'b1;
                                              an4 <= 1'b1;
                                              an5 <= 1'b1;
                                              an6 <= 1'b1;
                                              an7 <= 1'b0;
                                              reg_disp=reg_a;
                                     
                                            end
                                        else
                                            begin
                                                an0 <= 1'b1;
                                                an1 <= 1'b1;
                                                an2 <= 1'b1;
                                                an3 <= 1'b1;
                                                an4 <= 1'b1;
                                                an5 <= 1'b1;
                                                an6 <= 1'b1;
                                                an7 <= 1'b1;
                                            end
                                        
                                
	always @*
		begin
			case (reg_disp)
				4'b0000: out_disp[6:0] = 7'b1000000;//0
				4'b0001: out_disp[6:0] = 7'b1111001;//1
				4'b0010: out_disp[6:0] = 7'b0100100;//2
				4'b0011: out_disp[6:0] = 7'b0110000;//3
				4'b0100: out_disp[6:0] = 7'b0011001;//4
				4'b0101: out_disp[6:0] = 7'b0010010;//5
				4'b0110: out_disp[6:0] = 7'b0000010;
				4'b0111: out_disp[6:0] = 7'b1111000;
				4'b1000: out_disp[6:0] = 7'b0000000;
				4'b1001: out_disp[6:0] = 7'b0010000;//9
				4'b1010: out_disp[6:0] = 7'b0001000;//A
				4'b1011: out_disp[6:0] = 7'b0000011;//B
				4'b1100: out_disp[6:0] = 7'b0000110;//C
				4'b1101: out_disp[6:0] = 7'b0100001;//D
				4'b1110: out_disp[6:0] = 7'b0000110;//E
				4'b1111: out_disp[6:0] = 7'b0001110;//F
				default: out_disp[6:0] = 7'b0000110;
			endcase
		end
		
endmodule
