`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/29 21:15:26
// Design Name: 
// Module Name: VGA_ctr
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


module VGA_ctr(
    input vga_clk_i,
    input rst_i,
    input [3:0]rdata,
    input [3:0]gdata,
    input [3:0]bdata,
    output [11:0]rgb_display_o,
    output wire hsync_o,
    output wire vsync_o,
    output wire data_read_active,
    output wire picture_active,
    output wire picture_over,
    output reg [9:0]h_addr,
    output reg [9:0]v_addr
    );
    parameter 
    hpw_end = 10'd95, // horiz_pulse_width end
    hbp_end = 10'd143, // horiz_back_porch end
    hdata_end = 10'd783, // horiz_disp_time end
    hfp_end = 10'd799, // horiz_front_porch end
    vpw_end = 10'd1, // verti_pulse_width end
    vbp_end = 10'd30, // verti_back_porch end
    vdata_end = 10'd510,// verti_disp_time end
    vfp_end = 10'd520;  // verti_front_porch end

    reg [9:0]hcnt; // hori_counter adds when vga_clk arrives;
    reg [9:0]vcnt; // verti_counter adds when a line end;
    wire data_active; // Index indicating if the point is in valid region

/*------------------------------------------------------------h_cnt--------------------------------------------------------*/
    always @(posedge vga_clk_i or posedge rst_i) begin
        if(rst_i) begin
            hcnt <= 10'd0;
        end
        else if (hcnt < hfp_end)begin
            hcnt <= hcnt + 10'd1;
        end
        else begin
            hcnt <= 10'd0;
        end
    end 

/*----------------------------------------------------------v_cnt----------------------------------------------------------*/
    always @(posedge vga_clk_i or posedge rst_i) begin
        if(rst_i) begin
            vcnt <= 10'd0;
        end
        else if (hcnt == hfp_end && vcnt < vfp_end)begin
            vcnt <= vcnt + 10'd1;
        end
        else if(hcnt == hfp_end && vcnt == vfp_end)begin
            vcnt <= 10'd0;
        end
        else begin
            vcnt <= vcnt;
        end
    end
/*----------------------------------------------------------h_addr----------------------------------------------------------*/
    always @(posedge vga_clk_i or posedge rst_i)begin
        if(rst_i)begin
            h_addr <= 10'd0;
        end
        else if(hcnt >= hbp_end && hcnt < hdata_end)
            h_addr <= hcnt - hbp_end + 1;
        else
            h_addr <= 10'd0;
    end
/*---------------------------------------------------------v_addr-----------------------------------------------------------*/

    always @(posedge vga_clk_i or posedge rst_i)begin
        if(rst_i)begin
            v_addr <= 10'd0;
        end
        else if(vcnt >= vbp_end && vcnt < vdata_end && hcnt == hfp_end)
            v_addr <= vcnt - vbp_end + 1;
        else if(vcnt >= vbp_end && vcnt <= vdata_end && hcnt < hfp_end)
            v_addr <= v_addr;
        else
            v_addr <= 10'd0;
    end

    assign data_active = (hcnt > hbp_end) && (hcnt <= hdata_end) && (vcnt > vbp_end) && (vcnt <= vdata_end); // When the cnt is in valid region, the index = 1;
    assign hsync_o = (hcnt > hpw_end) ? 1 : 0; // Horizontal sync; 
    assign vsync_o = (vcnt > vpw_end) ? 1 : 0; // Vertical sync;
    assign rgb_display_o = data_active ? {rdata,gdata,bdata} : 12'h000; // Color Distribution;
    assign picture_over = (hcnt == hfp_end) && (vcnt == vfp_end);
    assign data_read_active = (hcnt >= hbp_end - 1) && (hcnt < hdata_end - 1);
    assign picture_active = (hcnt >= hbp_end) && (hcnt < hdata_end);

endmodule
