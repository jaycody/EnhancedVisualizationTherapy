// Lovers are particles from the Asteroids NOC midterm

class Lover {
  PVector kinect;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float topseed;
  float dia; //diameter
  float drawVectorSize;
  float G; // gravitational constant since now each attracts each


  Lover(PVector _loc, float m, float t, float _s, float _G) { //PVectorLoc, mass, topspeed, drawVectorSize, G
    location = _loc.get(); // initial location value  
    //location = new PVector(_x, _y, _z);  old skool method

    velocity = new PVector(0, 0);
    acceleration = new PVector (0, 0);
    mass = m;
    topspeed = t;
    dia = 3*mass;
    drawVectorSize = _s;
    G = _G;
    //fill (255,0,0);
  }

  // these functions refer to requests from attractor class for calcForceGravity
  PVector getLoc() {
    return location;
  }

  PVector getVel() {
    return velocity;
  }
  float getMass() {
    return mass;
  }
  
  
  //passing in the updated ATTRACTOR location value
  void handControlled (float x, float y, float z) {
    kinect = new PVector (x, y, z);
  }


  void applyforce (PVector force) {
    PVector f = PVector.div(force, mass);
    //PVector f = force.get();  // use non-static version of the force
    //f.div(mass);
    acceleration.add(f);
    // if (showVectors) {
    //  drawVector(force, location, drawVectorSize);
    //}
  }

//  //caculate and return the force that each object has on all other LOVER objects (como attractor)
//  //____CALCULATE AND RETURN GravForce
//  PVector calcGravForce (Lover love) {
//    // -----MOUSE CONTROL-------
//    //PVector mouse = new PVector(mouseX, mouseY);
//    //PVector force = PVector.sub(mouse,love.getLoc());  // get distance and magnitude PVector then 
//    // regular center located mass
//    PVector force = PVector.sub(location, love.getLoc());  // get distance and magnitude PVector then 
//    float distance = force.mag();
//    distance = constrain(distance, 5.0, 25.0);
//    float gravityStrength = (G * mass * love.getMass()) / (distance * distance);  // ATTRACTION GRAVITY
//    if (repel) {
//      gravityStrength = gravityStrength * -1;
//    }
//    force.normalize();
//    force.mult(gravityStrength);  // attractive force
//    //force.div(gravityStrength);  // can we divide here to make a repelling force?  ANS: NOPE (dividing with amplify
//    return force;
//  }


  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }


//  void display() {  // Normal non drag action vs display2()
//    //normalize location.y and use to make diameter small or bigger
//    PVector d = location.get();
//    float diam = d.y/height;
//    println(diam);
//
//    stroke(0);
//    fill(255, 0, 0);
//    ellipse (location.x, location.y, diameter, diameter);
//  }
//  //________getting the circle to change color when in liquid
//  void display2() {   // for drag action -> color change
//    stroke (255);
//    fill(0, 255, 255);
//    ellipse (location.x, location.y, diameter, diameter);
//  }

  void checksides() {
    if (location.x > width-(dia/2)) {
      velocity.x = velocity.x * -1;
      location.x=width -(dia/2);
      //location.x = 0;
    }
    if (location.x <(dia/2)) {
      velocity.x= velocity.x* -1;
      location.x=dia/2;
      // location.x = width;
    }
    if (location.y >height-(dia/2)) {
      velocity.y = velocity.y * -1;
      location.y= height-(dia/2);
      //location.y = 0;
    }
    if (location.y < (dia/2)) {
      velocity.y = velocity.y *-1;
      location.y=dia/2;
      // location.y = height;
    }
  }

  void checkspeed() {
    float speed = velocity.mag();
    if (speed > topspeed) {
      velocity.normalize();
      velocity.mult(topspeed);
    }
  }

  // DISPLAY LOVERS FOR KINECT
  void displayLovers() {
    pushMatrix();
    pushStyle();
    noStroke();
    fill(0, 255, 0);
    translate(location.x, location.y, location.z);
    sphere(15); // sphere size = diameter
    //ellipse (0, 0, 75, 75);
    popStyle();
    popMatrix();
  }
}


