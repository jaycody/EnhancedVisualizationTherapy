/*jason stephens
thesis - itp - spring 2012
HandControlledAR

From ex.9-8::Learning Processing - Shiffman
and Recursion Example NOC
*/


// Example 9-8: A snake following the mouse
float f;
float fxPos;
// Declare two arrays with 50 elements.
int[] xpos = new int[40];//50=original 
int[] ypos = new int[40];

void setup() {
  size(1024,768);
  
  smooth();
  // Initialize all elements of each array to zero.
  for (int i = 0; i < xpos.length; i ++ ) {
    xpos[i] = 0; 
    ypos[i] = 0;
  }
}

void draw() {
  background(0);
  
  // Shift array values
  for (int i = 0; i < xpos.length-1; i ++ ) {
    // Shift all elements down one spot. 
    // xpos[0] = xpos[1], xpos[1] = xpos = [2], and so on. Stop at the second to last element.
    xpos[i] = xpos[i+1];
    ypos[i] = ypos[i+1];
  }
  
  // New location
  xpos[xpos.length-1] = mouseX; // Update the last spot in the array with the mouse location.
  ypos[ypos.length-1] = mouseY;
  
  // Draw everything
  for (int i = 0; i < xpos.length; i ++ ) {
    float j=20; // where j is the timer for looping the recursion
     // Draw an ellipse for each element in the arrays. 
     // Color and size are tied to the loop's counter: i.
    //noStroke(); //original code
    //fill(255-i*5);//original code
    stroke(0+i*6);
    noFill();
   // ellipse(xpos[i],ypos[i],i*3,i*3);//comment this out and place recursive function
   f = float(i);
   fxPos = float(xpos[i]);// need to turn this into a float
     drawCircle(fxPos,ypos[i],f*4, j);
    //add the recursive function here::
    //drawCircle(xpos[xpos.length-1],ypos[ypos.length-1],i*3, j); 
    
  }
}

void drawCircle(float x, int y,  float radius, float t) {
  ellipse(x,y,radius,radius); 
  if (t > 1) {
    t= t/2.9;  //had to get this timer out of the loop somehow
    drawCircle(x + radius/2, y, radius/1.5, t);
    drawCircle(x - radius/2, y, radius/1.5, t);
    
  }
 
 
 
 
 
  
  
  
  
  
}
