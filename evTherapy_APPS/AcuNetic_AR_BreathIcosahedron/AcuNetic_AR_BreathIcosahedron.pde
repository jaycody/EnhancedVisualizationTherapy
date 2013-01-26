// jason stephens
// Project Development Studio
// ITP - NYU - Spring 2011
// Intelligent Healing Spaces
// HandTracking:
// __ICOSAHEDRON
// __Paricle System Asteroids from NOC Midterm

/* --------------------------------------------------------------------------
 * Branched 24April2011
 * from:  SimpleOpenNI Hands3d Test : 02/27/2011
 * Processing Wrapper for the OpenNI/Kinect library
 * ----------------------------------------------------------------------------
 */

/* To-Do:

____get just RGB working with icosahedrons
____then add......
 __Setup threhold controls          DONE
 __Save as version 1 and lockit      DONE
 __Start version 2 with object      DONE
 __Add simple object              DONE  
 __Drop Object   DONE
 __Stationary Object Rotates   DONE
 __Switch Objects  DONE
 __Add particle system ASTEROIDS  DONE
 __Tweak Asteroids Controls
 __Add OTHER particle system
 */

/* CONTROLS
 'd' toggles showDepthMap
 UpDown Arrrows changes angle
 Shift UpDown Zooms
 
 1, 2, 3 = threshold controls
 1 = 1 place holder (or increments of 1)
 2 = 2 place holder (or increments of 2)
 3 = 3 place holder (or increments of 3)
 
 -----ICOSAHEDRON CONTROLS--------
 6 = ON/OFF for ico1  [both icos start off]
 y = placement of ico1
 5 = ON/OFF for ico2  [both icos start off]
 t = placement of ico2
 
 _____LOVER ASTEROID CONTROLS_______
 9 = ON/OFF for ASTEROIDS
 o = placement of ASTEROID ATTRACTOR
 i = show VECTORS
 l = show mutual attractions
 
 
 TO DO
 __create array of Lover Objects
 __create an attractor object
 __incorporate attractor
 __create ability to "place" the attractor
 */

import SimpleOpenNI.*;
import processing.opengl.*;
SimpleOpenNI context;

//prepare for 3D view with AR added
boolean RGBviewer = true;
PImage rgbImage;
int lastKeyPress = 0;

// PGraphic to get just the RGBImage
PGraphics PG_RGB;

//_______Hand Tracking Variables_________
float        zoomF =0.5f;
float        rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
// the data from openni comes upside down
float        rotY = radians(0);
float        depthThreshold = 2300;  //testing at Orchard St setup reveals 0-2300 index depth
boolean      handsTrackFlag = false;
boolean      showDepthMap = true;
PVector      handVec = new PVector();
ArrayList    handVecList = new ArrayList();
int          handVecListSize = 60;
String       lastGesture = "";

// _______ICOSAHEDRON VARIABLES________
// declare the Icosahedron object
Icosahedron ico1;
Icosahedron ico2;
// icosahedron permanent location variables
float ico1Size = 75;//1st
//float ico1Size = 30;//1st
boolean      ico1On   = false;  // '6'  ON/OFF
boolean      ico1Move = true; //  'y'  MOVE 
float        icoLocX;  //permanent location of icosahedron
float        icoLocY;  //permanent location of icosahedron
float        icoLocZ;  //permanent location of icosahedron

// ico2 permanent location variables
float ico2Size = 100;//first
//float ico2Size = 50;//first
boolean      ico2On = false;  // '5'  ON/OFF
boolean      ico2Move = true; //  't' MOVE
float        ico2LocX;  //permanent location of ico2
float        ico2LocY;  //permanent location of ico2
float        ico2LocZ;  //permanent location of ico2

// _______ASTEROID OBJECT VARIABLES_________

//array of moving objects
Lover [] lovers = new Lover [10];   // LOVER Class Arguments = loc.x, loc.y, w, h, mass, topspeed

// an array of Attractors
Attractor [] attractors = new Attractor [1];  // where attractor index [0] = hand controlled

boolean attractor = false;
boolean showVectors = false;  //show vectors of asteroids
boolean repel = false;  //between asteroids repel
boolean showMutualAttractions = false; //show vectors between asteroids
boolean permAttractor  = true;

PVector gravity;
float x; //initial location
float y; //initial location
float z; //initial location
float G; //gravitational constant for attractors
float topspeed; // so shit don't get out of control

float attLocX;//for permanent location of attractor
float attLocY;
float attLocZ;



