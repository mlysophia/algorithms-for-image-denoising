clear
clc
I = imread('lena.jpg');
I=rgb2gray(I);
t=0.1;
In=imnoise(I,'gaussian',0,t);
K = autoK(In);

I = double(I)/256;
In = double(In)/256;

k=200;   %��������

[M,N1]=size(In);
set(gcf,'position',[0 0 N1 M]);
imshow(In,[],'border','tight', 'initialmagnification','fit');  %�ް�ɫ�߿���ʾ

print -dpng lena_noise_gauss_0.1.png
fprintf('lena_%d_gauss_%.2f_SNR:%.2f\n',k,t,SNR(I,In))
fprintf('lena_%d_gauss_%.2f_PSNR:%.2f\n',k,t,PSNR(I,In))
fprintf('lena_%d_gauss_%.2f_MSSIM:%.2f\n',k,t,MSSIM(I,In)*100)

dt = 0.05;   %% ����Ϊĳ�ֳ������� ��PDE��ֵ���п����Ϊ��ʱ�䲽����
 for tt = 1:k
     %�����ĸ�������ݶ�
     Gn = [In(1,:,:);In(1:end-1,:,:)] - In;  % N - O
     Gs = [In(2:end,:,:);In(end,:,:)] - In;  % S - O
     Ge = [In(:,2:end,:) In(:,end,:)] - In;  % E - O
     Gw = [In(:,1,:) In(:,1:end-1,:)] - In;  % W - O
     %2. ������ɢϡ��
     Cn = 1./(1 + (Gn/K).^2);
     Cs = 1./(1 + (Gs/K).^2);
     Ce = 1./(1 + (Ge/K).^2);
     Cw = 1./(1 + (Gw/K).^2);    
     %3. һ��ʱ���ʽ�����PDE(��ɢ)
     diff = (Cn.*Gn + Cs.*Gs + Ce.*Ge + Cw.*Gw);
     In = In + dt*diff;   % ����һ����ŷ����ʽ   
 end
[M,N1]=size(In);
set(gcf,'position',[0 0 N1 M]);
imshow(In,[],'border','tight', 'initialmagnification','fit');  %�ް�ɫ�߿���ʾ

print -dpng lena_pm_200_gauss_0.1.png
fprintf('lena_pm_%d_gauss_%.2f_SNR:%.2f\n',k,t,SNR(I,In))
fprintf('lena_pm_%d_gauss_%.2f_PSNR:%.2f\n',k,t,PSNR(I,In))
fprintf('lena_pm_%d_gauss_%.2f_MSSIM:%.2f\n',k,t,MSSIM(I,In)*100)
