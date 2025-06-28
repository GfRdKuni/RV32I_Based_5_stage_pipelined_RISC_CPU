`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/05 15:26:11
// Design Name: 
// Module Name: bdtrans
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


module bdtrans(input [31:0] in,
               output reg [3:0] in_ten,
               output reg [3:0] in_one);
    always @(*) begin
        case(in)
            32'd0: begin in_ten <= 4'd0; in_one <= 4'd0; end
            32'd1: begin in_ten <= 4'd0; in_one <= 4'd1; end
            32'd2: begin in_ten <= 4'd0; in_one <= 4'd2; end
            32'd3: begin in_ten <= 4'd0; in_one <= 4'd3; end
            32'd4: begin in_ten <= 4'd0; in_one <= 4'd4; end
            32'd5: begin in_ten <= 4'd0; in_one <= 4'd5; end
            32'd6: begin in_ten <= 4'd0; in_one <= 4'd6; end
            32'd7: begin in_ten <= 4'd0; in_one <= 4'd7; end
            32'd8: begin in_ten <= 4'd0; in_one <= 4'd8; end
            32'd9: begin in_ten <= 4'd0; in_one <= 4'd9; end
            32'd10: begin in_ten <= 4'd1; in_one <= 4'd0; end
            32'd11: begin in_ten <= 4'd1; in_one <= 4'd1; end
            32'd12: begin in_ten <= 4'd1; in_one <= 4'd2; end
            32'd13: begin in_ten <= 4'd1; in_one <= 4'd3; end
            32'd14: begin in_ten <= 4'd1; in_one <= 4'd4; end
            32'd15: begin in_ten <= 4'd1; in_one <= 4'd5; end
            32'd16: begin in_ten <= 4'd1; in_one <= 4'd6; end
            32'd17: begin in_ten <= 4'd1; in_one <= 4'd7; end
            32'd18: begin in_ten <= 4'd1; in_one <= 4'd8; end
            32'd19: begin in_ten <= 4'd1; in_one <= 4'd9; end
            32'd20: begin in_ten <= 4'd2; in_one <= 4'd0; end
            32'd21: begin in_ten <= 4'd2; in_one <= 4'd1; end
            32'd22: begin in_ten <= 4'd2; in_one <= 4'd2; end
            32'd23: begin in_ten <= 4'd2; in_one <= 4'd3; end
            32'd24: begin in_ten <= 4'd2; in_one <= 4'd4; end
            32'd25: begin in_ten <= 4'd2; in_one <= 4'd5; end
            32'd26: begin in_ten <= 4'd2; in_one <= 4'd6; end
            32'd27: begin in_ten <= 4'd2; in_one <= 4'd7; end
            32'd28: begin in_ten <= 4'd2; in_one <= 4'd8; end
            32'd29: begin in_ten <= 4'd2; in_one <= 4'd9; end
            32'd30: begin in_ten <= 4'd3; in_one <= 4'd0; end
            32'd31: begin in_ten <= 4'd3; in_one <= 4'd1; end
            32'd32: begin in_ten <= 4'd3; in_one <= 4'd2; end
            32'd33: begin in_ten <= 4'd3; in_one <= 4'd3; end
            32'd34: begin in_ten <= 4'd3; in_one <= 4'd4; end
            32'd35: begin in_ten <= 4'd3; in_one <= 4'd5; end
            32'd36: begin in_ten <= 4'd3; in_one <= 4'd6; end
            32'd37: begin in_ten <= 4'd3; in_one <= 4'd7; end
            32'd38: begin in_ten <= 4'd3; in_one <= 4'd8; end
            32'd39: begin in_ten <= 4'd3; in_one <= 4'd9; end
            32'd40: begin in_ten <= 4'd4; in_one <= 4'd0; end
            32'd41: begin in_ten <= 4'd4; in_one <= 4'd1; end
            32'd42: begin in_ten <= 4'd4; in_one <= 4'd2; end
            32'd43: begin in_ten <= 4'd4; in_one <= 4'd3; end
            32'd44: begin in_ten <= 4'd4; in_one <= 4'd4; end
            32'd45: begin in_ten <= 4'd4; in_one <= 4'd5; end
            32'd46: begin in_ten <= 4'd4; in_one <= 4'd6; end
            32'd47: begin in_ten <= 4'd4; in_one <= 4'd7; end
            32'd48: begin in_ten <= 4'd4; in_one <= 4'd8; end
            32'd49: begin in_ten <= 4'd4; in_one <= 4'd9; end
            32'd50: begin in_ten <= 4'd5; in_one <= 4'd0; end
            32'd51: begin in_ten <= 4'd5; in_one <= 4'd1; end
            32'd52: begin in_ten <= 4'd5; in_one <= 4'd2; end
            32'd53: begin in_ten <= 4'd5; in_one <= 4'd3; end
            32'd54: begin in_ten <= 4'd5; in_one <= 4'd4; end
            32'd55: begin in_ten <= 4'd5; in_one <= 4'd5; end
            32'd56: begin in_ten <= 4'd5; in_one <= 4'd6; end
            32'd57: begin in_ten <= 4'd5; in_one <= 4'd7; end
            32'd58: begin in_ten <= 4'd5; in_one <= 4'd8; end
            32'd59: begin in_ten <= 4'd5; in_one <= 4'd9; end
            32'd60: begin in_ten <= 4'd6; in_one <= 4'd0; end
            32'd61: begin in_ten <= 4'd6; in_one <= 4'd1; end
            32'd62: begin in_ten <= 4'd6; in_one <= 4'd2; end
            32'd63: begin in_ten <= 4'd6; in_one <= 4'd3; end
            32'd64: begin in_ten <= 4'd6; in_one <= 4'd4; end
            32'd65: begin in_ten <= 4'd6; in_one <= 4'd5; end
            32'd66: begin in_ten <= 4'd6; in_one <= 4'd6; end
            32'd67: begin in_ten <= 4'd6; in_one <= 4'd7; end
            32'd68: begin in_ten <= 4'd6; in_one <= 4'd8; end
            32'd69: begin in_ten <= 4'd6; in_one <= 4'd9; end
            32'd70: begin in_ten <= 4'd7; in_one <= 4'd0; end
            32'd71: begin in_ten <= 4'd7; in_one <= 4'd1; end
            32'd72: begin in_ten <= 4'd7; in_one <= 4'd2; end
            32'd73: begin in_ten <= 4'd7; in_one <= 4'd3; end
            32'd74: begin in_ten <= 4'd7; in_one <= 4'd4; end
            32'd75: begin in_ten <= 4'd7; in_one <= 4'd5; end
            32'd76: begin in_ten <= 4'd7; in_one <= 4'd6; end
            32'd77: begin in_ten <= 4'd7; in_one <= 4'd7; end
            32'd78: begin in_ten <= 4'd7; in_one <= 4'd8; end
            32'd79: begin in_ten <= 4'd7; in_one <= 4'd9; end
            32'd80: begin in_ten <= 4'd8; in_one <= 4'd0; end
            32'd81: begin in_ten <= 4'd8; in_one <= 4'd1; end
            32'd82: begin in_ten <= 4'd8; in_one <= 4'd2; end
            32'd83: begin in_ten <= 4'd8; in_one <= 4'd3; end
            32'd84: begin in_ten <= 4'd8; in_one <= 4'd4; end
            32'd85: begin in_ten <= 4'd8; in_one <= 4'd5; end
            32'd86: begin in_ten <= 4'd8; in_one <= 4'd6; end
            32'd87: begin in_ten <= 4'd8; in_one <= 4'd7; end
            32'd88: begin in_ten <= 4'd8; in_one <= 4'd8; end
            32'd89: begin in_ten <= 4'd8; in_one <= 4'd9; end
            32'd90: begin in_ten <= 4'd9; in_one <= 4'd0; end
            32'd91: begin in_ten <= 4'd9; in_one <= 4'd1; end
            32'd92: begin in_ten <= 4'd9; in_one <= 4'd2; end
            32'd93: begin in_ten <= 4'd9; in_one <= 4'd3; end
            32'd94: begin in_ten <= 4'd9; in_one <= 4'd4; end
            32'd95: begin in_ten <= 4'd9; in_one <= 4'd5; end
            32'd96: begin in_ten <= 4'd9; in_one <= 4'd6; end
            32'd97: begin in_ten <= 4'd9; in_one <= 4'd7; end
            32'd98: begin in_ten <= 4'd9; in_one <= 4'd8; end
            32'd99: begin in_ten <= 4'd9; in_one <= 4'd9; end
            default: begin in_ten <= 4'd15; in_one <= 4'd15; end
        endcase
    end
endmodule
