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

import SimpleOpenNI.*;
SimpleOpenNI  kinect;

//------------KEYSTONE CLASS
// this object is key! you can use it to render fully accelerated
// OpenGL scenes directly to a texture
static boolean calibrate;
boolean calibrating = false;
GLGraphicsOffScreen offscreen;
Keystone ks;
keystone ks2;
CornerPinSurface projectorSurface;
CornerPinSurface cameraViewSurface;
PGraphics projectorDraw;
PGraphics cameraCrop;
//---------------------------------------------------


//-----------CLOSEST POINT TRACKING
PGraphics closestPointResolutionScreen;
//closest point
int closestX = 0; 
int closestY = 0;
//bounding box variables
int bBx, bBy, bBw, bBh; //bounding box x, y, width, height


//---------------RGB Viewer
PImage  RGBViewer;
PImage emptyImage;
PImage rgbImage;
PImage drawClosestPointHighRes;  // this  is used to put the 640,480 into a bigger image
PImage crossHairs;//crossHairs
//------Boolean for RGB
boolean viewRGB=true;
boolean displayCrossHair = false;


//-----------------------Projector VS Camera variables.
int computerScreenXRes = 1920;  //main computer sceen X-axis resolution
int CXRes = 640;  // Variable for Camera X Resolution--if 4:3
int CYRes= 480;  // Variable for Camera Y Resolution--if 4:3
int PXRes = 1024; // Variable for Projector X Resolution
int PYRes = 768;  // Variable for Projector Y Resolution
int passedX;
int passedY;

//recursive circles
float dia = 1000;
float centX, centY, d, w, fluxMap;
float scalar = 1.1;
float fluctuation = 1;

//easing variables
float easeX, easeY, targetX, targetY;
float easing = 0.15;//.05original

//booleans for view
boolean showDepthImage = true;
boolean showBoundingBox = true;
boolean showEV_PointGuide = true;
int counter = 0;
int lastKeyPressed = 1;

//----------------------------------------Removes Window Frame
public void init() {
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}


// ---------------------------------------SETUP
void setup()
{
  size(1024, 768, OPENGL);

  //bounding box variables eventually to become a class
  bBx=100;
  bBy=115;
  bBw=575;
  bBh=355;
  //write to a seperate screen to keep depthArray index within range before 1024,768
  closestPointResolutionScreen = createGraphics(640, 480, P2D);//P3D ORIGINAL//P2D??

  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.alternativeViewPointDepthImage();


  printInstructions();
}

//_____________________________________
// ______________draw__________________
void draw() {

  kinect.update();

  //add lastKeyPress function here and pass lastKeyPress variable
  if (lastKeyPressed == 1) {
    trackClosestPoint();
  }
  else if (lastKeyPressed == 2) {
    drawARcrossHair();
  }
  else { 
    // background(0);
  }
}
//_____________________________________
// ___________FUNCTIONS________________
void trackClosestPoint() {
  /*Kinect resolution = 640x480, but my projector is 1024x768.  
   How do I resize Kinect image without disturbing the boundary conditions established for depth?
   ANS:  Use PGraphic like a push/popMatrix() but within beginDraw() and endDraw() as follows */

  //keep the scope local for updating
  int closestValue = 8000;
  int currentX=0;
  int currentY=0;

  // get the depth array from the kinect
  int[] depthValues = kinect.depthMap();


  //setup special bounding box threshold values here to exclude curtains.  create variables for these
  for (int x = bBx; x < bBw; x++) {
    for (int y = bBy; y < bBh; y++) {
      int i = x + y * 640-1;//subtracting one for some reason,  index out of bounds or somethnig
      int currentDepthValue = depthValues[i];
      // if that pixel is the closest one we've seen so far
      if (currentDepthValue > 0 && currentDepthValue < closestValue) {
        // save its value
        closestValue = currentDepthValue;
        // and save its position (both X and Y coordinates)
        currentX = x;
        currentY = y;
      }
    }
  } 

  //_________________GET RUNNING AVERAGE
  // closestX and closestY become
  // a running average with currentX and currentY
  closestX = (closestX + currentX) / 2;
  closestY = (closestY + currentY) / 2;

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
  //_______________________________________________


  //______DOT SYNTAX inside of pg.beginDraw() and pg.endDraw(); !!!!
  closestPointResolutionScreen.beginDraw();

  //draw the depth image on the screen
  if (showDepthImage) {
    closestPointResolutionScreen.image(kinect.depthImage(), 0, 0);
  }


  //bounding box representation
  closestPointResolutionScreen.fill(0, 50, 0, 50); //make the bounding box representation light green
  if (showBoundingBox) {
    closestPointResolutionScreen.rect(100, 115, 575-100, 355-115); // then use the same variables from for loop to inform rect
  }

  // draw a red circle at the X and Y coordinates of the closest pixel.
  closestPointResolutionScreen.fill(255, 0, 0);
  if (showEV_PointGuide) {
    closestPointResolutionScreen.ellipse(easeX, easeY, 25, 25);//only moved the eased amount
  }
  closestPointResolutionScreen.endDraw();

  image(closestPointResolutionScreen, 0, 0, 1024, 768); 
  //______________________________________
}

