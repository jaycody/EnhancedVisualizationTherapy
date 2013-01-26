/*jasonStephens
 thesis ITP spring 2012
 EV_Therapy :: EV_PointGenerator
 */

/*
 :TODO:
 ____attach tallest point to the circle calibration
 DONE ____create a PVector return type after calculating distances
 ____create a function that calculates the Velocity vector betwwen two points
 ____make an EV_Object class, each with it's own navigation system.  each with it's own way of being in the world.
 ____figure out some polar cordinates
 
 ____ADD the sinusodal colors to the recursive circle cross hairs!!
 
 ____Frame Differencing to detect breathing.  get(rectangle x,y,w,h) at center of chest of client.
 of previous.  create running averag beteen the current depths and compare to determine the breathing
 */


import deadpixel.keystone.*;
Keystone ks;
CornerPinSurface surface;
//PVector surfaceMouse; //accessible anywhere

PGraphics offscreen;
PImage depthImage;
PImage sceneImage;
PImage rgbImage;
PImage rvl;

boolean depthSwitch = true;
boolean surfaceRender = true;
import SimpleOpenNI.*;
SimpleOpenNI  kinect;
//AcuNetic acuNetic;

//--------------------starting closest point tracking
int closestX = 0; 
int closestY = 0;
int closestDepth=0;
//easing variables
float easeX, easeY, easeDepth, targetX, targetY, targetDepth;
float easing = 0.1;//.05original
int startX, endX, startY, endY;
//---------------------------------------------------

void setup() {
  size(1024, 768, P3D);
  noStroke();
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(640, 480, 10);//matchesKinectResolution with 20
  offscreen = createGraphics(640, 480, P2D);//offscreen buffer to draw the surface
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableScene();
  kinect.enableRGB();
  rvl = loadImage("starParticle-1.png");
  //----------------------------- initializing the OBJECTS
  //acuNetic = new AcuNetic ();
  printInstructions();
  //------------------------------bounding box variables
  //bounding box variables eventually to become a class
  startX=100;
  endX=575;
  startY=115;
  endY=355;
}
//--------------------------------------------DRAW----------------------
void draw() {
  frame.setLocation(1920, 0);//draws the Processing output to Projector
  updateKinectImages(); 

  //-------------------------------------all the offscreen stuff with surfaceRender at the end.
  PVector surfaceMouse = surface.getTransformedMouse();
  offscreenFunction();
  trackClosestPoint();//placed here, the closest point get's mapped to screen.
  createCalcDrawTableToolVectors(); //
  if (surfaceRender) {
    surface.render(offscreen);
  }
  
  //createCalcDrawTableToolVectors(); //
  drawRVLtestImage();
  // drawAcuNeticTestImage(); 

  //may have to put this bad boy at the end....
}
//-----------------------------------------------------------TABLE TOP CALIBRATIION FUNCTION
void createCalcDrawTableToolVectors() {
  //1.set the necessary PVectors
  PVector currentMouse = new PVector (mouseX, mouseY);
  PVector center = new PVector (width/2, height/2);
  //2.calculate the Direction Vector between 2 points and return a PVector dir 
  PVector dir = calcAndReturnDirVectorFromCurrentLocToOtherLoc (currentMouse, center);
  //experiment making a new center location
  PVector newCenter = PVector.sub(currentMouse, dir);//changing this one
  //3.now pass the newly returned dir vector plus the center vector to  create calibration screen at that point
  //added RGB arguments
  drawCenterTableVectorTool(dir, center, 255, 0, 0);  //could potentially use this to create several such tools
  PVector dir2 = PVector.div(dir, 2);
  drawCenterTableVectorTool(dir2, newCenter, 0, 255, 0);//origianl newCenter,dir
  drawCenterTableVectorTool(dir2, currentMouse, 0, 0, 255);
}
PVector calcAndReturnDirVectorFromCurrentLocToOtherLoc (PVector currentLoc, PVector otherLoc) {
  PVector dir = PVector.sub(currentLoc, otherLoc); // currentLoc.sub(previousLoc); */
  return dir;
}
void drawCenterTableVectorTool(PVector dir, PVector center, int r, int g, int b) {
  float m = dir.mag();
  pushMatrix();
  translate (center.x, center.y);
  rectMode(RADIUS);
  fill(r, g, b*abs((mouseY-center.y)/center.y), 150);
  strokeWeight(2);
  stroke(b, r, g);
  ellipse(0, 0, 2*m, 2*m);
  line (0, 0, dir.x, dir.y);
  rectMode(CORNER);
  popMatrix();
}
//------------------------------------------------------------------

void trackClosestPoint() {
  // declare these within the draw loop
  // so they change every time
  int closestValue = 8000;
  int currentX=0;
  int currentY=0;

  int currentDepth = 0;// add you later


  // get the depth array from the kinect
  int[] depthValues = kinect.depthMap();

  // for each row in the depth image
  for (int x = startX; x < endX; x++) {
    // look at each pixel in the row
    for (int y = startY; y < endY; y++) {
      // pull out the corresponding value from the depth array
      int i = x + y * 640;
      int currentDepthValue = depthValues[i];

      // if that pixel is the closest one we've seen so far
      if (currentDepthValue > 0 && currentDepthValue < closestValue) {
        // save its value
        closestValue = currentDepthValue;
        // and save its position (both X and Y coordinates)
        currentX = x;
        currentY = y;
        currentDepth = currentDepthValue;
      }
    }
  }

  // closestX and closestY become
  // a running average with currentX and currentY
  closestX = (closestX + currentX) / 2;
  closestY = (closestY + currentY) / 2;

  closestDepth = (closestDepth + currentDepth)/2;//and add you later

  //__________________Add easing.  
  //easing is an ARRIVAL BEHAVIOR como Reynolds "life-like and improvisational" 
  //instantiated using a simple feedback mechanism of some kind:  
  //As I get closer to target slow down.  Velocity is a function of the distance to target..somehow 
  targetX = closestX;
  float dx = targetX-easeX;
  if (abs(dx)>1) {
    easeX += dx * easing;  //easing scales the distance betwee
  }
  targetY = closestY;
  float dy = targetY-easeY;
  if (abs(dy)>1) {
    easeY += dy * easing;  //easing scales the distance betwee
  }
  /*--------------------------------add DEPTH easing later
   
   targetDepth = closestDepth;
   float ddepth = targetDepth-easeDepth;
   if (abs(ddepth)>1) {
   easeDepth += ddepth * easing;  //easing scales the distance betwee
   }
   ------------------------------------*/

  //draw the depth image on the screen
  //image(kinect.depthImage(),0,0);

  // draw a red circle over it, 
  // positioned at the X and Y coordinates 
  // we saved of the closest pixel.

  //next draw this to the other keystone screen.  that would be great.

  offscreen.beginDraw();

  if (depthSwitch) {
    offscreen.image(sceneImage, 0, 0);
  }

  //start with bounding box 1 (curtain excluder)
  offscreen.fill(0, 50, 0, 50);
  offscreen.rect(startX, startY, endX-startY, endY-startY); //yeah buddy!! bounding box begins
  //easing circle
  offscreen.fill(200, 20, 150, 150);
  offscreen.ellipse(easeX, easeY, 30, 30); // this is the eased version... no problemo
  offscreen.endDraw();
}

