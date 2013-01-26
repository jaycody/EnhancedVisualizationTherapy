/*************************************************************
 **********Kinect Tracking to Move Particles******************
 **************Created by Andrew Lazarow**********************
 *******Using elements of: Max Bouchard's Keystone Library****
 ************Dan Shiffman's Flocking example******************
 ***********and Craig Reynold's Steering Behviors*************
 ***********and Max Rheiner's SimpleOpenNI library************
 ***************For ITP, Nature of Code, Spring 2012.*********
 ************************MIDTERM******************************
 ************************************************************/

/*

 To Use: 
 -Connect Microsoft Kinect Sensor, and a projector.
 -Make sure Mirroring is TURNED OFF
 -Set PXRes and PYRes to equal the projector's resolution.
 -Hitting 'v' Turns on and off the RGB Viewer.
 -Calibrate the Projector/Kinect by hitting 'c':
 
 -Drag the top/larger mesh surface til fill the projection area.
 -Using an RGB view of the Kinect, in the camera view drag the
 smaller mesh to match the location of the large mesh.  
 
 -Hit'c' to stop the callibration and play.
 -Turn off RGB by hitting 'v' to optimize speed
 
 KeyPressed Commands:
 
 -'v' Turns on and off the Kinect's RGB View
 -'c' turns on and off calibration modes.
 -'t' displays a cross, if you want to help center the kinect (though not necessary).
 -'r' blows wind' to blow particles to the right.
 -'l' blows wind' to blow particles to the right.
 -'g' adds gravity - and pulls particles down
 -'u' removes gravity - and pulls particles up.
 -'a' adds attraction strength to the 'attractor' (the user's hand).
 -'d' reduces or erases attraction strength to the 'attractor' (the user's hand).
 
 
 */

import java.awt.event.MouseEvent;
import java.io.OutputStream;
import java.util.ArrayList;
/*
import codeanticode.gsvideo.*;
 import toxi.geom.*;
 import toxi.physics2d.*;
 import toxi.physics2d.behaviors.*;
 */

//-------------SYPHON ADDITIONS:
import codeanticode.syphon.*;

//-------------For OSC P5
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;


//-----------------------For SimpleOpenNI
import SimpleOpenNI.*;

SimpleOpenNI  context;
boolean       autoCalib=true;

int whichUser=1;

//-----------------------Adds RGB
//--------------PImages
PImage  RGBViewer;
PImage emptyImage;
PImage rgbImage;
//------Boolean for RGB
boolean viewRGB=true;


//-----------------------For the Keystone Class
static boolean calibrate;
boolean calibrating = false;
Keystone ks;
CornerPinSurface cameraViewSurface;
PGraphics projectorDraw;
PGraphics cameraCrop;
PImage stars;
PrintWriter output;

//-------
int sendTransformedCoordX=0;
int sendTransformedCoordY=0;


//---------------For Erasing Wall Images
PImage cityView;
PImage bricks;
float a;
boolean handErase = false;


//-----------------------Projector VS Camera variables.

int CXRes; // Variable for Camera X Resolution--if 4:3
int CYRes; // Variable for Camera Y Resolution--if 4:3
int PXRes; // Variable for Projector X Resolution
int PYRes; // Variable for Projector Y Resolution
int passedX;
int passedY;


//-----------------------Sets up Camera


//-----------------------loads Images
PImage Bottle; // Bottle image
PImage crossHairs;//crossHairs


//-----------------------Booleans
boolean displayCross = false;  //displays calibration cross
//--Physics/Wind related Booleans
boolean rightWind=false;
boolean leftWind=false;
boolean noGrav = false;
boolean addGrav = false;
boolean addAttraction = false;
boolean deleteAttraction = false;

//-------------SYPHON ADDITIONS:
SyphonServer server;


//---------------ImageCalibTest
PImage screenShot;
int imageVertexOneX=0;
int imageVertexOneY;
int imageVertexTwoX;
int imageVertexTwoY;
int imageVertexThreeX;
int imageVertexThreeY;
int imageVertexFourX;
int imageVertexFourY;



