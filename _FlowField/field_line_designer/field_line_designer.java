import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class field_line_designer extends PApplet {


////////////////////////////////////////////////////////
//                                                    //
//      F I E L D    L I N E    D E S I G N E R       //
//                                                    //
////////////////////////////////////////////////////////

//      (c) bit.craft 2011

//      
//      click the mouse to charge it and move it around.
//      once you release the mouse, the charge is released to the field.
//      
//      Key Map
//      
//      [SPACE] to switch the mouse charge
//      [TAB] or [#] switch between field types 
//      
//      [q][w][e] [a][s][d] move the limits 
//      [l] limit on/off
//      
//      Use cursor keys to rotate the field lines.
//      [SHIFT] cursor keys to change the line density
//      
//      [b] blurred / soft mode
//      [m] moiree mode on/off
//      [-] line thickness
//      [f] filters
//      [t] tiled mode
//      [i] invert colors
//      
//      [1] lores 
//      [2] hires
//      [g] grid style reset
//      [r] reset all
//      [R] reset to blank
//      
//      enjoy!
//

static final int XLINES = 1, YLINES = 2, XYLINES = 3,  MASK = 0xff;
static final int ANG = 0, MAG = 1;

static int nocolor = 0xffcccccc, fgcolor = 0xff003399, bgcolor = 0xffffffff;
float shiftsteps = 16f, moireeFactor = 50;

int xscale, yscale, xshift, yshift, renderMode, filterMode;
boolean limited, smooth, moiree, tiles;
float charge, newcharge, csum, tween;
float yrange, above, below;
float[][][] field;
int[] buffer;
float xres, yres;
int n, w, h;
PImage img;
int res = 1;
int edge = 0;

public void setup() {
  img = loadImage("loading.gif");
  size(400, 400);
  colorMode(RGB, 2);
  cursor(CROSS);
  resetNice(res);
  resetGrid();
}

public void draw() {
  xres = PApplet.parseFloat(w) / width;  
  yres = PApplet.parseFloat(h) / height;
  float factor = moiree &&  !tiles ? moireeFactor : 1.0f;
  charge = mousePressed ? lerp(charge, newcharge, tween) : 0;
  yrange = 1 + (above + below);
  float ymin = 5 * (csum + charge) - below;
  float ymax = ymin + yrange;
  int ctop = tiles ? nocolor : color(0);
  int cbottom = tiles ? nocolor : color(2);
  float bottom =  ymin + yshift / shiftsteps;
  float top = ymax + yshift / shiftsteps;
  float xs = xscale * factor;
  float ys = yscale * factor / yrange;
  float dx = xshift / shiftsteps;
  float dy = ymin  +  yshift / shiftsteps;
  loadPixels();
   for(int y = 0; y < h; y++) {
     for(int x = 0; x < w; x++) {
       float[] vector = field[x][y];
       float px = x - mouseX * xres;
       float py = y - mouseY * yres;
       float mag = (vector[MAG] + charge * log(mag(px, py)) + .5f);
       int c = 0;
       if(limited && mag < bottom) c = cbottom;
       else if(limited && mag > top) c = ctop;
       else {
         mag = (mag - dy) * ys;
         mag = mag - floor(mag);
         float ang = ((vector[ANG] + charge * atan2(px, py)) - PI) / TWO_PI ;
         ang = ang * xs + dx;
         ang = ang - floor(ang);
         if(tiles) {
           c = img.get(PApplet.parseInt(map(ang, 0, 1, 0, img.width-1)), PApplet.parseInt(map(mag, 0, 1, 0, img.height-1)));
         } else switch(renderMode) {
           case(XLINES): c = color(ang + .5f); break;
           case(YLINES): c = color(mag + .5f); break;
           case(XYLINES): c = color(mag +ang); break;
         }  
       }
       pixels[y * w + x] = c;
     }
   }

   if(filterMode > 0) edgeFilter(filterMode, 1 + edge); 
   if(smooth) blurFilter(res); else if(res > 1) blurFilter(res-1);
   updatePixels();
   if(frameCount % 20 == 0) println(frameRate);
}


public void addCharge(float ax, float ay, float charge) {
  csum += charge;
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      float dx = (x - ax);
      float dy = (y - ay);
      float[] vector = field[x][y];
      vector[ANG] += charge * atan2(dx, dy);
      vector[MAG] += charge * log(mag(dx, dy));
    }
  }
}








public void edgeFilter(int edges, int d) {
  for(int e = 0; e < edges; e++) {
    int c1 = (e == edges - 1) ? fgcolor : 0;
    int c2 = (e == edges - 1) ? bgcolor : 255;
    for(int y = 0; y < h; y++) for(int x = 0; x < w; x++) {
      int i = y * w + x;
      int c = pixels[y * w+x] & MASK;
      int cmin = 256;
      for(int dy = -d; dy <= d; dy+=d) {
        for(int  dx= -d; dx <= d ;dx+=d) {
          int px = constrain(x + dx, 0, w - 1);
          int py = constrain(y + dy, 0, h - 1);
          cmin = min(cmin, pixels[px + w * py] & MASK);
          int col = c - cmin > 64 ? c1 : c2;
          buffer[i] = col;
        }
      }
    }
    arrayCopy(buffer, pixels);
  }
}

