`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/26 20:26:21
// Design Name: 
// Module Name: tb_cnn
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


module tb_cnn();
    
    
        reg                   clk             ;       
        reg                   rst_n          ;       
        // CMOS Data;
        wire   [7:0]                bin_data         ;  
        wire                   bin_data_vld     ;  
        //;
        wire [31:0]    pool_data                   ;
        wire            pool_data_vld         ;
        wire            active_video          ;
        wire            vid_hsync             ;
        wire            vid_ce                ;
        wire  vsync1;


  

  always  #5  clk=~clk;



  initial
    begin
       clk=0;
       rst_n=0;
       #500
       rst_n=1'b1;
       



    end

 gen_sim_data   gen_sim_data1(
        // system signals
        .   clk             (clk)       ,      
        .   rst_n               (rst_n)  ,       
        //
        .   vsync               ()    ,
        .   bin_data_vld          (bin_data_vld)  ,
        .   bin_data                (bin_data)
);


 cnn_top  cnn_top1(
        .clk(clk),
        .rst_n(rst_n),
      //.Data
        .  bin_data            (bin_data[0]     )  ,       
        .  bin_data_vld        (bin_data_vld )    ,
        .  pool_data           (pool_data    )    ,
        .  pool_data_vld       (pool_data_vld)    ,       
        .  active_video        (active_video )    ,       
        .  vid_hsync           (vid_hsync    )    ,
        .  vid_ce              (vid_ce       )      ,
        .vsync(vsync1)   
    );
    
    endmodule