function K=autoK(I)
% 自动估计梯度阈值K函数
% 用robust_statistic自动估计梯度阈值(参Sapiro P231)
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
