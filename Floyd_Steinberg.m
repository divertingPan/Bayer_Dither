%   Transfer an image to black-white-dots image with Floyd Steinberg method

clear;
clc;
Image = imread('./data/img-3.jpg');
GrayImage = .2989*Image(:,:,1)...
           +.5870*Image(:,:,2)...
           +.1140*Image(:,:,3);

[height, width]=size(GrayImage);

Ouput = zeros(height, width);
tmp = zeros(height+2, width+2);
tmp(2:height+1, 2:width+1) = GrayImage;

for i = 2:height+1
    for j = 2:width+1
        if tmp(i,j) < 128
            Ouput(i-1,j-1) = 0;
            err = tmp(i,j);
        else
            Ouput(i-1,j-1) = 255;
            err = tmp(i,j) - 255;
        end
        tmp(i,j+1)=tmp(i,j+1)+7/16*err;
        tmp(i+1,j-1)=tmp(i+1,j-1)+3/16*err;
        tmp(i+1,j)=tmp(i+1,j)+5/16*err;
        tmp(i+1,j+1)=tmp(i+1,j+1)+1/16*err;
    end
    end

Ouput = uint8(Ouput);
subplot(1,2,1);imshow(GrayImage),title('Original');
subplot(1,2,2);imshow(Ouput),title('Floyd-Steinberg');
