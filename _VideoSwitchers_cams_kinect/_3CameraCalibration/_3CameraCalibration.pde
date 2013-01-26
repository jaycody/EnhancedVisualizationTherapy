/*jason stephens
EV Therapy - Thesis
3 Camera Calibration (640*3, 0)

1 PS Eye, 1 USB Cam, 1 Kinect)

 */

import processing.video.*;
import SimpleOpenNI.*;

Capture cam1;
Capture cam2;
SimpleOpenNI  kinect;
//Capture cam3;

void setup() {
  size(640*3, 480);
  
// start OpenNI, loads the library
  SimpleOpenNI.start();

  // If no device is specified, will just use the default.
  //cam = new Capture(this, 320, 240, 8);

  // To use another device (i.e. if the default device causes an error),  
  // list all available capture devices to the console to find your camera.
  String[] devices = Capture.list();
  println(devices);

  // Change devices[0] to the proper index for your camera.
  cam1 = new Capture(this, 640, 480, devices[8]);
  cam2 = new Capture(this, 640, 480, devices[9]);
  kinect = new SimpleOpenNI(this);
  // cam3 = new Capture(this, 640, 480, devices[7]);
  
  kinect.enableRGB();

  // Opens the settings page for this capture device.
  cam1.settings();
  cam2.settings();
  //   cam3.settings();
}


void draw() {
  
  kinect.update();
   // load the color image from the Kinect
  PImage rgbImage = kinect.rgbImage();
image(rgbImage,640*2,0);
  
  if (cam1.available() == true) {
    cam1.read();
    //image(cam, 0, 0);
    // The following does the same, and is faster when just drawing the image
    // without any additional resizing, transformations, or tint.
    set(0, 0, cam1);
  }

  if (cam2.available() == true) {
    cam2.read();
    //image(cam2, 640, 0);
    // The following does the same, and is faster when just drawing the image
    // without any additional resizing, transformations, or tint.
    set(640, 0, cam2);
  }
  
  //  if (cam3.available() == true) {
  //    cam3.read();
  //    //image(cam2, 640, 0);
  //    // The following does the same, and is faster when just drawing the image
  //    // without any additional resizing, transformations, or tint.
  //    set(640*2, 0, cam3);
  //  }
} 

