%   Transfer an image to 4-level-gray image with Bayer matrix

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

GrayImage = .2989*Image(:,:,1)...
           +.5870*Image(:,:,2)...
           +.1140*Image(:,:,3);
%r = Image(:,:,1);
%g = Image(:,:,2);
%b = Image(:,:,3);

[height, width] = size(GrayImage);

output = 0;
for i = 1:height
    for j = 1:width

        BayerMatrix1 = m3(bitand(i,7) + 1, bitand(j,7) + 1) / 4;
        BayerMatrix2 = 16 + BayerMatrix1;
        BayerMatrix3 = 16 + BayerMatrix2;
        BayerMatrix4 = 16 + BayerMatrix3;

        if (GrayImage(i,j)/4 >= 0 && GrayImage(i,j)/4 < 16)
            if (GrayImage(i,j)/4 > BayerMatrix1) output(i,j) = 63;
            else output(i,j) = 0;
            end
        elseif (GrayImage(i,j)/4 > 15 && GrayImage(i,j)/4 < 32)
            if (GrayImage(i,j)/4 >= BayerMatrix2) output(i,j) = 127;
            else output(i,j) = 63;
            end
        elseif (GrayImage(i,j)/4 > 31 && GrayImage(i,j)/4 < 48)
            if (GrayImage(i,j)/4 >= BayerMatrix3) output(i,j) = 191;
            else output(i,j) = 127;
            end
        else
            if (GrayImage(i,j)/4 >= BayerMatrix4) output(i,j) = 255;
            else output(i,j) = 191;
            end
        end
    end
end

ImageNewBayer = uint8(output);

subplot(1,2,1);imshow(GrayImage),title('Original');
subplot(1,2,2);imshow(ImageNewBayer),title('Bayer-New');

%imwrite(ImageNewBayer, './output/Image8BitM3_4_Step_Gray.png');
