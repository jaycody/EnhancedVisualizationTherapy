// simple mover class

class Mover {
  PVector loc;
  PVector vel;
  PVector acc;
  float mass;
  float maxvel;
  float G; // Gravitational Constant

  Mover(PVector _loc, PVector _vel, PVector _acc, float _m, float _G) {
    loc = _loc.get();
    vel = _vel.get();
    acc = _acc.get();
    mass = _m;
    maxvel = 20;
    G= _G;
  }

  PVector getLoc() {
    return loc;
  }

  PVector getVel() {
    return vel;
  }
  float getMass() {
    return mass;
  }
  
  
// this calculates each movers effect on each other mover
  PVector attract (Mover move){
    PVector force = PVector.sub(loc, move.getLoc());
    float distance = force.mag();
    distance = constrain (distance, 5.0,25.0);
    force.normalize();
    
    //float strength = (G * mass * move.getMass()) / distance * distance;    // ATTRACTING FORCE
    float strength = -1* (G * mass * move.getMass()) / distance * distance;  // REPPELLING FORCE
    if (repel){
      strength = strength * -1;
    }
    force.mult(strength);
    return force;
  }
    
    
  
  void applyforce (PVector force) {
    PVector f = PVector.div(force,mass);  // receive the force from attractor passing to main program and back
    acc.add(f);
   if (showVectors){
    drawVector(f,loc,1000);
   }
  }

    void display() {
      ellipseMode(CENTER);
      fill (255,0,255);
      ellipse (loc.x, loc.y, mass*2, mass*2);
      if (showVectors) {
      drawVector(vel,loc,20);
      }
    }

    void update() {
      vel.add(acc);
      vel.limit(maxvel);
      loc.add(vel);
      acc.mult(0);
    }
  }