void setup()
{
  size(1024, 768, P3D);  // 
  //size(1024, 768, OPENGL); 
  background(0);
  
  PG_RGB = createGraphics (640, 480, P2D);//retain aspect ratio for index boundary

  // ___ICOSAHEDRON___
  ico1 = new Icosahedron(ico1Size);  // create instance of ico1
  ico2 = new Icosahedron(ico2Size);  // create instance of ico2

  //_______________________ASTEROIDS SETUP
  gravity = new PVector (0, .5);
  topspeed = 15;

  //+++++++INITIALIZE Attractor []++++++++arguments: PVector loc, mass, Gravitational Constant
  // for (int i = 0; i<attractors.length; i++) {
  //   if (i != 0) {  // random parameters for all other attractors in the array
  //    attractors[i] = new Attractor (new PVector (random(0, width), random(0, height)), random (15, 40), random (8, 13));
  //   }
  attractors[0] = new Attractor (new PVector(width/2, height/2), 120, 80); // Loc, mass, gravity


  //________INITIALIZE Lover [] arguments: loc.x, loc.y, loc.z, mass,, topspeed, drawVectorSize, G_Constant
  for (int i = 0; i<lovers.length; i ++) {
    lovers[i] = new Lover (new PVector (random(0, width), random(0, width), random(-100, 100)), random(40, 50), 50, 50, 1);  //arg= LocPVector(x,y,z), mass,topspeed, vectorsize,G
  }
  //_______________________________

  //______________________________
  // Setting up SimpleOpenNI
  context = new SimpleOpenNI(this);
  // disable mirror
  context.setMirror(false);
  // enable depthMap generation 
  context.enableDepth();
  context.enableRGB();
  context.alternativeViewPointDepthToImage();
  rgbImage = createImage(620, 480, RGB);
  // enable hands + gesture generation
  context.enableGesture();
  context.enableHands();
  // add focus gestures 
  context.addGesture("RaiseHand");
  // set how smooth the hand capturing should be
  //context.setSmoothingHands(-50);  //lower is smoother
  //______________________________

  stroke(255, 255, 255);
  smooth();

  perspective(95.0f, 
  float(width)/float(height), 
  10.0f, 150000.0f);

  print("'0' = showPointCloud");
  println("'1' = showRGB");
}

