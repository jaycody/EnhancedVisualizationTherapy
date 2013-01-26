/*jason stephens
 thesis - itp
 AR_Acupressure_withClasses
 
 from the tutorial:
 Augmented Reality Dynamic Example by Amnon Owed (21/12/11)
 Processing 1.5.1 + NyARToolkit 1.1.6 + GSVideo 1.0
 
 TODO:
 _____Control PS3 Auto Color Correct etc.
 _____Create AR Class System
 */

import codeanticode.glgraphics.*;
import java.io.*; // for the loadPatternFilenames() function
import processing.opengl.*; // for OPENGL rendering
import jp.nyatla.nyar4psg.*; // the NyARToolkit Processing library
import codeanticode.gsvideo.*; // the GSVideo library
String camPara, patternPath;


MultiMarker nya;
GSCapture cam;

// this is the arraylist that holds all the objects
ArrayList <ARObject> ars = new ArrayList <ARObject> ();

int arWidth = 320;
int arHeight = 240;

// the number of pattern markers (from the complete list of .patt files) 
//that will be detected, here the first 10 from the list.
int numMarkers = 10;

// the maximum rotation speed (x, y, z) at which the RGBCubes will rotate
float mS = 0.2;



void setup() {

  //insert these lines to point to the data folder
  camPara = "camera_para.dat";
  patternPath = dataPath("ARToolKit_Patterns");

  size(1024, 768, GLConstants.GLGRAPHICS);
 cam = new GSCapture(this, 640, 480, "DV Video:0");  //firewire camera
//cam = new GSCapture(this, 640, 480, "Sony HD Eye for PS3 (SLEH 00201)"); //PS3
  
  cam.start(); // start capturing

  // initialize the MultiMarker at a specific resolution (make sure to input images for detection EXACTLY at this resolution)
  nya = new MultiMarker(this, arWidth, arHeight, camPara, NyAR4PsgConfig.CONFIG_DEFAULT);

  // set the delay after which a lost marker is no longer displayed. by default set to something higher, but here manually set to immediate.
  nya.setLostDelay(50000000);// where '1' = immediate
  
  // load the pattern filenames (markers)
  String[] patterns = loadPatternFilenames(patternPath);
  // for the selected number of markers...
  for (int i=0; i<numMarkers; i++) {
    // add the marker for detection
    nya.addARMarker(patternPath + "/" + patterns[i], 80);
    // and create an ARObject with the corresponding 'ID'
    ars.add(new ARObject(i));
  }

  // set the color range to 1 (instead of 255), saves typing for the coloring of the cube
  colorMode(RGB, 1);
  // turn off stroke for the rest of the sketch
  noStroke();
  
  frameRate(60);
}



void draw() {
  // if there is a cam image coming in...
  if (cam.available()) {
    cam.read(); // read the cam image
    background(0); // a background call is needed for correct display of the marker results
    image(cam, 0, 0, width, height); // display the image at the width and height of the sketch window
    // create a copy of the cam image at the resolution of the AR detection (otherwise nya.detect will throw an assertion error!)
    PImage cSmall = cam.get();
    cSmall.resize(arWidth, arHeight);
    nya.detect(cSmall); // detect markers in the image
    // set the AR perspective uniformly, this general point-of-view is the same for all markers
    nya.setARPerspective();
    
    // run all the ARObjects's in the arraylist => most things are handled inside the ARObject (see the class for more info)
    for (ARObject ar : ars) { 
      ar.run();
    }

    // reset to the default perspective
    perspective();
  }
}



// this function loads .patt filenames into a list of Strings based on a full path to a directory (relies on java.io)
String[] loadPatternFilenames(String path) {
  File folder = new File(path);
  FilenameFilter pattFilter = new FilenameFilter() {
    public boolean accept(File dir, String name) {
      return name.toLowerCase().endsWith(".patt");
    }
  };
  return folder.list(pattFilter);
}

