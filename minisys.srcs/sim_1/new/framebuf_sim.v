`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/04 22:11:47
// Design Name: 
// Module Name: framebuf_sim
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


module framebuf_sim();
    reg[18:0] write_addr = 19'd641;
    reg[11:0] write_data = 12'hfff;
    wire[11:0] pixel_out;
    reg fbwrite = 0, clock = 0, reset = 1;
    wire hsync, vsync;
    wire[15:0] vsync_data;
    framebuf framebuf(
        write_addr,
        write_data,
        fbwrite,
        clock,
        reset,
        pixel_out,
        hsync,
        vsync,
        vsync_data
    );
    
    always #50 clock = ~clock;
    
    initial begin
        #100 reset = 0;
        #100 fbwrite = 1;
        #100 fbwrite = 0;
    end
endmodule
