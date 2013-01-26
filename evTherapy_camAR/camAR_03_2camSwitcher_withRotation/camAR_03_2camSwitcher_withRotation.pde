/*jason stephens
 thesis - itp
 overhead Camera
 
 -from GSCapture example using GLGraphics
 NOTES:  
 Use Shiffman's GettingStartedExample to get LIst of available cameras
 
 TODO:
 DONE____create switch between these two
 ____Rotate for supine view.
 ____Add iPad controls
 ____will this work with the augmented reality?
 
 // Using integration with GLGraphics for fast video playback.
 // All the decoding stages, until the color conversion from YUV
 // to RGB are handled by gstreamer, and the video frames are
 // directly transfered over to the OpenGL texture encapsulated
 // by the GLTexture object.
 */


import processing.opengl.*;
import codeanticode.glgraphics.*;
import codeanticode.gsvideo.*;

GSCapture cam;
//GSCapture cam2;
GLTexture tex;
//GLTexture tex2;

int lastKeyPressed =1;
boolean rotate90 =false;
boolean flip =false;

void setup() {
  //size(640, 480, GLConstants.GLGRAPHICS);
  size(1024, 768, GLConstants.GLGRAPHICS);

  cam = new GSCapture(this, 640, 480, "DV Video:0");
//  cam2 = new GSCapture(this, 640, 480, "Sony HD Eye for PS3 (SLEH 00201)");

  // Use texture tex as the destination for the camera pixels.
  tex = new GLTexture(this);
  cam.setPixelDest(tex);     
  cam.start();

/*
  // Use texture tex as the destination for the camera pixels.
  tex2 = new GLTexture(this);
  cam2.setPixelDest(tex2);     
  cam2.start();
  */
  
/*

  //____________________________Get RESOLUTION
  int[][] res = cam.resolutions();
  for (int i = 0; i < res.length; i++) {
    println(res[i][0] + "x" + res[i][1]);
  } 

  //_____________________________Get FRAMERATES
  String[] fps = cam.framerates();
  for (int i = 0; i < fps.length; i++) {
    println(fps[i]);
  }
  //____________________________Get RESOLUTION
  int[][] res2 = cam2.resolutions();
  for (int i = 0; i < res2.length; i++) {
    println(res2[i][0] + "x" + res2[i][1]);
  } 
  //_____________________________Get FRAMERATES
  String[] fps2 = cam2.framerates();
  for (int i = 0; i < fps2.length; i++) {
    println(fps2[i]);
  }
  
  */
  //_______________________________PRINT INSTRUCTIONS
  println("SpaceBar = Flip");
  println("'0' = Rotate");
  println("'1' = OverHead Cam");
  println("'2' = Angled Cam");
}


void captureEvent(GSCapture cam) {
  if (lastKeyPressed == 1) {
    cam.read();
  }

 /* if (lastKeyPressed == 2) {
    cam2.read();
  }
  */
  
}


void draw() {
    frame.setLocation(1200, 0);//draws the Processing output to Projector
    
  // If there is a new frame available from the camera, the 
  // putPixelsIntoTexture() function will copy it to the
  // video card and will return true.
  if (flip) {
    scale(-1, 1);
    translate(-width, 0);
  }
  else if (!flip) {
    scale (1, 1);
  }

  if (rotate90) {
    
    translate(width - ((width- .75*height)/2), 0); //!!! figured it out DANG that took awhile
    scale (.75);
    
    rotate(PI/2);
    
  }
  else if (!rotate90) {
  }

  if (lastKeyPressed == 1) {
    if (tex.putPixelsIntoTexture()) {
      image(tex, 0, 0, width, height);
    }
  }

/*
  if (lastKeyPressed == 2) {
    if (tex2.putPixelsIntoTexture()) {
      image(tex2, 0, 0, width, height);
    }
  }
  */
}

void keyPressed() {
  if (key == '1') {
    lastKeyPressed = 1;
  }
  else if (key == '2') {
    lastKeyPressed = 2;
  }
  else if (key == '3') {
    lastKeyPressed = 3;
  }
  else if (key == ' ') {
    flip=!flip;
    background(0);
  }
  else if (key == '0') {
    rotate90=!rotate90;
    background(0);
  }
}

//-------------------------------------------MOVE THE SCREEN and remove the window pane
void init() { 
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

