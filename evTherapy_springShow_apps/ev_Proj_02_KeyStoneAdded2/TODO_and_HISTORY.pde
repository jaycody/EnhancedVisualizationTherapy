/*::TODO HISTORY::
DONE____put Bioflower in its own tab
*/


 /*
 ::FOLLOWING A SEQUENCE::
 
 1. Create Environmnet:
     -darkness
     -set ambient light with hand
     -ask them  to inhail exhail to calibrate hightest and lowest in breath monitor area.
     -start ambient light changing based on breath
     -hand waving erases the ambient light from their body and table :: reveals a white light on the ENTIRE body/table
     -conclusion::  client and table white against ambient light background

 2. Assement Phase
     -my hands now erase the white light on the body and table to reveal the feedback loop of my movements on dark background
     -frame differencing used to erase the white light and start from just the body dark
     -My color :: client's color :: room color
    
 3. Pay Attention Here:: Place Points
      a)place points::white light on spots::objects on spots
      b)points ineract and manifest their nature as attractor repellers
      
 4. Begin Treatment::
     
     

     -
 




/* :HISTORY:
 
 -->23April(Monday)::added mousePress function to get mouseCordinates for bounding box
 dimensions needed around massage table.  current closest pixels are curtains and walls (12 hours on this one).
 Used the RunningAverageClosest Point tracker instead but used same algorithm to loop through specified index.
 worked like a champ.
 
 -->24April(Tues)::Closest point tracking working.  Bounded box representation added.  Tech Rider written.  Attempted
 to write kinect.update to PGraphics buffer. Took 3 hours to figure out that the dot syntax is required for 
 all commands within the PGraphics_Foo.beginDraw(); 
 and PGraphics_Foo.endDraw();  //next up:: Easing and the Greg Reynald's
 Arrival Behavior of the autonmous vehicle.  Turns out that taking the average before using the easing creates a bit of jitter
 in itself.  Earased the running  average in favor of the Arrival behavior for the closest point tracking.  Or not.  
 Unsure about that, but moving on.
 
 -->25-26April(Wd-Thurs)::Tempted fate:: 
 attempted integration of keystoning library along with Andrew Lazarow's Projector Mapping / 
 Kinect Calibration software.  The keysone library allows for deformation of Processing's output of the projected image
 such that the resulting image compensates for the deformation caused by angled projection surfaces.  The Kinect calibration
 aspect of the code maps the kinect's depth information onto the keystoned projections.  It's essentially a two way mapping
 program that maps the incoming camera signal onto an outgoing mapped video signal.  It is meant to synchronize the 3 seperate 
 coordinate systems (projector's image, kinect's view, massage table projection surface).  Ideally, if I place my hand on the
 corner of the massage table, an undistorted image will appear at that very spot.
 Problems started when testing Andrew's code (as in, it wouldn't work).  But I had seen him demonstrate it!  So I persisted 
 and after some time realized that it requires Processing 2.0.  Having run into bugs with my own software a few months back, 
 I had decided to stick with 1.5, which is what I'm currently using.  So I had this great idea to change my code into 2.0
 compliable, and then integrate the keystone and the kinect calibration software.  WRONG ANSWER.  I first read up on the basic
 differences, then ran some tests, then got my code working, then started adding functionality from the other apps, then
 started running into phantom issues related to OPENGL, PGraphics, P3D, memmory allocation, and on and on.  By this time
 a solid 35 hours of programming had passed (thus, "wed-thurs" is one day under HISTORY).  An increase in mental malfunctions (like 
 loosing my place in the code) prompted a rest, and when I awoke I saw only an undifferienciated mass of 1.5 and 2.0 code, 
 mocking me.  Current strategy:  save this code as a piece of historical artifact.  Then, SaveAS the next version.  Strip
 code back to most fundamental.  Integrate only the non GL-keystone lib.  Fancy warping of multiple coordinate systems
 using inverse billinear interpolation from incompatible code will have to wait until I'm once again struck with debilitating 
 delusions about time, complexity, and my coding abilities.  
 To quote Andrew Lazarow from his own code:  // this was more of a pain than I tought!  
 Now it's back to the drawing board.  Focus on what's essential!
 Question:  /*How do we resize a Kinect image, without lossing the relationship between
 the clickable (x,y) cordinate point on the draw screen and the depth info
 associated with that point and its given index in the array of 620x480?
 ANS:  We create a PGraphics screen with its own coordinate system
 that is equal to the resolution of the camera image we are writing into it,
 then we establish the boundary condtions or we read the realitime measurements from the
 mouseOver areas, all the while remaining inside of the PGraphics specific dot syntax.
 Then we .endDraw();
 Followed by an image call to the PGraphic screen that we had just ended.  
 Image calls take 4 arguments, the last two we use to resize.  
 Meanwhile the coordinate system inside the PGraphics begin / endDraw functions
 reamian intact as if we had called a push or popMatrix.  From the outside, the
 image looks bigger.   But if the surface of the moon looked bigger, it wouldn't be because
 it expanded, it would be because the moon got closer and now takes up my entire field of view.
 
 reply from Shiffman:  look into Flow Fields as Cellular Automata 
 */



