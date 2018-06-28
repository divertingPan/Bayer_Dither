%   Transfer an image to 4-level-overlay image with Bayer matrix

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

Colormap(:,:,1) = [[0   0   0  ];
                   [255 0   0  ];
                   [255 255 0  ];
                   [255 255 255]];

Colormap(:,:,2) = [[0   0   0  ];
                   [0   255 0  ];
                   [0   255 255];
                   [255 255 255]];

Colormap(:,:,3) = [[0   0   0  ];
                   [0   0   255];
                   [0   255 255];
                   [255 255 255]];
map_setting = 1;

Image = imread('./data/img-9.jpg');

GrayImage = .2989*Image(:,:,1)...
           +.5870*Image(:,:,2)...
           +.1140*Image(:,:,3);


[height, width] = size(GrayImage);

output = zeros(height, width);
Overlay_Image = zeros(height, width, 3);
for i = 1:height
    for j = 1:width

        BayerMatrix1 = m3(bitand(i,7) + 1, bitand(j,7) + 1) / 3;
        BayerMatrix2 = 21.3333 + BayerMatrix1;
        BayerMatrix3 = 21.3333 + BayerMatrix2;
        ImageColor = GrayImage(i,j) / 4;

        if (ImageColor >= 0 && ImageColor < 21)
            if (ImageColor > BayerMatrix1)
                Overlay_Image(i,j,1) = Colormap(2,1,map_setting);
                Overlay_Image(i,j,2) = Colormap(2,2,map_setting);
                Overlay_Image(i,j,3) = Colormap(2,3,map_setting);
            else
                Overlay_Image(i,j,1) = Colormap(1,1,map_setting);
                Overlay_Image(i,j,2) = Colormap(1,2,map_setting);
                Overlay_Image(i,j,3) = Colormap(1,3,map_setting);
            end
        elseif (ImageColor >= 21 && ImageColor < 43)
            if (ImageColor >= BayerMatrix2)
                Overlay_Image(i,j,1) = Colormap(3,1,map_setting);
                Overlay_Image(i,j,2) = Colormap(3,2,map_setting);
                Overlay_Image(i,j,3) = Colormap(3,3,map_setting);
            else
                Overlay_Image(i,j,1) = Colormap(2,1,map_setting);
                Overlay_Image(i,j,2) = Colormap(2,2,map_setting);
                Overlay_Image(i,j,3) = Colormap(2,3,map_setting);
            end
        else
            if (ImageColor >= BayerMatrix3)
                Overlay_Image(i,j,1) = Colormap(4,1,map_setting);
                Overlay_Image(i,j,2) = Colormap(4,2,map_setting);
                Overlay_Image(i,j,3) = Colormap(4,3,map_setting);
            else
                Overlay_Image(i,j,1) = Colormap(3,1,map_setting);
                Overlay_Image(i,j,2) = Colormap(3,2,map_setting);
                Overlay_Image(i,j,3) = Colormap(3,3,map_setting);
            end
        end
    end
end

ImageNewBayer = uint8(output);
Overlay_Image = uint8(Overlay_Image);

subplot(1,2,1);imshow(GrayImage),title('Original');
subplot(1,2,2);imshow(Overlay_Image),title('Bayer-overlay');

%imwrite(ImageNewBayer, './output/Image8BitM3_4_Step_overlay.png');
