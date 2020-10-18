//**************************************************************
// All rights reserved.

// Module Name     :  MatrixMult_NSPC    

// File name    :  MatrixMult_NSPC.v

// Author       :  Zihan Xia, University of Electronic Science and Technology of China

// Email        :  xiazihan28@outlook.com

//Abstract       :  This module is a RTL demo, which implements a 8*2 matrix //multiplication array with bundle size=4. 
//                  In the proposed CNN, all the activation is positive due to ReLU.
                    /* weight matrix row:8, col:2
                    [[ 0.24449992  0.2131777 ]
                    [ 0.25800651  0.47452684]
                    [ 0.24823252 -0.81958256]
                    [-0.47316468  0.80140023]
                    [-0.93461812  0.50390557]
                    [-0.03607011 -0.89698963]
                    [ 0.73632516 -0.42032411]
                    [-0.64424554  0.93303716]]
                    */
//                  More details can be found in paper:
//                 "Neural Synaptic Plasticity-Like Computing A High Computing Efficient Deep Convolutional Neural Network Accelerator".

//*********************************************************************

`timescale 1ns/100ps
module MatrixMult_NSPC(
   input clk, rst_n,
   output [16-1:0] computed,
   input   [32-1:0]    data //a vector with 8 * (4 bit data)
);

//bundle size =4

wire signed [8-1:0] Y1;
wire signed [8-1:0] Y2;
assign computed = {Y1,Y2};
wire   signed [8-1:0]     ker1_stage0_sum1;
wire   signed [8-1:0]     ker1_stage0_sum2;
wire   signed [8-1:0]     ker2_stage0_sum1;
wire   signed [8-1:0]     ker2_stage0_sum2;
MatrixMult_NSPC_PE_1_1 inst_MatrixMult_NSPC_PE_1_1(
       .clk(clk), .rst_n(rst_n),
       .sum_next(ker1_stage0_sum1),
       .data(data[31:16])
);
MatrixMult_NSPC_PE_1_2 inst_MatrixMult_NSPC_PE_1_2(
       .clk(clk), .rst_n(rst_n),
       .sum_next(ker1_stage0_sum2),
       .data(data[15:0])
);
MatrixMult_NSPC_PE_2_1 inst_MatrixMult_NSPC_PE_2_1(
       .clk(clk), .rst_n(rst_n),
       .sum_next(ker2_stage0_sum1),
       .data(data[31:16])
);
MatrixMult_NSPC_PE_2_2 inst_MatrixMult_NSPC_PE_2_2(
       .clk(clk), .rst_n(rst_n),
       .sum_next(ker2_stage0_sum2),
       .data(data[15:0])
);
reg   signed [8-1:0]     ker1_stage1_sum1;
always @ (posedge clk, negedge rst_n)begin
   if (!rst_n) begin
       ker1_stage1_sum1 <= 0;
   end
   else begin
       ker1_stage1_sum1 <= ker1_stage0_sum1+ker1_stage0_sum2;
   end
end
 assign Y1 = ker1_stage1_sum1;



reg   signed [8-1:0]     ker2_stage1_sum1;
always @ (posedge clk, negedge rst_n)begin
   if (!rst_n) begin
       ker2_stage1_sum1 <= 0;
   end
   else begin
       ker2_stage1_sum1 <= ker2_stage0_sum1+ker2_stage0_sum2;
   end
end
 assign Y2 = ker2_stage1_sum1;



endmodule





// processing elements, which are implemented by Neural Synaptic Plasticity-Like Computing 


module  MatrixMult_NSPC_PE_1_1 (
       input       clk, rst_n,
       output  reg   [8-1:0]    sum_next,
       input       [16-1:0]    data
);
   wire      [4-1:0]    data1;
   wire      [4-1:0]    data2;
   wire      [4-1:0]    data3;
   wire      [4-1:0]    data4;
   assign  data1 = data[15:12];
   assign  data2 = data[11:8];
   assign  data3 = data[7:4];
   assign  data4 = data[3:0];
//wires spreading::::::::::::::::::::::::::::::::::::::::::::
wire   spread_data1_bit0_1;
wire   spread_data1_bit1_1;
wire   spread_data1_bit1_2;
wire   spread_data1_bit2_1;
wire   spread_data1_bit2_2;
wire   spread_data1_bit2_3;
wire   spread_data1_bit2_4;
wire   spread_data1_bit3_1;
wire   spread_data1_bit3_2;
wire   spread_data1_bit3_3;
wire   spread_data1_bit3_4;
wire   spread_data1_bit3_5;
wire   spread_data1_bit3_6;
wire   spread_data1_bit3_7;
wire   spread_data1_bit3_8;
wire   spread_data2_bit0_1;
wire   spread_data2_bit1_1;
wire   spread_data2_bit1_2;
wire   spread_data2_bit2_1;
wire   spread_data2_bit2_2;
wire   spread_data2_bit2_3;
wire   spread_data2_bit2_4;
wire   spread_data2_bit3_1;
wire   spread_data2_bit3_2;
wire   spread_data2_bit3_3;
wire   spread_data2_bit3_4;
wire   spread_data2_bit3_5;
wire   spread_data2_bit3_6;
wire   spread_data2_bit3_7;
wire   spread_data2_bit3_8;
wire   spread_data3_bit0_1;
wire   spread_data3_bit1_1;
wire   spread_data3_bit1_2;
wire   spread_data3_bit2_1;
wire   spread_data3_bit2_2;
wire   spread_data3_bit2_3;
wire   spread_data3_bit2_4;
wire   spread_data3_bit3_1;
wire   spread_data3_bit3_2;
wire   spread_data3_bit3_3;
wire   spread_data3_bit3_4;
wire   spread_data3_bit3_5;
wire   spread_data3_bit3_6;
wire   spread_data3_bit3_7;
wire   spread_data3_bit3_8;
wire   spread_data4_bit0_1;
wire   spread_data4_bit1_1;
wire   spread_data4_bit1_2;
wire   spread_data4_bit2_1;
wire   spread_data4_bit2_2;
wire   spread_data4_bit2_3;
wire   spread_data4_bit2_4;
wire   spread_data4_bit3_1;
wire   spread_data4_bit3_2;
wire   spread_data4_bit3_3;
wire   spread_data4_bit3_4;
wire   spread_data4_bit3_5;
wire   spread_data4_bit3_6;
wire   spread_data4_bit3_7;
wire   spread_data4_bit3_8;
assign   spread_data1_bit0_1 = data1[0];
assign   spread_data1_bit1_1 = data1[1];
assign   spread_data1_bit1_2 = data1[1];
assign   spread_data1_bit2_1 = data1[2];
assign   spread_data1_bit2_2 = data1[2];
assign   spread_data1_bit2_3 = data1[2];
assign   spread_data1_bit2_4 = data1[2];
assign   spread_data1_bit3_1 = data1[3];
assign   spread_data1_bit3_2 = data1[3];
assign   spread_data1_bit3_3 = data1[3];
assign   spread_data1_bit3_4 = data1[3];
assign   spread_data1_bit3_5 = data1[3];
assign   spread_data1_bit3_6 = data1[3];
assign   spread_data1_bit3_7 = data1[3];
assign   spread_data1_bit3_8 = data1[3];
assign   spread_data2_bit0_1 = data2[0];
assign   spread_data2_bit1_1 = data2[1];
assign   spread_data2_bit1_2 = data2[1];
assign   spread_data2_bit2_1 = data2[2];
assign   spread_data2_bit2_2 = data2[2];
assign   spread_data2_bit2_3 = data2[2];
assign   spread_data2_bit2_4 = data2[2];
assign   spread_data2_bit3_1 = data2[3];
assign   spread_data2_bit3_2 = data2[3];
assign   spread_data2_bit3_3 = data2[3];
assign   spread_data2_bit3_4 = data2[3];
assign   spread_data2_bit3_5 = data2[3];
assign   spread_data2_bit3_6 = data2[3];
assign   spread_data2_bit3_7 = data2[3];
assign   spread_data2_bit3_8 = data2[3];
assign   spread_data3_bit0_1 = data3[0];
assign   spread_data3_bit1_1 = data3[1];
assign   spread_data3_bit1_2 = data3[1];
assign   spread_data3_bit2_1 = data3[2];
assign   spread_data3_bit2_2 = data3[2];
assign   spread_data3_bit2_3 = data3[2];
assign   spread_data3_bit2_4 = data3[2];
assign   spread_data3_bit3_1 = data3[3];
assign   spread_data3_bit3_2 = data3[3];
assign   spread_data3_bit3_3 = data3[3];
assign   spread_data3_bit3_4 = data3[3];
assign   spread_data3_bit3_5 = data3[3];
assign   spread_data3_bit3_6 = data3[3];
assign   spread_data3_bit3_7 = data3[3];
assign   spread_data3_bit3_8 = data3[3];
assign   spread_data4_bit0_1 = data4[0];
assign   spread_data4_bit1_1 = data4[1];
assign   spread_data4_bit1_2 = data4[1];
assign   spread_data4_bit2_1 = data4[2];
assign   spread_data4_bit2_2 = data4[2];
assign   spread_data4_bit2_3 = data4[2];
assign   spread_data4_bit2_4 = data4[2];
assign   spread_data4_bit3_1 = data4[3];
assign   spread_data4_bit3_2 = data4[3];
assign   spread_data4_bit3_3 = data4[3];
assign   spread_data4_bit3_4 = data4[3];
assign   spread_data4_bit3_5 = data4[3];
assign   spread_data4_bit3_6 = data4[3];
assign   spread_data4_bit3_7 = data4[3];
assign   spread_data4_bit3_8 = data4[3];
//wires selecting and backward conversion::::::::::::::::::::::::::::::::::::::::::::
//uniformly selection
   wire      [8-1-1:0]    sum_next_wire;
   wire              sum_data1;
   assign  sum_data1 = spread_data1_bit3_3;
   wire      [2:0]  sum_data2;
   assign  sum_data2 = spread_data2_bit2_1+spread_data2_bit3_6;
   wire              sum_data3;
   assign  sum_data3 = spread_data3_bit3_3;
   wire      [2:0]  sum_data4;
   assign  sum_data4 = spread_data4_bit2_2+spread_data4_bit3_1+spread_data4_bit3_5;
   assign  sum_next_wire = sum_data1+sum_data2+sum_data3-sum_data4;
   always @ (posedge clk, negedge rst_n) begin
       if (!rst_n)begin
           sum_next <= 0;
       end
       else begin
           sum_next <= (sum_next_wire<<1);
       end
   end
endmodule

module  MatrixMult_NSPC_PE_1_2 (
       input       clk, rst_n,
       output  reg   [8-1:0]    sum_next,
       input       [16-1:0]    data
);
   wire      [4-1:0]    data1;
   wire      [4-1:0]    data2;
   wire      [4-1:0]    data3;
   wire      [4-1:0]    data4;
   assign  data1 = data[15:12];
   assign  data2 = data[11:8];
   assign  data3 = data[7:4];
   assign  data4 = data[3:0];
//wires spreading::::::::::::::::::::::::::::::::::::::::::::
wire   spread_data1_bit0_1;
wire   spread_data1_bit1_1;
wire   spread_data1_bit1_2;
wire   spread_data1_bit2_1;
wire   spread_data1_bit2_2;
wire   spread_data1_bit2_3;
wire   spread_data1_bit2_4;
wire   spread_data1_bit3_1;
wire   spread_data1_bit3_2;
wire   spread_data1_bit3_3;
wire   spread_data1_bit3_4;
wire   spread_data1_bit3_5;
wire   spread_data1_bit3_6;
wire   spread_data1_bit3_7;
wire   spread_data1_bit3_8;
wire   spread_data2_bit0_1;
wire   spread_data2_bit1_1;
wire   spread_data2_bit1_2;
wire   spread_data2_bit2_1;
wire   spread_data2_bit2_2;
wire   spread_data2_bit2_3;
wire   spread_data2_bit2_4;
wire   spread_data2_bit3_1;
wire   spread_data2_bit3_2;
wire   spread_data2_bit3_3;
wire   spread_data2_bit3_4;
wire   spread_data2_bit3_5;
wire   spread_data2_bit3_6;
wire   spread_data2_bit3_7;
wire   spread_data2_bit3_8;
wire   spread_data3_bit0_1;
wire   spread_data3_bit1_1;
wire   spread_data3_bit1_2;
wire   spread_data3_bit2_1;
wire   spread_data3_bit2_2;
wire   spread_data3_bit2_3;
wire   spread_data3_bit2_4;
wire   spread_data3_bit3_1;
wire   spread_data3_bit3_2;
wire   spread_data3_bit3_3;
wire   spread_data3_bit3_4;
wire   spread_data3_bit3_5;
wire   spread_data3_bit3_6;
wire   spread_data3_bit3_7;
wire   spread_data3_bit3_8;
wire   spread_data4_bit0_1;
wire   spread_data4_bit1_1;
wire   spread_data4_bit1_2;
wire   spread_data4_bit2_1;
wire   spread_data4_bit2_2;
wire   spread_data4_bit2_3;
wire   spread_data4_bit2_4;
wire   spread_data4_bit3_1;
wire   spread_data4_bit3_2;
wire   spread_data4_bit3_3;
wire   spread_data4_bit3_4;
wire   spread_data4_bit3_5;
wire   spread_data4_bit3_6;
wire   spread_data4_bit3_7;
wire   spread_data4_bit3_8;
assign   spread_data1_bit0_1 = data1[0];
assign   spread_data1_bit1_1 = data1[1];
assign   spread_data1_bit1_2 = data1[1];
assign   spread_data1_bit2_1 = data1[2];
assign   spread_data1_bit2_2 = data1[2];
assign   spread_data1_bit2_3 = data1[2];
assign   spread_data1_bit2_4 = data1[2];
assign   spread_data1_bit3_1 = data1[3];
assign   spread_data1_bit3_2 = data1[3];
assign   spread_data1_bit3_3 = data1[3];
assign   spread_data1_bit3_4 = data1[3];
assign   spread_data1_bit3_5 = data1[3];
assign   spread_data1_bit3_6 = data1[3];
assign   spread_data1_bit3_7 = data1[3];
assign   spread_data1_bit3_8 = data1[3];
assign   spread_data2_bit0_1 = data2[0];
assign   spread_data2_bit1_1 = data2[1];
assign   spread_data2_bit1_2 = data2[1];
assign   spread_data2_bit2_1 = data2[2];
assign   spread_data2_bit2_2 = data2[2];
assign   spread_data2_bit2_3 = data2[2];
assign   spread_data2_bit2_4 = data2[2];
assign   spread_data2_bit3_1 = data2[3];
assign   spread_data2_bit3_2 = data2[3];
assign   spread_data2_bit3_3 = data2[3];
assign   spread_data2_bit3_4 = data2[3];
assign   spread_data2_bit3_5 = data2[3];
assign   spread_data2_bit3_6 = data2[3];
assign   spread_data2_bit3_7 = data2[3];
assign   spread_data2_bit3_8 = data2[3];
assign   spread_data3_bit0_1 = data3[0];
assign   spread_data3_bit1_1 = data3[1];
assign   spread_data3_bit1_2 = data3[1];
assign   spread_data3_bit2_1 = data3[2];
assign   spread_data3_bit2_2 = data3[2];
assign   spread_data3_bit2_3 = data3[2];
assign   spread_data3_bit2_4 = data3[2];
assign   spread_data3_bit3_1 = data3[3];
assign   spread_data3_bit3_2 = data3[3];
assign   spread_data3_bit3_3 = data3[3];
assign   spread_data3_bit3_4 = data3[3];
assign   spread_data3_bit3_5 = data3[3];
assign   spread_data3_bit3_6 = data3[3];
assign   spread_data3_bit3_7 = data3[3];
assign   spread_data3_bit3_8 = data3[3];
assign   spread_data4_bit0_1 = data4[0];
assign   spread_data4_bit1_1 = data4[1];
assign   spread_data4_bit1_2 = data4[1];
assign   spread_data4_bit2_1 = data4[2];
assign   spread_data4_bit2_2 = data4[2];
assign   spread_data4_bit2_3 = data4[2];
assign   spread_data4_bit2_4 = data4[2];
assign   spread_data4_bit3_1 = data4[3];
assign   spread_data4_bit3_2 = data4[3];
assign   spread_data4_bit3_3 = data4[3];
assign   spread_data4_bit3_4 = data4[3];
assign   spread_data4_bit3_5 = data4[3];
assign   spread_data4_bit3_6 = data4[3];
assign   spread_data4_bit3_7 = data4[3];
assign   spread_data4_bit3_8 = data4[3];
//wires selecting and backward conversion::::::::::::::::::::::::::::::::::::::::::::
   wire      [8-1-2:0]    sum_next_wire;
   wire      [2:0]  sum_data1;
   assign  sum_data1 = spread_data1_bit2_1+spread_data1_bit3_7+spread_data1_bit3_4;
   wire      [2:0]  sum_data3;
   assign  sum_data3 = spread_data3_bit2_4+spread_data3_bit3_2;
   wire      [2:0]  sum_data4;
   assign  sum_data4 = spread_data4_bit2_3+spread_data4_bit3_5;
   assign  sum_next_wire = 0-sum_data1+sum_data3-sum_data4;
   always @ (posedge clk, negedge rst_n) begin
       if (!rst_n)begin
           sum_next <= 0;
       end
       else begin
           sum_next <= (sum_next_wire<<2);
       end
   end
endmodule

module  MatrixMult_NSPC_PE_2_1 (
       input       clk, rst_n,
       output  reg   [8-1:0]    sum_next,
       input       [16-1:0]    data
);
   wire      [4-1:0]    data1;
   wire      [4-1:0]    data2;
   wire      [4-1:0]    data3;
   wire      [4-1:0]    data4;
   assign  data1 = data[15:12];
   assign  data2 = data[11:8];
   assign  data3 = data[7:4];
   assign  data4 = data[3:0];
//wires spreading::::::::::::::::::::::::::::::::::::::::::::
wire   spread_data1_bit0_1;
wire   spread_data1_bit1_1;
wire   spread_data1_bit1_2;
wire   spread_data1_bit2_1;
wire   spread_data1_bit2_2;
wire   spread_data1_bit2_3;
wire   spread_data1_bit2_4;
wire   spread_data1_bit3_1;
wire   spread_data1_bit3_2;
wire   spread_data1_bit3_3;
wire   spread_data1_bit3_4;
wire   spread_data1_bit3_5;
wire   spread_data1_bit3_6;
wire   spread_data1_bit3_7;
wire   spread_data1_bit3_8;
wire   spread_data2_bit0_1;
wire   spread_data2_bit1_1;
wire   spread_data2_bit1_2;
wire   spread_data2_bit2_1;
wire   spread_data2_bit2_2;
wire   spread_data2_bit2_3;
wire   spread_data2_bit2_4;
wire   spread_data2_bit3_1;
wire   spread_data2_bit3_2;
wire   spread_data2_bit3_3;
wire   spread_data2_bit3_4;
wire   spread_data2_bit3_5;
wire   spread_data2_bit3_6;
wire   spread_data2_bit3_7;
wire   spread_data2_bit3_8;
wire   spread_data3_bit0_1;
wire   spread_data3_bit1_1;
wire   spread_data3_bit1_2;
wire   spread_data3_bit2_1;
wire   spread_data3_bit2_2;
wire   spread_data3_bit2_3;
wire   spread_data3_bit2_4;
wire   spread_data3_bit3_1;
wire   spread_data3_bit3_2;
wire   spread_data3_bit3_3;
wire   spread_data3_bit3_4;
wire   spread_data3_bit3_5;
wire   spread_data3_bit3_6;
wire   spread_data3_bit3_7;
wire   spread_data3_bit3_8;
wire   spread_data4_bit0_1;
wire   spread_data4_bit1_1;
wire   spread_data4_bit1_2;
wire   spread_data4_bit2_1;
wire   spread_data4_bit2_2;
wire   spread_data4_bit2_3;
wire   spread_data4_bit2_4;
wire   spread_data4_bit3_1;
wire   spread_data4_bit3_2;
wire   spread_data4_bit3_3;
wire   spread_data4_bit3_4;
wire   spread_data4_bit3_5;
wire   spread_data4_bit3_6;
wire   spread_data4_bit3_7;
wire   spread_data4_bit3_8;
assign   spread_data1_bit0_1 = data1[0];
assign   spread_data1_bit1_1 = data1[1];
assign   spread_data1_bit1_2 = data1[1];
assign   spread_data1_bit2_1 = data1[2];
assign   spread_data1_bit2_2 = data1[2];
assign   spread_data1_bit2_3 = data1[2];
assign   spread_data1_bit2_4 = data1[2];
assign   spread_data1_bit3_1 = data1[3];
assign   spread_data1_bit3_2 = data1[3];
assign   spread_data1_bit3_3 = data1[3];
assign   spread_data1_bit3_4 = data1[3];
assign   spread_data1_bit3_5 = data1[3];
assign   spread_data1_bit3_6 = data1[3];
assign   spread_data1_bit3_7 = data1[3];
assign   spread_data1_bit3_8 = data1[3];
assign   spread_data2_bit0_1 = data2[0];
assign   spread_data2_bit1_1 = data2[1];
assign   spread_data2_bit1_2 = data2[1];
assign   spread_data2_bit2_1 = data2[2];
assign   spread_data2_bit2_2 = data2[2];
assign   spread_data2_bit2_3 = data2[2];
assign   spread_data2_bit2_4 = data2[2];
assign   spread_data2_bit3_1 = data2[3];
assign   spread_data2_bit3_2 = data2[3];
assign   spread_data2_bit3_3 = data2[3];
assign   spread_data2_bit3_4 = data2[3];
assign   spread_data2_bit3_5 = data2[3];
assign   spread_data2_bit3_6 = data2[3];
assign   spread_data2_bit3_7 = data2[3];
assign   spread_data2_bit3_8 = data2[3];
assign   spread_data3_bit0_1 = data3[0];
assign   spread_data3_bit1_1 = data3[1];
assign   spread_data3_bit1_2 = data3[1];
assign   spread_data3_bit2_1 = data3[2];
assign   spread_data3_bit2_2 = data3[2];
assign   spread_data3_bit2_3 = data3[2];
assign   spread_data3_bit2_4 = data3[2];
assign   spread_data3_bit3_1 = data3[3];
assign   spread_data3_bit3_2 = data3[3];
assign   spread_data3_bit3_3 = data3[3];
assign   spread_data3_bit3_4 = data3[3];
assign   spread_data3_bit3_5 = data3[3];
assign   spread_data3_bit3_6 = data3[3];
assign   spread_data3_bit3_7 = data3[3];
assign   spread_data3_bit3_8 = data3[3];
assign   spread_data4_bit0_1 = data4[0];
assign   spread_data4_bit1_1 = data4[1];
assign   spread_data4_bit1_2 = data4[1];
assign   spread_data4_bit2_1 = data4[2];
assign   spread_data4_bit2_2 = data4[2];
assign   spread_data4_bit2_3 = data4[2];
assign   spread_data4_bit2_4 = data4[2];
assign   spread_data4_bit3_1 = data4[3];
assign   spread_data4_bit3_2 = data4[3];
assign   spread_data4_bit3_3 = data4[3];
assign   spread_data4_bit3_4 = data4[3];
assign   spread_data4_bit3_5 = data4[3];
assign   spread_data4_bit3_6 = data4[3];
assign   spread_data4_bit3_7 = data4[3];
assign   spread_data4_bit3_8 = data4[3];
//wires selecting and backward conversion::::::::::::::::::::::::::::::::::::::::::::
   wire      [8-1-2:0]    sum_next_wire;
   wire              sum_data2;
   assign  sum_data2 = spread_data2_bit3_8;
   wire      [2:0]  sum_data3;
   assign  sum_data3 = spread_data3_bit2_4+spread_data3_bit3_1+spread_data3_bit3_6;
   wire      [2:0]  sum_data4;
   assign  sum_data4 = spread_data4_bit2_2+spread_data4_bit3_3+spread_data4_bit3_6;
   assign  sum_next_wire = sum_data2-sum_data3+sum_data4;
   always @ (posedge clk, negedge rst_n) begin
       if (!rst_n)begin
           sum_next <= 0;
       end
       else begin
           sum_next <= (sum_next_wire<<2);
       end
   end
endmodule

module  MatrixMult_NSPC_PE_2_2 (
       input       clk, rst_n,
       output  reg   [8-1:0]    sum_next,
       input       [16-1:0]    data
);
   wire      [4-1:0]    data1;
   wire      [4-1:0]    data2;
   wire      [4-1:0]    data3;
   wire      [4-1:0]    data4;
   assign  data1 = data[15:12];
   assign  data2 = data[11:8];
   assign  data3 = data[7:4];
   assign  data4 = data[3:0];
//wires spreading::::::::::::::::::::::::::::::::::::::::::::
wire   spread_data1_bit0_1;
wire   spread_data1_bit1_1;
wire   spread_data1_bit1_2;
wire   spread_data1_bit2_1;
wire   spread_data1_bit2_2;
wire   spread_data1_bit2_3;
wire   spread_data1_bit2_4;
wire   spread_data1_bit3_1;
wire   spread_data1_bit3_2;
wire   spread_data1_bit3_3;
wire   spread_data1_bit3_4;
wire   spread_data1_bit3_5;
wire   spread_data1_bit3_6;
wire   spread_data1_bit3_7;
wire   spread_data1_bit3_8;
wire   spread_data2_bit0_1;
wire   spread_data2_bit1_1;
wire   spread_data2_bit1_2;
wire   spread_data2_bit2_1;
wire   spread_data2_bit2_2;
wire   spread_data2_bit2_3;
wire   spread_data2_bit2_4;
wire   spread_data2_bit3_1;
wire   spread_data2_bit3_2;
wire   spread_data2_bit3_3;
wire   spread_data2_bit3_4;
wire   spread_data2_bit3_5;
wire   spread_data2_bit3_6;
wire   spread_data2_bit3_7;
wire   spread_data2_bit3_8;
wire   spread_data3_bit0_1;
wire   spread_data3_bit1_1;
wire   spread_data3_bit1_2;
wire   spread_data3_bit2_1;
wire   spread_data3_bit2_2;
wire   spread_data3_bit2_3;
wire   spread_data3_bit2_4;
wire   spread_data3_bit3_1;
wire   spread_data3_bit3_2;
wire   spread_data3_bit3_3;
wire   spread_data3_bit3_4;
wire   spread_data3_bit3_5;
wire   spread_data3_bit3_6;
wire   spread_data3_bit3_7;
wire   spread_data3_bit3_8;
wire   spread_data4_bit0_1;
wire   spread_data4_bit1_1;
wire   spread_data4_bit1_2;
wire   spread_data4_bit2_1;
wire   spread_data4_bit2_2;
wire   spread_data4_bit2_3;
wire   spread_data4_bit2_4;
wire   spread_data4_bit3_1;
wire   spread_data4_bit3_2;
wire   spread_data4_bit3_3;
wire   spread_data4_bit3_4;
wire   spread_data4_bit3_5;
wire   spread_data4_bit3_6;
wire   spread_data4_bit3_7;
wire   spread_data4_bit3_8;
assign   spread_data1_bit0_1 = data1[0];
assign   spread_data1_bit1_1 = data1[1];
assign   spread_data1_bit1_2 = data1[1];
assign   spread_data1_bit2_1 = data1[2];
assign   spread_data1_bit2_2 = data1[2];
assign   spread_data1_bit2_3 = data1[2];
assign   spread_data1_bit2_4 = data1[2];
assign   spread_data1_bit3_1 = data1[3];
assign   spread_data1_bit3_2 = data1[3];
assign   spread_data1_bit3_3 = data1[3];
assign   spread_data1_bit3_4 = data1[3];
assign   spread_data1_bit3_5 = data1[3];
assign   spread_data1_bit3_6 = data1[3];
assign   spread_data1_bit3_7 = data1[3];
assign   spread_data1_bit3_8 = data1[3];
assign   spread_data2_bit0_1 = data2[0];
assign   spread_data2_bit1_1 = data2[1];
assign   spread_data2_bit1_2 = data2[1];
assign   spread_data2_bit2_1 = data2[2];
assign   spread_data2_bit2_2 = data2[2];
assign   spread_data2_bit2_3 = data2[2];
assign   spread_data2_bit2_4 = data2[2];
assign   spread_data2_bit3_1 = data2[3];
assign   spread_data2_bit3_2 = data2[3];
assign   spread_data2_bit3_3 = data2[3];
assign   spread_data2_bit3_4 = data2[3];
assign   spread_data2_bit3_5 = data2[3];
assign   spread_data2_bit3_6 = data2[3];
assign   spread_data2_bit3_7 = data2[3];
assign   spread_data2_bit3_8 = data2[3];
assign   spread_data3_bit0_1 = data3[0];
assign   spread_data3_bit1_1 = data3[1];
assign   spread_data3_bit1_2 = data3[1];
assign   spread_data3_bit2_1 = data3[2];
assign   spread_data3_bit2_2 = data3[2];
assign   spread_data3_bit2_3 = data3[2];
assign   spread_data3_bit2_4 = data3[2];
assign   spread_data3_bit3_1 = data3[3];
assign   spread_data3_bit3_2 = data3[3];
assign   spread_data3_bit3_3 = data3[3];
assign   spread_data3_bit3_4 = data3[3];
assign   spread_data3_bit3_5 = data3[3];
assign   spread_data3_bit3_6 = data3[3];
assign   spread_data3_bit3_7 = data3[3];
assign   spread_data3_bit3_8 = data3[3];
assign   spread_data4_bit0_1 = data4[0];
assign   spread_data4_bit1_1 = data4[1];
assign   spread_data4_bit1_2 = data4[1];
assign   spread_data4_bit2_1 = data4[2];
assign   spread_data4_bit2_2 = data4[2];
assign   spread_data4_bit2_3 = data4[2];
assign   spread_data4_bit2_4 = data4[2];
assign   spread_data4_bit3_1 = data4[3];
assign   spread_data4_bit3_2 = data4[3];
assign   spread_data4_bit3_3 = data4[3];
assign   spread_data4_bit3_4 = data4[3];
assign   spread_data4_bit3_5 = data4[3];
assign   spread_data4_bit3_6 = data4[3];
assign   spread_data4_bit3_7 = data4[3];
assign   spread_data4_bit3_8 = data4[3];
//wires selecting and backward conversion::::::::::::::::::::::::::::::::::::::::::::
   wire      [8-1-2:0]    sum_next_wire;
   wire      [2:0]  sum_data1;
   assign  sum_data1 = spread_data1_bit2_1+spread_data1_bit3_1;
   wire      [2:0]  sum_data2;
   assign  sum_data2 = spread_data2_bit2_2+spread_data2_bit3_6+spread_data2_bit3_2;
   wire              sum_data3;
   assign  sum_data3 = spread_data3_bit3_3;
   wire      [2:0]  sum_data4;
   assign  sum_data4 = spread_data4_bit2_2+spread_data4_bit3_7+spread_data4_bit3_5;
   assign  sum_next_wire = sum_data1-sum_data2-sum_data3+sum_data4;
   always @ (posedge clk, negedge rst_n) begin
       if (!rst_n)begin
           sum_next <= 0;
       end
       else begin
           sum_next <= (sum_next_wire<<2);
       end
   end
endmodule

