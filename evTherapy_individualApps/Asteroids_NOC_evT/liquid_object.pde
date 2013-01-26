/* Liquid class
 where liquid is an area of increased drag
 
 DRAG = -1 * Cd * speed * speed
 (1) dynamic force 
 (2) opposite the direction of velocity and 
 (3) directly proportional to the speed of the object
 
 where drag is a force in opposite direction (-1)
 multiplied by the Coefficient of Drag (Cd):  the constant representing the viscosity of the medium
 multiplied by Velocity Squared (speed * speed):  less drag at slower speeds, exponential increase.
 
 */


class Liquid { 
  float x;  // x location of drag box
  float y;
  float w;
  float h;  // width and height of this drag box
  float Cd;  // Coefficient of drag
  float vel = 1;

  Liquid (float _x, float _y, float _w, float _h, float _Cd) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    Cd = _Cd;  // Coefficient of DRAG
  }

  // LIQUID FUNCTIONS:  // these functions contain RETURNS, which is why it's not VOID Function
  // use a conditional to determine if the moving object LOVER is inside the liquid
  boolean contains(Lover m) {
    PVector loc =m.location;
    // is Lover object is inside of mouse controlled fluid?
    //    if (loc.x> mouseX && loc.x < mouseX + w  && loc.y > mouseY && loc.y < mouseY+ h) {  //creates flyover
    //     return true;
    //  } 
    // is Lover object inside of stationary fluid area? Yes? then go back to if statement and apply force
    if (loc.x> x && loc.x < x + w  && loc.y > y && loc.y < y+ h) {
      return true;
    } 
    // No?  then return fals and do not apply drag force
    else {
      return false;
    }
  }

  /* ----DRAG FUNCTION that:
   1. takes in a Moving Object's Info
   2. Uses Object's info to calculate the Drag Vector (Magnitude and Direction)
   3. Returns Drag PVector for application to that object
   
   
   --- Drag Formula:  [-1 * Coefficient of drag * speed * speed] ---
   
   --Creating Drag Force from Moving Object's Information: [CONCEPT]
   1. first remove the direction from Velocity vector and use it's magnitude to solve drag formula
   2. then remove the velocity's magnitude and use it's direction so the drag force knows which way to go
   
   ----How to create a Drag Force from a Moving Object's Information
   1. Find Drag Magnitude:
   1a. Find Speed of moving object from the magnitude of Object's velocity Vector
   1b. Apply Speed to Drag Formula and Solve for Drag Amount [Drag Magnitude]. Save it in float variable
   2. Find Drag Direction:
   2a. Create the "Drag" vector and set it equal to the moving object's velocity using the .get() function
   2b. Normalize this new Drag Vector (previously Velocity) to remove Magnitude and derive DIRECTION
   3. Calculate Drag Force by Multiplying it's Direction (from 3) by it's Magnitude (from 1)
   4. Return the Drag Force to main program for it's application to the moving object
   
   */

  PVector drag(Lover m) {
    // 1. Find Drag Magnitude
    float speed = m.velocity.mag(); // 1.
    float dragMagnitude = -1 * Cd * speed * speed;  // 2.

    // 2. Find drag direction:  derived from unit vector of velocity
    PVector drag = m.velocity.get(); // 2a. Create Drag Vector
    drag.normalize(); //2b. Derive Drag's Direction

    // 3. Calculate Drag's Force Vector (magnitude and direction)
    drag.mult(dragMagnitude);

    // 4. Return the new Drag Vector to main program
    return drag;
  }

  void display () {
    fill (175);
    rect(x,y,w,h);

  }
  void update () { // for Mouse Controlled Liquid Area
    fill (175);
    rect(mouseX,mouseY,w,h);
  }
}

