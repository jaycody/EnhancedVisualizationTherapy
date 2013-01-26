// -----------------------------------------------------------------
// hand events

void onCreateHands(int handId, PVector pos, float time)
{
  println("onCreateHands - handId: " + handId + ", pos: " + pos + ", time:" + time);

  handsTrackFlag = true;
  handVec = pos;

  handVecList.clear();
  handVecList.add(pos);
}

void onUpdateHands(int handId, PVector pos, float time)
{
  //println("onUpdateHandsCb - handId: " + handId + ", pos: " + pos + ", time:" + time);
  handVec = pos;

  handVecList.add(0, pos);
  if (handVecList.size() >= handVecListSize)
  { // remove the last point 
    handVecList.remove(handVecList.size()-1);
  }
}

void onDestroyHands(int handId, float time)
{
  println("onDestroyHandsCb - handId: " + handId + ", time:" + time);

  handsTrackFlag = false;
  context.addGesture(lastGesture);
}

// -----------------------------------------------------------------
// gesture events

void onRecognizeGesture(String strGesture, PVector idPosition, PVector endPosition)
{
  println("onRecognizeGesture - strGesture: " + strGesture + ", idPosition: " + idPosition + ", endPosition:" + endPosition);

  lastGesture = strGesture;
  context.removeGesture(strGesture); 
  context.startTrackingHands(endPosition);
}

void onProgressGesture(String strGesture, PVector position, float progress)
{
  //println("onProgressGesture - strGesture: " + strGesture + ", position: " + position + ", progress:" + progress);
}

void drawVector(PVector v, PVector loc, float scayl) {
  if (v.mag() > 0.0) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(loc.x, loc.y, loc.z);
    stroke(255);
    strokeWeight(3);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,0,len,0,0);
    //line(loc.x, loc.y, loc.z,handVec.x, handVec.y, handVec.z);
    //line(len,0,0,len-arrowsize,+arrowsize/2,0);
    //line(len,0,0,len-arrowsize,-arrowsize/2,0);
    popMatrix();
  }
}
