/*jasonStephens
 thesis ITP spring 2012
 EV_Therapy :: EV_PointGenerator
 */

/*__________________________________
 :TODO:
 
 DONE____convert screen resolution to 1024, 768.  may cause problems for the depthArray with an index of 640x480.  
 DONE___do the closest point tracking in a PGraphics and then write the PGrapchics into a larger screen size.
 DONE___create PGraphics at 640, 480 and do all of the depthimage analaysis on this.  then write it to 640, 480 screen.
 DONE____if all clear, then increase screen size, then place PGraphics again.  
 DONE____If good, then resize PGraphic to fit 1024, 768.
 DONE____add easing to closest point tracking
 
 ____Calibration/Keystoning Begin NOW
 ____Processing 2.0? or not?
 
 ____create a bounding box for depth measurements using my height as a threshold so top of my head isn't tracked
 ____add realWorldMeasurement Device aim real world measurement at chest, get breathing results.
 
 ____add switch to turn off the depthImage while retaining the depth info
 ____add secondary threshold level for 2 hands.  
 ____Add a boundary condition around the closest hand so that closest hand is not registered 2 times, 
 such that if point (x,y) is closest, then ignore second closest pixels within sphere diamgeter X of. 
 
 ____Add a sphere from the GLLIghts_handlightSource to the chest area, and then use depth information
 get() that location to inform the size of the sphere!  use scaled eased quantity to hook it up.
 
 ____Frame Differencing to detect breathing.  get(rectangle x,y,w,h) at center of chest of client.
 of previous.  create running averag beteen the current depths and compare to determine the breathing
 
 
 ____add recursive circles::perhaps switch to SwitchCase organization vs lastKeyPress
 ____add sphere_Textured app
 ____add keyboard controls
 ____Potentially use this new PGraphic as a keystone device?? to resize it to massage table using iPad controls
 
 */
import processing.opengl.*;
import codeanticode.glgraphics.*;

import deadpixel.keystone.*;
// this object is key! you can use it to render fully accelerated
// OpenGL scenes directly to a texture
GLGraphicsOffScreen offscreen;
Keystone ks;
CornerPinSurface surface;

PVector easingVector;


import SimpleOpenNI.*;
SimpleOpenNI  kinect;

/*create an offscreen graphics buffer::
 drawing to an off-screen buffer can save CPU cycles by letting you draw pixels using
 Processing drawing routines then save those pixels to a PImage, and draw the PImage 
 to the screen instead of re-drawing the image each frame. 
 Another use of off-screen buffers is the ability to mask areas of an image drawn 
 in Processing to give the effect of a 'viewport' or scrollable area. */
PGraphics closestPointResolutionScreen; 

PImage drawClosestPointHighRes;
PImage starParticle;

//closest point
int closestX = 0; 
int closestY = 0;
int closestDepth=0;
//easing variables
float easeX, easeY, easeDepth, targetX, targetY, targetDepth;
float easing = 0.05;//.05original


//bounding box variables
int startX, endX, startY, endY; //bounding box x, y, width, height
int startU, endU, startV, endV;
int currentStartX, currentStartY, currentEndX, currentEndY;
PVector boxCenter;
PVector boxBoundary;

//recursive circles
float dia = 1000;
float centX, centY, d, w, fluxMap;
float scalar = 1.1;
float fluctuation = 1;


//booleans for view.  space bar toggles one on the other off.  
boolean showDepthImage = true;
boolean showRGBImage = false;

boolean showBoundingBox = true;
boolean showEV_PointGuide = true;
int counter = 0;
int lastKeyPressed = 1;

//_____________________________________
// ______________setup_________________
void setup()
{
  size(1024, 768, OPENGL);

  //this will be passed around to inform the closest pont and poinding box
  easingVector = new PVector (width/2, height/2, 0);

  //bounding box variables eventually to become a class
  startX=100;
  endX=575;
  startY=115;
  endY=355;

  startU =0;
  endU=0;
  startV=0;
  endV=0;

  currentStartX = 0;
  currentStartY = 0;
  currentEndX = 0;
  currentEndY = 0;




  //_---------------may have to change the w/2 to pgraphic.w/2!!!!
  PVector boxCenter = new PVector (width/2, height/2);
  PVector boxBoundary = new PVector (0, 0);


  //write to a seperate screen to keep depthArray index within range before 1024,768
  closestPointResolutionScreen = createGraphics(640, 480, P2D);//P3D ORIGINAL
  starParticle = loadImage("starParticle-1.png");


  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  printInstructions();
}

