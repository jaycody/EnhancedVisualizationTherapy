import processing.opengl.*;
float circle;
float strokeH;
float strokeS;
float strokeB;
 
void setup() {
  size(1024, 768, OPENGL);
  colorMode(HSB, 255);
  background(0);
  smooth();
}
 
void draw() {
   pushMatrix();
  translate(mouseX, mouseY);
  popMatrix();
  circle = random(10);
  strokeH= random(170, 185);
  strokeS= random(140, 180);
  strokeB= random(120, 180);

  fill(255);
  stroke(strokeH, strokeS, strokeB, 100);
  ellipse(mouseX, mouseY, circle, circle);
 // line(mouseX, mouseY, 300 - pmouseX, 350 - pmouseY);
 line(mouseX, mouseY, width-mouseX,height-mouseY);

  }
 
void mousePressed() {
  background(0);      // clears the background
}
 
//void keyPressed() {
//  println("Saved!");
//  save("OFFF.jpg");
//}

