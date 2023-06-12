function It=order4_diffusion(I,edgestop,show,niter,K,Io,dt)
% You's fourth_order Diffusionȥ�뺯��
% by Qulei @2006/01/03
% I:input gray or color image
% edgestop:(edge stop function)-�Ѱ�����һ��(��pm1Ϊ��׼ͳһ)
%       ='lin':linear diffusion,    g=1                           -unstable
%       ='pm1':perona_malik,        g=1/(1+(x/K)^2)               -Ч���Ժ�
%       ='pm2':perona-malik,        g=exp(-(x/K)^2)               -Ч������
%       ='tky':Tukey's biweight,    g= / (1-(x/K).^2).^2 ,|x|<=K  -Ч������
%                                      \  0              ,otherwise
% show:�Ƿ���ʾ��ɢ����
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

%�����һ��g()�Ĳ���k,a(��PM1Ϊ��׼ͳһ)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if edgestop=='lin'
    k=1;
elseif edgestop=='pm1'
    k=K;%�ݶ���ֵ��һ��
    a=1;%��ֵ��һ��
elseif edgestop=='pm2'
    k=K*(2^0.5);
    a=1/(2*exp(-0.5));
elseif edgestop=='tky'
    k=K*5^0.5;
    a=25/32;
end

%��ɢ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(show=='is') figure; end
for i=1:niter
    %����ͼ���ֵ�Ķ��ײ��(laplace)
    d2I=I(:,[2:col col],:)+I(:,[1 1:col-1],:)+I([2:row row],:,:)+I([1 1:row-1],:,:)-4*I;
    
    %���ղ�ͬ����ɢ����(�ѹ�һ��)������ɢϵ��
    if edgestop=='lin'%����ͬ����ɢ(gaussian)
        g=d2I;
    elseif edgestop=='pm1'%����������ɢ(PM1)
        g=(1./(1+(d2I/k).^2).*a).*d2I;
    elseif edgestop=='pm2'%����������ɢ(PM2)
        g=(exp(-(d2I/K).^2).*a).*d2I;
    elseif edgestop=='tky'%����������ɢ(Tukey)
        g=zeros(row,col,nchannel);
        index=find(abs(d2I)<=k);
        g(index)=((1-(d2I(index)/k).^2).^2*a).*d2I;
    end
    
    %���㺯��g�Ķ��ײ��
    d2g=g(:,[2:col col],:)+g(:,[1 1:col-1],:)+g([2:row row],:,:)+g([1 1:row-1],:,:)-4*g;
    
    %�ݶ��½����������PDE(��ɢ)
    I=I-dt*d2g;
    
    if(show=='is')
        imshow(uint8(I));drawnow;
        if exist('Io')
            % title(['sigma=15;','K=',num2str(K),';',num2str(i),'/',num2str(niter),';SNR=',num2str(SNR(Io,I))]);
        end
    end
%     pause;
    
%     %����ͼ��
%     step=1;
%     if rem(i-1,step)==0
% %         imwrite(uint8(I),[num2str(round((i-1)/step)),'.bmp'],'bmp');
%         saveas(gcf,[num2str(round((i-1)/step)),'.jpg']);
%     end
    
end

%ʹ����ֵ�˲�ȥ������
It=I;
if nchannel==1
    It=medfilt2(I);
elseif nchannel==3
    It(:,:,1)=medfilt2(I(:,:,1));
    It(:,:,2)=medfilt2(I(:,:,2));
    It(:,:,3)=medfilt2(I(:,:,3));
end
figure;imshow(uint8(It));