/*--------------------------------------------------------------------------------
 Enhanced Visualization (EV) Therapy :: Technology :: 3 Parts :: 
 1] EV_Projections :: Enhanced Visualization Projections :: computer1 :: imagery projected directly onto client in physical space :: 
 2] Acu_AR :: Augmented Reality Acupressure :: computer2 :: visable as Augmented Reality in video goggles or on face-cradle display :: 
 3] IHS :: Intelligent Healing Space  :: responsive environment with sensors, feedback mechanisms, and awareness of client and session
 
 Naming Convention::
 -EV_Projections = drop "Projections" [eg EV_Projection_Foo --> EV_Foo] 
 // updated from previous convention, which also added prefixes [eg Acu(EV_Projection)_Foo --> Acu(EV)_Foo (eg Acu(EV)_Point)]
 -Acu_AR = add underscore + suffix as necessary, such that FlowFieldFoo --> Acu_AR_FlowFieldFoo
 // updated previous convention, which was :: 
 base case = "EV_AR" :: drop "EV" [eg EV_AR_Foo --> AR_Foo] && Add prefixes [eg Acu(EV_AR)_Foo --> Acu(AR)_Foo (eg Acu(AR)_Point)]
 -IHS = add underscore + suffix as necessary, such that Strong A.I. = IHS_Awareness ;)
 
 EV_Projections::Computer1::Tronik::MacBookPro_Lion10.7::8gigsRam::Procesing1.5.1
 -uses the InFocus ShortThrow projector positioned over the massage table
 -uses Kinect positioned near the projector directly above massage table
 -includes:  
 EV_PointGenerator :: created and controlled via gesture and touchOSC (via iPad suspended in space and iPhone attached to my arm)
 EV_Point::Acupressure Point via Projections
 EV_Vehicle :: "life-like and improvisational" particles with goals, desires, abilities, behaviors and awareness of self, others, and EV session details
 EV_FlowFieldAutomata :: Reaction-Diffusion Systems, Continuous Cellular Automata, tessellation structures
 ->EV_FlowFieldDepth :: Vector Field :: Direction from depth contours, Force from slope angle + gravity - friction
 ->EV_FlowFieldIllumination:: Vector Field :: Direction from projected light's location :: Force Magnitude from Brightness of projected light as seen by Kinect1 RGB.
 
 EV_FeedbackLoop
 
 
 Acu_AR::Computer2::Megatronik::MacPro_8core_3GHz::6gigsRam[sigh]::Processing1.5.1 [after 8 weeks of openFrameworks]
 -1st DVI out to 24inch main screen
 -2nd DVI out downshifted to VGA and sent to VGA 1x4 splitter
 -1x4 VGA Splitters out to:
 1. Face-Cradle Display :: 19inch Dell (1024x768) attached to massage table via manfrotto clamp with articulating joint
 2. Vuzix 920 Video Goggles for client in supine position
 3. Vuzix 920 Video Goggles for therapist
 (Vuzix each also require USB-2 to Computer2 for Power (and Perhaps signal information as well (perhaps USB powered hub would work?))
 4. Video Projector:: rear projected at fabric above space
 making session viewable to public outside space while retaining coherence with healing space with curtains closed
 -includes:
 Acu_AR_PointGenerator
 Acu_AR_Point
 Acu_AR_Object
 Acu_AR_Vehicle
 Acu_AR_FlowFieldDepth
 Acu_AR_FlowFieldIllumination
 Acu_AR_FeedbackLoop
 
 
 
 
 
 ______________________________________
 EV_PointGenerator
 created and controlled via gesture and touchOSC (via iPad suspended in space and iPhone attached to my arm)
 ______________________________________
 
 
 
 ______________________________________
 EV_Point
 Acupressure Point via Projections
 communicates its depth to Vehicles
 ______________________________________
 
 ---___________________________________
 EV_Vehicle
 "life-like and improvisational" particles with goals, desires, abilities, behaviors and awareness of self, others, and EV session details
 ______________________________________
 
 ______________________________________
 EV_FlowFieldAutomata
 Reaction-Diffusion Systems, Continuous Cellular Automata, tessellation structures, SOLITONS!
 ______________________________________
 
 ___________________________________
 EV_FlowFieldDepth
 Vector Field :: Direction from depth contours, Force from slope angle + gravity - friction
 ______________________________________
 
 ______________________________________
 EV_FlowFieldIllumination::
 Vector field whose Direction is a function of the projected light's location, 
 and whose Force Magnitude is a function of Brightness of projected light of Acu(EV)_Point as seen by Kinect1 RGB.
 ______________________________________
 
 ______________________________________
 EV_FeedbackLoop
 1.  USE Transparency on PGraphics with createGraphics:
 Unlike the main drawing surface which is completely opaque, 
 surfaces created with createGraphics() can have transparency. 
 This makes it possible to draw into a graphics and maintain the alpha channel. 
 By using save() to write a PNG or TGA file, the transparency of the graphics object will be honored. 
 Note that transparency levels are binary: pixels are either complete opaque or transparent.
 TODO:
 ____use one RVL sample with alpha channel intact.  looping but with feedback added
 ______________________________________
 
 ______________________________________
 Acu_AR_PointGenerator::
 ______________________________________
 
 ______________________________________
 Acu_AR_Point::Acupressure Points via Augmented Reality
 ______________________________________
 
 */