//_____________________________________
// ______________draw__________________
void draw() {

  kinect.update();

  trackClosestPoint();

  drawDynamicBoundingBox();
}
//_____________________________________
// ___________FUNCTIONS________________
void trackClosestPoint() {
  /* psuedoCode:
   1.setup local variables for establishing closest point
   2.create an array called depthValues and poplulate it with REAL depth info from kinect's depthMap
   3.ForLoop through constrained PixelGroup with boundaries smaller than the 640x480 index length
   4.establish THRESHOLD test for each pixel that exists inside the constrained pixel group (bounding box)
   
   
  /*Kinect resolution = 640x480, but my projector is 1024x768.  
   How do I resize Kinect image without disturbing the boundary conditions established for depth?
   ANS:  Use PGraphic like a push/popMatrix() but within beginDraw() and endDraw() as follows */

  //keep the scope local for updating
  //int tableClient = 0;
  int closestValue = 8000;
  int currentDepth = 0;
  int currentX=0;
  int currentY=0;


  // get the depth array from the kinect
  int[] depthValues = kinect.depthMap();
  //setup special bounding box threshold values here to exclude curtains.  create variables for these
  for (int x = currentStartX; x < endX; x++) {
    for (int y = startY; y < endY; y++) {
      int i = x + y * 640-1;//subtracting one for some reason,  index out of bounds or somethnig
      int currentDepthValue = depthValues[i];

      // if that pixel is the closest one we've seen so far
      if (currentDepthValue > 0 && currentDepthValue < closestValue) {
        //and if it's is above the massage table threshold
        // save its value
        closestValue = currentDepthValue;
        // and save its position (both X and Y and Z coordinates)
        currentX = x;
        currentY = y;
        currentDepth = currentDepthValue;
      }
    }
  }

  //_________________GET RUNNING AVERAGE
  // closestX and closestY become
  // a running average with currentX and currentY
  closestX = (closestX + currentX) / 2;
  closestY = (closestY + currentY) / 2;
  closestDepth = (closestDepth + currentDepth)/2;

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
  targetDepth = closestDepth;
  float ddepth = targetDepth-easeDepth;
  if (abs(ddepth)>1) {
    easeDepth += ddepth * easing;  //easing scales the distance betwee
  }
  //_______________________________________________
  //upDate the easingVector
  easingVector.x = easeX;
  easingVector.y = easeY;
  easingVector.z = easeDepth;
  //println(easingVector.x);

  //______DOT SYNTAX inside of pg.beginDraw() and pg.endDraw(); !!!!
  closestPointResolutionScreen.beginDraw();


  //draw the depth image, bounding box and calibration ellipse
  if (showDepthImage) {
    closestPointResolutionScreen.image(kinect.depthImage(), 0, 0);
    //initial bounding box
    closestPointResolutionScreen.fill(0, 50, 0, 50); //make the bounding box representation light green
    closestPointResolutionScreen.rect(startX, startY, endX-startX, endY-startY); // then use the same variables from for loop to inform rect
    // draw a red circle at the X and Y coordinates of the closest pixel.
    closestPointResolutionScreen.fill(255, 0, 0);
    closestPointResolutionScreen.ellipse(easeX, easeY, 30, 30);

    //insert the dynamic bounding box right here
    closestPointResolutionScreen.rectMode(CENTER);
    PVector boxBoundary = new PVector (easeX, easeY);
    PVector boxCenter = new PVector (closestPointResolutionScreen.width/2, closestPointResolutionScreen.height/2);
    float boxScale = boxCenter.dist(boxBoundary);
    //println(boxScale);
    closestPointResolutionScreen.fill(145, 30, 255, map(boxScale, -180, closestPointResolutionScreen.height/2, 255, 0));
    closestPointResolutionScreen.line(boxCenter.x, boxCenter.y, easeX, easeY);
    //create a box with boundary that is twice the distance as mouseX is from mid width and mouseY from mid height
    //constrained to no less than 80.54x50 (golden ratio roughly) and not to exceed the boundary of the screen.
    closestPointResolutionScreen.rect(boxCenter.x, boxCenter.y, constrain( 2*(abs(boxCenter.x-easeX)), 80.54, closestPointResolutionScreen.width*.8), constrain(2*(abs(boxCenter.y-easeY)), 50, closestPointResolutionScreen.height*.8));

    // if the (u,v) of the dynamic box is less than the starting point for the initial bounding box, then the starting point = startU point
    int startU = int(boxCenter.x - abs(boxCenter.x-easeX));  //constrain( 2*(abs(boxCenter.x-easeX)), 80.54, closestPointResolutionScreen.width*.8));
    int startV = int(boxCenter.y-abs(boxCenter.y-easeY));
    int endU = int(closestPointResolutionScreen.width-startU);
    int endV = int(closestPointResolutionScreen.height - startV);
/*
    if (startU > startX) {
      currentStartX = startU;
    }
    else if (startU <= startX) {
      currentStartX = startX;
    }
    /*
    if (startV > startY) {
     currentStartY = startV;
     }
     else {
     currentStartY = startY;
     }
    /*
     if (endU < endX) {
     currentEndX = endU;
     }
     if (endV < endY) {
     currentEndY = endV;
     }
     */

    println ("startU =" + startU + "startX = " + startX + "startV = " + startV + " startY = " + startY+ "endU = " + endU + "endX = " + endX + " endV = " + endV + "endY =" + endY + "currentStartX = " + currentStartX);

    closestPointResolutionScreen.rectMode(CORNER);
  } 
  else {
    closestPointResolutionScreen.background(0);
  }
  closestPointResolutionScreen.pushMatrix();
  closestPointResolutionScreen.imageMode(CENTER);
  closestPointResolutionScreen.translate (easeX, easeY);
  float starRotate = map(easeX, 0, width, -2*PI, 2*PI);
  closestPointResolutionScreen.rotate(starRotate);
  closestPointResolutionScreen.image(starParticle, 0, 0, 100, 100);
  closestPointResolutionScreen.imageMode(CORNER);
  closestPointResolutionScreen.fill(0, 0, 255);
  closestPointResolutionScreen.popMatrix();


  closestPointResolutionScreen.endDraw();

  image(closestPointResolutionScreen, 0, 0, 1024, 768); 

  // image(starParticle, easeX, easeY);
  //______________________________________
}

