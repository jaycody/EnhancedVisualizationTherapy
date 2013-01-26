/*jason stephens
 thesis - itp - spring 2012
 EV_Therapy - Dynamic Bounding Box
 
 The DynBndBox works in addition to a stationary bounding box that excludes the walls and curtain
 With just a stationary bounding box, the top of my head will register
 unless my hand is above my head.  This app looks for the tallest point above the
 massage table that is closest to the center of the table. The box dimensions
 then become a function of the points distance from center, angle from center, and depth. 
 The box's aspect ratio remains consistent with the table's ratio, with a maximum width/heigh
 not to exceed the orignal stationary bounding box.
 
 After DynBndBx 1 is created, a second box and 3rd box are genrated based on the height of the top
 of my head and my other hand if it is taller than my head.  If third point is beyond
 my head, and beyond the range of a bounding box around my head,(to exclude my shoulders), then a 
 third box appears.
 */

import SimpleOpenNI.*;
SimpleOpenNI  kinect;

PImage depthImage;

void setup()
{
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

void draw()
{
  kinect.update();

  //get the 1D array of depth values
  int[] depthValues = kinect.depthMap();
  //-------1.call kinect.update(); // to update Kinect Pixels
  //-------2.create a 1D array to store the updated depthValues from kinect's depthMap
  //-------3.Now Extract the depth at specific array index related to
               // MOUSECLICK using eith get() or old skool
  //-------4.load the pixels of the kinect.depthImage into PImage
  //-------5.loop through PImage pixels of depthImage and use each pixel location 
               //to get associated index # and use to extract depth value from [] depthValues
  //-------6. store extracted depth value from each index  and store for threshold test
  //-------7. Test each pixel depth against threholds.  
  //-------8. if tested pixel is outside range, then set that pixel to ZERO
  //-------9. After one complete loop, call image() to show update image of visible/invisible

 
  //convert mouse position to index value and store index value
   //this works because the array of depth values already loaded has
   //the same size index as the screen display.  so we use the mouseXY screen
   //information and associate it with the array of depthValues
   
   int clickPosition = mouseX + (mouseY * 640);
   //use index value to extract full depth information
   int millimeters = depthValues[clickPosition];
   float inches = millimeters / 25.4;
   println("mm: " + millimeters + " in: " + inches);
   
   
   
   /*---------------------------------------------------------
  //following approach is WRONG.  get() circumvents the array completely at returns pixel values
 // as oppsed to getting index value and using that to get depthValue 
  //______________________---alternative approach :: use get() at mouseClick
  if (mousePressed) {
    int loc = get(mouseX, mouseY); // this doesn't need dot syntax, we just need the array index
    int millimeters = depthValues[loc];
    float inches = millimeters/25.4; //
  }
  ------------------------------------------------------------
  */
  

  depthImage = kinect.depthImage();
  for (int x = 0; x < 640; x++) {
    for (int y = 0; y < 480; y++) {
      int i = x + y * 640;
      int currentDepthValue = depthValues[i];
      if (currentDepthValue < 610 || currentDepthValue > 1525) {
        //depthImage.pixels[i] = 0;
      }
    }
  }

  image(depthImage, 0, 0);
}

void mousePressed() {
  save("depth_limit.png");
}

