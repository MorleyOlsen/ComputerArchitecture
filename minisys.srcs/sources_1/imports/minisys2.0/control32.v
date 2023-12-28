`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module control32(Opcode,Jrn,Function_opcode,Alu_resultHigh,RegDST,ALUSrc,MemorIOtoReg,
                 RegWrite,MemRead,MemWrite,IORead,IOWrite,FBWrite,Branch,nBranch,Jmp,Jal,I_format,Sftmd,ALUOp);
    input[5:0]   Opcode;            // ����ȡָ��Ԫinstruction[31..26]
    input[21:0]  Alu_resultHigh;  //����ִ�е�ԪAlu_Result[31..10]
    input[5:0]   Function_opcode;  	// ����ȡָ��Ԫr-���� instructions[5..0]
    output       Jrn;         	 // Ϊ1������ǰָ����jr
    output       RegDST;          // Ϊ1����Ŀ�ļĴ�����rd������Ŀ�ļĴ�����rt
    output       ALUSrc;          // Ϊ1�����ڶ�������������������beq��bne���⣩
    output       MemorIOtoReg;   	//  Ϊ1������Ҫ�Ӵ洢�������ݵ��Ĵ���
    output       RegWrite;   	//  Ϊ1������ָ����Ҫд�Ĵ���
    output       MemRead;       //1 need to read
    output       MemWrite;   	//  Ϊ1������ָ����Ҫд�洢��
    output       IORead;
    output       IOWrite;
    output       FBWrite; // д֡������
    output       Branch;    	//  Ϊ1������Beqָ��
    output       nBranch;   	//  Ϊ1������Bneָ��
    output       Jmp;        	//  Ϊ1������Jָ��
    output       Jal;        	//  Ϊ1������Jalָ��
    output       I_format;  	//  Ϊ1������ָ���ǳ�beq��bne��LW��SW֮�������I-����ָ��
    output       Sftmd;     	//  Ϊ1��������λָ��
    output[1:0]  ALUOp;	//  ��R-���ͻ�I_format=1ʱλ1Ϊ1, beq��bneָ����λ0Ϊ1
   
    wire Jmp,I_format,Jal,Branch,nBranch;
    wire R_format,Lw,Sw;
   
    assign R_format = (Opcode==6'b000000)? 1'b1:1'b0;    	//--00h 
    assign RegDST = R_format;                               //˵��Ŀ����rd��������rt
    
    //3-17
    
    assign RegWrite=(Jrn || Sw || Branch || nBranch || Jmp)? 1'b0:1'b1;
    //(R_format || Lw || Jal || I_data) && !(Jrn);
    //��Ҫд�Ĵ�����ָ��
    assign MemWrite=((Sw==1)&&(Alu_resultHigh[21:6]==16'b0))? 1'b1:1'b0;
    //д�洢��
    assign MemRead=((Lw==1) && (Alu_resultHigh[21:6]==16'b0))? 1'b1:1'b0;
    //���洢��
    assign IOWrite=((Sw==1) && (Alu_resultHigh==22'b1111111111111111111111))? 1'b1:1'b0;
    //д�˿�
    assign IORead=((Lw==1) && (Alu_resultHigh==22'b1111111111111111111111))? 1'b1:1'b0;
    //���˿�
    assign FBWrite=(Sw && Alu_resultHigh[21:10]==12'hFFE);
    assign MemorIOtoReg=(Opcode==6'b100011)? 1'b1:1'b0;
    
    //��ϰ3-1
        assign I_format=(Opcode[5:3]==3'b001)? 1'b1:1'b0;
        //����beq�ȣ���3λΪ001
        assign Lw=(Opcode==6'b100011)? 1'b1:1'b0;
        //Lw��op�ֶ�
        assign Jal=(Opcode==6'b000011)? 1'b1:1'b0;
        //jal��op�ֶ�
        assign Jrn=(Opcode==6'b000000 && Function_opcode==6'b001000)? 1'b1:1'b0;
        //jrn
    
    //��ϰ3-2
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
