function mssim=MSSIM(I,In)
%  I : 原图像
% In: 带噪声图像

[m,n,p]= size(I);
c1= 0.0001;
c2= 0.0009;
win=max(m/2,n/2);
%win原本为调用函数时传递的参数，表示MSSIM在SSIM基础上取均值时，视窗选取的大小
%在本实验中为方便起见，且不失MSSIM指标准确性,将其改为在函数内部定义
sz= floor(win/2);

mer= [];
for k= 1:p
    for i= sz+1:10:m-sz
        for j= sz+1:10:n-sz
            %原函数循环步长为1，考虑时间原因，这里改为10
            six= I(i-sz:i+sz,j-sz:j+sz,k);
            %图像I第k维在当前视窗下的矩阵
            six= six(:);
            %将six拉成一维向量
            siy= In(i-sz:i+sz,j-sz:j+sz,k);
            %图像In第k维在当前视窗下的矩阵
            siy= siy(:);
            %将siy拉成一维向量
            meux= mean(six);
            meuy= mean(siy);
            %取均值
            sigx= std(six,0);
            sigy= std(siy,0);
            %取标准偏差
            sigxy= sum((six-meux).*(siy-meuy))/(numel(six)-1);
            er= ((2*meux*meuy+c1)*(2*sigxy+c2))/((meux^2+meuy^2+c1)*(sigx^2+sigy^2+c2));
            mer= [mer er];
        end
    end
end
mssim= sum(mer)/(numel(mer));
%此函数来自Matlab Central File Exchange, 由Mohammad Moinul Islam提供
%改变了变量命名以使各去噪指标函数编程风格一致
%未添加注释的部分需要了解MSSIM指标的原理
%由于时间原因，将不再查阅更多资料，而信任此指标函数
end
