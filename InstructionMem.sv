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
//                4: Word = 32'h00100093; //Addi r1,zero,1
//                8: Word = 32'h00200113; //Addi r2,zero,2 
//                12: Word = 32'h00000033; //NOOP
//                20: Word = 32'h00300193; //Addi r3,zero,3
//                24: Word = 32'h00400213; //Addi r4,zero,4
//                28: Word = 32'h00400F93; //Addi r31,zero,4
//                36: Word = 32'h00908293; //Addi r5,r1,9
//                44: Word = 32'h01F2F313; //ANDI r6,r5,31 (1010 & 11111 = 01010)
//                48: Word = 32'h01F2E393; //ORI  r7,r5,31 (1010 & 11111 = 11111)
//                52: Word = 32'h00218433; //ADD r8,r2,r3  2 + 3
//                56: Word = 32'h404284B3; //SUB r9,r5,r4  10 - 4
//                60: Word = 32'h0032F533; //AND r10,r5,r3  1010 & 0011 
//                64: Word = 32'h00522223; //SW r5,4(r4) posición 8 de men tendra un 10
//                68: Word = 32'h00821423; //SH r8,8(r4) posición 12 de men tendra un 5 
//                72: Word = 32'h004F8463; //BEQ r31,r4,8
    
                 
//            4: Word =  32'h00000593;//  "move a1,zero;"   
//            8: Word = 32'h00000613;//  "move a2,zero;"   
//            12: Word = 32'h00000693;//  "move a3,zero;"   
//            16: Word = 32'h00000713;//  "move a4,zero;"   
//            20: Word = 32'h00000793;//  "move a5,zero;"   
//            24: Word = 32'h00000813;//  "move a6,zero;"   
//            28: Word = 32'h00000893;//  "move a7,zero;"   
//            32: Word = 32'h00550513;//  "addi a0,a0,5;"   
//            36: Word = 32'h00000033;//  NOOP --------------L1
//            40: Word = 32'h00158593;//  "addi a1,a1,1;"           
//            44: Word = 32'h00960613;//  "addi a2,a2,9;"
//            46: Word = 32'h00000033;//  NOOP   
//            52: Word = 32'h01f67693;//  "andi a3,a2,31;"  
//            56: Word = 32'h00a66713;//  "ori  a4,a2,10;"  
//            60: Word = 32'h00b607b3;//  "add a5,a2,a1;"   
//            64: Word = 32'h40b60833;//  "sub a6,a2,a1;"   
//            68: Word = 32'h00b678b3;//  "and a7,a2,a1;"   
//            72: Word = 32'h00000033;//  NOOP
//            76: Word = 32'h02A59263;//  "bne a0,a1,.L1;" 
//            80: Word = 32'h00000033;//  NOOP
//            88: Word = 32'h00000513;//  "move a0,zero;"   
//            92: Word = 32'h00000593;//  "move a1,zero;"   
//            96: Word = 32'h00000613;//  "move a2,zero;"   
//            100: Word = 32'h00a50513;//  "addi a0,a0,10;"  
//            104: Word = 32'h00458593;//  "addi a1,a1,4;"   
//            108: Word = 32'h00160613;//  "addi a2,a2,1;"                     
//            112: Word = 32'h00000033;//  NOOP -------------L2
//            116: Word = 32'h08C58663;//  "beq  a2,a1,.L3;"   
//            120: Word = 32'h00000033;//  NOOP               
//            128: Word = 32'h00160613;//  "addi a2,a2,1;" 
//            132: Word = 32'h00000033; //NOOP
//            136: Word = 32'h06C51863;//  "bne  a2,a0,.L2;"                            
//            140: Word = 32'h00000033; //NOOP---------------L3
            148: Word =  32'h00000513;// "move a0,zero;"   
            152: Word =  32'h00000593;// "move a1,zero;"   
            156: Word = 32'h00000613;//  "move a2,zero;"   
            160: Word = 32'h00000693;//  "move a3,zero;"   
            164: Word = 32'h00000713;//  "move a4,zero;"   
            168: Word = 32'h00000793;//  "move a5,zero;"   
            172: Word = 32'h00000813;//  "move a6,zero;"   
            176: Word = 32'h00000893;//  "move a7,zero;"                     
            180: Word = 32'h09068693;//"addi a3,a3,144;" 
            184: Word = 32'h00050533; //"add a0,a0,zero;"  
            188: Word = 32'h00158593; //"addi a1,a1,1;"
            196: Word = 32'h00a58633; //"add a2,a1,a0;"
//            200: Word = 32'h00000033; //NOOP---------------L4
            204: Word = 32'h00050593; //"addi a1,a0,0;"
            208: Word = 32'h00060513; //"addi a0,a2,0;"
//            212: Word = 32'h00000033; //NOOP
            216: Word = 32'h00c32223; //"sw a2,4(t1);"
            220: Word = 32'h00a58633; //"add a2,a1,a0;"
            224: Word = 32'h00430313; //"addi t1,t1,4;"
//            228: Word = 32'h00000033; //NOOP
            232: Word = 32'h0CC69463; //"bne a2,a3,.L4;"
            236: Word = 32'h00c32223; //"sw a2,4(t1);" 
//            240: Word = 32'h00000033; //NOOP
            244: Word = 32'h00472283; //"lw t0,4(a4);"
            248: Word = 32'h00470713; //"addi a4,a4,4;"
            252: Word = 32'h00472303; //"lw t1,4(a4);"
            256: Word = 32'h00470713; //"addi a4,a4,4;"
            260: Word = 32'h00472383; //"lw t2,4(a4);"
            264: Word = 32'h00470713; //"addi a4,a4,4;"
            268: Word = 32'h00472e03; //"lw t3,4(a4);"
            272: Word = 32'h00470713; //"addi a4,a4,4;"
            276: Word = 32'h00472e83; //"lw t4,4(a4);"
            280: Word = 32'h00470713; //"addi a4,a4,4;"
            284: Word = 32'h00472f03; //"lw t5,4(a4);"   
            288: Word = 32'h00470713; //"addi a4,a4,4;"  
            292: Word = 32'h00472f83; //"lw t6,4(a4);"
////            296: Word = 32'h00000033; //NOOP
////            300: Word = 32'h00000033; //NOOP
            304: Word = 32'h12530463; //"BEQ r5,r6,296"  
            
              default Word = 32'h00000000;
            
        endcase 
    end



endmodule