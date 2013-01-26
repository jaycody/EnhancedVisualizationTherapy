/**
 * Spot. 
 * 
 * Move the mouse the change the position and concentation
 * of a blue spot light. 
 
 TO-DO:
 DONE _____Curently adding Control5 control for directionalLight (requires a Control Windo)
 ______Download touchOSC editor and connect iphone to NewTron host as per the directions
 http://www.sparkfun.com/tutorials/152
 _____add Control5 controls to sphere size and position
 _____add Control5 controls to lighting position
 _____add Control5 controls to color
 _____add Control5 into touchOSC
 _____add Kinect to follow average point and map to eyeball tracking
 
 */

import controlP5.*;
ControlP5 controlP5;
Slider2D s; // 2D slider for X,Y of directionalLIght
ControlWindow controlWindow;

float directionalLightX = 0;
float directionalLightY = 0;
float directionalLightZ = 0;


float spotLightX;
float spotLightY;

//int concentration = 600; // Try values 1 -> 10000

void setup() 
{

  size(640, 360, P3D);
  controlP5 = new ControlP5(this);

  //Horizontal Sliders for directionalLight X and Y in Controller Window
  //control window in setup
  controlP5.setAutoDraw(false);
  controlWindow = controlP5.addControlWindow("controlP5window", 100, 100, 400, 400); //window positionXY, window size

  controlWindow.hideCoordinates();

  controlWindow.setBackground(color(40));

  Controller mySlider = controlP5.addSlider("directionalLightX", -2*PI, 2*PI, 0, 20, 20, 200, 10);
  //range -100 to 100, starting at 0, placing at x = 20, y = 20, 200 pixels long, 10 pixels wide
  mySlider.setWindow(controlWindow);

  // direcitonalLightY slider
  Controller mySlider2 = controlP5.addSlider("directionalLightY", -2*PI, 2*PI, 0, 20, 60, 200, 10);
  //range -100 to 100, starting at 0, placing at x = 20, y = 20, 200 pixels long, 10 pixels wide
  mySlider2.setWindow(controlWindow);

  Controller mySlider3 = controlP5.addSlider("directionalLightZ", -2*PI, 2*PI, 0, 310, 20, 10, 200);
  mySlider3.setWindow(controlWindow);

  //2D Controls for directionalLight X and Y inside Controller Window
  //Slider2D s = controlP5.addSlider2D("slider", -2*PI, 2*PI, -2*PI, 2*PI, 0, 0, 20, 100, 100, 100); 
  //s.setWindow(controlWindow); //put the 2DSlider into the Control Window




    noStroke();
  fill(204);
  sphereDetail(60);
}

void draw() 
{
  background(0); 

  //  // directional light for sphere
  //  ScaleddirectionalLightX = directionalLightX * -1; // range of the slider to match range of dirLightX
  //  ScaleddirectionalLightY = directionalLightY * -1; // range of the slider to match range of dirLightX
  //  print(ScaleddirectionalLightX);
  //  println(", " + ScaleddirectionalLightY);
  ////  directionalLight(51, 102, 126, ScaleddirectionalLightX, ScaleddirectionalLightY, -3); // with 1D sliders
  //  //red or hue, green or hue, blue or hue, direction along x-axis, direction along y, direction along z, (-1 - +1)

  // directionalLight Controlled by 2D slider
  directionalLight(51, 102, 126, directionalLightX, directionalLightY, directionalLightZ); // with 2DSliders

  // Orange light on the upper-right of the sphere
  spotLight(204, 153, 0, 360, 160, 600, 0, 0, -1, PI/2, 600); //spotLight(v1, v2, v3, x, y, z, nx, ny, nz, angle, concentration)
  // v123=color, xyz=cordinate of light, nx,ny,nz direction along xyz axis, angle =angle of spotlight cone, concentration
  // Moving spotlight that follows the mouse
  spotLight(102, 153, 204, mouseX, mouseY, 600, 0, 0, -1, PI/2, 600); 

  translate(width/2, height/2, 0); 
  sphere(120);
}

