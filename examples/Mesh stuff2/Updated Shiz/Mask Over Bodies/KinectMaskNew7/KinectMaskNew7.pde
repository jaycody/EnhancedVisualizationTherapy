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



//-----------------------For SimpleOpenNI
import SimpleOpenNI.*;

SimpleOpenNI  context;
boolean tracking = false;
int userID;
int[] userMap;

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


//---------------For Mask Images
PImage  userImage;
PImage empireImage;
PImage clouds;
boolean maskAlone=false;


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
PImage bricks;
int imageVertexOneX=0;
int imageVertexOneY=0;
int imageVertexTwoX=300;
int imageVertexTwoY=0;
int imageVertexThreeX=300;
int imageVertexThreeY=400;
int imageVertexFourX=0;
int imageVertexFourY=400;



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

  projectorDraw = createGraphics(PXRes/2, PYRes/2, OPENGL);
  cameraCrop = createGraphics(PXRes/4, PYRes/4, OPENGL);

  //----------------For Mask Images
  userImage = createImage(640, 480, ARGB);
  empireImage = loadImage("White.jpg");
  clouds = loadImage("Black.jpg");
  empireImage.loadPixels();
  bricks = loadImage("brickFloor.jpg");


  //------------------SimpleOpenNI

  context = new SimpleOpenNI(this);

  // enable depthMap generation 
  context.enableDepth();
  //------------------FOR RGB IMAGE
  context.enableRGB();
  //---------Skeleton Tracking turned OFF for MASK
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE);

  //----------------------FOR RGB IMAGE
  context.alternativeViewPointDepthToImage();


  //-----------------Loads images
  crossHairs = loadImage("CrossS.png");

  //----------Setup for the RGB Function
  RGBViewer = createImage(640, 480, ARGB);
  emptyImage = loadImage("emptyImage.png");
  emptyImage.loadPixels();


  //-------------SYPHON ADDITIONS:
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Mesh Test One Syphon");
}


//----------------------------------Draw
void draw() {




  //PVector transformedCoord = cameraViewSurface.getTransformedPassedValues(passedX, passedY);
  PVector transformedCoord = cameraViewSurface.getTransformedPassedValues(mouseX, mouseY);

  transformedCoord.mult(2);



  //-------------RGB View Magic Trick.

  if (viewRGB==true) {
    RGBViewFunction();
  }


  //--------------------------------------SimpleOpenNI

  context.update();
  if (tracking) {
    //rgbImage = context.rgbImage();
    //rgbImage.loadPixels();
    clouds.loadPixels();
    userMap = context.getUsersPixels(SimpleOpenNI.USERS_ALL);
    for (int y=0;y < context.depthHeight();y+=1) {
      for (int x=0;x < context.depthWidth();x+=1) {
        int i = x + y * 640;
        if (userMap[i] != 0) {
          userImage.pixels[i] = clouds.pixels[i];
        } 
        else {
          userImage.pixels[i] = empireImage.pixels[i];
        }
      }
    }
    clouds.updatePixels();
    userImage.updatePixels();

    if (calibrating==false) {

      //------------------
      //------ Draw the scene, offscreen
      projectorDraw.beginDraw();
      projectorDraw.background (0);
      //projectorDraw.image(bricks,0,0);
      projectorDraw.beginShape();
      projectorDraw.texture(userImage);
      projectorDraw.vertex (0, 0, imageVertexOneX, imageVertexOneY);
      projectorDraw.vertex (projectorDraw.width, 0, imageVertexTwoX, imageVertexTwoY);
      projectorDraw.vertex (projectorDraw.width, projectorDraw.height, imageVertexThreeX, imageVertexThreeY);
      projectorDraw.vertex (0, projectorDraw.height, imageVertexFourX, imageVertexFourY);
      projectorDraw.endShape();
      projectorDraw.endDraw();
    }



    image(userImage, 0, 0);
    //image(bricks,0,0);
  }


  //-------------Skeleton Tracking and drawing.
  // for all users from 1 to 10

    noStroke();


  // render the scene, transformed using the corner pin surface

    //    projectorSurface.render(projectorDraw);
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


  if (maskAlone==true) {
    server.sendImage(userImage);
  }
  
    if (maskAlone==false) {
    server.sendImage(projectorDraw);
  }
}

//---------------------ENDs DRAW LOOP






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


  if (key == 'v') {
    viewRGB=!viewRGB;
  }

  if (key == 'm') {
    maskAlone=!maskAlone;
  }
}

