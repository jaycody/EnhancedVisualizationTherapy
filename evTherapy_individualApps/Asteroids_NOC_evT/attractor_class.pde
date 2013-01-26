// add the big bad attractor class
// for now it's a simple attractor that doesn't move

// how do I turn this information into a force that I can apply to the mover objects?
// F =  (G*m1*m2) / (distance * distance)
/* ANS:  by creating a function in the Attractor Class the 
 1.  receives a mover object  AND
 2.  returns a PVector ATTRACTION force to be passed on to the Mover objects applyforce function.
 */

// How do we receive a mover object?        


class Attractor {  
  PVector loc;
  // PVector vel;  
  // PVector acc;
  float mass;
  // float topspeed;
  float G; //gravitational constant;

  //  For later use when the attractor is moving
  //  Attractor(PVector _loc, float _m) { 
  //    loc = _loc.get();
  //    vel = _vel.get();
  //    acc = _acc.get();
  //    mass = _m;
  //  }

  Attractor (PVector _loc, float _m, float _G) {
    loc = _loc.get(); // standard centered located mass
    //loc = new PVector(mouseX,mouseY);
    mass = _m;
    G = _G;
  }


  //____CALCULATE AND RETURN GravForce
  PVector calcGravForce (Lover love) {
    // -----MOUSE CONTROL-------
    //PVector mouse = new PVector(mouseX, mouseY);
    //PVector force = PVector.sub(mouse,love.getLoc());  // get distance and magnitude PVector then 
    // regular center located mass
    PVector force = PVector.sub(loc,love.getLoc());  // get distance and magnitude PVector then 
    float distance = force.mag();
    distance = constrain(distance,5.0,25.0);
    float gravityStrength = (G * mass * love.getMass()) / (distance * distance);
    force.normalize();
    force.mult(gravityStrength);
    return force;
  }

//_____ADDING another PVector calcGravForce function specifically for the mouse controlled mouse
PVector calcGravForceMouse (Lover love) {
    // -----MOUSE CONTROL-------
    PVector mouse = new PVector(mouseX, mouseY);
    PVector force = PVector.sub(mouse,love.getLoc());  // get distance and magnitude PVector then 
    // regular center located mass
    //PVector force = PVector.sub(loc,love.getLoc());  // get distance and magnitude PVector then 
    float distance = force.mag();
    distance = constrain(distance,5.0,25.0);
    float gravityStrength = (G * mass * love.getMass()) / (distance * distance);
    force.normalize();
    force.mult(gravityStrength);
    return force;
  }



  // method to display
  void display () {
    stroke (0);
    fill(255);
    ellipse(loc.x, loc.y, mass*2, mass*2);
  }

  void mouseControlled () {
    stroke (0);
    fill(255);
    ellipse(mouseX, mouseY, mass*2, mass*2);
  }
}



