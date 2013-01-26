/*jason stephens
 EV Therapy - Thesis
 3 Camera Switcher
 
 Camera Configuration as follows:
 1 USB Cam, PS3 Eye, Kinect -> Starting from USB port furthest away 1-3
 
 USE The touchOSC layout:  "_3CameraSwitcher_iPadControls"
 
 
 TODO: 
 DONE_____connect iPad Controls.
 DONE_____setMirror
DONE _____find FPS and aspect ratio for each camera.
 
 _____position cameras in massage space
 _____swap out web cam for PS3 Eye
 _____get command over auto camera controls 
 _____add controls to the ipad
 _____recreate in openFrameworks
 _____add virtual camera control
 
 */


//import processing.opengl.*;
import processing.video.*;
import SimpleOpenNI.*;
import oscP5.*;  // ipad action
import netP5.*;  // ipad action

Capture cam1;
Capture cam2;
SimpleOpenNI  kinect;
OscP5 oscP5;


PImage mainCam;
int lastKeyPressed = 2;
boolean setMirror = false;
boolean wasOn = false;

void setup() {
  size (1024, 768); //OPENGL does not work
  //size(640, 480);

  //start the oscP5 listening for incoming messages at port 8000
  oscP5 = new OscP5(this, 8000);

  // start OpenNI, loads the library
  SimpleOpenNI.start();

  //_____________________________LIST CAMERAS
  // list all available capture devices to the console to find your camera.
  String[] devices = Capture.list();
  println(devices);
  // list all Kinects
  // print all the cams 
  StrVector strList = new StrVector();
  SimpleOpenNI.deviceNames(strList);
  for (int i=0;i<strList.size();i++)
    println(i + ":" + strList.get(i));
  //_____________________________LIST CAMERAS

  //_____________________________AssignCameras
  // Change devices[0] to the proper index for your camera.
  cam1 = new Capture(this, 640, 480, devices[8]);
  cam2 = new Capture(this, 640, 480, devices[9]);
  kinect = new SimpleOpenNI(0, this);
  // cam3 = new Capture(this, 640, 480, devices[7]);
  kinect.enableRGB();
  // Opens the settings page for this capture device.
  cam1.settings();
  cam2.settings();
  //_____________________________AssignCameras
  
  //_____________________________GetResolutions

  
}


void draw() {

  PImage mainCam = readCameras();   // 
  if (setMirror) {
    pushMatrix();
    scale(-1, 1);
    translate(-width, 0);
    image(mainCam, 0, 0, 640*1.6, 480*1.6);
    popMatrix();
  }
  else if (!setMirror) {
    image(mainCam, 0, 0, 640*1.6, 480*1.6);
  }



  //loadPixels(); 
  // mainCam.loadPixels();
  // create a mirror image
  //now loop through pixels
  //  for (int x = 0; x<mainCam.width; x++) {
  //    for (int y = 0; y<mainCam.height; y++) {
  //      int loc = (mainCam.width - x-1) + y*mainCam.width;
  //      int i = x+y*mainCam.width;
  //      mainCam.pixels[i] = mainCam.pixels[loc];
  //    }
  //  }
}


PImage readCameras () {   //return a Pimage

  if (lastKeyPressed == 1) {
    if (cam1.available() == true) {
      cam1.read();
    }
    mainCam = cam1;
  }
  if (lastKeyPressed == 2) {
    if (cam2.available() == true) {
      cam2.read();
    }
    mainCam = cam2;
  }

  if (lastKeyPressed == 3) {
    kinect.update();
    mainCam = kinect.rgbImage();
  }

  // println (lastKeyPressed);
  return mainCam;
}

void keyPressed() {
  if (key == '1') {
    lastKeyPressed = 1;
  }
  else if (key == '2') {
    lastKeyPressed = 2;
  }
  else if (key == '3') {
    lastKeyPressed = 3;
  }
  else if (key == '4') {  //setMirror
    setMirror = !setMirror;
  }
}

// create a function to receive and parse oscP5 messages.
void oscEvent (OscMessage theOscMessage) {

  String addr = theOscMessage.addrPattern();  //never did fully understand string syntaxxx
  float val = theOscMessage.get(0).floatValue(); // this is returning the get float from bellow

  if (addr.equals("/1/cam1")) {  //remove the if statement and put it in draw
    lastKeyPressed =1;

    //rcvLookLR = val; //assign received value.  then call function in draw to pass parameter
  }
  else if (addr.equals("/1/cam2")) {
    lastKeyPressed = 2;
    // rcvLookUD = val;// assigned receive val. prepare to pass parameter in called function: end of draw
  }
  else if (addr.equals("/1/kinect")) {
    lastKeyPressed = 3;
    // rcvLookUD = val;// assigned receive val. prepare to pass parameter in called function: end of draw
  }
  else if (addr.equals("/1/setMirror")) {
    setMirrorFunction(val);
  }
 //   println(lastKeyPressed);
}


//___________________________________________FUNCTIONAL DEBOUNCER!!!!!!!!!
void setMirrorFunction (float osc) {  //DEBOUNCING THE BUTTON
  if ((osc == 1) && (wasOn)) {
    setMirror = !setMirror;
    wasOn = false;
  }
  if ((osc == 1) && (!wasOn)) {
    wasOn = true;
  }
}

