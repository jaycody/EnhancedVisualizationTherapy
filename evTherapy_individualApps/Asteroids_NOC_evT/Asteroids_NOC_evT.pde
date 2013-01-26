// jason stephens
// nature of code
// Using the FORCE

/* 
INTERACTION:
 KeyPressed = showVectors being objects and Attractors
 SpaceBar = toggle showVectors between Moving Objects
 Mouse.Location = primary attractor
 mousePressed = toggle Attraction / Repel

 FORCES: 
 1. Attraction - gravitational from center object
 2. Wind - one direction through purple stripe, another direction in green stripe
 3. Drag - inside the randomly placed grey liquids AND inside mouse controlled box
 4. Friction - inside green stripe
 5. working on everthing attracting everything else
 

NEXT TO DO:
 0. create an array of attractors [even if it's just for ONE]   DONE
 0a. create one attractor that is mouse controlled              DONE
 1. insert vector arrows for the moving objects                 DONE
 2. insert boolean to turn on/off vector lines                  DONE
 3. everything attracts everything [except itself]              DONE
 4. create repeling force between objects but attraction to mouse controlled mass DONE!!!
 .        [#4 by adding a -1 multiplier to the gravitatinal formula!!!]
 
4.1 save this sketch as a new sketch, just in case something happens
 4a. Add ShiffmanShip Class!
 4b. Subject Shiffman ship to the forces of nature
 
 5. control attractor using blob detection
 6. enter OSCILLATIONS [better late than never. thank god from spring break to catch up]
 7. get to particle systems
 
 
 POSSIBLES:
 1. Potentiameter to control the Gravitational Constant [where center may be 0 and negative repels]
 2. Sliders to control wind direction
 3. Create an EDIT mode where liquid can be moved around
 */
 
import processing.opengl.*;

//array of moving objects
Lover [] lovers = new Lover [10];   // LOVER Class Arguments = loc.x, loc.y, w, h, mass, topspeed

//array of drag locations Liquid
Liquid [] liquids = new Liquid [10];

// an array of Attractors
Attractor [] attractors = new Attractor [5];

boolean showVectors = false;
boolean repel = false;
boolean showMutualAttractions = false;

PVector wind;
PVector gravity;
PVector otherwind;
PVector otherwind2;
float G; //gravitational constant for 
float topspeed; // so shit don't get out of control
float mew;  // coefficient of friction

void setup () {
  smooth();
  size (1024,768,OPENGL);
  background (0);
  fill (255);
  frameRate(100);

  wind = new PVector (0,0);
  otherwind = new PVector (15,-.1);
  otherwind2 = new PVector (-13,-.5);
  gravity = new PVector (0,.5);
  topspeed = 15;
  mew = 0;  //Coefficient of Friction for a given surface:  how much friction in this world

  //+++++++INITIALIZE Attractor []++++++++arguments: PVector loc, mass, Gravitational Constant
  for (int i = 0; i<attractors.length; i++) {
    if (i != 0) {  // random parameters for all other attractors in the array
      attractors[i] = new Attractor (new PVector (random(0,width), random(0,height)), random (15, 40), random (8,13));
    }
    attractors[0] = new Attractor (new PVector(width/2, height/2), 30, 25); // consistant mouse controlled mass
  }

  //++++++INITIALIZE Liquid [] ++++++++++arguments: loc.x, loc.y, w, h, Coefficient of DRAG
  for (int i = 0; i<liquids.length; i++) {
    liquids[i] = new Liquid (random(0,width), random(0,height), random (5,70), random (5,50), random (0, 1));
  }

  //+++++INITIALIZE Lover []++++++++++arguments: loc.x, loc.y, mass,, topspeed, drawVectorSize, Gravitational Constant
  for (int i = 0; i<lovers.length; i ++) {
    lovers[i] = new Lover (random (0,width),0, random (5,15), 10, 5000, 10);
  }
}

