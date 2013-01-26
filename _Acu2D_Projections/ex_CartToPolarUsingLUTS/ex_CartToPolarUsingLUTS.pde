// Example 3: output-based cartesian-to-polar using LUTs

PImage input, outputBasedLUT;
int[][] LUT;

void setup() {
  input = loadImage("input.png");
  size(input.width, input.height, P2D);
  calculateLUT(0.5, input.width, input.height);
}

void draw() {
  // lookup tables are so fast that - when using them -
  // the pixel manipulation can be run in realtime without
  // any noticable cost to the sketch's frameRate
  outputBasedLUT = outputBasedLUT(input);
  println(int(frameRate));
  image(outputBasedLUT, 0, 0);
}

void calculateLUT(float factor, int w, int h) {
  LUT = new int[w][h];
  int pL = w * h - 1;
  for (int y=0; y<h; y++) {
    for (int x=0; x<w; x++) {
      int my = y-h/2;
      int mx = x-w/2;
      float angle = atan2(my, mx) - HALF_PI ;
      float radius = sqrt(mx*mx+my*my) / factor;
      float ix = map(angle,-PI,PI,w,0);
      float iy = map(radius,0,h,0,h);
      int inputIndex = int(ix) + int(iy) * w;
      if (inputIndex <= pL) {
        LUT[x][y] = inputIndex;
      } else {
        LUT[x][y] = -1;
      }
    }
  }
}

PImage outputBasedLUT(PImage input) {
  PImage output = createImage(input.width, input.height, RGB);
  color black = color(0);
  for (int y=0; y<output.height; y++) {
    for (int x=0; x<output.width; x++) {
      int outputIndex = x + y * output.width;
      int inputIndex = LUT[x][y];
      if (inputIndex == -1) {
        output.pixels[outputIndex] = black;
      } else {
        output.pixels[outputIndex] = input.pixels[inputIndex];
      }
    }
  }
  return output;
}

