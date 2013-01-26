/* _________________________________
 :HISTORY:
 
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
