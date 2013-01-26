// Hormigas by Patricio Gonzalez Vivo
//
// This is a mix of two wonderfull sketchs:
//   - Optical Flow (2010/05/28) by Hidetoshi Shimodaira shimo@is.titech.ac.jp 2010 GPL http://www.openprocessing.org/visuals/?visualID=10435
//   - Flow Field Following by Daniel Shiffman <http://www.shiffman.net> The Nature of Code, Spring 2009. Via Reynolds: http://www.red3d.com/cwr/steer/FlowFollow.html
//
// Thanks Hidetoshi and Daniel
 
import processing.video.*;
Capture video;
 
int wscreen=640;
int hscreen=480;
int fps=30;
 
color[] vline;
 
FlowField flowfield;
ArrayList boids;
 
// switch
boolean debug = false;
 
boolean colorFlow=true; // segmentation of moving objects?
boolean flagmirror=true; // mirroring image?
 
void setup(){
  // screen and video
  size(wscreen, hscreen, P2D); 
  video = new Capture(this, wscreen, hscreen, fps);
 
  vline = new color[wscreen];
 
  flowfield = new FlowField(10);
  boids = new ArrayList();
 
  // Make a whole bunch of boids with random maxspeed and maxforce values
  for (int i = 0; i < 120; i++) {
    boids.add(new Boid(new PVector(random(width),random(height)),random(2,5),random(0.1f,0.5f)));
  }
 
  // draw
  rectMode(CENTER);
  ellipseMode(CENTER);
}
 
void draw() {
  if(video.available()){
    // video capture
    video.read();
 
    // mirror
    if(flagmirror) {
      for(int y=0;y<hscreen;y++) {
        int ig=y*wscreen;
        for(int x=0; x<wscreen; x++)
          vline[x] = video.pixels[ig+x];
        for(int x=0; x<wscreen; x++)
          video.pixels[ig+x]=vline[wscreen-1-x];
      }
    }
 
    set(0,0,video);
    flowfield.update();
    if (debug) flowfield.display();
    if (colorFlow) flowfield.drawColorFlow();   
  }
 
  for (int i = 0; i < boids.size(); i++) {
    Boid b = (Boid) boids.get(i);
    b.follow(flowfield);
    b.run();
  }
}
 
void stopGame(){
  super.stop();
}
 
void keyPressed(){
  if(key=='c') video.settings();
  else if(key=='d') debug = !debug;
  else if(key=='w') colorFlow=!colorFlow; // segmentation on/off
  else if(key=='e') stopGame(); // quit
  else if(key=='m') flagmirror=!flagmirror; // mirror on/off
}