public void blurFilter(int dmax) { 
   for(int d = 1; d <= dmax; d++) {  
      for(int x = 0; x < w; x++) for(int y = 0; y < h; y++) {
        int p = y * w + x;
        int E = x >= w-d ? 0 : d;
        int W = x >= d ? -d : 0;
        int N = y >= d ? -w*d : 0;
        int S = y >= (h-d) ? 0 : w*d;
        int p0 = p+N, p1 = p+S, p2 = p+W, p3 = p+E, p4 = p0+W, p5 = p0+E, p6 = p1+W, p7 = p1+E;
        int r = (  (r(pixels[p])<<2) + (r(pixels[p0]) + (r(pixels[p1]) + r(pixels[p2]) + r(pixels[p3]))<<1) + r(pixels[p4]) + r(pixels[p5]) + r(pixels[p6]) + r(pixels[p7]) )>>4;
        int g = (  (g(pixels[p])<<2) + (g(pixels[p0]) + (g(pixels[p1]) + g(pixels[p2]) + g(pixels[p3]))<<1) + g(pixels[p4]) + g(pixels[p5]) + g(pixels[p6]) + g(pixels[p7]) )>>4;
        int b = (  (b(pixels[p])<<2) + (b(pixels[p0]) + (b(pixels[p1]) + b(pixels[p2]) + b(pixels[p3]))<<1) + b(pixels[p4]) + b(pixels[p5]) + b(pixels[p6]) + b(pixels[p7]) )>>4;
        buffer[p] = 0xff000000 + (r<<16) | (g<<8) | b;
      }
      arrayCopy(buffer, pixels); 
   }
}

public final static int r(int c) {return (c >> 16) & 255; }
public final static int g(int c) {return (c >> 8) & 255;}
public final static int b(int c) {return c & 255; }




public void keyPressed() {
  float dy = yrange / yscale;
  switch(key) {
    
    case ' ' : newcharge = charge > 0 ? -1 : 1;  break;
    case TAB:
    case '#': if(++renderMode > XYLINES) renderMode = XLINES; break;
    
    case 'f': filterMode = (filterMode + 1) % 5; break;
    case 'b': smooth = !smooth; break;
    case 'm': moiree = !moiree; break;
    case '-': edge = (edge + 1) % (res + 1); break;
    case 't': tiles = !tiles; break;
    case 'i': fgcolor ^= bgcolor; bgcolor ^=fgcolor; fgcolor ^= bgcolor; break;
    
    case 'q': above += dy; yscale++; break;
    case 'a': if(yscale > 1) above -= dy; yscale--; break;
    case 's': above -= dy; below += dy; break;
    case 'w': above += dy; below -= dy; break;
    case 'e':  if(yscale > 1) below -= dy; yscale--; break;
    case 'd': below += dy; yscale++; break;
    case 'l': limited = !limited; break;
    
    case 'g': resetGrid(); break;
    case 'r': resetNice(res); break;
    case '1': resetNice(1); break;
    case '2': resetNice(2); break;
    case 'R': reset(res); break;
    
    case CODED:
      if(keyEvent.isShiftDown()) switch(keyCode) {
        case DOWN: yscale--; renderMode |= YLINES; break;
        case UP: yscale++; renderMode |= YLINES; break;
        case LEFT: xscale--; renderMode |= XLINES;  break;
        case RIGHT: xscale++; renderMode |= XLINES; break;
      } else switch(keyCode) {
        case DOWN: yshift++; break;
        case UP: yshift --; break;
        case LEFT: xshift--; break;
        case RIGHT: xshift++; break;
      }
  }
  
  if(moiree && renderMode ==  XYLINES) renderMode = XLINES;
  
  xscale = max(xscale, 1);
  yscale = max(yscale, 1); 

}


public void mousePressed() {
  if (mouseButton == LEFT)  newcharge = charge > 0 ? -1 : +1;
  if (mouseButton == RIGHT) newcharge = charge > 0 ? +1 : -1;
}


public void mouseReleased() {
  addCharge(mouseX * xres, mouseY * yres, newcharge);
}

public void resetNice(int res) {
  reset(res);
  addCharge(w/4, h/2, -1);
}


public void reset(int resolution) {
  res = resolution;
  w = res * width;
  h = res * height;
  n = w * h;
  buffer = new int[n];
  field = new float[w][h][2];
  hires = createImage(w, h, RGB);
  tween = res == 1 ? 0.5f : 1.0f ;
  csum = 0;
  newcharge = 1;
}


public void resetGrid() {
  renderMode = XYLINES;
  xscale = 20;
  yscale = 10;
  above = 1;
  below = 1;
  filterMode = 1;
  edge = res-1;
  tiles = false;
  limited = true;
  moiree = false;
  smooth = (res == 1);
}



PImage hires;

public void loadPixels() {
  if(w == width && h == height) super.loadPixels();
  else {
    hires.loadPixels();
    pixels = hires.pixels;
  }
}

public void updatePixels() {
  if (w == width && h == height) super.updatePixels();
  else {
    hires.updatePixels();
    image(hires, 0, 0, width, height);
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--stop-color=#cccccc", "field_line_designer" });
  }
}
