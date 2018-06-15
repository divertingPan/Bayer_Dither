%   Transfer an image to black-white-dots image with Bayer matrix

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


  
for i = 1:256
    Xi = 16 * fix(i/15);
    for j = 1:256
        Yj = fix(j/15);
        Sample(i, j) = Xi + Yj;
    end
end
Sample = uint8(Sample);


OuputM3 = 0;
for i = 1:256
    for j = 1:256
        ImageColor = Sample(i,j) / 4;
        BayerMatrix = m3(bitand(i,7) + 1, bitand(j,7) + 1);
        if ( ImageColor <= BayerMatrix )
           OuputM3(i,j) = 0;
        else
           OuputM3(i,j) = 255;
        end
    end
end
Image8BitM3 = uint8(OuputM3);


OuputM2 = 0;
for i = 1:256
    for j = 1:256
        ImageColor = Sample(i,j) / 16;
        BayerMatrix = m2(bitand(i,3) + 1, bitand(j,3) + 1);
        if ( ImageColor <= BayerMatrix )
            OuputM2(i,j) = 0;
        else
            OuputM2(i,j) = 255;
        end
    end
end
Image8BitM2 = uint8(OuputM2);


subplot(1,3,1);imshow(Sample),title('Original');
subplot(1,3,2);imshow(Image8BitM2),title('Bayer-M2');
subplot(1,3,3);imshow(Image8BitM3),title('Bayer-M3');

imwrite(Sample, './sample/stepgray.png');
imwrite(Image8BitM2, './sample/Image8BitM2.png');
imwrite(Image8BitM3, './sample/Image8BitM3.png');
