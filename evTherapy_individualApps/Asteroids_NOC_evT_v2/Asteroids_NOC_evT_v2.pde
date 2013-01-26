// jason stephens
// nature of code
// 28 feb 2011
// more gravitational forces
/*
INTERACTION:
 mousePressed = toggle attract and repel between objects
 keyPressed DOWN = toggle show Vectors
 keyPressed RIGHT, LEFT, UP = control of ShiffmanShip
 
 COMPUTING GRAVITY between two masses involves:
 1. d -->the distance between the objects
 2. m1, m2 -->the mass of each object
 3. G -->the force of gravity 
 4. F = (G*m1*m2)/(d*d) [the force of gravity 
 each body exerts on the other (including direction and magnitude]
 
 NEXT TO DO:
 1. everything attracts everything        DONE
 2. array of attractor class              DONE
 2b. insert boolean to turn on and off vector lines  DONE
 2c. create repelling force between objects  DONE
 3. move an attractor with mouse [prepare for moving with gesture]
 
 4. move an attractor using blob detection
 5. move an attractor with KINECT
 */

Mover [] movers = new Mover [50];  //yeah buddy, get with those arrays!!


Attractor [] attractors = new Attractor [1];

ShiffmanShip ship;

boolean showVectors = false;
boolean repel  = true;

void setup() {
  size (1024,768);
  smooth();
  background (0);
  // frameRate(20);

  ship = new ShiffmanShip ();

  // INITIALIZE the ATTRACTOR array
  for (int i= 0; i<attractors.length; i++) {   // arguments: Loc, mass, Gravitation constant "G"
    if (i != 0) {
      attractors[i] = new Attractor (new PVector (random (0, width), random (0, height)), random (3,40), random (1,5));
    }
    // INITIALIZE the MOUSE controlled Attractor
    attractors[0] = new Attractor (new PVector (mouseX, mouseY), 20, 90);  // arguments: Loc, mass, Gravitation constant "G"
  }



  // INITIALIZE that Mover array
  // turns out that putting the variables inside the for loop works wonders
  for (int i = 0; i<movers.length; i++) {
    PVector loc = new PVector (random(0,width), random(0,height));
    PVector vel = new PVector (random (-1,1),random(-1,1));
    PVector acc = new PVector (0,0);
    float mass = random (1,10);
    float G = .001;
    movers[i] = new Mover (loc, vel, acc, mass, G);  // arguments: loc, vel, acc, mass, Gravity constant
  }
}

void draw () {
  // background (0,100);
  frameRate(20);
  fill (0,100);

  rect(0,0,width, height);

  //ShiffmanShip
  // Update location
  // ship.update();
  // Wrape edges
  //ship.wrapEdges();
  // Draw ship
  //ship.display();

  //ShiffmanShip keyPressed Controls
  if (keyPressed) {
    if (key == CODED && keyCode == LEFT) {
      ship.turn(-0.05);
    } 
    else if (key == CODED && keyCode == RIGHT) {
      ship.turn(0.05);
    } 
    if (key == CODED && keyCode == UP) {
      ship.thrust();
    }
    if ((key == CODED && keyCode == UP) && (key == CODED && keyCode == LEFT)) {  // trying to get both to work at once
      ship.turn(-0.05);
      ship.thrust();
    }
  }


  // display eac on the attractor ARRAY
  for (int i = 0; i<attractors.length; i++) {
    if (i != 0) { // if it's NOT MouseAttractor [0]
      attractors[i].display();
    } 
    else {
      attractors[0].mouseControlled();
    }
  }


  // display each instance of mover class
  for (int i = 0; i<movers.length; i++) {
    for (int j = 0; j<movers.length; j++) {
      if (j!=i) {  //so that the mover will not be attracted to itself
        PVector force = movers[j].attract(movers[i]);  // this goes to [j] mover class to calculate force grav
        movers[i].applyforce(force);  //this returns the force from [j] mover and applies it to [i]mover
      }
    }
    movers[i].display();
    movers[i].update();

    // attracting the classes together
    for (int j =0; j<attractors.length; j++) {
      if (j!=0) {  // we want movers attracted to randomly placed attractors.  mouse needsAttractor different functio
        PVector f = attractors[j].calcGravForce(movers[i]);  // calls the attractionOn function from attractor class
        movers[i].applyforce(f);  // then takes that force from attractor and applies it to mover
      } 
      else {  //else if attractor[0] aka MouseAttractor then use separate function yo
        PVector f = attractors[0].calcGravForceMouse(movers[i]);
        movers[i].applyforce(f);
      }
    }
  }
}
void keyPressed() {
  if (keyPressed) {
    if (key == CODED) {
      if((keyCode != LEFT) && (keyCode != RIGHT) && (keyCode != UP)) {
        showVectors = !showVectors;
      }
    }
  }
}
void mousePressed () {
  repel = !repel;
}

// Renders a vector object 'v' as an arrow and a location 'loc'
void drawVector(PVector v, PVector loc, float scayl) {
  if (v.mag() > 0.0) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(loc.x,loc.y);
    stroke(0);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    stroke(255);
    line(0,0,len,0);
    line(len,0,len-arrowsize,+arrowsize/2);
    line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  }
}

