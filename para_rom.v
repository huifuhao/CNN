`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/24 21:05:39
// Design Name: 
// Module Name: para_rom
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


module para_rom #(
     parameter W_WIDTH  =15,
     parameter B_WIDTH  =15
	)(
    input  clk,
    input  rst_n,

    input   [7:0]  param_rd_addr,
    input [4:0]  conv_cnt, 

     output [W_WIDTH:0]   param_w_h0,
     output [W_WIDTH:0]   param_w_h1,
     output [W_WIDTH:0]   param_w_h2,
     output [W_WIDTH:0]   param_w_h3,
     output [W_WIDTH:0]   param_w_h4,
     output [B_WIDTH:0]   param_bias

    );
    
    
    
 
    ROM_B ROM_bias (
  .clka(clk),    // input wire clka
  .addra(conv_cnt),  // input wire [4 : 0] addra
  .douta(param_bias)  // output wire [15 : 0] douta
);


ROM_w0 ROW_w0 (
  .clka(clk),    // input wire clka
  .addra(param_rd_addr),  // input wire [7 : 0] addra
  .douta(param_w_h0)  // output wire [15 : 0] douta
);



ROM_w1 ROW_w1 (
  .clka(clk),    // input wire clka
  .addra(param_rd_addr),  // input wire [7 : 0] addra
  .douta(param_w_h1)  // output wire [15 : 0] douta
);


ROM_w2 ROW_w2 (
  .clka(clk),    // input wire clka
  .addra(param_rd_addr),  // input wire [7 : 0] addra
  .douta(param_w_h2)  // output wire [15 : 0] douta
);


ROW_w3 ROW_w3 (
  .clka(clk),    // input wire clka
  .addra(param_rd_addr),  // input wire [7 : 0] addra
  .douta(param_w_h3)  // output wire [15 : 0] douta
);


ROM_w4 ROW_w4 (
  .clka(clk),    // input wire clka
  .addra(param_rd_addr),  // input wire [7 : 0] addra
  .douta(param_w_h4)  // output wire [15 : 0] douta
);
endmodule
