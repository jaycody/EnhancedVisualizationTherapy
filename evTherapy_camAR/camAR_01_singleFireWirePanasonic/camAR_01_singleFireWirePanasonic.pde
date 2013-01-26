/*jason stephens
thesis - itp
overhead Camera

-from GSCapture example using GLGraphics
NOTES:  
Use Shiffman's GettingStartedExample to get LIst of available cameras
TODO:
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
GSCapture cam2;
GLTexture tex;

void setup() {
  //size(640, 480, GLConstants.GLGRAPHICS);
  size(1024, 768, GLConstants.GLGRAPHICS);
  
cam2 = new GSCapture(this, 640, 480, "Sony HD Eye for PS3 (SLEH 00201)");
  cam = new GSCapture(this, 640, 480, "DV Video:0");
  
  // Use texture tex as the destination for the camera pixels.
  tex = new GLTexture(this);
  cam.setPixelDest(tex);     
  cam.start();
  
  
  // You can get the resolutions supported by the
  // capture device using the resolutions() method.
  // It must be called after creating the capture 
  // object. 
  int[][] res = cam.resolutions();
  for (int i = 0; i < res.length; i++) {
    println(res[i][0] + "x" + res[i][1]);
  } 
  
  
  
  // You can also get the framerates supported by the
  // capture device:
  String[] fps = cam.framerates();
  for (int i = 0; i < fps.length; i++) {
    println(fps[i]);
  } 
   
}

void captureEvent(GSCapture cam) {
  cam.read();
}

void draw() {
  // If there is a new frame available from the camera, the 
  // putPixelsIntoTexture() function will copy it to the
  // video card and will return true.
  if (tex.putPixelsIntoTexture()) {
    image(tex, 0, 0, width, height);
  }
}
