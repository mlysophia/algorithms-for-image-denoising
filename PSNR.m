function psnr = PSNR(I, In) 
% ����ͼ���ֵ����Ⱥ���������
% I : ԭͼ��
% In: ������ͼ��
[n,m,nchannel] = size(I);
if nchannel==1   %gray image
    mse=sum(sum((I-In).^2))/(n*m);
else             %color image
    mse=0;
    for i=1:3
        mse=mse+sum(sum((I(:,:,i)-In(:,:,i)).^2))/(n*m);
        mse=mse/3;
    end
end
psnr=10*log10(255^2/mse);
end