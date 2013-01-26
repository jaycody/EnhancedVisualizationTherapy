//___________________________________Controls
void keyPressed() {

  //_________________________________first use the switch::case method
  switch(key) {
  case 'c':

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

  else if (key == ' ') {
    showDepthImage = (!showDepthImage);
    showRGBImage = (!showRGBImage);
    closestPointResolutionScreen.background(0);
  }
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
}

void printInstructions () {
  println("Space Bar Toggles Depth/RGBImage"); 
  println("Use Arrow Keys to adjust size of initial bounding box");
}

