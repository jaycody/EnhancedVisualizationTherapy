import peasy.*;
import org.openkinect.*;
import org.openkinect.processing.*;

/*
 Simple Kinect point-cloud demo
 
 Henry Palonen <h@yty.net>

 Using Daniel Shiffman's great processing-library for Kinect:
 http://www.google.com/url?sa=D&q=http://www.shiffman.net/2010/11/14/kinect-and-processing/&usg=AFQjCNH8kZWDMhFueeNBn5x97XoDR3v9oQ
 
 Based on Kyle McDonalds Structure Light scanner:
 http://www.openprocessing.org/visuals/?visualID=1014

*/
float zscale = 3;
float zskew = 150;

int inputWidth = 640;
int inputHeight = 480;

PeasyCam cam;

float[][] gray = new float[inputHeight][inputWidth];

PImage depth;

static final int gray(color value) { 
  return max((value >> 16) & 0xff, (value >> 8 ) & 0xff, value & 0xff);  
} 

void setup() {
  size(inputWidth, inputHeight, P3D);
  cam = new PeasyCam(this, width);
  NativeKinect.init();
  depth = createImage(640,480,RGB);
  stroke(255);
}

void draw () {
  background(0);

  depth.pixels = NativeKinect.getDepthMap();
  depth.updatePixels();

  NativeKinect.update();
  
  for (int y = 0; y < inputHeight; y++) {
    for (int x = 0; x < inputWidth; x++) {
       // FIXME: this loses Z-resolution about tenfold ...
       //       -> should grab the real distance instead...
       color argb = depth.pixels[y*width+x];
       gray[y][x] = gray(argb);
    }
  }
  
  // Kyle McDonald's original source used here
  translate(-inputWidth / 2, -inputHeight / 2);  
  int step = 2;
  for (int y = step; y < inputHeight; y += step) {
    float planephase = 0.5 - (y - (inputHeight / 2)) / zskew;
    for (int x = step; x < inputWidth; x += step)
        point(x, y, (gray[y][x] - planephase) * zscale);
  }
  
}
