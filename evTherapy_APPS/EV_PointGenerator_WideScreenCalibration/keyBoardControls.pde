//___________________________________Controls
void keyPressed() {
  
  //_________________________________first use the switch::case method
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // & moved
    //ks.toggleCalibration();
    //calibrating=!calibrating;
    //where Andrew's ks.toggleCalibration() looks like this::
    //_________________________________
    /* ignore input events if the calibrate flag is not set
		if (!calibrate)
			return;
    */

    break;
  }
  //__________________________________
  
  
  
  if (key == '1') {
    lastKeyPressed = 1;
  }
  else if (key == '2') {
    lastKeyPressed = 2;
  }
  else if (key == '3') {
    lastKeyPressed = 3;
  }
   else if (key == '4') {
      showDepthImage = (!showDepthImage);
      showBoundingBox = (!showBoundingBox);
     closestPointResolutionScreen.background(0);
  }
  
//  //thanks Andrew
//  if (key == 't') {
//    displayCross=!displayCross;
//  }
//
//  if (key == 'r' || key == 'R') {
//    rightWind=!rightWind;
//  }
//
//  if (key == 'l' || key == 'L') {
//    leftWind=!leftWind;
//  }
//
//  if (key == 'u' || key == 'U') {
//    noGrav=!noGrav;
//  }
//
//  if (key == 'g' || key == 'G') {
//    addGrav=!addGrav;
//  }
//
//  if (key == 'a' || key == 'A') {
//    addAttraction=!addAttraction;
//  }
//
//  if (key == 'd' || key == 'D') {
//    deleteAttraction=!deleteAttraction;
//  }
//
//  if (key == 'v') {
//    viewRGB=!viewRGB;
//  }
//
//  if (key == 's') {
//    showAttractor=!showAttractor;
//  }
//  else if (key == ' ') {
//    counter++;
//  }
  
  
  
  
}

void printInstructions () {
  println("Space Bar Toggles DepthImage");
}

