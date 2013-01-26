// Controls for the Keystone object
void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // & moved
    ks.toggleCalibration();
    break;
  case 'l':
    // loads the saved layout
    ks.load();
    break;
  case 's':
    // saves the layout
    ks.save();
    break;
  }
}
void keyStonedSurface(){
   // convert normal mouse and convert it to new cordinates
  PVector mouse = surface.getTransformedMouse();
  // first draw the sketch offscreen
  offscreen.beginDraw();
  //offscreen.background(50);
  offscreen.image(kinect.depthImage(),0,0);
  offscreen.lights();
  offscreen.fill(255);
  offscreen.translate(mouse.x, mouse.y);
  offscreen.rotateX(millis()/200.0);
  offscreen.rotateY(millis()/400.0);
  offscreen.box(100);
  offscreen.endDraw();
  // then render the sketch using the 
  // keystoned surface
  background(0);
  surface.render(offscreen.getTexture());
}
void printInstructions () {
  println("Space Bar Toggles Depth/RGBImage"); 
  println("Use Arrow Keys to adjust size of initial bounding box");
}

