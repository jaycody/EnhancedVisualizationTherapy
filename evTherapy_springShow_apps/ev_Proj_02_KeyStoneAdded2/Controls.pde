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

  case 'd' :
    depthSwitch = !depthSwitch;
    break;

  case 'r' :
    surfaceRender = !surfaceRender;
    break;
  }
}
 /* 
  if (key == CODED) {
    if (keyCode == UP) {
      //increase height
      startY -= 5;
      endY+=5;
    } 
    else if (keyCode == DOWN) {
      //decrease height
      startY+=5;
      endY-=5;
    } 
    else if (keyCode == LEFT) {
      //decrease size
      startX += 5;
      endX -=5;
    }
    else if (keyCode == RIGHT) {
      //increase
      startX-=5;
      endX +=5;
    }
  }
  */

  //bio star
  //background(0);
  //d1 = 0;
  //  if (key == 'c')
  //    num ++;
  //  if (key == 'v')
  //    num--;
  //  if (num == 1)
  //    num = 2;

//-------------------------------------------MOVE THE SCREEN
void init() { 
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}




//------------------------------------------PRINTING
void printDebug (PVector surfaceMouse) {
  println("mouseX = " + mouseX + " :: surfaceMouse.x = " + surfaceMouse.x);
}
void printInstructions () {
  println("'c' toggles calibration");
  println("'s' saves the keystone layout as xml");
  println("'l' loads a keystone layout xml");
  println("'d' toggles depthSwitch");
  println("'r' toggles surfaceRender and depthSwitch");
  println("Space Bar Toggles Depth/RGBImage"); 
  println("Use Arrow Keys to adjust size of initial bounding box");
}

