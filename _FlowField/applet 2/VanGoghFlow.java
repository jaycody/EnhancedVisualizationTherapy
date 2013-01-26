import processing.core.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class VanGoghFlow extends PApplet {

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

public void setup() {
  size(1024,768);
  smooth();
  vg = loadImage("vangogh.jpg");
  vg.loadPixels();
  // Make a new flow field with "resolution" of 16
  flowfield = new FlowField(25);
  vehicles = new ArrayList<Vehicle>();
  // Make a whole bunch of vehicles with random maxspeed and maxforce values
  for (int i = 0; i < 200; i++) {
    vehicles.add(new Vehicle(new PVector(random(width),random(height)),random(.1f,1),random(7,8)));
  }
}

public void draw() {
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


 public void keyPressed() {
  debug = !debug;
}

// Make a new flowfield
 public void mousePressed() {
  flowfield.init();
}




// Flow Field Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code, Spring 2011

class FlowField {

  // A flow field is a two dimensional array of PVectors
  PVector[][] field;
  int cols, rows; // Columns and Rows
  int resolution; // How large is each "cell" of the flow field
  int imgPixel;

  FlowField(int r) {
    resolution = r;
    // Determine the number of columns and rows based on sketch's width and height
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    init();
  }

  public void init() {
    // Reseed noise so we get a new flow field every time
    noiseSeed((int)random(10000));
    float xoff = 0;
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
        float theta = map(blue(PApplet.parseInt(vg.pixels[i+j*width])),0,255,0,TWO_PI);
        // Polar to cartesian coordinate transformation to get x and y components of the vector
        field[i][j] = new PVector(cos(theta),sin(theta));
        yoff += 0.1f;
      }
      xoff += 0.1f;
    }
  }

  // Draw every vector
  public void display() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        drawVector(field[i][j],i*resolution,j*resolution,resolution-2);
      }
    }

  }

  // Renders a vector object 'v' as an arrow and a location 'x,y'
  public void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(x,y);
    stroke(0);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,len,0);
    line(len,0,len-arrowsize,+arrowsize/2);
    line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  }

  public PVector lookup(PVector lookup) {
    int column = PApplet.parseInt(constrain(lookup.x/resolution,0,cols-1));
    int row = PApplet.parseInt(constrain(lookup.y/resolution,0,rows-1));
    return field[column][row].get();
  }


}





// Flow Field Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code, Spring 2011

class Vehicle {

  // The usual stuff
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  PImage moon = loadImage("moon.png");

    Vehicle(PVector l, float ms, float mf) {
    location = l.get();
    r = 3.0f;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
  }

  public void run() {
    update();
    borders();
    display();
  }


  // Implementing Reynolds' flow field following algorithm
  // http://www.red3d.com/cwr/steer/FlowFollow.html
  public void follow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(location);
    // Scale it up by maxspeed
    desired.mult(maxspeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }

  public void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // Method to update location
  public void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  public void display() {
    // Draw a triangle rotated in the direction of velocity
    tint(0xffFFFFFF, 100);
    float theta = velocity.heading2D() + radians(90);
    fill(0);
    stroke(0);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    /*beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();*/
    popMatrix();
    image(moon,location.x-10,location.y-10);
  }

  // Wraparound
  public void borders() {
    if (location.x < 0) { location.x = width-20; location.y = height; } ;
    if (location.y < 0) location.y = height-20;
    if (location.x > width) location.x = 50;
    if (location.y > height) location.y = 50;
  }
}


  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "VanGoghFlow" });
  }
}
