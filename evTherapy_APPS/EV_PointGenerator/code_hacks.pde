/* a depository for code I will eventually need (rather than searching searching again through examples*/
//__________________________________________________________________


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
