FKBox windMill;
float rotx = -PI / 2 + PI / 10f;
float roty = -PI / 2 - PI / 10f;
 
float mouseXwhenNotPressed = width / 2;
float mouseYhenNotPressed = 0;
 
 
void setup() {
  size(600, 600, P3D);
  rectMode(CORNERS);
 
  int B = color(128);
  int W = color(255);
 
  windMill = new FKBox(this, -30f, -30f, 30f, 30f, 0f, W);
 
  makeHorizontalWing(+1, B);
  makeHorizontalWing(-1, B);
 
  makeVerticalWing(+1, B);
  makeVerticalWing(-1, B);
 
  makeDiagonalWing(+1, B);
  makeDiagonalWing(-1, B);
 
  makeOtherDiagonalWing(+1, B);
  makeOtherDiagonalWing(-1, B);
 
  windMill.impulse(0.0000002f, 0.99999999f);
  windMill.move(0.0001000f);
  windMill.draw();
}
 
 
void makeVerticalWing(int direction, int wingColor) {                              
  FKBox aNewNode = new FKBox(this, 0f, -2f, direction * 220f, 2f, PI / 2f, wingColor);
  windMill.attach(aNewNode, 0, direction * windMill.h / 2f);
 
  makeWingTail(direction, wingColor, aNewNode);            
}
 
void makeHorizontalWing(int direction, int wingColor) {                                                    
  FKBox aNewNode = new FKBox(this, 0f, -2f, direction * 220f, 2f, 0f, wingColor);
  windMill.attach(aNewNode, direction * windMill.w / 2f, 0);
 
  makeWingTail(direction, wingColor, aNewNode);    
}
 
void makeDiagonalWing(int direction, int wingColor) {                              
  FKBox aNewNode = new FKBox(this, 0f, -2f, direction * 220f, 2f, PI / 4f, wingColor);
  windMill.attach(aNewNode, direction * windMill.w / 2f, direction * windMill.h / 2f);
 
  makeWingTail(direction, wingColor, aNewNode);            
}
 
void makeOtherDiagonalWing(int direction, int wingColor) {                             
  FKBox aNewNode = new FKBox(this, 0f, -2f, direction * 220f, 2f, -PI / 4f, wingColor);
  windMill.attach(aNewNode, direction * windMill.w / 2f, -direction * windMill.h / 2f);
 
  makeWingTail(direction, wingColor, aNewNode);            
}
 
 
void makeWingTail(int direction, int wingColor, FKBox aNewNode) {
  FKBox anotherNewNode = new FKBox(this, -2f, 0f, 2f, direction * 90f, -PI/2f, wingColor);
  aNewNode.attach(anotherNewNode, direction * aNewNode.w * 3/4f, 0);
  FKBox oneMoreNewNode = new FKBox(this, -2f, 0f, 2f, direction * 90f, 0f, wingColor);
  anotherNewNode.attach(oneMoreNewNode, 0, direction * anotherNewNode.h / 2f);
  FKBox evenOneMoreNewNode = new FKBox(this, -2f, 0f, 2f, direction * 45f, 0f, wingColor);
  oneMoreNewNode.attach(evenOneMoreNewNode, 0, direction * oneMoreNewNode.h * 2 / 3f);
  FKBox andAnotherOneNewNode = new FKBox(this, -2f, 0f, 2f, direction * 22.5f, 0f, wingColor);
  evenOneMoreNewNode.attach(andAnotherOneNewNode, 0, direction * evenOneMoreNewNode.h * 2 / 3f);
}
 
 
void draw() {
  background(0);
  stroke(255);
 
  // Change height of the camera with mouseY
  float distZ = 575.0f;
 
  float xCam = 300 + distZ * sin(rotx) * cos(roty);
  float yCam = 300 + distZ * cos(rotx);
  float zCam = distZ * sin(rotx) * sin(roty);
 
  camera(xCam, yCam, zCam, // eyeX, eyeY, eyeZ
  300f, 300f, 0.0f, // centerX, centerY, centerZ
  0.0f, 1.0f, 0.0f); // upX, upY, upZ
 
  // Orange point light on the top
  pointLight(150, 100, 0, // Color
  200, -150, 0); // Position
 
  // Blue directional light from the left
  directionalLight(0, 102, 255, // Color
  -1, 0, 0); // The x-, y-, z-axis direction
 
  // Orange directional light from the bottom
  directionalLight(208, 128, 0, // Color
  0, -1, 0); // The x-, y-, z-axis direction
 
  // Green directional light from the right
  directionalLight(128, 224, 224, // Color
  +1, 0, 0); // The x-, y-, z-axis direction
 
  // Yellow spotlight from the front
  spotLight(255, 255, 109, // Color
  300, 150, 375, // Position
  0f, -0.5f, -0.5f, // Direction
  PI, 0.1f); // Angle, concentration
 
  ellipseMode(CENTER);
  ellipse(width / 2, height / 2, 95, 95);
 
  translate(width / 2, height / 2);
 
  strokeWeight(2);
 
  if (mousePressed == false) {
    mouseXwhenNotPressed = mouseX;
    mouseYhenNotPressed = mouseY;
  }
 
  if (mousePressed == false || mouseButton == LEFT) {
 
    float force = (float) (mouseXwhenNotPressed) / (float) (width)
      * 0.4f - 0.2f;
    float decay = (float) (mouseYhenNotPressed) / (float) (height)
      * 0.02f + 0.01f;
 
    windMill.impulse(force, decay);
 
    float friction = 0.88f;
    windMill.move(friction);
  }
 
  windMill.draw();
 
}
 
void mouseDragged() {
  float dy = mouseX - pmouseX;
  float dx = mouseY - pmouseY;
 
  float rate = 0.008f;
  if (abs(dx) > abs(dy)) {
    rotx -= (dx) * rate;
    rotx = java.lang.Math.min(rotx, 0 - 0.01f);
    rotx = java.lang.Math.max(rotx, -PI + 0.01f);
 
  }
  else {
    roty += (dy) * rate;
  }
 
}

