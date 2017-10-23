
clear all;
close all;
clc;
%59->00
%66 test
a=imread('fotos\dsc03266.jpg');
figure(1);
imshow(a);

[b,c]=regionMascara1(a);

% figure(2)
% imshow(b);
% impixelinfo();
% 
% figure(3);
% imshow(c);
% impixelinfo();

se1 = strel('disk',130);
d=imfill(b,'holes');

d=imerode(d,se1);
d=imdilate(d,se1);

d=uint8(d);
figure(5)
imshow(d*255);
impixelinfo();

e=ones(size(a,1),size(a,2),size(a,3),'uint8');
for c=1:size(a,3)
    for i=1:size(a,1)
        for j=1:size(a,2)
            e(i,j,c)=e(i,j,c)*d(i,j);
        end
    end
end
f=e.*a;
figure(6)
imshow(f);
impixelinfo();
