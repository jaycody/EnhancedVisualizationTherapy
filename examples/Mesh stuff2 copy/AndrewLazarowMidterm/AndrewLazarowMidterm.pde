/*************************************************************
 **********Kinect Tracking to Move Particles******************
 **************Created by Andrew Lazarow**********************
 *******Using elements of: Max Bouchard's Keystone Library****
 **********Dan Shiffman's Toxic Libs Attractor example********
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
 -'s' shows a white circle where the attractor is.
 
 
 */

import java.awt.event.MouseEvent;
import java.io.OutputStream;
import java.util.ArrayList;
import codeanticode.gsvideo.*;
import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

//-----------------------For SimpleOpenNI
import SimpleOpenNI.*;

SimpleOpenNI  context;
boolean       autoCalib=true;

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
Keystone ks2;
CornerPinSurface projectorSurface;
CornerPinSurface cameraViewSurface;
PGraphics projectorDraw;
PGraphics cameraCrop;


//-----------------------ToxicLibs calls.
//ArrayList for particles
ArrayList<Particle> particles;
//Attractor Class
Attractor attractor;
//Toxi particles
VerletPhysics2D physics;


//-----------------------Projector VS Camera variables.

int CXRes; // Variable for Camera X Resolution--if 4:3
int CYRes; // Variable for Camera Y Resolution--if 4:3
int PXRes; // Variable for Projector X Resolution
int PYRes; // Variable for Projector Y Resolution
int passedX;
int passedY;


//-----------------------Sets up Camera


//-----------------------loads Images
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
boolean showAttractor=false;



//----------------------------------------Removes Window Frame
public void init() {
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}


//----------------------------------Setup
void setup() {

  PXRes = 1920; // Variable for Projector X Resolution
  PYRes = 1080;  // Variable for Projector Y Resolution
  CXRes = 640;  // Variable for Camera X Resolution--if 4:3
  CYRes = 480; // Variable for Camera Y Resolution--if 4:3

  size(CXRes+PXRes, PYRes, OPENGL);
  smooth();


  //----------------Initiates Keystone
  ks = new Keystone(this);
  projectorSurface = ks.createCornerPinSurface(PXRes/2, PYRes/2, 20);
  ks2 = new Keystone(this);
  cameraViewSurface = ks.createCornerPinSurface(PXRes/4, PYRes/4, 20);
  //-----------------Sets up offscreen buffer
  projectorDraw = createGraphics(PXRes/2, PYRes/2, OPENGL);
  cameraCrop = createGraphics(PXRes/4, PYRes/4, OPENGL);



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
  crossHairs = loadImage("CrossS.png");

  //----------Setup for the RGB Function
  RGBViewer = createImage(640, 480, ARGB);
  emptyImage = loadImage("emptyImage.png");
  emptyImage.loadPixels();

  //-----------------Sets Up Physics
  physics = new VerletPhysics2D ();
  physics.setDrag(0.05f);
  physics.setWorldBounds(new Rect(0, 0, projectorDraw.width, projectorDraw.height+100));
  physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.5f)));

  particles = new ArrayList<Particle>();
  for (int i = 0; i < 750; i++) {
    particles.add(new Particle(new Vec2D(random(width), PYRes/4), i));
  }

  attractor = new Attractor(new Vec2D(0, 0));
}


//----------------------------------Draw
void draw() {
  frame.setLocation(1680-CXRes, 0);

  background(0);

  //---------Physics Part 1


  if (calibrating==false) {
    physics.update ();
  }


  PVector transformedCoord = cameraViewSurface.getTransformedPassedValues(passedX, passedY);

  //--------------Physics Part 2 Attractor:
  attractor.lock();
  if (calibrating==false) {
    attractor.set(transformedCoord.x*2, transformedCoord.y*2);
    //}




    //------ Draw the scene, offscreen
    projectorDraw.beginDraw();
    //projectorDraw.background(0);
    projectorDraw.fill(0, 20);
    projectorDraw.rect(0, 0, projectorDraw.width, projectorDraw.height); 
    projectorDraw.fill(0, 255, 0);
    projectorDraw.imageMode(CENTER);
    attractor.changeBehavior();
    if (showAttractor==true) {
      attractor.display();
    }
    for (Particle p: particles) {
      p.display();
    }
    projectorDraw.endDraw();
  }

  //--------------------------------------SimpleOpenNI
  stroke(0, 0, 255);
  strokeWeight(3);

  context.update();

  //-------------RGB View Magic Trick.

  if (viewRGB==true) {
    RGBViewFunction();
  }

  //-------------Skeleton Tracking and drawing.
  // for all users from 1 to 10
  int i;
  for (i=1; i<=10; i++)
  {
    // check if the skeleton is being tracked
    if (context.isTrackingSkeleton(i))
    {
      // draw the skeleton
      if (i==1) {
        drawSkeleton(i);  

        // draw a circle for a head 
        circleForRightHand(i);
      }
    }
  }

  noStroke();


  // render the scene, transformed using the corner pin surface



    projectorSurface.render(projectorDraw);
  cameraViewSurface.render(cameraCrop);
  if (calibrating==true) {
    println ("mouse X     " + mouseX + "     mouse Y     " + mouseY);
  }
  //println (surfaceMouse.x);

  if (displayCross==true) {
    imageMode(CENTER);
    image(crossHairs, CXRes+(PXRes/2), PYRes/2);
    image(crossHairs, CXRes/2, CYRes/2);
  }
}


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
  }

  if (key == 't') {
    displayCross=!displayCross;
  }

  if (key == 'r' || key == 'R') {
    rightWind=!rightWind;
  }

  if (key == 'l' || key == 'L') {
    leftWind=!leftWind;
  }

  if (key == 'u' || key == 'U') {
    noGrav=!noGrav;
  }

  if (key == 'g' || key == 'G') {
    addGrav=!addGrav;
  }

  if (key == 'a' || key == 'A') {
    addAttraction=!addAttraction;
  }

  if (key == 'd' || key == 'D') {
    deleteAttraction=!deleteAttraction;
  }

  if (key == 'v') {
    viewRGB=!viewRGB;
  }

  if (key == 's') {
    showAttractor=!showAttractor;
  }
}
/*
void stop() {
 kinect.quit();
 super.stop();
 }
 */
