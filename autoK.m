function K = autoK(I)
%�Զ����ɲ���K��ͼ��
%IΪ����ͼ��
[row,col,nchannel] = size(I);  K = 0;
if nchannel == 1    %gray image
    [gradx,grady] = imgradient(I);
    %gradx��ͼ��ˮƽ�����ݶȣ�grady��ͼ����ֱ�����ݶ�
    gradI = (gradx.^2 + grady.^2).^0.5;
    %gradIΪÿһ���ص㴦�ݶ�������2-����
    K = 1.4826*mean(mean(abs(gradI-mean(mean(gradI))))); 
    %mean(mean(gradI))ΪI���������ص���ݶ�����2-�����ľ�ֵ
    %mean(mean(abs(...)))������ͼ��I�и����ص���ɵļ��ϵ���ɢ�̶�
    %Kֵ̫Сʱȥ��Ч�����ã�Kֵ̫��ʱ��Ե���ֱ��
    %����ͼ��I�и����ص���ɵļ��ϵ���ɢ�̶ȿ��Ա�ʾKֵ��С
else                %color image
    for i=1:3
        [gradx,grady] = imgradient(I(:,:,i));
        gradI = (gradx.^2 + grady.^2).^0.5;
        K = K + 1.4826*mean(mean(abs(gradI - mean(mean(gradI)))));
    end
    K = K/3;
    %����ͨ����ɫͼ���У��Ը����ص�ͨ����ÿһ��ɵļ��ϵ���ɢ�̶ȵľ�ֵ��ʾKֵ��С
end
end