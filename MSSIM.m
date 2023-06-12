function mssim=MSSIM(I,In)
%  I : ԭͼ��
% In: ������ͼ��

[m,n,p]= size(I);
c1= 0.0001;
c2= 0.0009;
win=max(m/2,n/2);
%winԭ��Ϊ���ú���ʱ���ݵĲ�������ʾMSSIM��SSIM������ȡ��ֵʱ���Ӵ�ѡȡ�Ĵ�С
%�ڱ�ʵ����Ϊ����������Ҳ�ʧMSSIMָ��׼ȷ��,�����Ϊ�ں����ڲ�����
sz= floor(win/2);

mer= [];
for k= 1:p
    for i= sz+1:10:m-sz
        for j= sz+1:10:n-sz
            %ԭ����ѭ������Ϊ1������ʱ��ԭ�������Ϊ10
            six= I(i-sz:i+sz,j-sz:j+sz,k);
            %ͼ��I��kά�ڵ�ǰ�Ӵ��µľ���
            six= six(:);
            %��six����һά����
            siy= In(i-sz:i+sz,j-sz:j+sz,k);
            %ͼ��In��kά�ڵ�ǰ�Ӵ��µľ���
            siy= siy(:);
            %��siy����һά����
            meux= mean(six);
            meuy= mean(siy);
            %ȡ��ֵ
            sigx= std(six,0);
            sigy= std(siy,0);
            %ȡ��׼ƫ��
            sigxy= sum((six-meux).*(siy-meuy))/(numel(six)-1);
            er= ((2*meux*meuy+c1)*(2*sigxy+c2))/((meux^2+meuy^2+c1)*(sigx^2+sigy^2+c2));
            mer= [mer er];
        end
    end
end
mssim= sum(mer)/(numel(mer));
%�˺�������Matlab Central File Exchange, ��Mohammad Moinul Islam�ṩ
%�ı��˱���������ʹ��ȥ��ָ�꺯����̷��һ��
%δ���ע�͵Ĳ�����Ҫ�˽�MSSIMָ���ԭ��
%����ʱ��ԭ�򣬽����ٲ��ĸ������ϣ������δ�ָ�꺯��
end
