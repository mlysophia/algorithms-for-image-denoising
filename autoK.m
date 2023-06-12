function K = autoK(I)
%自动生成参数K的图像
%I为噪声图像
[row,col,nchannel] = size(I);  K = 0;
if nchannel == 1    %gray image
    [gradx,grady] = imgradient(I);
    %gradx是图像水平方向梯度，grady是图像竖直方向梯度
    gradI = (gradx.^2 + grady.^2).^0.5;
    %gradI为每一像素点处梯度向量的2-范数
    K = 1.4826*mean(mean(abs(gradI-mean(mean(gradI))))); 
    %mean(mean(gradI))为I中所有像素点的梯度向量2-范数的均值
    %mean(mean(abs(...)))代表了图像I中各像素点组成的集合的离散程度
    %K值太小时去噪效果不好，K值太大时边缘保持变差
    %所以图像I中各像素点组成的集合的离散程度可以表示K值大小
else                %color image
    for i=1:3
        [gradx,grady] = imgradient(I(:,:,i));
        gradI = (gradx.^2 + grady.^2).^0.5;
        K = K + 1.4826*mean(mean(abs(gradI - mean(mean(gradI)))));
    end
    K = K/3;
    %在三通道彩色图像中，以各像素点通道在每一组成的集合的离散程度的均值表示K值大小
end
end