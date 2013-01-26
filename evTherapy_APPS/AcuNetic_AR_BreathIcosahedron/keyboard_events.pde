// -----------------------------------------------------------------
// Keyboard event
void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  case 'd':
    showDepthMap = !showDepthMap;
    break;

    // depthThreshold controls
    // '1' = 1, '2'=10, '3'=100
  case '1': //increment depthThreshold by 10 units
    depthThreshold ++;
    println("depthThreshold = " + depthThreshold);
    break;
  case '!': //increment depthThreshold by 10 units
    depthThreshold --;
    println("depthThreshold = " + depthThreshold);
    break;

    //case '2': //increment depthThreshold by 10 units
  case '2': //increment depthThreshold by 10 units
    depthThreshold = depthThreshold + 10;
    println("depthThreshold = " + depthThreshold);
    break;
  case '@': //increment depthThreshold by 10 units
    depthThreshold = depthThreshold - 10;
    println("depthThreshold = " + depthThreshold);
    break;

    //case '3': //increment depthThreshold by 100
  case '3': //increment depthThreshold by 10 units
    depthThreshold = depthThreshold + 100;
    println("depthThreshold = " + depthThreshold);
    break;
  case '#': //increment depthThreshold by 10 units
    depthThreshold = depthThreshold - 100;
    println("depthThreshold = " + depthThreshold);
    break;


    // ico1  ON/OFF
  case '6':
    ico1On = !ico1On;
    println ("ico1On= " + ico1On);
    break;
    //icol1 PLACE
  case 'y':
    icoLocX = handVec.x; 
    icoLocY = handVec.y;
    icoLocZ = handVec.z - ico1Size;
    ico1Move = !ico1Move;
    println ("ico1Move= " + ico1Move);
    break;

    // ico2  ON/OFF
  case '5':
    ico2On = !ico2On;
    println ("ico2On= " + ico2On);
    break;
    //icol1 PLACE
  case 't':
    ico2LocX = handVec.x; 
    ico2LocY = handVec.y;
    ico2LocZ = handVec.z - ico2Size;
    ico2Move = !ico2Move;
    println ("ico2Move= " + ico2Move);
    break;

    //   _____LOVER ASTEROIDS and ATTRACTOR CONTROLS_______
    // 9 = ON/OFF for ATTRACTOR and ASTEROIDS
    // o = placement of ASTEROID ATTRACTOR
    // i = show VECTORS
    // l = show mutual attractions
  case '9':
    attractor = !attractor;
    break;
  case 'o':

    attLocX =handVec.x;//for permanent location of attractor
    attLocY  = handVec.y;
    attLocZ = handVec.z; 
    permAttractor =!permAttractor; 
    break;
    //  
    //  case 'i':
    //showVectors = !showVectors;

    //toggle RGB / PointCloud

  case'0':
    lastKeyPress = 0;
    break;
  case'-':
    lastKeyPress =1;
    break;
  }


  switch(keyCode)
  {
  case LEFT:
    rotY += 0.1f;
    break;
  case RIGHT:
    rotY -= 0.1f;
    break;
  case UP:
    if (keyEvent.isShiftDown()) {
      zoomF += 0.01f;
      //print the zoom to make calibration easier
      println("zoom =  " + zoomF);
    }
    else
      rotX += 0.1f;
    break;
  case DOWN:
    if (keyEvent.isShiftDown())
    {
      zoomF -= 0.01f;
      //print the zoom to make calibration easier
      println("zoom =  " + zoomF);


      if (zoomF < 0.01)
        zoomF = 0.01;
    }

    else
      rotX -= 0.1f;
    break;
  }
}

