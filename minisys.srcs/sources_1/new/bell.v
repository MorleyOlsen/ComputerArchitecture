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

//clk时钟，rst复位，max_freq频率控制声音周期，max_m时钟频率控制方波周期，
//cnt_hz最低计数阈值，beep蜂鸣器输出控制
module bell(clk,rst,write,addr,data,beep);
    input clk;//clock
    input rst;//reset
   // input[23:0] max_freq;//基准频率分频比
    input write;
    input[2:0] addr;
    input[15:0] data;
    output beep;//beep sound

    reg[15:0] mid,top;//起始计数值，预置传入
    reg[15:0] max_m;//基准时钟分频比
    
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
    //parameter rest=24'hffffff;//休止符，最大阈值
    //parameter len=60;//每次计数到len循环一次sound_cnt
    
    reg[15:0] cnt_m;
    reg clk_m;

    //cnt_m initialize基准时钟分频
    always@(posedge clk or negedge rst) begin
        if(!rst)//复位信号==0
            begin
            cnt_m<=0;
            clk_m<=0;
            end
        else if(cnt_m==max_m)//达到输入的最大周期数
            begin
            cnt_m<=0;//重新赋值
            clk_m<=1;
            end
        else begin
            cnt_m<=cnt_m+1'b1;//自增，消耗周期
            clk_m<=0;
        end
    end
       
    //产生方波
    //clk_m 是基准时钟分频 【时钟】
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
