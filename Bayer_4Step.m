%   Transfer an image to 4-level-gray image with Bayer matrix
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

GrayImage = .2989*Image(:,:,1)...
           +.5870*Image(:,:,2)...
           +.1140*Image(:,:,3);
       
%r = Image(:,:,1);
%g = Image(:,:,2);
%b = Image(:,:,3);

[height, width] = size(GrayImage);

output = zeros(height, width);
for i = 1:height
    for j = 1:width

        BayerMatrix1 = m3(bitand(i,7) + 1, bitand(j,7) + 1) / 3;
        BayerMatrix2 = 21.3333 + BayerMatrix1;
        BayerMatrix3 = 21.3333 + BayerMatrix2;
        ImageColor = GrayImage(i,j) / 4;

        if (ImageColor >= 0 && ImageColor < 21)
            if (ImageColor > BayerMatrix1)
                output(i,j) = 84;
            else
                output(i,j) = 0;
            end
        elseif (ImageColor >= 21 && ImageColor < 43)
            if (ImageColor >= BayerMatrix2)
                output(i,j) = 171;
            else
                output(i,j) = 84;
            end
        else
            if (ImageColor >= BayerMatrix3)
                output(i,j) = 255;
            else
                output(i,j) = 171;
            end
        end
    end
end

ImageNewBayer = uint8(output);

subplot(1,2,1);imshow(GrayImage),title('Original');
subplot(1,2,2);imshow(ImageNewBayer),title('Bayer-New');

%imwrite(ImageNewBayer, './output/Image8BitM3_4_Step_Gray.png');