void draw () {
  //background (0);
  fill (0,50);
  rect(0,0,width,height);

  //Display Attractor [] -> ForLoop
  for (int i= 0; i<attractors.length; i++) {
    if(i!=0) { // display the arttractors[] except for [0] which is mouse controlled
      attractors[i].display();
    }
    attractors[0].mouseControlled();// if you are [0] then use other fucnction to calc location
  }

  //Display Liquids [] -> ForLoop
  for (int i = 0; i<liquids.length; i++) {
    liquids[i].display();
  }
  // liquids[0].update();  //this is the mouse controlled liquid


//  // Draw WIND ZONES
//  //___OTHERWIND2 ZONE
//  fill (0,255,0,50);
//  rect (0,height/1.5,width, height/1.5);
//  //____OTHERWIND ZONE
//  fill (255,0,255,50);
//  rect (0,height/4,width,height/2-height/4);




  // Lovers[] forLoop -> applyforces (friction, otherwind(1-2), wind, gravity), update, display, checksides
  for (int i=0 ; i < lovers.length; i ++) {

    //____________________________FRICTION_______________________
    // 1. ______CALCULATING FRICTION:
    //    mew = 0;  //Coefficient of Friction for a given surface:  how much friction in this world
    //    float N = 1; // gravitational force perpendicular to velocity vector
    //    float frictionMag = N * mew;  // magnitude of friction given oil on the moon vs oil on earth
    //    PVector friction = lovers[i].velocity.get();  // be sure to get initial friction based on initial velocity
    //    friction.mult(-1);  // according to the equation -1 * mew * N * ||v||
    //    friction.normalize();
    //    friction.mult(frictionMag);

    //2. ______APPLY FRICTION:
    //lovers[i].applyforce (friction);   //  <-----------------apply FRICTION to each object
    //___________________________________


    //________  OTHER WIND OF VARIOUS ELEVATIONS_______________________ 
    if ((lovers[i].location.y > height/4) && (lovers[i].location.y < height/2)) {
      lovers[i].applyforce(otherwind);
    }
    if (lovers[i].location.y > height/1.5) {
      lovers[i].applyforce(otherwind2);
      // lovers[i].applyforce(friction);  // put friction inside of of otherwind area
    }

    //________________________________


    //______APPLY REMAINING FORCES_____
    lovers[i].applyforce (wind);
    lovers[i].applyforce (gravity);

    //_____UPDATE and DISPLAY
    lovers[i].update();
    lovers[i].display();  //moving the display function ABOVE Liquid[].forLoops gets Lovers to change color

    // ___CheckSides and CheckSpeed
    lovers[i].checksides();
    lovers[i].checkspeed();
    lovers[i].renderVectors(); //function for checking keypressed and return functio to drawVector

    // SEND Each lovers[] to EACH attractors[] and RETURN GravForce -> Nested ForLoop
    for (int j= 0; j<attractors.length; j++) {
      if (j !=0) {  // calc grav for each attractor except attractor[0]
        PVector f = attractors[j].calcGravForce(lovers[i]);  //function to send each Lover to attractor class
        lovers[i].applyforce(f);  // function in attractor class returns PVector f and applies it to each
        if (showVectors){
        drawVector (f, lovers[i].getLoc(), 200);
        }
      } 
      else {  //if attractor[0], then use function for calc grav at mouse location
        PVector f = attractors[0].calcGravForceMouse (lovers[i]);
        lovers[i].applyforce(f);
         if (showVectors){
        drawVector (f, lovers[i].getLoc(), 200);
        }
      }
      if (showVectors) {
        drawVector (lovers[i].getVel(), lovers[i].getLoc(), 20);
      }
    }
    
    // SEND Each lovers[] to each lovers[]
    for (int j =0;j<lovers.length; j++) {
      PVector f = lovers[j].calcGravForce(lovers[i]);
      lovers[i].applyforce(f);
    }

    /*___________________DRAG________________
     _______Appl DRAG to every lovers[] that moves through any liquids[] -> Nested ForLoop 
     --constantly asking boolean to return true */
    for (int j =0; j< liquids.length; j++) {
      if (liquids[j].contains(lovers[i])) {
        PVector drag = liquids[j].drag(lovers[i]);
        lovers[i].applyforce(drag);
        lovers[i].display2(); // display2() changes the color of object as it moves through liquid
      }
    }
  }
 
}

void keyPressed() {  // acts as a switch with the keyboard
  showVectors = !showVectors;
}

void mousePressed() {
  repel = !repel;
}

void drawVector(PVector v, PVector loc, float scayl) {
  if (v.mag() > 0.0) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(loc.x,loc.y);
    stroke(255);
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
}

