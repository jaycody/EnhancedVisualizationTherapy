/*jason stephens
thesis - ITP
EV_Therapy - EV_Orbitors

Inspired by Steven Kay's Planets:
http://www.openprocessing.org/sketch/7638

_____________
::TODO::
_____place them on their own PGraphic Screen and prepare for feedback loop
_____Add an invisible attractor that that these solar systems can be placed
_____Add a function so that their color changes with velocity while still being informed by location
*/

import processing.opengl.*;
planet[] solarsystem;
int NUM_PLANETS=8;
boolean doStroke=false;
boolean doTrail=true;
 
void setup() {
  size(1024,768,OPENGL);//was P3D
  smooth();
  reset();
}
 
void reset(){
  solarsystem=new planet[NUM_PLANETS];
  for (int i=0;i<NUM_PLANETS;i++) solarsystem[i]=new planet(i);
  solarsystem[0].M=4000.0;//M=2000.0
  background(0,0,0);
}
 
void mousePressed(){
  reset();
}
 
void keyPressed() {
  if (key==' ') reset();
  if (key=='s') doStroke=!doStroke;
  if (key=='t') doTrail=!doTrail;
  if (key==']') {
    NUM_PLANETS+=1;
    reset();
  }
  if (key=='[' && NUM_PLANETS>=4) {
    NUM_PLANETS-=1;
    reset();
  }
}
 
void draw() {
  fill(0,3);
  rect(0,0,width,height);
  if (!doTrail) background(0,0,0);
  for (int i=0;i<NUM_PLANETS;i++) {
    solarsystem[i].exert();
  }
  for (int i=0;i<NUM_PLANETS;i++) {
    solarsystem[i].move();
  }
  //if (frameCount%2==0) {
  for (int i=0;i<NUM_PLANETS;i++) {
    solarsystem[i].draw();
  }
  //}
}

