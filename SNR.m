function snr=SNR(I,In)
% 计算图像信噪比函数，其中
% I : 原图像
% In: 带噪声图像
[~,~,nchannel] = size(I);
if nchannel==1   %gray image
    ps=sum(sum((I-mean(mean(I))).^2));
    pn=sum(sum((I-In).^2));
else             %color image
    ps=0;pn=0;
    for i=1:3
        ps=ps+sum(sum((I(:,:,i)-mean(mean(I(:,:,i)))).^2));
        pn=pn+sum(sum((I(:,:,i)-In(:,:,i)).^2));
    end
    ps=ps/3;pn=pn/3;
end
snr=10*log10(ps/pn);
end