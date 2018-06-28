%   Transfer an image to 4-level-RGB image with Bayer matrix
%   Bug is fixed

clear;
clc;

m1 = [[ 0 2 ];
      [ 3 1 ]];
  
u1 = ones(2, 2);

m2 = [[ 4*m1       4*m1+2*u1 ];
      [ 4*m1+3*u1  4*m1+u1   ]];
  
u2 = ones(4, 4);

m3 = [[ 4*m2       4*m2+2*u2 ];
      [ 4*m2+3*u2  4*m2+u2   ]];

  
Image = imread('./data/img-1.jpg');

r = Image(:,:,1);
g = Image(:,:,2);
b = Image(:,:,3);

[height, width] = size(r);

ChannelR = zeros(height, width);

for i = 1:height
    for j = 1:width

        BayerMatrix1 = m3(bitand(i,7) + 1, bitand(j,7) + 1) / 3;
        BayerMatrix2 = 21.3333 + BayerMatrix1;
        BayerMatrix3 = 21.3333 + BayerMatrix2;
        ImageColor = r(i,j) / 4;
        
        if (ImageColor >= 0 && ImageColor < 21)
            if (ImageColor > BayerMatrix1)
                ChannelR(i,j) = 84;
            else
                ChannelR(i,j) = 0;
            end
        elseif (ImageColor >= 21 && ImageColor < 43)
            if (ImageColor >= BayerMatrix2)
                ChannelR(i,j) = 171;
            else
                ChannelR(i,j) = 84;
            end
        else
            if (ImageColor >= BayerMatrix3)
                ChannelR(i,j) = 255;
            else
                ChannelR(i,j) = 171;
            end
        end
    end
end
ChannelR = uint8(ChannelR);

ChannelG = zeros(height, width);
for i = 1:height
    for j = 1:width

        BayerMatrix1 = m3(bitand(i,7) + 1, bitand(j,7) + 1) / 3;
        BayerMatrix2 = 21.3333 + BayerMatrix1;
        BayerMatrix3 = 21.3333 + BayerMatrix2;
        ImageColor = g(i,j) / 4;
        
        if (ImageColor >= 0 && ImageColor < 21)
            if (ImageColor > BayerMatrix1)
                ChannelG(i,j) = 84;
            else
                ChannelG(i,j) = 0;
            end
        elseif (ImageColor >= 21 && ImageColor < 43)
            if (ImageColor >= BayerMatrix2)
                ChannelG(i,j) = 171;
            else
                ChannelG(i,j) = 84;
            end
        else
            if (ImageColor >= BayerMatrix3)
                ChannelG(i,j) = 255;
            else
                ChannelG(i,j) = 171;
            end
        end
    end
end
ChannelG = uint8(ChannelG);

ChannelB = zeros(height, width);
for i = 1:height
    for j = 1:width

        BayerMatrix1 = m3(bitand(i,7) + 1, bitand(j,7) + 1) / 3;
        BayerMatrix2 = 21.3333 + BayerMatrix1;
        BayerMatrix3 = 21.3333 + BayerMatrix2;
        ImageColor = b(i,j) / 4;
        
        if (ImageColor >= 0 && ImageColor < 21)
            if (ImageColor > BayerMatrix1)
                ChannelB(i,j) = 84;
            else
                ChannelB(i,j) = 0;
            end
        elseif (ImageColor >= 21 && ImageColor < 43)
            if (ImageColor >= BayerMatrix2)
                ChannelB(i,j) = 171;
            else
                ChannelB(i,j) = 84;
            end
        else
            if (ImageColor >= BayerMatrix3)
                ChannelB(i,j) = 255;
            else
                ChannelB(i,j) = 171;
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