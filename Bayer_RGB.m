%   Transfer an image to RGB-dots image with Bayer matrix

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

Ouput_ChannelR = zeros(height, width);
for i = 1:height
    for j = 1:width
        ImageColor = r(i,j) / 4;
        BayerMatrix = m3(bitand(i,7) + 1, bitand(j,7) + 1);
        if ( ImageColor <= BayerMatrix )
           Ouput_ChannelR(i,j) = 0;
        else
           Ouput_ChannelR(i,j) = 255;
        end
    end
end
Ouput_ChannelR = uint8(Ouput_ChannelR);

Ouput_ChannelG = zeros(height, width);
for i = 1:height
    for j = 1:width
        ImageColor = g(i,j) / 4;
        BayerMatrix = m3(bitand(i,7) + 1, bitand(j,7) + 1);
        if ( ImageColor <= BayerMatrix )
           Ouput_ChannelG(i,j) = 0;
        else
           Ouput_ChannelG(i,j) = 255;
        end
    end
end
Ouput_ChannelG = uint8(Ouput_ChannelG);

Ouput_ChannelB = zeros(height, width);
for i = 1:height
    for j = 1:width
        ImageColor = b(i,j) / 4;
        BayerMatrix = m3(bitand(i,7) + 1, bitand(j,7) + 1);
        if ( ImageColor <= BayerMatrix )
           Ouput_ChannelB(i,j) = 0;
        else
           Ouput_ChannelB(i,j) = 255;
        end
    end
end
Ouput_ChannelB = uint8(Ouput_ChannelB);

Image8BitM3(:,:,1) = Ouput_ChannelR;
Image8BitM3(:,:,2) = Ouput_ChannelG;
Image8BitM3(:,:,3) = Ouput_ChannelB;

subplot(1,2,1);imshow(Image),title('Original');
subplot(1,2,2);imshow(Image8BitM3),title('Bayer-M3-RGB');

%imwrite(Image8BitM3, './output/Image8BitM3_RGB.png');