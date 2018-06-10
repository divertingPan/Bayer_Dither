int resolution = 128;
int pixelsize = 8;
int color_div = 4;
String OpenFileName = "img-2.jpg";

int drawsize = resolution * pixelsize;
int bit_depth = 256/color_div;


void setup() {
  size(1024, 1024);
  background(0);
  noStroke();
  //smooth();
}


void draw() {
  mosaic();
  long time = System.currentTimeMillis();
  String filename = String.valueOf(time);
  save(filename + "_saved.png");
  noLoop();
}


void mosaic() {
  PImage inputImage = loadImage(OpenFileName);
  //image(inputImage, drawsize, 0);
  for(int x = 0; x < drawsize; x = pixelsize + x) {
    for(int y = 0; y < drawsize; y = pixelsize + y) {
      color c1 = inputImage.get(x + pixelsize / 2, y + pixelsize / 2);
      color c2 = RGBto8Bit(c1);
      fill(c2);
      rect(x, y, x + pixelsize, y + pixelsize);
    }
  }
}


color RGBto8Bit(color c) {
  int rgbR;
  int rgbG;
  int rgbB;
  rgbR = (c & 0xff0000) >> 16;
  rgbG = (c & 0xff00) >> 8;
  rgbB = (c & 0xff);
  color gray = (rgbR * 30 + rgbG * 60 + rgbB * 10) / 100;
  color Gray8Bit = (bit_depth) * (gray / bit_depth);
  if(gray / bit_depth == 256 / bit_depth - 1) {
    Gray8Bit = 255;
  }
  return Gray8Bit;
}
