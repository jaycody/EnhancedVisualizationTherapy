/*jasonStephens
 thesis ITP spring 2012
 evTherapy - evPointGestureControl
 starting point = G.Bornestein's closestPointTrackerWithAverage
 
 HISTORY:
 23April(Monday):added mousePress function to get mouseCordinates for bounding box
 dimensions needed around massage table.  current closest pixels are curtains and walls (12 hours on this one).
 Used the RunningAverageClosest Point tracker instead but used same algorithm to loop through specified index.
 worked like a champ.
 24April(Tues)::Closest point tracking working.  Bounded box representation added.  Easing Added
 
 TODO:
 ____convert screen resolution to 1024,768.  may cause problems for the depthArray with an index of 640x480.  
 DONE___do the closest point tracking in a PGraphics and then write the PGrapchics into a larger screen size.
 DONE___create PGraphics at 640,480 and do all of the depthimage analaysis on this.  then write it to 640,480 screen.
 DONE____if all clear, then increase screen size, then place PGraphics again.  
 ____If good, then resize PGraphic to fit 1024,768.
 ____Potentially use this new PGraphic as a keystone device?? to resize it to massage table using iPad controls
 ____create a bounding box for depth measurements using my height as a threshold so top of my head isn't tracked
 ____add recursive circles::perhaps switch to SwitchCase organization vs lastKeyPress
 ____add sphere_Textured app
 ____add keyboard controls
 ____add easing to closest point tracking
 ____add bounary condition to exclude bellow my height
 ____add secondary threshold level for 2 hands.  
 ____Add a boundary condition around the closest hand so that closest hand is not registered 2 times, 
 such that if point (x,y) is closest, then ignore second closest pixels within sphere diamgeter X of. 
 
 */

import SimpleOpenNI.*;
SimpleOpenNI  kinect;

//PGrapchis for whatever
PGraphics closestPointResolutionScreen;

//closest point
int closestX = 0; 
int closestY = 0;

//recursive circles
float dia = 1000;
float centX, centY, d, w, fluxMap;
float scalar = 1.1;
float fluctuation = 1;

//easing variables
float easeX, easeY, targetX, targetY;
float easing = 0.10;//.05original

int lastKeyPressed = 1;

void setup()
{
  size(1024, 768);

  //write to a seperate screen to keep depthArray index within range before 1024,768
  closestPointResolutionScreen = createGraphics(640, 480, P3D);

  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

void draw() {
  kinect.update();

  //add lastKeyPress function here and pass lastKeyPress variable
  if (lastKeyPressed == 1) {
    trackClosestPoint();
  }
  else if (lastKeyPressed == 2) {
    drawARcrossHair();
  }
  else { 
    background(0);
  }
}

void trackClosestPoint() {
  /*Kinect resolution = 640x480, but my projector is 1024x768.  
   How do I resize Kinect image without disturbing the boundary conditions established for depth?
   ANS:  Use PGraphic like a push/popMatrix() but within beginDraw() and endDraw() as follows */
   
  closestPointResolutionScreen.beginDraw();

  //keep the scope local for updating
  int closestValue = 8000;
  int currentX=0;
  int currentY=0;

  // get the depth array from the kinect
  int[] depthValues = kinect.depthMap();

  //setup special bounding box threshold values here to exclude curtains.  create variables for these
  for (int x = 100; x < 575; x++) {
    for (int y = 115; y < 355; y++) {
      int i = x + y * 640;
      int currentDepthValue = depthValues[i];
      // if that pixel is the closest one we've seen so far
      if (currentDepthValue > 0 && currentDepthValue < closestValue) {
        // save its value
        closestValue = currentDepthValue;
        // and save its position (both X and Y coordinates)
        currentX = x;
        currentY = y;
      }
    }
  }
  // closestX and closestY become
  // a running average with currentX and currentY
  closestX = (closestX + currentX) / 2;
  closestY = (closestY + currentY) / 2;

  //draw the depth image on the screen
  image(kinect.depthImage(), 0, 0);

  //bounding box representation
  fill(0, 50, 0, 50); //make the bounding box representation light green
  rect(100, 115, 575-100, 355-115); // then use the same variables from for loop to inform rect

  // draw a red circle at the X and Y coordinates of the closest pixel.
  fill(255, 0, 0);
  ellipse(closestX, closestY, 25, 25);
  
//pop the PGraphic up, resize it as needed.  draw to screen should be seperate control
  closestPointResolutionScreen.endDraw();
 // closestPointResolutionScreen.resize(1024, 768);
  image(closestPointResolutionScreen, 0, 0);
}

