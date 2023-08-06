`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/23 19:45:47
// Design Name: 
// Module Name: conv_cal
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


module conv_cal #(
     parameter W_WIDTH  =16,
     parameter B_WIDTH  =16,
     parameter M_WIDTH  =24 //此处必须要和乘法器位宽一致
	)(
    input  clk,
    input  rst_n,


    output reg [4:0]  data_rd_addr,
    output reg [4:0]  row_cnt,  //行
    input [4:0]   col_data,
    input      cal_start,


     output reg [7:0]  param_rd_addr,
     output reg [4:0]  conv_cnt, 

     input [W_WIDTH-1:0]   param_w_h0,
     input [W_WIDTH-1:0]   param_w_h1,
     input [W_WIDTH-1:0]   param_w_h2,
     input [W_WIDTH-1:0]   param_w_h3,
     input [W_WIDTH-1:0]   param_w_h4,
     input   signed [B_WIDTH-1:0]   param_bias,

    
     output wire [31:0]  conv_rslt_act,
     output reg      conv_rslt_act_vld     

    );



reg            conv_flag;
reg       [W_WIDTH*5-1:0]   param_w_h0_arr ;
reg       [W_WIDTH*5-1:0]   param_w_h1_arr ;
reg       [W_WIDTH*5-1:0]   param_w_h2_arr ;
reg       [W_WIDTH*5-1:0]   param_w_h3_arr ;
reg       [W_WIDTH*5-1:0]   param_w_h4_arr ;

  reg [4:0]    col_data_r0;
  reg [4:0]    col_data_r1;
  reg [4:0]    col_data_r2;
  reg [4:0]    col_data_r3;
  reg [4:0]    col_data_r4;
  
 

    wire   signed [M_WIDTH-1:0]  mult00;
    wire   signed [M_WIDTH-1:0]  mult01;
    wire   signed [M_WIDTH-1:0]  mult02;
    wire   signed [M_WIDTH-1:0]  mult03;
    wire   signed [M_WIDTH-1:0]  mult04;
   
    wire   signed [M_WIDTH-1:0]  mult10;
    wire   signed [M_WIDTH-1:0]  mult11;
    wire   signed [M_WIDTH-1:0]  mult12;
    wire   signed [M_WIDTH-1:0]  mult13;
    wire   signed [M_WIDTH-1:0]  mult14;
  
     wire  signed  [M_WIDTH-1:0] mult20;
    wire   signed [M_WIDTH-1:0]  mult21;
    wire   signed [M_WIDTH-1:0]  mult22;
    wire   signed [M_WIDTH-1:0]  mult23;
    wire   signed [M_WIDTH-1:0]  mult24;
    
     wire  signed  [M_WIDTH-1:0] mult30;
    wire   signed [M_WIDTH-1:0]  mult31;
    wire   signed [M_WIDTH-1:0]  mult32;
    wire   signed [M_WIDTH-1:0]  mult33;
    wire   signed [M_WIDTH-1:0]  mult34;
   
     wire  signed  [M_WIDTH-1:0] mult40;
    wire   signed [M_WIDTH-1:0]  mult41;
    wire   signed [M_WIDTH-1:0]  mult42;
    wire   signed [M_WIDTH-1:0]  mult43;
    wire   signed [M_WIDTH-1:0]  mult44;
   always@(posedge clk or  negedge rst_n)
   begin
  	if (!rst_n) 
  		conv_flag <=1'b0;		
  	else if (conv_cnt =='d29   &&  row_cnt =='d23 && data_rd_addr=='d31)
  	    conv_flag <=1'b0;
    else if(cal_start==1'b1)
        conv_flag <=1'b1;
  end


    always @(posedge clk or negedge rst_n) begin
  	if (!rst_n) 
  		param_rd_addr <='d0;		
  	else if (conv_flag ==1'b0)
  	    param_rd_addr <='d0;
    else if(conv_flag==1'b1 && row_cnt=='d0 && data_rd_addr <='d4) //这里为什么row_cnt为0
        param_rd_addr <=param_rd_addr+1'b1;
  end




  always @(posedge clk or negedge rst_n) begin
  	if (!rst_n) 
  	  begin
  	  	param_w_h0_arr<='d0;
  	  	param_w_h1_arr<='d0;
  	  	param_w_h2_arr<='d0;
  	  	param_w_h3_arr<='d0;
  	  	param_w_h4_arr<='d0;
  	  end
  	else if (row_cnt =='d0   &&  data_rd_addr<='d5 && data_rd_addr>='d1)
  	begin
  	    param_w_h0_arr<={param_w_h0,param_w_h0_arr[W_WIDTH*5-1:W_WIDTH]};
  	    param_w_h1_arr<={param_w_h1,param_w_h1_arr[W_WIDTH*5-1:W_WIDTH]};
  	    param_w_h2_arr<={param_w_h2,param_w_h2_arr[W_WIDTH*5-1:W_WIDTH]};
  	    param_w_h3_arr<={param_w_h3,param_w_h3_arr[W_WIDTH*5-1:W_WIDTH]};
  	    param_w_h4_arr<={param_w_h4,param_w_h4_arr[W_WIDTH*5-1:W_WIDTH]};
  		
  	end 
  end
   

   always @(posedge clk or negedge rst_n) begin
  	if (!rst_n) 
  		row_cnt <=1'b0;		
  	else if (row_cnt =='d23   &&  conv_flag =='d1 && data_rd_addr=='d31)
  	    row_cnt <=1'b0;
    else if(conv_flag==1'b1  && data_rd_addr=='d31)  //表明一行读取完毕
        row_cnt <=row_cnt+1'b1;
   end
   
   always@(posedge clk or negedge rst_n) begin
  	if (!rst_n) 
  		data_rd_addr <=1'b0;		
  	else if (conv_flag=='d1 &&  data_rd_addr=='d31)
  	    data_rd_addr <=1'b0;
    else if(conv_flag==1'b1)
        data_rd_addr <=data_rd_addr+1'b1;
  end

  //图像缓存
   always @(posedge clk or negedge rst_n) begin
  	if (!rst_n) 
  	begin
  		col_data_r0<=0;
  		col_data_r1<=0;
  		col_data_r2<=0;
  		col_data_r3<=0;
  		col_data_r4<=0;
  	end	
  	else 
  	  begin
  	  	col_data_r4<=col_data;
  		col_data_r3<=col_data_r4;
  		col_data_r2<=col_data_r3;
  		col_data_r1<=col_data_r2;
  		col_data_r0<=col_data_r1;

  	  end
  end
  

//第一行乘法器
mult_gen_0   mult_gen_00 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r0[0]}}),      // input wire [7 : 0] A
  .B(param_w_h0_arr[W_WIDTH-1:0]),      // input wire [17 : 0] B
  .P(mult00)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_01 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r1[0]}}),      // input wire [7 : 0] A
  .B(param_w_h0_arr[W_WIDTH*2-1:W_WIDTH]),      // input wire [17 : 0] B
  .P(mult01)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_02 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r2[0]}}),      // input wire [7 : 0] A
  .B(param_w_h0_arr[W_WIDTH*3-1:W_WIDTH*2]),      // input wire [17 : 0] B
  .P(mult02)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_03 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r3[0]}}),      // input wire [7 : 0] A
  .B(param_w_h0_arr[W_WIDTH*4-1:W_WIDTH*3]),      // input wire [17 : 0] B
  .P(mult03)      // output wire [25 : 0] P
);

mult_gen_0   mult_gen_04 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r4[0]}}),      // input wire [7 : 0] A
  .B(param_w_h0_arr[W_WIDTH*5-1:W_WIDTH*4]),      // input wire [17 : 0] B
  .P(mult04)      // output wire [25 : 0] P
);



//第二行乘法器 col_data是一下出来五行的数据
mult_gen_0   mult_gen_10 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r0[1]}}),      // input wire [7 : 0] A
  .B(param_w_h1_arr[W_WIDTH-1:0]),      // input wire [17 : 0] B
  .P(mult10)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_11 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r1[1]}}),      // input wire [7 : 0] A
  .B(param_w_h1_arr[W_WIDTH*2-1:W_WIDTH]),      // input wire [17 : 0] B
  .P(mult11)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_12 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r2[1]}}),      // input wire [7 : 0] A
  .B(param_w_h1_arr[W_WIDTH*3-1:W_WIDTH*2]),      // input wire [17 : 0] B
  .P(mult12)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_13 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r3[1]}}),      // input wire [7 : 0] A
  .B(param_w_h1_arr[W_WIDTH*4-1:W_WIDTH*3]),      // input wire [17 : 0] B
  .P(mult13)      // output wire [25 : 0] P
);

mult_gen_0   mult_gen_14 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r4[1]}}),      // input wire [7 : 0] A
  .B(param_w_h1_arr[W_WIDTH*5-1:W_WIDTH*4]),      // input wire [17 : 0] B
  .P(mult14)      // output wire [25 : 0] P
);


//第三行乘法器
mult_gen_0   mult_gen_20 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r0[2]}}),      // input wire [7 : 0] A
  .B(param_w_h2_arr[W_WIDTH-1:0]),      // input wire [17 : 0] B
  .P(mult20)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_21 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r1[2]}}),      // input wire [7 : 0] A
  .B(param_w_h2_arr[W_WIDTH*2-1:W_WIDTH]),      // input wire [17 : 0] B
  .P(mult21)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_22 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r2[2]}}),      // input wire [7 : 0] A
  .B(param_w_h2_arr[W_WIDTH*3-1:W_WIDTH*2]),      // input wire [17 : 0] B
  .P(mult22)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_23 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r3[2]}}),      // input wire [7 : 0] A
  .B(param_w_h2_arr[W_WIDTH*4-1:W_WIDTH*3]),      // input wire [17 : 0] B
  .P(mult23)      // output wire [25 : 0] P
);

mult_gen_0   mult_gen_24 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r4[2]}}),      // input wire [7 : 0] A
  .B(param_w_h2_arr[W_WIDTH*5-1:W_WIDTH*4]),      // input wire [17 : 0] B
  .P(mult24)      // output wire [25 : 0] P
);


//第四行乘法器
mult_gen_0   mult_gen_30 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r0[3]}}),      // input wire [7 : 0] A
  .B(param_w_h3_arr[W_WIDTH-1:0]),      // input wire [17 : 0] B
  .P(mult30)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_31 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r1[3]}}),      // input wire [7 : 0] A
  .B(param_w_h3_arr[W_WIDTH*2-1:W_WIDTH]),      // input wire [17 : 0] B
  .P(mult31)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_32 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r2[3]}}),      // input wire [7 : 0] A
  .B(param_w_h3_arr[W_WIDTH*3-1:W_WIDTH*2]),      // input wire [17 : 0] B
  .P(mult32)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_33 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r3[3]}}),      // input wire [7 : 0] A
  .B(param_w_h3_arr[W_WIDTH*4-1:W_WIDTH*3]),      // input wire [17 : 0] B
  .P(mult33)      // output wire [25 : 0] P
);

mult_gen_0   mult_gen_34 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r4[3]}}),      // input wire [7 : 0] A
  .B(param_w_h3_arr[W_WIDTH*5-1:W_WIDTH*4]),      // input wire [17 : 0] B
  .P(mult34)      // output wire [25 : 0] P
);


//第五行乘法器
mult_gen_0   mult_gen_40 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r0[4]}}),      // input wire [7 : 0] A
  .B(param_w_h4_arr[W_WIDTH-1:0]),      // input wire [17 : 0] B
  .P(mult40)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_41 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r1[4]}}),      // input wire [7 : 0] A
  .B(param_w_h4_arr[W_WIDTH*2-1:W_WIDTH]),      // input wire [17 : 0] B
  .P(mult41)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_42 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r2[4]}}),      // input wire [7 : 0] A
  .B(param_w_h4_arr[W_WIDTH*3-1:W_WIDTH*2]),      // input wire [17 : 0] B
  .P(mult42)      // output wire [25 : 0] P
);


mult_gen_0   mult_gen_43 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r3[4]}}),      // input wire [7 : 0] A
  .B(param_w_h4_arr[W_WIDTH*4-1:W_WIDTH*3]),      // input wire [17 : 0] B
  .P(mult43)      // output wire [25 : 0] P
);

mult_gen_0   mult_gen_44 (
  .CLK(clk),  // input wire CLK
  .A({8{col_data_r4[4]}}),      // input wire [7 : 0] A
  .B(param_w_h4_arr[W_WIDTH*5-1:W_WIDTH*4]),      // input wire [17 : 0] B
  .P(mult44)      // output wire [25 : 0] P
);


   always @(posedge clk or negedge rst_n) begin
  	if (!rst_n) 
  		conv_cnt <='d0;	
    else if(conv_flag==0)
        conv_cnt<='d0;		
    else if(conv_flag==1'b1 && row_cnt=='d23 && data_rd_addr =='d31) //这里为什么row_cnt为0
        conv_cnt <=conv_cnt+1'b1;
  end


  reg   signed   [31:0]  conv_rslt;



   always @(posedge clk or negedge rst_n) begin
  	if (!rst_n) 
  		conv_rslt <='d0;	
    else if(data_rd_addr<='d30 &&  data_rd_addr>='d7 )
       conv_rslt<=  mult00+ mult01 +mult02 +mult03+mult04
                    + mult10+ mult11 +mult12 +mult13+mult14
                    +mult20+ mult21 +mult22 +mult23+mult24
                    +mult30+ mult31 +mult32 +mult33+mult34
                    +mult40+ mult41 +mult42 +mult43+mult44+param_bias;
   end  



   always @(posedge clk or negedge rst_n) begin
  	if (!rst_n) 
  		conv_rslt_act_vld <='d0;	
    else if(data_rd_addr<='d30 &&  data_rd_addr>='d7)
        conv_rslt_act_vld<='d1;	
    else 
       conv_rslt_act_vld<='d0;
  end               

  assign   conv_rslt_act  =(conv_rslt[31]==1'b0)  ? conv_rslt :'d0;




endmodule
