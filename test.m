I = imread('lena.jpg');
I=rgb2gray(I);
[M,N1]=size(I);
set(gcf,'position',[0 0 N1 M]);
imshow(I,[],'border','tight', 'initialmagnification','fit');  %�ް�ɫ�߿���ʾ
print -dpng lena1.png