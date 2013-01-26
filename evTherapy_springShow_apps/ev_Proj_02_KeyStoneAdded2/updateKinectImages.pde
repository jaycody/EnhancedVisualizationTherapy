//----------------------------sending functions to their own tabs
void updateKinectImages() {
  
  kinect.update();
//_____________________________________create the PImages
//depthImage = kinect.depthImage();
sceneImage =kinect.sceneImage();
//rgbImage = kinect.rgbImage();
//-------------------------------------create the arrays
//int []dmap = kinect.depthMap();//array of depth
//int []smap = kinect.sceneMap();//every pixel is assinged either 0 =background, 1=first object,etc


/*-----------------floor plane??
// get the floor plane
   PVector point = new PVector();
   PVector normal = new PVector();
   kinect.getSceneFloor(point,normal); 
  */ 
}

//-------------------------------------offscreenKeyStoneFunctions

void offscreenFunction() {
 // Convert the mouse coordinate into surface coordinates
  // this will allow you to use mouse events inside the 
  // surface from your screen. 
  PVector surfaceMouse = surface.getTransformedMouse();


  // Draw the scene, offscreen
  offscreen.beginDraw();
  //load pixels here:
  loadPixels();
  offscreen.loadPixels();
  
  //-----------------------------------------TOGGLE depthImage / Background(0)
  if (depthSwitch){
  offscreen.image(sceneImage, 0, 0);
  }
  if (!depthSwitch){
    //offscreen.background(0); 
  }
  
  
  //cycle through to implement pixel changes
  for (int i = 0; i < offscreen.pixels.length; i++) {
   //float rand = random (255);
    color c = color(255,255*(mouseX/width));
    offscreen.pixels[i] = c;
  }
  
  offscreen.updatePixels();
  updatePixels();

  //----------------------------------------DrawASurfaceMouseInsideTheNewCordinates
  //myfunction(surfaceMouse);
  offscreen.endDraw();
  // render the scene, transformed using the corner pin surface

//  surface.render(offscreen);

  //------------------------------printoutWhat's happening.
  //printDebug(surfaceMouse);
  
  
}

void myfunction (PVector surfaceMouse) {
  offscreen.beginDraw();
  offscreen.fill(255*(surfaceMouse.y/offscreen.height),map (surfaceMouse.x,offscreen.width,0,0,255), 0);
  offscreen.imageMode(CENTER);
  offscreen.image(rvl, surfaceMouse.x,surfaceMouse.y,50,50);
  offscreen.imageMode(CORNER);
  offscreen.endDraw();
}

