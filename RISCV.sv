`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 21:20:52
// Design Name: 
// Module Name: RISCV
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



module RISC_V(
    input clk,
    input rst
    );
    
//Declaración de variables

    //FETCH STAGE OUTPUTS (_FO)
    reg [31:0] PC_FO, DATA_FO;
    
    //DECODE PIPELINE OUTPUTS (_DPO)
    reg [31:0] PC_DPO, DATA_DPO;
    
    //DECODE STAGE OUTPUTS(_DO)
    reg [31:0] DATA_A_DO;
    reg [31:0] DATA_B_DO;
    reg [31:0] DATA_SE_DO;
    reg [4:0]  INST_DO;
    reg [1:0]  CRT_WB_DO;
    reg [2:0]  CRT_MEM_DO;
    reg [2:0]  CRT_EXE_DO;
    reg [6:0]  FUNCT7_DO;
    reg [2:0]  FUNCT3_DO;
    
    //EXECUTE PIPELINE OUTPUTS (_EPO)
    reg [1:0]  CRT_WB_EPO;
    reg [2:0]  CRT_MEM_EPO;
    reg [2:0]  CRT_EXE_EPO;
    reg [31:0] PC_EPO;
    reg [31:0] DATA_A_EPO;
    reg [31:0] DATA_B_EPO;
    reg [31:0] DATA_SE_EPO;
    reg [4:0]  INST_EPO;
    reg [6:0] FUNCT7_EPO;
    reg [2:0] FUNCT3_EPO;
    
    //EXECUTE STAGE OUTPUTS (_EO)
    reg [2:0] CRT_MEM_EO;
    reg [1:0] CRT_WB_EO;
    reg [31:0] PC_NEXT_EO;
    reg ZERO_EO;
    reg [31:0] ALU_RESULT_EO;
    reg [31:0] DATO_B_EO; 
    reg [4:0] INST_EO;
    
    //MEMORY PIPELINE OUTPUTS (_MPO)
    reg [1:0] CRT_WB_MPO;
    reg [2:0] CRT_MEM_MPO;
    reg [31:0] PC_MPO;
    reg ZERO_MPO;
    reg [31:0] ALU_RESULT_MPO;
    reg [31:0] DATO_B_MPO;
    reg [4:0] INST_MPO;
    
    //MEMORY STAGE OUTPUTS (_MO)
    reg [31:0] DATA_MO;
    reg [31:0] ReadData_MO;
    reg [4:0] INST_MO;
    reg BRANCH_MO;
    reg [1:0] CRT_WB_MO;
    
    //WRITEBACK PIPELINE OUTPUTS (_WPO)
    reg  [1:0]  CRT_WB_WPO; 
    reg  [31:0] READ_DATA_WPO;
    reg  [31:0] ALU_RESULT_WPO;
    reg  [4:0]  INST_WPO;
    
    //WRITEBACK STAGE OUTPUTS (_WO)
    reg [31:0] DATA_WO;
    
//INSTANTIATIONS
  
    FETCH FETCH(
        .PC_MEM(PC_MPO), .rst(rst), .clk(clk),.MUX_CRT(BRANCH_MO), .PC_OUT(PC_FO), .DATA_OUT(DATA_FO));
        
    IF_ID_PIPELINE IF_ID_PIPELINE(
            .rst(rst), .clk(clk), .PC_IN(PC_FO), .DATA_IN(DATA_FO), .PC_OUT(PC_DPO), .DATA_OUT(DATA_DPO)
            );
            
    DECO DECO(
        .rst(rst), .clk(clk), .INSTRUCTION(DATA_DPO), .CRT_WB_IN(CRT_WB_WPO[0]), .WRITE_DATA(DATA_WO), .INST(INST_WPO), 
        
        .DATA_A_OUT(DATA_A_DO), .DATA_B_OUT(DATA_B_DO), .DATA_SE_OUT(DATA_SE_DO), .INST_OUT(INST_DO),
        .CRT_WB_OUT(CRT_WB_DO), .CRT_MEM_OUT(CRT_MEM_DO), .CRT_EXE_OUT(CRT_EXE_DO),
        .FUNCT7_OUT(FUNCT7_DO), .FUNCT3_OUT(FUNCT3_DO));

    ID_EXE_PIPELINE ID_EXE_PIPELINE(
        .rst(rst), .clk(clk), .CRT_WB_IN(CRT_WB_DO), .CRT_MEM_IN(CRT_MEM_DO), .CRT_EXE_IN(CRT_EXE_DO),
         
        .PC_IN(PC_DPO), .DATA_A_IN(DATA_A_DO), .DATA_B_IN(DATA_B_DO), .DATA_SE_IN(DATA_SE_DO), .INST_IN(INST_DO),
        .FUNCT7_IN(FUNCT7_DO), .FUNCT3_IN(FUNCT3_DO),
        
        .CRT_WB_OUT(CRT_WB_EPO), .CRT_MEM_OUT(CRT_MEM_EPO), .CRT_EXE_OUT(CRT_EXE_EPO), .PC_OUT(PC_EPO), 
        .DATA_A_OUT(DATA_A_EPO), .DATA_B_OUT(DATA_B_EPO), .DATA_SE_OUT(DATA_SE_EPO), .INST_OUT(INST_EPO),
        .FUNCT7_OUT(FUNCT7_EPO),.FUNCT3_OUT(FUNCT3_EPO)    
    );
          
    EXE EXE(
        //Datos de entrada
        .DATO_A_IN(DATA_A_EPO), .DATO_B_IN(DATA_B_EPO), .DATO_SIGN_EXT_IN(DATA_SE_EPO), .PC_NEXT_IN(PC_EPO), .INST_IN(INST_EPO), .CRT_MEM_IN(CRT_MEM_EPO), .CRT_WB_IN(CRT_WB_EPO),
        .FUNCT7_IN(FUNCT7_EPO), .FUNCT3_IN(FUNCT3_EPO), .CRT_EXE_IN(CRT_EXE_EPO),
        // Datos Salida
        .CRT_MEM_OUT(CRT_MEM_EO), .CRT_WB_OUT(CRT_WB_EO), .PC_NEXT_OUT(PC_NEXT_EO), .ZERO_OUT(ZERO_EO), .ALU_RESULT(ALU_RESULT_EO), .DATO_B_OUT(DATO_B_EO), .INST_OUT(INST_EO)
            );

    EXE_MEN_PIPELINE EXE_MEN_PIPELINE(
        .rst(rst), .clk(clk), .CRT_WB_IN(CRT_WB_EO), .CRT_MEM_IN(CRT_MEM_EO), .PC_IN(PC_NEXT_EO), .ZERO_IN(ZERO_EO), .ALU_RESULT_IN(ALU_RESULT_EO), .DATO_B_IN(DATO_B_EO), .INST_IN(INST_EO),
    
        .CRT_WB_OUT(CRT_WB_MPO), .CRT_MEM_OUT(CRT_MEM_MPO), .PC_OUT(PC_MPO), .ZERO_OUT(ZERO_MPO), .ALU_RESULT_OUT(ALU_RESULT_MPO), .DATO_B_OUT(DATO_B_MPO), .INST_OUT(INST_MPO)
    );

    MEM MEM(
        // Entradas control
        .clk(clk), .rst(rst), .CRT_MEM_IN(CRT_MEM_MPO), .CRT_WB_IN(CRT_WB_MPO), .CRT_WB_OUT(CRT_WB_MO),   //REVISAR        
        // Datos
        .ADDRESS_IN(ALU_RESULT_MPO), .DATA_IN(DATO_B_MPO), .ZERO_IN(ZERO_MPO), .INST_IN(INST_MPO), .DATA_OUT(DATA_MO), 
        
        .ReadData(ReadData_MO), .INST_OUT(INST_MO), .BRANCH_OUT(BRANCH_MO)
    );

    MEM_WB_PIPELINE MEN_WR_PIPELINE(
        .rst(rst), .clk(clk), .CRT_WB_IN(CRT_WB_MO), .READ_DATA_IN(ReadData_MO), .ALU_RESULT_IN(DATA_MO), .INST_IN(INST_MO),

        .CRT_WB_OUT(CRT_WB_WPO), .READ_DATA_OUT(READ_DATA_WPO), .ALU_RESULT_OUT(ALU_RESULT_WPO), .INST_OUT(INST_WPO)
    );
      
    WR WR(
        .CRT_WB_IN(CRT_WB_WPO[1]), .DATA_M(READ_DATA_WPO), .DATA_E(ALU_RESULT_WPO), .DATA_OUT(DATA_WO)
    );
                            
endmodule
