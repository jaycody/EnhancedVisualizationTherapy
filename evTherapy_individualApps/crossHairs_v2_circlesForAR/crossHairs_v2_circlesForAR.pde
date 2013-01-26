/*jason stephens
 thesis - ITP - Spring 2012
 HandControlled AR Crosshairs
 
 TODO:
DONE _____add easing
DONE_____create keyboard control
 _____add the SimpleOpenNI controls using a mesh
 _____create crossHair class
 _____add touchOSC controls
 
 FUNCTIONALITY
 ____CrossHairs
       PsuedoCode:  If hand is above certain depth, then activate crosshairs.
                    Follow the center of mass
 ____Pulsating Point
         use the tron circles 
         variable frequency, width, direction, color
 ____Pulsating Aura
   `    variable frequency, width, direction, color
 */


float dia = 1000;
float centX, centY, d, w,fluxMap;
float scalar = 1.1;
float fluctuation = 1;

//easing variables
float easeX, easeY, targetX, targetY;
float easing = 0.10;//.05original

int lastKeyPressed = 1;


void setup () {
  size (1024, 768);
  smooth ();
  noFill();
  background (0);
  centX = width/2;
  centY = height/2;
  stroke(0,0,255);
  strokeWeight(3);
  w = 120; //center box for AR
 
}

void draw () {
  if (lastKeyPressed == 1) {
 drawARcrossHair();
  }
  else { 
    background(0);
  }
}


void drawARcrossHair() {
  fill(0,0,0,20);
  rect(0, 0, 1024, 768); // for trails
  
  pushMatrix();
  
  //easing
  targetX = mouseX;
  float dx= targetX-easeX;
  if (abs(dx) >1){
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
  float dyMap = map (dTotal, 0, mouseY, 0,1.5);
  stroke (255*dyMap,255*dyMap,255);//should go white when moving quickly and settle to blue
    
  //translate(mouseX-width/2, mouseY-height/2);
  drawCircle (centX, centY, dia);
  pushMatrix();
  translate(centX, centY);
  rotate(PI/2);
  drawCircle (0, 0, dia);
  popMatrix();
  fill(255,255,255);
  rect(centX-w/2,centY-w/2,w,w);
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

void keyPressed() {
  if (key == '1') {
    lastKeyPressed = 1;
  }
  else if (key == '2') {
    lastKeyPressed = 2;
  }
  else if (key == '3') {
    lastKeyPressed = 3;
  }
}


