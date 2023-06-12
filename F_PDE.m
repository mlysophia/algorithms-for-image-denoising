clear
clc
I = imread('lena.jpg');
I=rgb2gray(I);
[row,col,nchannel]=size(I);
t=0.1;
In=imnoise(I,'gaussian',0,t);
K = autoK(In);

I = double(I);
In = double(In);

fprintf('lena_gauss_%.2f_SNR:%.2f\n',t,SNR(I,In))
fprintf('lena_gauss_%.2f_PSNR:%.2f\n',t,PSNR(I,In))
fprintf('lena_gauss_%.2f_MSSIM:%.2f\n',t,MSSIM(I,In)*100)

k=200;   %��������

dt = 0.05;   %% ����Ϊĳ�ֳ������� ��PDE��ֵ���п����Ϊ��ʱ�䲽����
 for tt = 1:k
     %����ͼ���ֵ�Ķ��ײ��(laplace)
     d2I=In(:,[2:col col],:)+In(:,[1 1:col-1],:)+In([2:row row],:,:)+In([1 1:row-1],:,:)-4*In;
     %������ɢϵ��
     g=(1./(1+(d2I/K).^2)).*d2I;   
     %���㺯��g�Ķ��ײ��
     d2g=g(:,[2:col col],:)+g(:,[1 1:col-1],:)+g([2:row row],:,:)+g([1 1:row-1],:,:)-4*g;
     %�ݶ��½����������PDE(��ɢ)
     In=In-dt*d2g;
 end
[M,N1]=size(In);
set(gcf,'position',[0 0 N1 M]);
imshow(In,[],'border','tight', 'initialmagnification','fit');  %�ް�ɫ�߿���ʾ

print -dpng lena_F_PDE_200_gauss_0.1.png
fprintf('lena_F_PDE_%d_gauss_%.2f_SNR:%.2f\n',k,t,SNR(I,In))
fprintf('lena_F_PDE_%d_gauss_%.2f_PSNR:%.2f\n',k,t,PSNR(I,In))
fprintf('lena_F_PDE_%d_gauss_%.2f_MSSIM:%.2f\n',k,t,MSSIM(I,In)*100)
