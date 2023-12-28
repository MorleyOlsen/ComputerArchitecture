`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module control32(Opcode,Jrn,Function_opcode,Alu_resultHigh,RegDST,ALUSrc,MemorIOtoReg,
                 RegWrite,MemRead,MemWrite,IORead,IOWrite,FBWrite,Branch,nBranch,Jmp,Jal,I_format,Sftmd,ALUOp);
    input[5:0]   Opcode;            // 来自取指单元instruction[31..26]
    input[21:0]  Alu_resultHigh;  //来自执行单元Alu_Result[31..10]
    input[5:0]   Function_opcode;  	// 来自取指单元r-类型 instructions[5..0]
    output       Jrn;         	 // 为1表明当前指令是jr
    output       RegDST;          // 为1表明目的寄存器是rd，否则目的寄存器是rt
    output       ALUSrc;          // 为1表明第二个操作数是立即数（beq，bne除外）
    output       MemorIOtoReg;   	//  为1表明需要从存储器读数据到寄存器
    output       RegWrite;   	//  为1表明该指令需要写寄存器
    output       MemRead;       //1 need to read
    output       MemWrite;   	//  为1表明该指令需要写存储器
    output       IORead;
    output       IOWrite;
    output       FBWrite; // 写帧缓冲器
    output       Branch;    	//  为1表明是Beq指令
    output       nBranch;   	//  为1表明是Bne指令
    output       Jmp;        	//  为1表明是J指令
    output       Jal;        	//  为1表明是Jal指令
    output       I_format;  	//  为1表明该指令是除beq，bne，LW，SW之外的其他I-类型指令
    output       Sftmd;     	//  为1表明是移位指令
    output[1:0]  ALUOp;	//  是R-类型或I_format=1时位1为1, beq、bne指令则位0为1
   
    wire Jmp,I_format,Jal,Branch,nBranch;
    wire R_format,Lw,Sw;
   
    assign R_format = (Opcode==6'b000000)? 1'b1:1'b0;    	//--00h 
    assign RegDST = R_format;                               //说明目标是rd，否则是rt
    
    //3-17
    
    assign RegWrite=(Jrn || Sw || Branch || nBranch || Jmp)? 1'b0:1'b1;
    //(R_format || Lw || Jal || I_data) && !(Jrn);
    //需要写寄存器的指令
    assign MemWrite=((Sw==1)&&(Alu_resultHigh[21:6]==16'b0))? 1'b1:1'b0;
    //写存储器
    assign MemRead=((Lw==1) && (Alu_resultHigh[21:6]==16'b0))? 1'b1:1'b0;
    //读存储器
    assign IOWrite=((Sw==1) && (Alu_resultHigh==22'b1111111111111111111111))? 1'b1:1'b0;
    //写端口
    assign IORead=((Lw==1) && (Alu_resultHigh==22'b1111111111111111111111))? 1'b1:1'b0;
    //读端口
    assign FBWrite=(Sw && Alu_resultHigh[21:10]==12'hFFE);
    assign MemorIOtoReg=(Opcode==6'b100011)? 1'b1:1'b0;
    
    //练习3-1
        assign I_format=(Opcode[5:3]==3'b001)? 1'b1:1'b0;
        //除了beq等，高3位为001
        assign Lw=(Opcode==6'b100011)? 1'b1:1'b0;
        //Lw的op字段
        assign Jal=(Opcode==6'b000011)? 1'b1:1'b0;
        //jal的op字段
        assign Jrn=(Opcode==6'b000000 && Function_opcode==6'b001000)? 1'b1:1'b0;
        //jrn
    
    //练习3-2
    assign Sw=(Opcode==6'b101011)? 1'b1:1'b0;
    //sw
    assign ALUSrc=(Opcode[5:3]==3'b001 || Lw || Sw)? 1'b1:1'b0;
    //ALU source
    assign Branch=(Opcode==6'b000100)? 1'b1:1'b0;
    //branch
    assign nBranch=(Opcode==6'b000101)? 1'b1:1'b0;
    //nBranch
    assign Jmp=(Opcode==6'b000010)? 1'b1:1'b0;
    //jmp
    assign Sftmd=(Opcode==6'b000000 && Function_opcode[5:3]==3'b000)? 1'b1:1'b0;
    //sftmd
    
    assign ALUOp={(R_format || I_format),(Branch || nBranch)};
    
endmodule
