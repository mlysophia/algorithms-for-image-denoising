function It=directional_diffusion(I,edgestop,method,show,niter,K,Io,dt)
% Alvarez's Directional Diffusion去噪函数
% by Qulei @2005/12/18
% I:input gray or color image
% edgestop:(edge stop function)-已包括归一化(以pm1为标准统一)
%       ='lin':linear diffusion,    g=1
%       ='pm1':perona_malik,        g=1/(1+(x/K)^2)
%       ='pm2':perona-malik,        g=exp(-(x/K)^2)
%       ='tky':Tukey's biweight,    g= / (1-(x/K).^2).^2 ,|x|<=K
%                                      \  0              ,otherwise
% method=
%       ='av1':Alvarez-directinal diffusion,    ut=k*Du=uee (mean curve motion)
%       ='av2':Alvarez-..+edgestop,             ut=g(|Du|)*k*Du=div(g(|Du|)*Du/|Du|)
% show:是否显示扩散过程
%       ='ns':no show-default
%       ='is':show
% niter:number of iterations-default 100
% K:(edge threshold parameter)
% Io;noise free image(if presented:used to compute SNR)
% dt:time increment-default 0.2

if ~exist('show') show='ns'; end
if ~exist('niter') niter=100; end
if ~exist('K') K=15; end
if ~exist('Io') Io=I; end
if ~exist('dt') dt=0.2; end
if (nargin<3) error('not enough arguments (at least 3 should be given)'); end

[row,col,nchannel]=size(I);

%计算归一化g()的参数k,a(以PM1为标准统一)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if edgestop=='lin'
    k=1;
elseif edgestop=='pm1'
    k=K;%梯度阈值归一化
    a=1;%幅值归一化
elseif edgestop=='pm2'
    k=K*(2^0.5);
    a=1/(2*exp(-0.5));
elseif edgestop=='tky'
    k=K*5^0.5;
    a=25/32;
end

%扩散%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(show=='is') figure; end
for i=1:niter
    %中心差法计算微分
    % WN  N  EN
    % W   O  E 
    % WS  S  ES
    Ix=(I(:,[2:col col],:)-I(:,[1 1:col-1],:))/2;%Ix=(E-W)/2
    Iy=(I([2:row row],:,:)-I([1 1:row-1],:,:))/2;%Iy=(S-N)/2
    Ixx=I(:,[2:col col],:)+I(:,[1 1:col-1],:)-2*I;%Ixx=E+W-2*O
    Iyy=I([2:row row],:,:)+I([1 1:row-1],:,:)-2*I;%Iyy=S+N-2*O
    ESWN=I([2:row row],[2:col col],:)+I([1 1:row-1],[1 1:col-1],:);%ES+WN
    ENWS=I([1 1:row-1],[2:col col],:)+I([2:row row],[1 1:col-1],:);%EN+WS
    Ixy=(ESWN-ENWS)/4;%Ixy=Iyx=((ES+WN)-(EN+WS))/4
    
    %k*Du=(Ixx*Iy^2-2*Ix*Iy*Ixy+Iyy*Ix^2)/(Ix^2+Iy^2)
    Du=(Ix.^2+Iy.^2).^0.5;
    if method=='av1'
        kDu=(Ixx.*Iy.^2-2*Ix.*Iy.*Ixy+Iyy.*Ix.^2)./(Ix.^2+Iy.^2+eps);
    elseif method=='av2'
        if edgestop=='pm1'
            g=1./(1+(Du/k).^2).*a;
        elseif edgestop=='pm2'
            g=exp(-(Du/K).^2).*a;
        elseif edgestop=='tky'
            g=zeros(row,col,nchannel);
            index=find(abs(Du)<=k);
            g(index)=(1-(Du(index)/k).^2).^2*a;
        end
        kDu=g.*(Ixx.*Iy.^2-2*Ix.*Iy.*Ixy+Iyy.*Ix.^2)./(Ix.^2+Iy.^2+eps);
    end
    
    %梯度下降法迭代求解PDE(扩散)
    I=I+dt*kDu;
    
    if(show=='is')
        imshow(uint8(I));drawnow;
        if exist('Io')
            title(['SNR=',num2str(SNR(Io,I))]);%信号噪声比:
        end
    end
%     pause;

%     %保存图像
%     step=2;
%     if rem(i-1,step)==0
%         imwrite(uint8(I),[num2str(round((i-1)/step)),'.bmp'],'bmp');
%         imcontour(I);
%         saveas(gcf,['C',num2str(round((i-1)/step)),'.bmp']);
%     end

end
It=I;