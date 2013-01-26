// Flow Field Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

// Via Reynolds: http://www.red3d.com/cwr/steer/FlowFollow.html

// Using this variable to decide whether to draw all the stuff
boolean debug = true;
PImage vg;

// Flowfield object
FlowField flowfield;
// An ArrayList of vehicles
ArrayList<Vehicle> vehicles;

void setup() {
  size(1024,768);
  smooth();
  vg = loadImage("1.png");
  vg.loadPixels();
  // Make a new flow field with "resolution" of 16
  flowfield = new FlowField(25);
  vehicles = new ArrayList<Vehicle>();
  // Make a whole bunch of vehicles with random maxspeed and maxforce values
  for (int i = 0; i < 200; i++) {
    vehicles.add(new Vehicle(new PVector(random(width),random(height)),random(.1,1),random(7,8)));
  }
}

void draw() {
  frameRate(30);
  background(vg);
  // Display the flowfield in "debug" mode
  if (debug) flowfield.display();
  // Tell all the vehicles to follow the flow field
  for (Vehicle v : vehicles) {
    v.follow(flowfield);
    v.run();
  }

  // Instructions
  fill(0);
  //text("Hit space bar to toggle debugging lines.\nClick the mouse to generate a new flow field.",10,height-30);

}


 void keyPressed() {
  debug = !debug;
}

// Make a new flowfield
 void mousePressed() {
  flowfield.init();
}




