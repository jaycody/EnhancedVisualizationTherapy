void drawARcrossHair() {
  fill(0, 0, 0, 20);
  //rect(0, 0, 1024, 768); // for trails
  rect (0,0,640, 480);

  pushMatrix();

  //easing
  targetX = mouseX;
  float dx= targetX-easeX;
  if (abs(dx) >1) {
    easeX += dx * easing;
  }
  //easing mouseY
  targetY = mouseY;
  float dy = targetY - easeY;
  if (abs(dy)>1) {
    easeY += dy * easing;
  }
  translate(easeX-width/2, easeY-height/2);

  //use distant to change color
  float dTotal = abs(dx) + abs(dy); // get the absolute value of the distance
  float dyMap = map (dTotal, 0, mouseY, 0, 1.5);
  stroke (255*dyMap, 255*dyMap, 255);//should go white when moving quickly and settle to blue

  //translate(mouseX-width/2, mouseY-height/2);
  drawCircle (centX, centY, dia);
  pushMatrix();
  translate(centX, centY);
  rotate(PI/2);
  drawCircle (0, 0, dia);
  popMatrix();
  fill(255, 255, 255);
  rect(centX-w/2, centY-w/2, w, w);
  noFill();
  popMatrix();
}

void drawCircle( float x, float y, float radius) {
  ellipse (x, y, radius, radius); 
  if (radius >2) {
    drawCircle(x+radius/2, y, radius/2);
    drawCircle(x-radius/2, y, radius/2);
    //   drawCircle(x, y+radius/2, radius/2);
    //   drawCircle(x, y-radius/2, radius/2);
  }
}