//------------------------------------------------------------------------------
//----------------------------------------------------------CODE HACKS-----------
//------------------------------------------------------------------------------


/*-------------------------------PATH TO THE IMAGES:::
 myImage = loadImage ("/Volumes/SubThree/Dropbox/_ITP_js5346/Processing/_imagesForProcessingPath/flowmap-1.png");
 */

//______distance() using Pythagorian Thereom
//takes 2 points (x,y) and (x1,y1) and return distance
//______also makes and fills 4 squares
/*
//top left square
 fill(distance(0,0,mouseX,mouseY));
 rect(0,0,width/2-1,height/2-1);
 
 // top right square
 fill(distance(width,0,mouseX,mouseY));
 rect(width/2,0,width/2-1,height/2-1);
 
 // bottom left square
 fill(distance(0,height,mouseX,mouseY));
 rect(0,height/2,width/2-1,height/2-1);
 
 // bottom right square
 fill(distance(width,height,mouseX,mouseY));
 rect(width/2,height/2,width/2-1,height/2-1);
 
 }
 float distance (float x1, float y1, float x2, float y2){
 float dx = x1-x2;
 float dy = y1-y2;
 float d = sqrt(dx*dx + dy*dy);
 return d;
 }
 */
//____________________________________________________________


//----------------------------------------Removes Window Frame
//public void init() {
//  frame.removeNotify();
//  frame.setUndecorated(true);
//  frame.addNotify();
//  super.init();
//}
//____________________________________________


//_________________________________________place program screen somewhere specific
//frame.setLocation(computerScreenXRes-CXRes, 0);// this will start screen at the beginnig of second screen,
//then come back into main screen for the X-axis length of the camers CXRes
//thank you andrew!!



//__________________________Using PIMage to store kinect cameras_BASIC DEPTH PImage from GregBornstein
//import SimpleOpenNI.*;
//SimpleOpenNI  kinect;
//
//void setup()
//{
//  // double the width to display two images side by side
//  size(640*2, 480);
//  kinect = new SimpleOpenNI(this);
//
//  kinect.enableDepth();  
//  kinect.enableRGB();
//}
//
//void draw()
//{
//  kinect.update();
//
//  PImage depthImage = kinect.depthImage();
//  PImage rgbImage = kinect.rgbImage();
// 
//  image(depthImage, 0, 0);
//  image(rgbImage, 640, 0);
//}
//_____________________________________

// __________________________Array of PGraphics as frames of an animation!!!
//_______________________________AND Polar to Cartesian conversion
//_______________AND DOT SYNTAX for addressing each PGraphic "spriteFrames[surf].beginDraw()
//_______________for loop loads the array in setup
//_______________modulo allows easy count through PGraphics array without forLoop
// -----PGraphics if I need two or more contexts with different properties!! or as off screen graphics buffer

