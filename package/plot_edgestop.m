function plot_edgestop(K)
% 画扩散函数、影响函数(+归一化)曲线图
% by Qulei @2005/12/11
% 包括PM1,PM2,Tukey扩散函数及其影响函数(参Sapiro Chapter4)
% K是边缘阈值

x=0:255;

%扩散函数g()
g_PM1=1./(1+(x/K).^2);
g_PM2=exp(-(x/K).^2);
g_Tukey=zeros(1,256);g_Tukey(1:round(K)+1)=(1-([0:round(K)]/K).^2).^2;
%影响函数influ=g()*x
influ_PM1=g_PM1.*x;
influ_PM2=g_PM2.*x;
influ_Tukey=g_Tukey.*x;

%计算归一化参数
K1=K;K2=K*(2^0.5);K3=K*5^0.5;%梯度阈值归一化
a1=1;a2=1/(2*exp(-0.5));a3=25/32;%幅值归一化

%归一化扩散函数g()
norm_g_PM1=1./(1+(x/K1).^2)*a1;
norm_g_PM2=exp(-(x/K2).^2)*a2;
norm_g_Tukey=zeros(1,256);norm_g_Tukey(1:round(K3)+1)=(1-([0:round(K3)]/K3).^2).^2*a3;
%归一化影响函数influ=g()*x
norm_influ_PM1=norm_g_PM1.*x;
norm_influ_PM2=norm_g_PM2.*x;
norm_influ_Tukey=norm_g_Tukey.*x;

%画曲线图
figure;
subplot(3,1,1);hold on;grid on;
title(['梯度阈值:K=',num2str(K)]);
ylabel('扩散函数');
plot(x,g_PM1,'r');
plot(x,g_PM2,'b');
plot(x,g_Tukey,'m');
h=legend('PM1','PM2','Tukey'); 
subplot(3,1,2);hold on;grid on;
ylabel('影响函数');
plot(x,influ_PM1,'r'); 
plot(x,influ_PM2,'b');
plot(x,influ_Tukey,'m');
subplot(3,1,3);hold on;grid on;
ylabel('归一化的影响函数');
plot(x,norm_influ_PM1,'r'); 
plot(x,norm_influ_PM2,'b');
plot(x,norm_influ_Tukey,'m');
hold off