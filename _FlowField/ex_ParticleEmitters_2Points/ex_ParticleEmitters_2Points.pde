/*

from Martin Rykfors 
Particle Emitters Open Processing:
http://www.openprocessing.org/sketch/59627

*/

import java.util.LinkedList;
 
LinkedList<Particle> parts;
LinkedList<ParticleEmitter> emits;
LinkedList<Sink> sinks;
LinkedList<Vortex> vorts;
PGraphics imgDraw;              //line segments are drawn into this one, then it is blended into the main image
 
void setup() {
  size(1024, 768);
  imgDraw = createGraphics(width, height, P3D);
  parts = new LinkedList<Particle>();
  emits = new LinkedList<ParticleEmitter>();
  sinks = new LinkedList<Sink>();
  vorts = new LinkedList<Vortex>();
  background(0);
 
  imgDraw.background(0);
  imgDraw.smooth();
 
  //add emitters
  ParticleEmitter e1 = new ParticleEmitter(100, random(100, 500));
  e1.charge = 1;
  e1.radius = 3;
  e1.intensity = 2;
  e1.pHue = (int) random(360);
  emits.add(e1);
 
  ParticleEmitter e2 = new ParticleEmitter(700, random(100, 500));
  e2.charge = 1;
  e2.radius = 3;
  e2.intensity = 2;
  e2.pHue = (int) random(360); //(e1.pHue + 180) % 360;
  emits.add(e2);
  
   ParticleEmitter e3 = new ParticleEmitter(400, random(100, 500));
  e3.charge = 1;
  e3.radius = 3;
  e3.intensity = 2;
  e3.pHue = (int) random(360); //(e1.pHue + 180) % 360;
  //e3.pHue = (e1.pHue + 180) % 360;
 emits.add(e3);
 
  // add sinks
  Sink s1 = new Sink(400, 300);
  s1.charge = -40;
  s1.killRadius = 10;
  sinks.add(s1);
 
  Sink s2 = new Sink(200, e1.y);
  s2.killRadius = -1;
  s2.charge = 2;
  sinks.add(s2);
 
  Sink s3 = new Sink(random(200, 400), random(200, 400));
  s3.killRadius = -1;
  s3.charge = 20;
  sinks.add(s3);
 
  Sink s4 = new Sink(600, e2.y);
  s4.killRadius = -1;
  s4.charge = 2;
  sinks.add(s4);
 
  //add vortices
  Vortex v1 = new Vortex(300, 300);
  v1.charge = -10;
  vorts.add(v1);
 
  Vortex v2 = new Vortex(500, 300);
  v1.charge = -10;
  vorts.add(v2);
}
 
void draw() {
  imgDraw.background(0);
  imgDraw.colorMode(HSB, 360, 1, 1);
 
  /*if (frameCount % 20 == 0)
    println(parts.size() + "\t" + frameRate);*/
 
  for (ParticleEmitter e : emits) {
    e.addParticles(parts);
  }
  imgDraw.beginDraw();
  imgDraw.smooth();
  updateParticles();
  imgDraw.endDraw();
  blend(imgDraw, 0, 0, width, height, 0, 0, width, height, ADD);
}
 
void updateParticles() {
  float dx, dy, sqDist;
  Particle p;
  ListIterator<Particle> it = parts.listIterator();
 
  while (it.hasNext ()) {
    p = it.next();
    for (ParticleEmitter e : emits) {
      dx = p.x - e.x;
      dy = p.y - e.y;
      sqDist = dx*dx + dy*dy;
      p.accx += dx/sqDist*e.charge;
      p.accy += dy/sqDist*e.charge;
    }
 
    for (Sink s : sinks) {
      dx = p.x - s.x;
      dy = p.y - s.y;
      sqDist = dx*dx + dy*dy;
      if (sqDist < s.killRadius*s.killRadius) {
        it.remove();
        continue;
      }
      p.accx += dx/sqDist*s.charge;
      p.accy += dy/sqDist*s.charge;
    }
 
    for (Vortex v : vorts) {
      dx = p.x - v.x;
      dy = p.y - v.y;
      sqDist = dx*dx + dy*dy;
      p.accx += dy*v.charge/sqDist;
      p.accy -= dx*v.charge/sqDist;
    }
 
    p.update();
    p.draw(imgDraw);
  }
}
 
void keyReleased() {
  if (key == 'r') {
    setup();
  }
}