void draw() {
  // update the cam
  context.update();
  background(0);
  // set the scene pos
  translate(width/2, height/2, -250);// original = (w/2,h/2,0)
  rotateX(rotX);
  //rotateY(radians(mouseY));
  scale(zoomF);
  //scale(mouseX*.008);
  
  
  //int[]   depthMap = context.depthMap();
  int     steps   = 5;  // to speed up the drawing, draw every third point
  //int     index;
  //PVector realWorldPoint;

 // PImage rgbImage = context.rgbImage();

//-----------------------------comment out ColoredPointCloud

  translate(0, 0, -1000);  // set the rotation center of the scene 1000 infront of the camera 
  PVector[] depthPoints = context.depthMapRealWorld();
  // don't skip any depth points
  for (int i = 0; i < depthPoints.length; i+=steps) {
    //original increment of for loop counter set to 1
    PVector currentPoint = depthPoints[i];
    // set the stroke color based on the color pixel
    //dontDrawIt
  //  stroke(rgbImage.pixels[i]);
   // point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
  
  //step in with the PG_RGB
  PG_RGB.beginDraw();
  PG_RGB.image(context.rgbImage(), 0, 0);
  PG_RGB.endDraw();
  image(PG_RGB, 0, 0);

  
  
  
  /*  ------previous method for creating point cloud excluded color
  for (int y=0;y < context.depthHeight();y+=steps)
  {
    for (int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      //if (depthMap[index] > depthThreshold){ //original
      if (depthMap[index] < depthThreshold) { // tested to 2300 for depthMap index size.

        // draw the projected point
        realWorldPoint = context.depthMapRealWorld()[index];
        if (showDepthMap == true) {
          point(realWorldPoint.x, realWorldPoint.y, realWorldPoint.z);
        }
      }
    }
  }
  */







// draw the tracked hand
pushStyle();  //pushStyle here so that the nested iff statements about icosahedron can keep style same
if (handsTrackFlag) {
  //iteratorShape();
  stroke(0, 0, 255);
  strokeWeight(4);
  fill(0, 0, 255);
  sphereDetail(15);
  //lights();
  ambientLight(102, 102, 102);
  directionalLight(255, 255, 255, 0, 0, 1);
  // point(handVec.x, handVec.y, handVec.z);


  //HAND ATTRACTOR and LOVERS
  if (attractor) {
    // if you are [0] then use other fucnction to calc location
    attractors[0].handControlled(handVec.x, handVec.y, handVec.z); //pass the hand variables to attractor


    // Lovers[] forLoop -> applyforces (gravity), update, display, checksides
    for (int i=0 ; i < lovers.length; i ++) {
      // just send it to it's class.  why not?
      if (permAttractor) {
        lovers[i].handControlled(handVec.x, handVec.y, handVec.z);


        lovers[i].update();
        lovers[i].displayLovers();
        //lovers[i].checksides();
        lovers[i].checkspeed();

        // SEND Each lovers[] to EACH attractors[] and RETURN GravForce -> Nested ForLoop
        //if attractor[0], then use function for calc grav at mouse location
        PVector f = attractors[0].calcGravForceKinect (lovers[i]);
        lovers[i].applyforce(f);
      }

      // drawVector (f, lovers[i].getLoc(), 2);    
      //drawVector (lovers[i].getLoc(), lovers[i].getLoc(), 20);
    }
  }



  //creat ico1  //ico1 must MOVE '6'  AND it must be ON '6'
  if ((ico1Move == true) && (ico1On == true)) {  // ico1Move = 'y'  ico1On = '6'
    pushMatrix();
    pushStyle();
    //    stroke(150, 0, 180);
    //    fill(170, 170, 0);
    stroke(255, 255, 255, 255);
    fill(0, 0, 255, 255);
    translate (handVec.x, handVec.y, handVec.z-ico1Size);
    rotateX(handVec.y*PI/(ico1Size*3.5));
    rotateY(handVec.x*PI/(ico1Size*3.5));
    // rotateZ(
    ico1.create();
    popStyle();
    popMatrix();
  }

  // create ico2 // Moving AND On
  if ((ico2Move == true) && (ico2On == true)) {  //ico2Move = 't' ico2On = '5'
    pushMatrix();
    pushStyle();
    strokeWeight(4);
    stroke(0, 0, 0, 255);
    fill(255, 0, 0, 255);
    translate (handVec.x, handVec.y, handVec.z-ico2Size);
    rotateX(handVec.y*PI/(ico2Size*3.5));
    rotateY(handVec.x*PI/(ico2Size*3.5));
    ico2.create();
    popStyle();
    popMatrix();
  }

  //ellipse in my hand
  //    pushMatrix();
  //    translate (handVec.x, handVec.y, handVec.z);
  //    //ellipse(0, 0, 60, 60);
  //    popMatrix();
  // popStyle();
}

// place ico1 and rotate permanent
if ((ico1Move == false) && (ico1On = true)) {
  pushMatrix();
  pushStyle();
  strokeWeight(4);
  stroke(255, 255, 255, 255);
  fill(0, 0, 255, 255);
  translate (icoLocX, icoLocY, icoLocZ);
  rotateX(icoLocY*PI/(ico1Size*3.5));  // so that when the icosahedron stops, it does so at the same location
  rotateY(icoLocX*PI/(ico1Size*3.5));  // so that when the icosahedron stops, it does so at the same location

  rotate(frameCount*PI/100); //so ico1 rotates when stationary
  ico1.create();
  popStyle();
  popMatrix();
}

//place ico2 and rotate permanent
if ((ico2Move == false) && (ico2On == true)) {  
  // ico2 must be BOTH Not Moving AND On if it is to be stationary
  pushMatrix();
  pushStyle();
  strokeWeight(4);
  stroke(0, 0, 0, 255);
  fill(255, 0, 0, 255);
  translate (ico2LocX, ico2LocY, ico2LocZ);
  rotateX(ico2LocY*PI/(ico2Size*3.5));  // so that when the icosahedron stops, it does so at the same location
  rotateY(ico2LocX*PI/(ico2Size*3.5));  // so that when the icosahedron stops, it does so at the same location

  rotate(frameCount*(-PI/100)); //so ico1 rotates when stationary
  ico2.create();
  popStyle();
  popMatrix();
}

//permanent placement of attractor
if (!permAttractor) {
  for (int i=0 ; i < lovers.length; i ++) {
    // just send it to it's class.  why not?

    lovers[i].handControlled(attLocX, attLocY, attLocZ);

    lovers[i].update();
    lovers[i].displayLovers();
    //lovers[i].checksides();
    lovers[i].checkspeed();

    // SEND Each lovers[] to EACH attractors[] and RETURN GravForce -> Nested ForLoop
    //if attractor[0], then use function for calc grav at mouse location
    PVector f = attractors[0].calcGravForceKinect (lovers[i]);
    lovers[i].applyforce(f);
  }
}


popStyle();

// draw the kinect cam
//context.drawCamFrustum();
}
