// simple stationary attractor class

/*  calculating gravitational force:
 Force of Gravity between two objects = (G*m1*m2) / (distance * distance)
 0.  assume knowledge of mass1 and mass2 and the Gravitational Constant
 1.  subtract location vectors to find direction / distance vectors
 2.  find magnitude to extract distance from this direction/distance vector 
 3.  now we have direction vector (#1) and distance as a magnitude float quantity (#2).
 4.  use Newton's Gravitational Formula to calculate the gravitational pull
 5.  (G*m1*m2) / (distance*distance);
 6.  use this gravitational force to inform the direction (which has been normalized
 to remove the distance (which was already used to calculate the force. Basically
 removing distance, using distance to calculate force, multiplying that force with
 direction
 */


class Attractor {
  PVector loc;
  float mass;
  float G;

  Attractor (PVector _loc, float _m, float _G) {
    loc = _loc.get();
    mass = _m;
    G = _G;
  }


  PVector calcGravForce (Mover move) {  // this function must receive the mover and return a force
    PVector force = PVector.sub(loc, move.getLoc()) ; //subtracting attractors location from mover's gets diection
    float distance = force.mag();  //  gives distance between those known locations
    distance = constrain(distance, 5.0, 25.0);  // this insures no crazy runnaway attractive o repel forces
    force.normalize();  // gives unit vector which is just direction
    
    float gravityStrength = (G*mass*move.getMass()) / (distance * distance);
    force.mult(gravityStrength);
    
    return force;  // return the force PVector to the function in the main program
  }
  
   void display () {
    stroke (0);
    fill (255,0,0, 200);
    ellipse (loc.x, loc.y, mass*2, mass*2);
  }
}

