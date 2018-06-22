%   Transfer an image to 4-level-RGB image with Bayer matrix

clear;
clc;

m1 = [[ 0 2 ];
      [ 3 1 ]];
  
u1 = ones(2, 2);

m2 = [[ 4*m1       4*m1+2*u1 ];
      [ 4*m1+3*u1  4*m1+u1   ]]
  
u2 = ones(4, 4);

m3 = [[ 4*m2       4*m2+2*u2 ];
      [ 4*m2+3*u2  4*m2+u2  ]]

  
Image = imread('./data/img-3.jpg');

r = Image(:,:,1);
g = Image(:,:,2);
b = Image(:,:,3);

[height, width] = size(r);

ChannelR = 0;
for i = 1:height
    for j = 1:width

        BayerMatrix1 = m3(bitand(i,7) + 1, bitand(j,7) + 1) / 4;
        BayerMatrix2 = 16 + BayerMatrix1;
        BayerMatrix3 = 16 + BayerMatrix2;
        BayerMatrix4 = 16 + BayerMatrix3;
        GrayImage(i,j) = r(i,j);
        
        if (GrayImage(i,j)/4 >= 0 && GrayImage(i,j)/4 < 16);
            if (GrayImage(i,j)/4 > BayerMatrix1) ChannelR(i,j) = 63;
            else ChannelR(i,j) = 0;
            end
        elseif (GrayImage(i,j)/4 > 15 && GrayImage(i,j)/4 < 32);
            if (GrayImage(i,j)/4 >= BayerMatrix2) ChannelR(i,j) = 127;
            else ChannelR(i,j) = 63;
            end
        elseif (GrayImage(i,j)/4 > 31 && GrayImage(i,j)/4 < 48);
            if (GrayImage(i,j)/4 >= BayerMatrix3) ChannelR(i,j) = 191;
            else ChannelR(i,j) = 127;
            end
        else
            if (GrayImage(i,j)/4 >= BayerMatrix4) ChannelR(i,j) = 255;
            else ChannelR(i,j) = 191;
            end
        end
    end
end
ChannelR = uint8(ChannelR);

ChannelG = 0;
for i = 1:height
    for j = 1:width

        BayerMatrix1 = m3(bitand(i,7) + 1, bitand(j,7) + 1) / 4;
        BayerMatrix2 = 16 + BayerMatrix1;
        BayerMatrix3 = 16 + BayerMatrix2;
        BayerMatrix4 = 16 + BayerMatrix3;
        GrayImage(i,j) = g(i,j);
        
        if (GrayImage(i,j)/4 >= 0 && GrayImage(i,j)/4 < 16)
            if (GrayImage(i,j)/4 > BayerMatrix1) ChannelG(i,j) = 63;
            else ChannelG(i,j) = 0;
            end
        elseif (GrayImage(i,j)/4 > 15 && GrayImage(i,j)/4 < 32)
            if (GrayImage(i,j)/4 >= BayerMatrix2) ChannelG(i,j) = 127;
            else ChannelG(i,j) = 63;
            end
        elseif (GrayImage(i,j)/4 > 31 && GrayImage(i,j)/4 < 48)
            if (GrayImage(i,j)/4 >= BayerMatrix3) ChannelG(i,j) = 191;
            else ChannelG(i,j) = 127;
            end
        else
            if (GrayImage(i,j)/4 >= BayerMatrix4) ChannelG(i,j) = 255;
            else ChannelG(i,j) = 191;
            end
        end
    end
end
ChannelG = uint8(ChannelG);

ChannelB = 0;
for i = 1:height
    for j = 1:width

        BayerMatrix1 = m3(bitand(i,7) + 1, bitand(j,7) + 1) / 4;
        BayerMatrix2 = 16 + BayerMatrix1;
        BayerMatrix3 = 16 + BayerMatrix2;
        BayerMatrix4 = 16 + BayerMatrix3;
        GrayImage(i,j) = b(i,j);
        
        if (GrayImage(i,j)/4 >= 0 && GrayImage(i,j)/4 < 16)
            if (GrayImage(i,j)/4 > BayerMatrix1) ChannelB(i,j) = 63;
            else ChannelB(i,j) = 0;
            end
        elseif (GrayImage(i,j)/4 > 15 && GrayImage(i,j)/4 < 32)
            if (GrayImage(i,j)/4 >= BayerMatrix2) ChannelB(i,j) = 127;
            else ChannelB(i,j) = 63;
            end
        elseif (GrayImage(i,j)/4 > 31 && GrayImage(i,j)/4 < 48)
            if (GrayImage(i,j)/4 >= BayerMatrix3) ChannelB(i,j) = 191;
            else ChannelB(i,j) = 127;
            end
        else
            if (GrayImage(i,j)/4 >= BayerMatrix4) ChannelB(i,j) = 255;
            else ChannelB(i,j) = 191;
            end
        end
    end
end
ChannelB = uint8(ChannelB);

ImageNewBayer(:,:,1) = ChannelR;
ImageNewBayer(:,:,2) = ChannelG;
ImageNewBayer(:,:,3) = ChannelB;

subplot(1,2,1);imshow(Image),title('Original');
subplot(1,2,2);imshow(ImageNewBayer),title('Bayer-New');

%imwrite(ImageNewBayer, './output/Image8BitM3_4Step_RGB.png');