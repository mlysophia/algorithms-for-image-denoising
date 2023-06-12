function plot_edgestop(K)
% ����ɢ������Ӱ�캯��(+��һ��)����ͼ
% by Qulei @2005/12/11
% ����PM1,PM2,Tukey��ɢ��������Ӱ�캯��(��Sapiro Chapter4)
% K�Ǳ�Ե��ֵ

x=0:255;

%��ɢ����g()
g_PM1=1./(1+(x/K).^2);
g_PM2=exp(-(x/K).^2);
g_Tukey=zeros(1,256);g_Tukey(1:round(K)+1)=(1-([0:round(K)]/K).^2).^2;
%Ӱ�캯��influ=g()*x
influ_PM1=g_PM1.*x;
influ_PM2=g_PM2.*x;
influ_Tukey=g_Tukey.*x;

%�����һ������
K1=K;K2=K*(2^0.5);K3=K*5^0.5;%�ݶ���ֵ��һ��
a1=1;a2=1/(2*exp(-0.5));a3=25/32;%��ֵ��һ��

%��һ����ɢ����g()
norm_g_PM1=1./(1+(x/K1).^2)*a1;
norm_g_PM2=exp(-(x/K2).^2)*a2;
norm_g_Tukey=zeros(1,256);norm_g_Tukey(1:round(K3)+1)=(1-([0:round(K3)]/K3).^2).^2*a3;
%��һ��Ӱ�캯��influ=g()*x
norm_influ_PM1=norm_g_PM1.*x;
norm_influ_PM2=norm_g_PM2.*x;
norm_influ_Tukey=norm_g_Tukey.*x;

%������ͼ
figure;
subplot(3,1,1);hold on;grid on;
title(['�ݶ���ֵ:K=',num2str(K)]);
ylabel('��ɢ����');
plot(x,g_PM1,'r');
plot(x,g_PM2,'b');
plot(x,g_Tukey,'m');
h=legend('PM1','PM2','Tukey'); 
subplot(3,1,2);hold on;grid on;
ylabel('Ӱ�캯��');
plot(x,influ_PM1,'r'); 
plot(x,influ_PM2,'b');
plot(x,influ_Tukey,'m');
subplot(3,1,3);hold on;grid on;
ylabel('��һ����Ӱ�캯��');
plot(x,norm_influ_PM1,'r'); 
plot(x,norm_influ_PM2,'b');
plot(x,norm_influ_Tukey,'m');
hold off