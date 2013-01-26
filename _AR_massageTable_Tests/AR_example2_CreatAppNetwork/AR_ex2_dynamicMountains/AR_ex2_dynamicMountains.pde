/*jason stephens
thesis - itp
AR_Acupressure

from the tutorial:
 Augmented Reality Dynamic Example by Amnon Owed (21/12/11)
Processing 1.5.1 + NyARToolkit 1.1.6 + GSVideo 1.0

TODO:
_____Control PS3 Auto Color Correct etc.
_____Create AR Class System
*/

import java.io.*; // for the loadPatternFilenames() function
import processing.opengl.*; // for OPENGL rendering
import jp.nyatla.nyar4psg.*; // the NyARToolkit Processing library
import codeanticode.gsvideo.*; // the GSVideo library
String camPara, patternPath;

// the dimensions at which the AR will take place. with the current library 1280x720 is about the highest possible resolution
// these need to be multiples of the capture resolution
int arWidth = 320;//640
int arHeight = 240; //360 original

// the number of pattern markers (from the complete list of .patt files) that will be detected, here the first 10 from the list.
int numMarkers = 50;

// the resolution at which the mountains will be displayed
int resX = 30;//60=original
int resY = 30;//60=original

// this is a 2 dimensional float array that all the displayed mountains use during their update-to-draw routine
float[][] val = new float[resX][resY];

GSCapture cam0;

MultiMarker nya;

float[] scaler = new float[numMarkers];
float[] noiseScale = new float[numMarkers];
float[] mountainHeight = new float[numMarkers];
float[] mountainGrowth = new float[numMarkers];

void setup() {

  camPara = "camera_para.dat";
  patternPath = dataPath("ARToolKit_Patterns");

 size(1024, 768,OPENGL);
  //size(640, 480,OPENGL);

  //cam0 = new GSCapture(this, 640, 480, "DV Video:0");  //firewire camera
  cam0 = new GSCapture(this, 640, 480, "Sony HD Eye for PS3 (SLEH 00201)"); //PS3
  cam0.start(); // start capturing

  //get resolution
  int[][] res0 = cam0.resolutions();
  for (int i = 0; i < res0.length; i++) {
    println(res0[i][0] + "x" + res0[i][1]);
  } 
  //get fps
  String [] fps0 = cam0.framerates();
  for (int i= 0; i <fps0.length; i++) {
    println(fps0[i]);
  }

  noStroke(); // turn off stroke for the rest of this sketch :-)
  
  // create a new MultiMarker at a specific resolution (arWidth x arHeight), with the default camera calibration and coordinate system
  nya = new MultiMarker(this, arWidth, arHeight, camPara, NyAR4PsgConfig.CONFIG_DEFAULT);

  // set the delay after which a lost marker is no longer displayed. by default set to something higher, but here manually set to immediate.
  nya.setLostDelay(100); //'1' = immediate (origninal setting)

  String[] patterns = loadPatternFilenames(patternPath);
  // for the selected number of markers, add the marker for detection
  // create an individual scale, noiseScale and maximum mountainHeight for that marker (= mountain)
  for (int i=0; i<numMarkers; i++) {
    nya.addARMarker(patternPath + "/" + patterns[i], 80);
    scaler[i] = random(1.8, 2.3); // scaled a little smaller or bigger
    noiseScale[i] = random(0.02, 0.075); // the perlin noise scale to make it look nicely mountainy
    mountainHeight[i] = random(75, 250); // the maximum height of a mountain
  }
}

void draw() {

  // if there is a cam image coming in...
  if (cam0.available()) {
    cam0.read(); // read the cam image
    background(0); // a background call is needed for correct display of the marker results
    image(cam0, 0, 0, width, height); // display the image at the width and height of the sketch window

    // create a copy of the cam image at the resolution of the AR detection (otherwise nya.detect will throw an assertion error!)
    PImage cSmall = cam0.get();
    cSmall.resize(arWidth, arHeight);
    nya.detect(cSmall); // detect markers in the image
    drawMountains(); // draw dynamically flowing mountains on the detected markers (3D)
  }
}

// this function draws correctly placed 3D 'mountains' on top of detected markers
// while the mountains are displayed they grow (up to a certain point), while not displayed they return to the zero-state
void drawMountains() {
  // set the AR perspective uniformly, this general point-of-view is the same for all markers
  nya.setARPerspective();
  // turn on some general lights (without lights it also looks pretty cool, try commenting it out!)
  lights();
  // for all the markers...
  for (int i=0; i<numMarkers; i++) {
    // if the marker does NOT exist (the ! exlamation mark negates it)...
    if ((!nya.isExistMarker(i))) {
      // if the mountainGrowth is higher than zero, decrease by 0.05 (return to the zero-state), then continue to the next marker
      if (mountainGrowth[i] > 0) { 
        mountainGrowth[i] -= 0.05;
      }
      continue;
    }

    // the following code is only reached and run if the marker DOES EXIST
    // if the mountainGrowth is lower than 1, increase by 0.03
    if (mountainGrowth[i] < 1) { 
      mountainGrowth[i] += 0.03;
    }
    // the double for loop below sets the values in the 2 dimensional float array for this mountain, based on it's noiseScale, mountainHeight and index (i).
    float xoff = 0.0;
    for (int x=0; x<resX; x++) {
      xoff += noiseScale[i];
      float yoff = 0;
      for (int y=0; y<resY; y++) {
        yoff += noiseScale[i];
        val[x][y] = noise(i*10+xoff+frameCount*0.05, yoff) * mountainHeight[i]; // this sets the value
        float distance = dist(x, y, resX/2, resY/2);
        distance = map(distance, 0, resX/2, 1, 0);
        if (distance < 0) { 
          distance = -distance;
        } // this line causing the four corners to flap upwards (try commenting it out or setting it to zero)
        val[x][y] *= distance; // in the default case this makes the value approach zero towards the outer ends (try commenting it out to see the difference)
      }
    }
    // get the Matrix for this marker and use it (through setMatrix)
    setMatrix(nya.getMarkerMatrix(i));
    scale(1, -1); // turn things upside down to work intuitively for Processing users
    scale(scaler[i]); // scale the mountain by it's individual scaler
    translate(-resX/2, -resY/2); // translate to center the mountain on the marker
    // for the full resolution...
    for (int x=0; x<resX-1; x++) {
      for (int y=0; y<resY-1; y++) {
        // each face is a Shape with a fill color, together they make a colored mountain
        fill(x*20+y*20, 255-x*5, y*5);
        beginShape();
        vertex(x, y, val[x][y] * mountainGrowth[i]);
        vertex((x+1), y, val[x+1][y] * mountainGrowth[i]);
        vertex((x+1), (y+1), val[x+1][y+1] * mountainGrowth[i]);
        vertex(x, (y+1), val[x][y+1] * mountainGrowth[i]);
        endShape(CLOSE);
      }
    }
  }

  // reset to the default perspective
  perspective();
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

