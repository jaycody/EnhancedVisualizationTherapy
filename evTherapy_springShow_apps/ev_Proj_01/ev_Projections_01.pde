/*jason stephens
 thesis - itp - spring 2012
 EV_Therapy - EV_Projections
//-----------------------------------------------------------------
TODO:
_____get depth image working inside keystone mesh
_____make a 640x480 surface for the kinect depth and stretch that as a mesh 
//-----------------------------------------------------------------
NOTES:
1May::starting from scratch.  presentation in 8 days.  Using OpenGL keystone to draw just the kinect to texture
Allows me to line up depth image with the massage surface.
Make a 640x480 surface for the kinect
*/

import processing.opengl.*;
import codeanticode.glgraphics.*;
import deadpixel.keystone.*;

// this object is key! you can use it to render fully accelerated
// OpenGL scenes directly to a texture
GLGraphicsOffScreen offscreen;
Keystone ks;
CornerPinSurface surface;

import SimpleOpenNI.*;
SimpleOpenNI  kinect;

void setup() {
  size(1024, 768, GLConstants.GLGRAPHICS);
  smooth();
  offscreen = new GLGraphicsOffScreen(this, width, height);//lets set this to the dimensions of the kinect (not widht/heigh
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(width, height, 20);

  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  printInstructions();
}


void draw() {
  kinect.update();
  keyStonedSurface();
  
  //image(kinect.depthImage(),0,0);

  fill(255, 0, 0);
  ellipse(mouseX, mouseY, 50, 50);
  
}