void drawDynamicBoundingBox () {
  rectMode(CENTER);
  //float scalarBox2 = dist
  float scalar = 100;
  float w = 1.618;
  float h = 1;
  fill(0, 0, 255, 100);
  rect(constrain (mouseX - w/2, 0, width), constrain (mouseY - h/2, 0, height), w*scalar, h*scalar);

  //second box that fixed but with variable w,h
  fill(255, 0, 0, 100);
  //rect(width/2, height/2, abs(mouseX-width/2), abs(mouseY-height/2));

  //3rd Box using PVectors to get distance for scale
  //tried passing easeX easeY here, but they are on different cordinate system

  /* PVector boxBoundary = new PVector (mouseX, mouseY);
   PVector boxCenter = new PVector (width/2, height/2);
   float boxScale = boxCenter.dist(boxBoundary);
   //println(boxScale);
   fill(145, 30, 255, map(boxScale, -180, height/2, 255, 0));
   line(boxCenter.x, boxCenter.y, mouseX, mouseY);
   //create a box with boundary that is twice the distance as mouseX is from mid width and mouseY from mid height
   //constrained to no less than 80.54x50 (golden ratio roughly) and not to exceed the boundary of the screen.
   rect(boxCenter.x, boxCenter.y, constrain( 2*(abs(boxCenter.x-mouseX)), 80.54, width*.8), constrain(2*(abs(boxCenter.y-mouseY)), 50, height*.8));
   */
  rectMode(CORNER);
}

