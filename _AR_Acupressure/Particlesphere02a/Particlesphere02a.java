import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class Particlesphere02a extends PApplet {

ImgProc imgProc = new ImgProc();   // Class ImgProc (from [Noise Particle 06] by Marcin Ignac )
int[] currFrame;                   // Frame data current 
int[] prevFrame;                   // Frame data previous
int[] tempFrame;                   // Frame data temp
int particlesDensity = 14;         // Particles density
int particleMargin = 64;           // Particles margin

Particle[] particles;
 
int startingRadius = 90, radius = 150;
int centerX = width/2, centerY = height/2;

int moveMode = 1;
float speed = 0.8f;

public void setup() {
  
  size(400, 400, P3D);
  
  frameRate(24);
  
  currFrame = new int[width*height];      // create frame data of current
  prevFrame = new int[width*height];      // create frame data of previous
  tempFrame = new int[width*height];      // create frame data of temp
  
  // set begining color of frames
  for(int i=0; i<width*height; i++) {     
    currFrame[i] = color(0, 0, 0); 
    prevFrame[i] = color(0, 0, 0); 
    tempFrame[i] = color(0, 0, 0); 
  }
  
  // create array of particles
  particles = new Particle[(width + particleMargin * 2) / particlesDensity * 
                           (height + particleMargin * 2) / particlesDensity ]; 
  
  // Create particles
  // -------------------------------------
  int i = 0;
  for(int y=-particleMargin; y<height+particleMargin; y+=particlesDensity) { 
    for(int x=-particleMargin; x<width+particleMargin; x+=particlesDensity) { 
       if (i == particles.length) { 
         break; 
       } 
       
       float theta = random(0,TWO_PI); 
       float u = random(-1,1); 
       int c = color(50+50*sin(PI*x/width), 127, 255*sin(PI*y/width));
       particles[i++] = new Particle(c, (int)random(64), (int)random(64), (int)random(64), theta, u); 
    } 
  }
}

public void draw() {
  
  background(0);
   
  // Blur effects.
  imgProc.blur(prevFrame, tempFrame, width, height);    
  
  // Scale Brightness effects.
  //if(pixMode == 1 && moveMode == 1 && fileName != "start.txt") imgProc.scaleBrightness(tempFrame, tempFrame, width, height, 0.2);
  
  arraycopy(tempFrame, currFrame);
  radius = startingRadius + centerX-mouseX; 
  
  for(int i=0; i<particles.length; i++) {
    particles[i].update();
    particles[i].render();
  }
  
  // draw the pixels in frame
  imgProc.drawPixelArray(currFrame, 0, 0, width, height); 
  arraycopy(currFrame, prevFrame); 

}

public void mousePressed() 
{  
  switch(moveMode) {
    case 0:
      moveMode = 1;
      speed = 0.2f;
      break;  
      
    case 1:
      moveMode = 0;
      speed = 0.01f;
      
  }
}

/**
 Class ImgProc
   This class is from "Noise Particle 06" by Marcin Ignac, Thanks.
    => http://www.openprocessing.org/visuals/?visualID=1163
*/
class ImgProc {
  
  public void ImgProc() {
  }
  
  public void drawPixelArray(int[] src, int dx, int dy, int w, int h) {

    loadPixels();
    int x;
    int y;
    
    for(int i=0; i<w * h; i++) {
      x = dx + i % w;
      y = dy + i / w;
      pixels[x + y * w] = src[i];
    }
    updatePixels();
  }
  
  // Blur effects.
  public void blur(int[] src, int[] dst, int w, int h) {
    
    int c;     
    int r, g, b;
    
    for(int y=1; y < h - 1; y++) {
      for(int x=1; x < w - 1; x++) {
        
        r = 0;
        g = 0;
        b = 0;
        
        for(int yb=-1; yb<=1; yb++) {
          for(int xb=-1; xb<=1; xb++) {
            c = src[(x + xb) + (y - yb) * w];
            r += (c >> 16) & 0xFF;
            g += (c >> 8) & 0xFF;
            b += (c) & 0xFF;
          }
        }
        
        r /= 9;
        g /= 9;
        b /= 9;
        dst[x + y * w] = 0xff000000 | (r << 16) | (g << 8) | b;
      }
    }
  }
  
  // Scale Brightness effects.
  public void scaleBrightness(int[] src, int[] dst, int w, int h, float s) {
    
    int r, g, b;
    int c;
    int a;
    float as = s;
    
    s = 1.0f;
    for(int y=0; y<h; y++) {
      for(int x=0; x<w; x++) {
        
        c = src[x + y * w];
        a = (int)(as * ((c >> 24) & 0xFF));
        r = (int)(s * ((c >> 16) & 0xFF)); 
        g = (int)(s * ((c >> 8) & 0xFF)); 
        b = (int)(s * ((c) & 0xFF));       
        dst[x + y * w] = (a << 24) | (r << 16) | (g << 8) | b; 
        
      }
    }
  }
}


class Particle {
  
  float theta, u;
  float vTheta, vU;
  float x, y, z;
  
  int theColor;
 
  float xDiff, yDiff, zDiff;     
  float nextX, nextY, nextZ;   
  
  Particle(int c, int nx, int ny, int nz, float Theta, float U){
    
    x = width/2;
    y = height/2;
    
    nextX = width/2;
    nextY = height/2;
    nextZ = width % height;
    
    theColor = c;   
    theta = Theta;
    u = U;
    vTheta = 0;
    vU = 0;
  }
  
  public void update() {
    
    vTheta = random(-0.001f, 0.001f);
    theta += vTheta;
    
    if(theta < 0 || theta > TWO_PI) {
      theta *= -1;
    }
    
    vU += random(-0.001f, 0.001f);
    u += vU;
    if(u < -1 || u > 1) {
      vU *= -1;
    }
    
    vU*=0.95f; 
    vTheta*=0.95f; 

    
    // switch with moving mode.
    switch(moveMode) {
      case 0:  // 0.=> Spreading
        nextX += random(-width/4, width/4);
        nextY += random(-height/4, height/4);
        nextZ += random(-height/4, height/4);
        break;
     
      case 1:  // 1. => Gathering
        nextX = (radius * cos(theta) * sqrt(1 - (u * u)));
        nextY = (radius * sin(theta) * sqrt(1 - (u * u)));
        nextZ = u*radius;
        
        // calcurate rotated positions  
        float radX = 45;
        float radY = 45;
        float radZ = 180;
        
        float x1,y1,z1,x2,y2;
        
        x1=nextX*cos(radY)+nextZ*sin(radY);
        y1=nextY;
        z1=-nextX*sin(radY)+nextZ*cos(radY);
  
        x2=x1;
        y2=y1*cos(radX)-z1*sin(radX);
        nextX=x2*cos(radZ)-y2*sin(radZ) + width/2;
        nextY=x2*sin(radZ)+y2*cos(radZ) + height/2;
       
    }
    
    // calculate the move position
    yDiff = (y - nextY) * speed;
    xDiff = (x - nextX) * speed;  
    zDiff = (z - nextZ) * speed;
     
    x -= xDiff--;
    y -= yDiff--;  
    z -= zDiff--;
       
  }
  
  public void render() {
    
    if ((x >= 0) && (x < width-1) && (y >= 0) && (y < height-1)) { 
      int currC = currFrame[(int)x + ((int)y)*width]; 
      currFrame[(int)x + ((int)y)*width] = blendColor(theColor, currC, ADD); 
    }
   
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "Particlesphere02a" });
  }
}
