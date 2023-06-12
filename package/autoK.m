function K=autoK(I)
% �Զ������ݶ���ֵK����
% ��robust_statistic�Զ������ݶ���ֵ(��Sapiro P231)
% by Qulei @2005/12/12
% I:input gray or color image

[row,col,nchannel]=size(I);

K=0;
if nchannel==1%gray image
    [gradx,grady]=gradient(I);
    gradI=(gradx.^2+grady.^2).^0.5;
    K=1.4826*mean(mean(abs(gradI-mean(mean(gradI)))));
else%color image
    for i=1:3
        [gradx,grady]=gradient(I(:,:,i));
        gradI=(gradx.^2+grady.^2).^0.5;
        K=K+1.4826*mean(mean(abs(gradI-mean(mean(gradI)))));
    end
    K=K/3;
end
