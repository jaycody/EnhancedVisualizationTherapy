/*************************************************************
 **********Laban Efforts, in Group Behavior******************
 **************Created by Andrew Lazarow**********************
 *******Using elements of: Dan Shiffman's Flocking example****
 ***********and Craig Reynold's Steering Behviors*************
 ***************For ITP, Nature of Code, Spring 2012.*********
 ************************FINAL Draft 1************************
 ************************************************************/

import controlP5.*;

//------------------ControlP5
ControlP5 controlP5;
ControlWindow controlWindow;
public int MaxForce = 50;
public int MaxSpeed = 50;
public int SeekStrength = 50;
public int SeparationStrength = 50;
public int Allignment = 50;
public int Cohesion = 50;
public int Indirection = 0;

//---------------Flock
Flock flock;

//----------Booleans

boolean behavFloat=false;
boolean behavGlide=false;
boolean behavDab=false;
boolean behavFlick=false;
boolean behavWring=false;
boolean behavSlash=false;
boolean behavPunch=false;
boolean behavPress=false;
boolean seekOn=false;
boolean arriverOn=false;
boolean debug = false;
boolean moreBoids=false;
boolean onlyBlack=false;


//---------------------- FlowField
FlowField flowfield;

//---------Image
PImage arrows;


PGraphics offscreen;


//---------------OSC P5
import oscP5.*;
import netP5.*;
int importX=500;
int importY=500;
//----------
OscP5 oscP5;
NetAddress myRemoteLocation;

//-------------SETUP
int projectorWidth = 1920;
int projectorHeight = 1080;

//----------------------------------------Removes Window Frame
public void init() {
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}



//------------------------------------SETUP
void setup() {
  size(projectorWidth, projectorHeight, OPENGL);
  background(0);
  //frameRate(50);
  //-----Flow Field
  flowfield = new FlowField(16);

  //-------Flock
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 10; i++) {
    Boid b = new Boid(width/2, height/2);
    flock.addBoid(b);
  }
  smooth();

  //------------ for Control P5
  controlP5 = new ControlP5(this);
  controlP5.setAutoDraw(false);
  controlWindow = controlP5.addControlWindow("controlP5window", 100, 100, 600, 300);
  controlWindow.hideCoordinates();
  controlWindow.setBackground(color(40));

  //--------------Sliders
  Controller mySlider = controlP5.addSlider("MaxForce", 0, 100, 40, 20, 100, 15);
  mySlider.setWindow(controlWindow);
  Controller mySlider1 = controlP5.addSlider("MaxSpeed", 0, 100, 40, 50, 100, 15);
  mySlider1.setWindow(controlWindow);
  Controller mySlider2 = controlP5.addSlider("SeekStrength", 0, 100, 40, 80, 100, 15);
  mySlider2.setWindow(controlWindow);
  Controller mySlider3 = controlP5.addSlider("SeparationStrength", 0, 100, 40, 110, 100, 15);
  mySlider3.setWindow(controlWindow);
  Controller mySlider4 = controlP5.addSlider("Allignment", 0, 100, 40, 140, 100, 15);
  mySlider4.setWindow(controlWindow);
  Controller mySlider5 = controlP5.addSlider("Cohesion", 0, 100, 40, 170, 100, 15);
  mySlider5.setWindow(controlWindow);
  Controller mySlider6 = controlP5.addSlider("Indirection", 0, 100, 40, 200, 100, 15);
  mySlider6.setWindow(controlWindow);




  //--------------Toggle
  Toggle myToggle1 = controlP5.addToggle("Float", false, 250, 20, 40, 40);
  myToggle1.setWindow(controlWindow);
  Toggle myToggle2 = controlP5.addToggle("Glide", false, 330, 20, 40, 40);
  myToggle2.setWindow(controlWindow);
  Toggle myToggle3 = controlP5.addToggle("Dab", false, 410, 20, 40, 40);
  myToggle3.setWindow(controlWindow);
  Toggle myToggle4 = controlP5.addToggle("Flick", false, 490, 20, 40, 40);
  myToggle4.setWindow(controlWindow);
  Toggle myToggle5 = controlP5.addToggle("Wring", false, 250, 150, 40, 40);
  myToggle5.setWindow(controlWindow);
  Toggle myToggle6 = controlP5.addToggle("Slash", false, 330, 150, 40, 40);
  myToggle6.setWindow(controlWindow);
  Toggle myToggle7 = controlP5.addToggle("Punch", false, 410, 150, 40, 40);
  myToggle7.setWindow(controlWindow);
  Toggle myToggle8 = controlP5.addToggle("Press", false, 490, 150, 40, 40);
  myToggle8.setWindow(controlWindow);


  //---------Window
  controlWindow.setTitle("LabanControls");

  //-------------image
  arrows = loadImage("Arrow1.png");


  offscreen = createGraphics(width, height, OPENGL);

  //--------------OSC
  oscP5 = new OscP5(this, 12000);

  //myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  oscP5.plug(this, "oscReader", "/sendingMouse");
}


//------------OSC Parsing
public void oscReader(int theA, int theB, int theC) {
  //println("### plug event method. received a message /test.");
  //println(" 2 ints received: "+theA+", "+theB);  
  importX = theA;
  importY = theB;
  importX = importX*2;
  importY = importY*2;
  //println(theC);
  //println(importX);
}

//-------------DRAW

void draw() {
  frame.setLocation(1680, 0);



  //background(0);
  fill (0, 70);
  rect(0, 0, width, height);

  setBahviors ();

  //------------------Read and weight from sliders
  float mxForcePass = MaxForce*.0006;
  float mxSpeedPass = MaxSpeed*.04;
  float SkStrngthPass = SeekStrength*.015;
  float SepStrngthPass=SeparationStrength*.035;
  float AllignmentStrngthPass=Allignment*.015;
  float CohesionStrngthPass=Cohesion*.015;
  float IndirectionStrngthPass=Indirection*.01;

  //------------------Draw to PGraphics images for Sketch and Syphon
  offscreen.beginDraw();
  offscreen.fill (0, 70);
  //--------Debug Draw
  if (debug) flowfield.display();
  offscreen.rect(0, 0, width, height);
  flock.run(mxForcePass, mxSpeedPass, SkStrngthPass, SepStrngthPass, AllignmentStrngthPass, CohesionStrngthPass, IndirectionStrngthPass);
  offscreen.endDraw();  

  if (onlyBlack==false) {
    image(offscreen, 0, 0);
  }

  if (onlyBlack==true) {
    background(0);
  }
  // Add a new boid into the System
  if (moreBoids==true) {
    flock.addBoid(new Boid(importX, importY));
    println("adding");
    //moreBoids=false;
  }
  /*
  fill (255,0,0);
   ellipse(importX, importY, 100,100);
   */
}


//---------------OSC Messages
/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {

  if (theOscMessage.isPlugged()==false) {
    /* print the address pattern and the typetag of the received OscMessage */
    //println("### received an osc message.");
    //println("### addrpattern\t"+theOscMessage.addrPattern());
    //println("### typetag\t"+theOscMessage.typetag());
  }
}






void keyPressed() {
  if (key == 'f') {
    behavFloat=!behavFloat;
  }

  if (key == 'a') {
    arriverOn=!arriverOn;
  }

  if (key == 'm') {
    moreBoids=!moreBoids;
  }

  if (key == 'b') {
    onlyBlack=!onlyBlack;
  }

  if (key == 's') {
    seekOn=!seekOn;
  }

  if (key == 'w') {
    flowfield.init();
    ;
  }

  if (key == ' ') {
    debug = !debug;
  }
}

