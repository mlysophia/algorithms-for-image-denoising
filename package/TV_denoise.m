function It=TV_denoise(I,show,niter,iflamda,sigma,Io,dt,a)
% Total Variation去噪函数
% by Qulei @2005/12/19
% I:input gray or color image
% show:是否显示扩散过程
%       ='ns':no show-default
%       ='is':show
% niter:number of iterations-default 100,(iflamda=1,则自动选择结束条件)
% iflamda:标志是否使用拉格朗日乘子(fidelity term lambda)-default 0
%       =0:不使用fidelity term,ut=div(Du/|Du|)=k  (need regularization!!)  ->相当于扩散      
%       =1:自动计算lamda值,   ut=div(Du/|Du|)-lamda*(u-uo)                 ->相当于最小化能量
%                              ..,lamda=mean(mean(div(Du/|Du|)*(I-Io)))/sigma^2
% sigma:噪声方差(lamda=0时,该项无作用)-default 1
% Io;noise free image(if presented:used to compute SNR)
% dt:time increment-default 0.2
% a:gradient regularization-default 1(if not present-unstable)

if ~exist('show') show='ns'; end
if ~exist('niter') niter=100; end
if ~exist('iflamda') iflamda=0; end
if ~exist('sigma') sigma=1; end
if ~exist('Io') Io=I; end
if ~exist('dt') dt=0.2; end
if ~exist('a') a=1; end
if (nargin<1) error('not enough arguments (at least 1 should be given)'); end

[row,col,nchannel]=size(I);
I_bak=I;
sigma2=sigma^2;
if iflamda==1
    I_last=0;
end

%扩散%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(show=='is') figure; end
i=0;iter=0;
while(i<niter)
    iter=iter+1;
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
    
    %k=div(Du/|Du|)=(Ixx*Iy^2-2*Ix*Iy*Ixy+Iyy*Ix^2)/(Ix^2+Iy^2)^(3/2)
%     k=(Ixx.*Iy.^2-2*Ix.*Iy.*Ixy+Iyy.*Ix.^2)./((Ix.^2+Iy.^2).^1.5+eps);%not regularized-unstable
    k=(Ixx.*(a+Iy.^2)-2*Ix.*Iy.*Ixy+Iyy.*(a+Ix.^2))./((a+Ix.^2+Iy.^2).^1.5);%regularized
    
    %梯度下降法迭代求解PDE(扩散)or最小化能量方程
    if iflamda==0
        i=i+1;
        I=I+dt*k;
        disp(['iter=',num2str(iter)]);
    else
        lamda=mean(mean(k.*(I-I_bak)))./sigma2;
        I=I+dt*(k-lamda*(I-I_bak));
        change=mean(mean(abs(I-I_last)));
        disp(['iter',num2str(iter),';change=',num2str(change)]);
        if change<0.01
            break;
        else
            I_last=I;%备份上一次结果
        end
    end
    
    if(show=='is')
        imshow(uint8(I));colormap('gray');
        if exist('Io')
            title([num2str(iter),'/',num2str(niter),';SNR=',num2str(SNR(Io,I))]);
%             title([num2str(iter),'/194',';SNR=',num2str(SNR(Io,I)),';error=',num2str(change)]);
        end
    end
%     pause;

%     %保存图像
%     step=2;
%     if rem(iter-1,step)==0
% %         imwrite(uint8(I),[num2str(round((iter-1)/step)),'.bmp'],'bmp');
%         saveas(gcf,[num2str(round((iter-1)/step)),'.jpg']);
%         %保存水平集图像
%         imcontour(I);
%         saveas(gcf,['C',num2str(round((iter-1)/step)),'.bmp']);
%     end

end
It=I;