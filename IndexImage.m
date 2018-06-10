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

[height,width] = size(GrayImage);

OuputM3 = 0;
for i = 1:height
    for j = 1:width
        ImageColor = GrayImage(i,j) / 4;
        BayerMatrix = m3(bitand(i,7) + 1, bitand(j,7) + 1);
        if ( (ImageColor < BayerMatrix) && (BayerMatrix < 64) )
            if ( (ImageColor < BayerMatrix) && (BayerMatrix < 60) )
                if ( (ImageColor < BayerMatrix) && (BayerMatrix < 10) )
                    OuputM3(i,j) = 64;
                else
                    OuputM3(i,j) = 0;
                end
            else 
                OuputM3(i,j) = 192;
            end
        else
            OuputM3(i,j) = 255;
        end
    end
end
Image8BitM3 = uint8(OuputM3);

OuputM2 = 0;
for i = 1:height
    for j = 1:width
        ImageColor = GrayImage(i,j) / 16;
        BayerMatrix = m2(bitand(i,3) + 1, bitand(j,3) + 1);
        if ( ImageColor < BayerMatrix )
            OuputM2(i,j) = 0;
        else
            OuputM2(i,j) = 255;
        end
    end
end
Image8BitM2 = uint8(OuputM2);

subplot(1,3,1);imshow(GrayImage),title('Original');
subplot(1,3,2);imshow(Image8BitM2),title('HardcoreM2-2bit');
subplot(1,3,3);imshow(Image8BitM3),title('HardcoreM3-4bit');