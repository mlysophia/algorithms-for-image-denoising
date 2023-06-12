% PDE去噪主程序
% by Qulei @2005/12/11

clc
clear all

% I=imread('pentagram.bmp');%gray image
I=imread('lena.jpg');
I=rgb2gray(I);
% I=imread('cameraman.tif');I=double(I(25:125,70:170));
% I=imread('canal.gif');%gray noisy image
% [I,map]=imread('ct_scan.bmp');I=ind2gray(I,map);
% I=imread('haifa.bmp');%color image
I=double(I);
[row,col,nchannel]=size(I);
figure;imshow(uint8(I)); 
In=I;

%加入(均值=0,方差=sigma)的高斯噪声(可选)
sigma=15;
if nchannel==1%gray image
    In=I+sigma*randn(row,col);
elseif nchannel==3%color image
    In=I+sigma*randn(row,col,3);
end
figure;imshow(uint8(In));
% title(['SNR=',num2str(SNR(I,In))]);%信号噪声比:

%手工指定梯度阈值(for smooth&directional diffusion)
K=15;
%用robust_statistic自动估计梯度阈值(参Sapiro P231)
% K=autoK(In)
%画出影响函数曲线
% plot_edgestop(K);
%画出水平集曲线
% figure;contour(In);axis ij;

%扩散去噪
edgestop='pm1';
method='cat';
niter=50;
% It=smooth_diffusion(In,edgestop,method,'is',niter,K,I);
% It=directional_diffusion(In,'tky','av2','is',niter,K,I);
% figure;contour(It);axis ij;%画出水平集曲线
% It=TV_denoise(In,'is',niter,0,0,I);%without fedality term
% It=TV_denoise(In,'is',1,1,sigma,I);%with fedality term
It=order4_diffusion(In,edgestop,'is',niter,K,I);
