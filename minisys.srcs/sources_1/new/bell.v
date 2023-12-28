`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/05 20:27:47
// Design Name: 
// Module Name: buzzing
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

//clkʱ�ӣ�rst��λ��max_freqƵ�ʿ����������ڣ�max_mʱ��Ƶ�ʿ��Ʒ������ڣ�
//cnt_hz��ͼ�����ֵ��beep�������������
module bell(clk,rst,write,addr,data,beep);
    input clk;//clock
    input rst;//reset
   // input[23:0] max_freq;//��׼Ƶ�ʷ�Ƶ��
    input write;
    input[2:0] addr;
    input[15:0] data;
    output beep;//beep sound

    reg[15:0] mid,top;//��ʼ����ֵ��Ԥ�ô���
    reg[15:0] max_m;//��׼ʱ�ӷ�Ƶ��
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            mid <= 16'hffff;
            top <= 16'hffff;
            max_m <= 16'hffff;
        end else if (write) begin
            case (addr)
                3'b000: mid <= data;
                3'b010: top <= data;
                3'b100: max_m <= data;
            endcase
        end
    end
    
    reg beep;
    //parameter rest=24'hffffff;//��ֹ���������ֵ
    //parameter len=60;//ÿ�μ�����lenѭ��һ��sound_cnt
    
    reg[15:0] cnt_m;
    reg clk_m;

    //cnt_m initialize��׼ʱ�ӷ�Ƶ
    always@(posedge clk or negedge rst) begin
        if(!rst)//��λ�ź�==0
            begin
            cnt_m<=0;
            clk_m<=0;
            end
        else if(cnt_m==max_m)//�ﵽ��������������
            begin
            cnt_m<=0;//���¸�ֵ
            clk_m<=1;
            end
        else begin
            cnt_m<=cnt_m+1'b1;//��������������
            clk_m<=0;
        end
    end
       
    //��������
    //clk_m �ǻ�׼ʱ�ӷ�Ƶ ��ʱ�ӡ�
    reg [15:0] cnt;

    always@(posedge clk_m or negedge rst)
    begin
        if(!rst) begin
            cnt<=0;
            beep<=1'b0;
        end else if(cnt >= mid) begin
            beep<=1;
        end else if(cnt >= top) begin
            beep<=0;
            cnt<=0;
        end else cnt<=cnt+1;  
    end
endmodule
