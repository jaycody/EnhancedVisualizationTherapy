/*************************************************************
 ********************Boid Class*******************************
 **************Created by Andrew Lazarow**********************
 *******Using elements of: Dan Shiffman's Flocking example****
 ************************FINAL Draft 1************************
 ************************************************************/


class Boid {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

    //---------Variables to change behaviors
  float seekstrngth;
  float SepStrngth;
  float alignStrngth;
  float cohesionStrngth;
  float directness;

  //------Change Fill
  int cR;
  int cG;
  int cB;
  int cAlph;
  float tester;

  Boid(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    location = new PVector(x, y);
    r = 4.0;
    cR = int(random(100, 255));
    cG = int(random(50, 125));
    cB = int(random(50, 125));
    cAlph = int(random(150, 255));

    maxspeed = 1;
    maxforce = 0.05;
    //---------
    seekstrngth = 1;
    SepStrngth = 1;
  }

  void run (ArrayList<Boid> boids, float mxForcePass, float mxSpd, float skStrnthPas, float SepStrngthPass, float AllignmentStrngthPass, float CohesionStrngthPass, float DirectnessPassed) {
    flock(boids);
    follow(flowfield);
    if (arriverOn==true) {
      arrive (new PVector (importX, importY));
    }
    update();
    borders();
    render();

    maxspeed=mxSpd;
    seekstrngth = skStrnthPas;
    SepStrngth=SepStrngthPass;
    alignStrngth=AllignmentStrngthPass;
    cohesionStrngth=CohesionStrngthPass;
    maxforce=mxForcePass;
    directness=DirectnessPassed;
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    PVector seek = seek(new PVector(importX, importY)); //Seek
    sep.mult(SepStrngth);
    ali.mult(alignStrngth);
    coh.mult(cohesionStrngth);
    //seek.add(randomer);
    seek.mult(seekstrngth);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    if (seekOn==true) {
      applyForce(seek);
    }
  }

  void follow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(location);
    // Scale it up by maxspeed
    desired.mult(maxspeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    PVector flowField = steer;
    flowField.mult(directness);

    applyForce(flowField);
  }

  void arrive(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    float d = desired.mag();

    // Normalize desired and scale with arbitrary damping within 100 pixels
    desired.normalize();
    if (d < 100) desired.mult(maxspeed*(d/100));
    else desired.mult(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    PVector arriveSteer = steer;
    arriveSteer.mult(seekstrngth);
    applyForce(arriveSteer);
  }



  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    //println("maxforce =    " + maxforce);
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    //offscreen.fill(cR, cG, cB, cAlph);
    offscreen.stroke(0);
    offscreen.pushMatrix();
    offscreen.translate(location.x, location.y);
    offscreen.rotate(theta);
    //offscreen.imageMode(CENTER);
    offscreen.tint(cR, cG, cB, cAlph);
    //offscreen.ellipse(0,0,20,20);
    offscreen.image(arrows, 0, 0);
    offscreen.popMatrix();
  }

  // Wraparound
  void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }
}