//--------------------------------------------Setup
void setup() {

  PXRes = 1024; // Variable for Projector X Resolution
  PYRes = 768;  // Variable for Projector Y Resolution
  CXRes = 640;  // Variable for Camera X Resolution--if 4:3
  CYRes = 480; // Variable for Camera Y Resolution--if 4:3

  size(PXRes/2, PYRes/2, OPENGL);
  smooth();


  //----------------Initiates Keystone
  ks = new Keystone(this);
  //------DELETEprojectorSurface = ks.createCornerPinSurface(PXRes/2, PYRes/2, 20);
  //------DELETE ks2 = new Keystone(this);
  cameraViewSurface = ks.createCornerPinSurface(PXRes/4, PYRes/4, 20);
  //-----------------Sets up offscreen buffer
  projectorDraw = createGraphics(PXRes/2, PYRes/2, P2D);
  cameraCrop = createGraphics(PXRes/4, PYRes/4, OPENGL);

  //----------------Erase Wall Images
  bricks = loadImage( "brickFloor.jpg" );
  cityView = loadImage( "NewYorkNight.jpeg" );




  //------------------SimpleOpenNI

  context = new SimpleOpenNI(this);

  // enable depthMap generation 
  context.enableDepth();
  //------------------FOR RGB IMAGE
  context.enableRGB();
  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  //----------------------FOR RGB IMAGE
  context.alternativeViewPointDepthToImage();


  //-----------------Loads images
  Bottle = loadImage("CokeBottle.png");
  stars = loadImage ("stars-n-planet.jpeg");
  crossHairs = loadImage("CrossS.png");

  //----------Setup for the RGB Function
  RGBViewer = createImage(640, 480, ARGB);
  emptyImage = loadImage("emptyImage.png");
  emptyImage.loadPixels();


  //-------------SYPHON ADDITIONS:
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Mesh Test One Syphon");

  //-------------OSC P5
  frameRate(60);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}


//----------------------------------Draw
void draw() {




  PVector transformedCoord = cameraViewSurface.getTransformedPassedValues(passedX, passedY);
  //PVector transformedCoord = cameraViewSurface.getTransformedPassedValues(mouseX, mouseY);

  transformedCoord.mult(2);


  sendTransformedCoordX=int (transformedCoord.x);
  sendTransformedCoordY=int (transformedCoord.y);

  //-------------RGB View Magic Trick.

  if (viewRGB==true) {
    RGBViewFunction();
  }

  //--------------Physics Part 2 Attractor:
  if (calibrating==false) {




    //------------------
    //------ Draw the scene, offscreen
    projectorDraw.beginDraw();
    projectorDraw.background (0);

    projectorDraw.endDraw();
  }

  //--------------------------------------SimpleOpenNI
  stroke(0, 0, 255);
  strokeWeight(3);

  context.update();



  //-------------Skeleton Tracking and drawing.
  // for all users from 1 to 10
  int i;
  for (i=1; i<=10; i++)
  {
    // check if the skeleton is being tracked
    if (context.isTrackingSkeleton(i))
    {
      // draw the skeleton
      if (i==whichUser) {
        drawSkeleton(i);  

        // draw a circle for a hand 
        circleForRightHand(i);
        circleForAHead(i);
      }
    }
  }

  noStroke();


  // render the scene, transformed using the corner pin surface

    //projectorSurface.render(projectorDraw);
  cameraViewSurface.render(cameraCrop);
  if (calibrating==true) {
    //println ("mouse X     " + mouseX + "     mouse Y     " + mouseY);
  }
  //println (surfaceMouse.x);

  if (displayCross==true) {
    imageMode(CENTER);
    image(crossHairs, CXRes+(PXRes/2), PYRes/2);
    image(crossHairs, CXRes/2, CYRes/2);
  }


  sendOSCMessage();

  server.sendImage(projectorDraw);
}

//---------------------ENDs DRAW LOOP



//---------------------RGB Magic - the work gets 'er done here.
void RGBViewFunction() {

  rgbImage = context.rgbImage();
  rgbImage.loadPixels();
  //clouds.loadPixels();
  //userMap = context.getUsersPixels(SimpleOpenNI.USERS_ALL);
  for (int y=0;y < 480;y+=1) {
    for (int x=0;x < 630 ;x+=1) {
      int i = x + y * 640;
      float r = red (emptyImage.pixels[i]);
      if (r!=0) {
        RGBViewer.pixels[i] = rgbImage.pixels[i];
      } 
      else {
        RGBViewer.pixels[i] = rgbImage.pixels[i];
      }
    }
  }

  RGBViewer.updatePixels();
  image(RGBViewer, 0, 0);
}





void keyPressed() {

  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // & moved
    ks.toggleCalibration();
    calibrating=!calibrating;
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    // ks2.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    //ks2.save();
    break;
  }

  if (key == 't') {
    displayCross=!displayCross;
  }

  if (key == 'h' || key == 'H') {
    handErase=!handErase;
  }

if (key == '1') {
    whichUser=1;
  }
  
  if (key == '2') {
    whichUser=2;
  }


  if (key == 'v') {
    viewRGB=!viewRGB;
  }
}

void sendOSCMessage() {
  /* createan osc message with address pattern /test */
  OscMessage myMessage = new OscMessage("/sendingMouse");

  //myMessage.add(mouseX); /* add an int to the osc message */
  //myMessage.add(mouseY); /* add a second int to the osc message */


  myMessage.add(sendTransformedCoordX); /* add an int to the osc message */
  myMessage.add(sendTransformedCoordY); /* add a second int to the osc message */

  myMessage.add(100); /* add a third int to the osc message */


  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
}


/*
void stop() {
 kinect.quit();
 super.stop();
 }
 */
