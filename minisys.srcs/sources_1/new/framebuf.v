`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/04 19:44:23
// Design Name: 
// Module Name: framebuf
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


module framebuf(
    input[19:0] write_addr,
    input[11:0] write_data,
    input fbwrite,
    input clock,
    input reset,
    output[11:0] pixel_out,
    output hsync,
    output vsync,
    output[15:0] vsync_data
);
    parameter
        h_visible = 640,
        h_front_porch = 640 + 16,
        h_sync_pulse = 640 + 16 + 96,
        h_back_porch = 640 + 16 + 96 + 48,
        v_visible = 480,
        v_front_porch = 480 + 10,
        v_sync_pulse = 480 + 10 + 2,
        v_back_porch = 480 + 10 + 2 + 33;
    
    reg[15:0] frame_count;
    assign vsync_data = frame_count;
        
    reg[9:0] hpos, vpos, hpos_delay, vpos_delay;
    reg[18:0] read_addr;
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            hpos <= 0;
            vpos <= 0;
            read_addr <= 0;
            frame_count <= 0;
        end else if (hpos == h_back_porch - 1) begin
            hpos <= 0;
            if (vpos == v_back_porch - 1) begin
                vpos <= 0;
                read_addr <= 0;
                frame_count <= frame_count + 1;
            end else vpos <= vpos + 1;
        end else begin
            if (hpos < h_visible && vpos < v_visible)
                read_addr <= read_addr + 1;
            hpos <= hpos + 1;
        end
    end
    always @(posedge clock) begin
        // 让输出的同步信号延迟一个周期，与 vram 的读延迟匹配
        hpos_delay <= hpos;
        vpos_delay <= vpos;
    end
    
    wire blank;
    assign blank = hpos_delay >= h_visible || vpos_delay >= v_visible;
    assign hsync = hpos_delay >= h_front_porch && hpos_delay < h_sync_pulse;
    assign vsync = vpos_delay >= v_front_porch && vpos_delay < v_sync_pulse;
    
    wire[11:0] pixel;
    assign pixel_out = blank ? 0 : pixel;
    
    vram fb(
        .clka(clock),
        .addra(write_addr[19:1]),
        .dina(write_data),
        .wea(fbwrite),
        .clkb(clock),
        .addrb(read_addr),
        .doutb(pixel)
    );
endmodule
