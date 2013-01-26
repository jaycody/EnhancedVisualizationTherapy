//--------------------------AcuNetic Objects-------------------------FORCE = MASS * ACCELERATION
/*
class AcuNetic {

  PVector loc;
  PVector vel;
  PVector acc;
  float mass;
  float r;
  float topspeed;
  float xoff, yoff;

  //----------AcuNetic Constructor
  AcuNetic () {
    loc = new PVector (width/2, height/2);
    vel = new PVector (0, 0);
    acc = new PVector (0, 0);
    mass = 1;//random(5, 10);
    r = mass*40;
    xoff = 1000;
    yoff = 0;
    topspeed = 5;
  }

  //---------AcuNetic Methods
  //forces applied to the object are passed in here
  void applyForce (PVector force) {
    //Here's one way to apply the force vector
    // PVector f = force.get(); this is one method of 
    // f.div(mass); // the more massive, the less force is acting on it

    PVector f = PVector.div(force, mass);
    acc.add(f); //this is known as "force accumulation."  During each run cycle, all the forces get add together, then applied
  }

  void update () {
    //    PVector closestDepth = new PVector (closestX, closestY);
    //    PVector dir = PVector.sub(closestDepth,loc);

    // Or towards mouse -----------------------------------
    PVector mouse = new PVector(mouseX, mouseY);
    PVector dir = PVector.sub(mouse, loc);

    dir.normalize();
    dir.mult(0.5);
    acc = dir;

    vel.add(acc);
    vel.limit(topspeed);
    loc.add(vel);
    //acc.mult(0); //clear the acceleration
  }


  void display () {
    // offscreen.beginDraw();
    fill(255*loc.x/width, loc.y/height, 190);
    ellipse (loc.x, loc.y, r, r);
    //offscreen.endDraw();
  }

  void checkEdges () {
    if (loc.x>offscreen.width- r/2) {
      vel.x *= -1;
      loc.x =offscreen.width-r/2;
    }
    if (loc.x<0+r/2) {
      vel.x *=-1;
      loc.x = 0+r/2;
    }
    if (loc.y>offscreen.height-(r/2)) {
      vel.y *= -1;
      loc.y = offscreen.height-r/2;
    }
    if (loc.y<0+ (r/2)) {
      vel.y *= -1;
      loc.y= 0+(r/2);
    }
  }
}
*/






