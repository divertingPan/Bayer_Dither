/*  Created in 2018/06/09
    Your image will be transferfed into the 4-level-gray image
    1024x1024 is the adaptable image resolution
*/

int resolution = 128;
int pixelsize = 8;

String OpenFileName = "img-1.jpg";

int[][] m3 = { { 0,   48,   12,   60,    3,   51,   15,   63},
               {32,   16,   44,   28,   35,   19,   47,   31},
               { 8,   56,    4,   52,   11,   59,    7,   55},
               {40,   24,   36,   20,   43,   27,   39,   23},
               { 2,   50,   14,   62,    1,   49,   13,   61},
               {34,   18,   46,   30,   33,   17,   45,   29},
               {10,   58,    6,   54,    9,   57,    5,   53},
               {42,   26,   38,   22,   41,   25,   37,   21}};


void setup() {
  size(1024, 1024);
  background(0);
  noStroke();
  //smooth();
}


void draw() {
  Fliter();
  save("./output/" + OpenFileName + "_saved.png");
  noLoop();
}


void Fliter() {
  PImage inputImage = loadImage(OpenFileName);

  for(int x = 0; x < resolution; x++) {
    for(int y = 0; y < resolution; y++) {
      color c1 = inputImage.get(x * pixelsize, y * pixelsize);
      fill(Bayer(x, y, RGBtoGray(c1)));
      rect(x * pixelsize, y * pixelsize, x + pixelsize, y + pixelsize);
    }
  }
}


color RGBtoGray(color c) {
  int rgbR;
  int rgbG;
  int rgbB;
  rgbR = (c & 0xff0000) >> 16;
  rgbG = (c & 0xff00) >> 8;
  rgbB = (c & 0xff);
  color Gray = (rgbR * 30 + rgbG * 60 + rgbB * 10) / 100;
  return Gray;
}


color Bayer(int x, int y, color c) {
  color color_out;
        int BayerMatrix1 = int(m3[x % 8][y % 8] / 4);
        int BayerMatrix2 = 16 + BayerMatrix1;
        int BayerMatrix3 = 16 + BayerMatrix2;
        int BayerMatrix4 = 16 + BayerMatrix3;

        if (c/4 >= 0 && c/4 < 16) {
            if (c/4 > BayerMatrix1) color_out = 63;
            else color_out = 0;
        }
        else if (c/4 > 15 && c/4 < 32) {
            if (c/4 >= BayerMatrix2) color_out = 127;
            else color_out = 63;
        }
        else if (c/4 > 31 && c/4 < 48) {
            if (c/4 >= BayerMatrix3) color_out = 191;
            else color_out = 127;
        }
        else {
            if (c/4 >= BayerMatrix4) color_out = 255;
            else color_out = 191;
        }
    
  return color_out;
}
