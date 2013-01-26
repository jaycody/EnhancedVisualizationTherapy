/*jason stephens
thesis - itp - spring 2012
EV_Therapy AcuNetic Breath Monitor */

/* TODO:
____create a room light that changes relative to depth change of mouse


*/

import processing.opengl.*;
//import java.awt.event.MouseEvent;
//import java.io.OutputStream;
//import java.util.ArrayList;
//import codeanticode.gsvideo.*;

import SimpleOpenNI.*;
SimpleOpenNI  kinect;

PGraphics PG_RGB;
PGraphics PG_depth;
PGraphics PG_entireScreen;

PImage PI_img;

void setup()
{
  size(640, 480, OPENGL);
  kinect = new SimpleOpenNI(this);

  //a place to write and resize the rgbAlternativeView.
  PG_RGB = createGraphics (640, 480, P2D);//retain aspect ratio for index boundary
  PG_depth = createGraphics (640, 480, P2D);
  PG_entireScreen = createGraphics (640, 480, P2D);

  PI_img = createGraphics(640, 480, P2D);

  kinect.enableDepth();  
  kinect.enableRGB();
  kinect.alternativeViewPointDepthToImage();
}

void draw()
{
  kinect.update(); 
  
  box(45);
  
   //------------------------------begin PG_RGB
  PG_RGB.beginDraw();
  PG_RGB.image(kinect.rgbImage(), 0, 0);
  PG_RGB.endDraw();

  //------------------------------begin PG_depth
  PG_depth.beginDraw();
  PG_depth.image(kinect.depthImage(), 0, 0);
  PG_depth.endDraw();

  //------------------------------begin PG_entireScreen
  PG_entireScreen.beginDraw();
  //PG_entireScreen.image(PG_RGB,0, 0);
  //PG_entireScreen.image(PG_depth,PG_RGB.width/2,0);
  PG_entireScreen.endDraw();


  //---------------------------------display the PG_images
  //display the PGraphics
  image(PG_RGB, 0, 0);
  //image(PG_depth, width/2, 0, 400, 50);
  //int w = 200;
  // image(PG_entireScreen,constrain (mouseX-w/2,0, width),constrain (mouseY-w/2,0,height),w,w);


  int[] depthValues = kinect.depthMap();
  // this was giving array out of bounds issues:
  int clickPosition = mouseX + (mouseY * PG_RGB.width);
  //int clickPosition = PgScreen1.get(mouseX,mouseY);
  int millimeters = depthValues[clickPosition];
  float inches = millimeters / 25.4;
  println("mm: " + millimeters + " in: " + inches);
}