//PGraphics[] spriteFrames = new PGraphics[6];
//PImage sprite;
//
//float x, y;
//float xang = 0.0;
//float yang = 0.0;
//int surf = 0;
//
//void setup() {
//  size(640, 360);
//  noSmooth();
//  background(0);
//  
//  // Create sprite
//  sprite=loadImage("Aqua-Ball-48x48.png");
//
//  // Create blank surfaces to draw on
//  for (int i = 0; i < spriteFrames.length; i++)  {
//    spriteFrames[i] = createGraphics(width, height, JAVA2D);
//  }   
//}
//
//void draw()
//{
//  background(0);
//  
//  // Get X, Y positions --from POLAR to Cartesian
//  x = (width/2)*sin((radians(xang))*0.95);
//  y = (height/2)*cos((radians(yang))*0.97);
//
//  // Inc the angle of the sine
//  xang += 1.17;
//  yang += 1.39;
//
//  // Blit our 'bob' on the 'active' surface
//  spriteFrames[surf].beginDraw();
//  spriteFrames[surf].image(sprite, x+(width/2)-32, y+(height/2)-32);
//  spriteFrames[surf].endDraw();            
//
//  // Blit the active surface to the screen
//  image(spriteFrames[surf], 0, 0, width, height);
//
//  // Inc the active surface number
//  surf = (surf+1) % spriteFrames.length;
//
//  // Display the results
//  //image(spriteEffect, 0, 0, width, height); 
//}
//------------------------------------------------------------
//------------------------------------------realWorldMeasurement
//int[] depthValues = kinect.depthMap();
//  int clickPosition = mouseX + (mouseY * 640);
//
//  int millimeters = depthValues[clickPosition];
//  float inches = millimeters / 25.4;
//
//  println("mm: " + millimeters + " in: " + inches);



/*-------------------Moving and dropping an Image that is tracking within a boundary box
 //in setup establish boolean
 // start the image out moving
 // so mouse press will drop it
 imageMoving = true;
 
 // then draw
 int[] depthValues = kinect.depthMap();
 
 //norml scan of entire image
 for(int y = 0; y < 480; y++){
 for(int x = 0; x < 640; x++){
 
 int reversedX = 640-x-1;        
 int i = reversedX + y * 640;
 int currentDepthValue = depthValues[i];
 
 if(currentDepthValue > 610 && currentDepthValue < 1525 && currentDepthValue < closestValue){
 
 closestValue = currentDepthValue;
 closestX = x;
 closestY = y;
 }
 }
 }
 
 float interpolatedX = lerp(lastX, closestX, 0.3);   
 float interpolatedY = lerp(lastY, closestY, 0.3);
 
 // clear the previous drawing
 background(0);
 
 // only update image position
 // if image is in moving state
 if(imageMoving){
 image1X = interpolatedX;
 image1Y = interpolatedY; 
 }
 
 //draw the image on the screen
 image(image1,image1X,image1Y);
 
 lastX = interpolatedX;
 lastY = interpolatedY;
 }
 
 void mousePressed(){
 // if the image is moving, drop it
 // if the image is dropped, pick it up    
 imageMoving = !imageMoving;
 }
 */

/*----------------DYNAMIC BOUDNING BOX FROM SHIFFMAN's CONVOLUTION EXAMPLE
 void draw() {
 // We're only going to process a portion of the image
 // so let's set the whole image as the background first
 image(img, 0, 0);
 
 // Calculate the small rectangle we will process
 int xstart = constrain(mouseX - w/2, 0, img.width);
 int ystart = constrain(mouseY - w/2, 0, img.height);
 int xend = constrain(mouseX + w/2, 0, img.width);
 int yend = constrain(mouseY + w/2, 0, img.height);
 int matrixsize = 3;
 loadPixels();
 // Begin our loop for every pixel in the smaller image
 for (int x = xstart; x < xend; x++) {
 for (int y = ystart; y < yend; y++ ) {
 color c = convolution(x, y, matrix, matrixsize, img);
 int loc = x + y*img.width;
 pixels[loc] = c;
 }
 }
 updatePixels();
 }
 
 color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img)
 {
 float rtotal = 0.0;
 float gtotal = 0.0;
 float btotal = 0.0;
 int offset = matrixsize / 2;
 for (int i = 0; i < matrixsize; i++){
 for (int j= 0; j < matrixsize; j++){
 // What pixel are we testing
 int xloc = x+i-offset;
 int yloc = y+j-offset;
 int loc = xloc + img.width*yloc;
 // Make sure we haven't walked off our image, we could do better here
 loc = constrain(loc,0,img.pixels.length-1);
 // Calculate the convolution
 rtotal += (red(img.pixels[loc]) * matrix[i][j]);
 gtotal += (green(img.pixels[loc]) * matrix[i][j]);
 btotal += (blue(img.pixels[loc]) * matrix[i][j]);
 }
 }
 // Make sure RGB is within range
 rtotal = constrain(rtotal, 0, 255);
 gtotal = constrain(gtotal, 0, 255);
 btotal = constrain(btotal, 0, 255);
 // Return the resulting color
 return color(rtotal, gtotal, btotal);
 }
 */

/*//------------------------------------------starting full screen in projector without frame borders SHIFFMAN
 /Shiffman's advice for starting full screen undecorated windows in second monitor
 //void init() { 
 //  frame.removeNotify();
 // frame.setUndecorated(true);
 // frame.addNotify();
 //  super.init();
 //}
 //then in draw add:  frame.setLocation(0,0); // to place an undecorated screen at origin
 //or in the case of second monitor (1024, 0) if my primary screen is (1024,768)
 */
