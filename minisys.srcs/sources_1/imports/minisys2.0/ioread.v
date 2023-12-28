`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module ioread(reset,ior,switchctrl,vsyncctrl,ioread_data,ioread_data_switch,ioread_data_vsync);
    input reset;			// 复位信号 
    input ior;              //  从控制器来的I/O读，
    input switchctrl;		//  从memorio经过地址高端线获得的拨码开关模块片选
    input vsyncctrl;
    input[15:0] ioread_data_switch;  //从外设来的读数据，此处来自拨码开关
    input[15:0] ioread_data_vsync;
    output[15:0] ioread_data;	// 将外设来的数据送给memorio
    
    reg[15:0] ioread_data;//_reg;
    //命名冲突 了
    
    always @* begin
        if(reset == 1)
            ioread_data = 16'b0000000000000000;
        else if(ior == 1) begin
            if(switchctrl == 1) ioread_data = ioread_data_switch;
            else if (vsyncctrl == 1) ioread_data = ioread_data_vsync;
            else ioread_data = ioread_data;
        end
    end
    //assign ioread_data=ioread_data_reg;//????赋值有问题
endmodule
