clear
clc
I = imread('lena.jpg');
I=rgb2gray(I);
t=0.01;
In=imnoise(I,'gaussian',0,t);
K = autoK(In);

I = double(I)/256;
In = double(In)/256;

k=100;   %迭代次数

n=2;
a=1;
Kb=K;
w=1;
m=1;

dt = 0.05;   %% 可视为某种超参数， 在PDE数值解中可理解为“时间步长”
 for tt = 1:k
     %计算四个方向的梯度
     Gn = [In(1,:,:);In(1:end-1,:,:)] - In;  % N - O
     Gs = [In(2:end,:,:);In(end,:,:)] - In;  % S - O
     Ge = [In(:,2:end,:) In(:,end,:)] - In;  % E - O
     Gw = [In(:,1,:) In(:,1:end-1,:)] - In;  % W - O
     %2. 计算扩散稀疏
     Cn = 1./(1 + (Gn/K).^n)-a./(1+((Gn-Kb)./w).^(2*m));
     Cs = 1./(1 + (Gs/K).^n)-a./(1+((Gs-Kb)./w).^(2*m));
     Ce = 1./(1 + (Ge/K).^n)-a./(1+((Ge-Kb)./w).^(2*m));
     Cw = 1./(1 + (Gw/K).^n)-a./(1+((Gw-Kb)./w).^(2*m));    
     %3. 一阶时间格式：求解PDE(扩散)
     diff = (Cn.*Gn + Cs.*Gs + Ce.*Ge + Cw.*Gw);
     In = In + dt*diff;   % 这是一个显欧拉格式   
 end
[M,N1]=size(In);
set(gcf,'position',[0 0 N1 M]);
imshow(In,[],'border','tight', 'initialmagnification','fit');  %无白色边框显示

print -dpng lena_FABD1_100_gauss_0.01.png
fprintf('lena_FABD_%d_gauss_%.2f_SNR:%.2f\n',k,t,SNR(I,In))
fprintf('lena_FABD_%d_gauss_%.2f_PSNR:%.2f\n',k,t,PSNR(I,In))
fprintf('lena_FABD_%d_gauss_%.2f_MSSIM:%.2f\n',k,t,MSSIM(I,In)*100)
