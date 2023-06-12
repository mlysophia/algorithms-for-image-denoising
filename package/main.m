% PDEȥ��������
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

%����(��ֵ=0,����=sigma)�ĸ�˹����(��ѡ)
sigma=15;
if nchannel==1%gray image
    In=I+sigma*randn(row,col);
elseif nchannel==3%color image
    In=I+sigma*randn(row,col,3);
end
figure;imshow(uint8(In));
% title(['SNR=',num2str(SNR(I,In))]);%�ź�������:

%�ֹ�ָ���ݶ���ֵ(for smooth&directional diffusion)
K=15;
%��robust_statistic�Զ������ݶ���ֵ(��Sapiro P231)
% K=autoK(In)
%����Ӱ�캯������
% plot_edgestop(K);
%����ˮƽ������
% figure;contour(In);axis ij;

%��ɢȥ��
edgestop='pm1';
method='cat';
niter=50;
% It=smooth_diffusion(In,edgestop,method,'is',niter,K,I);
% It=directional_diffusion(In,'tky','av2','is',niter,K,I);
% figure;contour(It);axis ij;%����ˮƽ������
% It=TV_denoise(In,'is',niter,0,0,I);%without fedality term
% It=TV_denoise(In,'is',1,1,sigma,I);%with fedality term
It=order4_diffusion(In,edgestop,'is',niter,K,I);
