/*jason stephens
 thesis - itp 
pulsatingAura
 */

int diam = 10;
float centX, centY;

void setup () {
  size (1024, 768);
  frameRate (24);
  smooth();
  background (0);
  centX=width/2;
  centY=height/2;
  stroke (0,0,255);
  strokeWeight(3);
  //noFill();
  fill(255,25);
}

void draw () {
//background (0);
  float mouseDiam = map (diam, mouseX,width,1,800);
  ellipse (centX, centY, mouseDiam, mouseDiam);
  ellipse (centX, centY, mouseDiam-50, mouseDiam-50);
  if (diam < 800) {
    //background (0);
    ellipse (centX, centY, diam, diam);
    diam += 10;
  }
} 

