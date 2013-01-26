/*jason stephens
 thesis - itp 
 pulsatingAura
 
 TODO:
 _______track rise and fall of breath and use it to inform the table matrix
 ______add eye closing from comp cameras
 */

int diam = 10;
float centX, centY;
int lastKeyPressed = 0;
int varStrokeWeight = 1;

//randomLineVariables
float stepX =10;
float stepY = 10;

float lastX = 0;
float lastY = 0;
float y = 50;
int borderX = 20;
int borderY=10;
int timerT =0;

void setup () {
  size (1024, 768);
  frameRate (24);
  smooth();
  background (0);
  centX=width/2;
  centY=height/2;
  stroke (0, 0, 255);
  strokeWeight(3);
  //noFill();
  fill(0, 25);
  printControls();
  y= height/2;  //to start line off in center
  lastY=height/2;
}

void draw () {
  // '1'___________________pulsatingPoint
  if (lastKeyPressed == 1) {
    pulsatingPoint(mouseX, mouseY);
  }
  // '2'___________________PulsatingAura
  if (lastKeyPressed ==2) {
    pulsatingAura();
  }
  // '3'___________________
  if (lastKeyPressed ==3) {
    randomLine();
  }
  // '4'___________________
  if (lastKeyPressed ==4) {
    randomLine2();
  }
  // ''___________________
  if (lastKeyPressed ==5) {
    noiseLine();
  }
  if (lastKeyPressed ==6) {
    sinLine();
  }
  if (lastKeyPressed ==7) {
    trigCircle();
  }
  // '9'___________________All
  if (lastKeyPressed ==9) {
    pulsatingAura();
    pulsatingPoint(mouseX, mouseY);
  }
} 
//1_________________________________
void pulsatingPoint(float x, float y) {
  //background (0);
  stroke (0, 0, 255);
  strokeWeight(varStrokeWeight);
  float mouseDiam = map (diam, mouseX, width, 1, 200);
  ellipse (x, y, mouseDiam, mouseDiam);
  ellipse (x, y, mouseDiam-50, mouseDiam-50);
  if (diam < 200) {
    ellipse (x, y, diam, diam);
    diam += 10;
  }
  if (diam >= 200) {
    diam =0;
  }
}
//2________________________________
void pulsatingAura() {
  strokeWeight(varStrokeWeight);
  background(0);
  strokeCap(SQUARE);

  //    for (int h = 0; h < height-15; h+=10) {
  for (int h = 0; h < mouseX-15; h+=10) {
    stroke(0, 0, 255, 255-h);
    line(width-h, 10, width-h, height);
    line(0, h, width, h);//original
    line(0, height-h, width, height-h);//original
    //stroke(0, h);
    // line(10, h+4, width-20, h+4);
  }
}
//3
void randomLine() {
  stroke (0, 0, 255);
  float randomX = random(width);
  float randomY = random(height);
  line(mouseX, mouseY, randomX, randomY);
  line (randomX, randomY, lastX, lastY);
  lastX = randomX;
  lastY = randomY;
}
//4
void randomLine2 () {
  stroke (0, 0, 255);
  while (timerT < 1) {
    for (int x = borderX; x<=width-borderX; x+=stepX) {
      stepY = random(10) -5; //making the range -10 to 10
      y += stepY;
      //y=borderY + random(height-2*borderY);
      //if (lastX >-999) {
      line (x, y, lastX, lastY);

      lastX = x;
      lastY = y;
    }
    timerT++;
  }
} 
//5
void noiseLine() {
  while (timerT<1) {
    stroke(255, 0, 255);
    line (20, height/2, width, height/2);
    stroke(0, 255, 0);
    int step =10;
    float noiseY = random (10);//acts os original random seed
    float y;
    for (int x=20; x<= width; x+=step) {
      y = width/2+ noise(noiseY)*80; //returns value from random seed then scalar
      line (x, y, lastX, lastY);
      lastX = x;
      lastY = y;
      noiseY += 0.9;//incremements noise by .1 (otherwise it repeats)
    }
    timerT++;
  }
}
//6
void sinLine() {
  while (timerT<1) {
    stroke(0, 255, 0);
    float stepX=1;
    float lastX=-999;
    float lastY=-999;
    float angle = 0;
    //float y = 50;
    for (int x = 20; x<=width; x+=stepX) {
      float rad = radians(angle);
      y=height/2+(sin(rad)*200);
      line (x, y, lastX, lastY);
      y=height/2+(pow(sin(rad), 3 )*200); //raise to the power of 3 (aka cube)
      line (x, y, lastX, lastY);
      y=height/2+(pow(sin(rad), 3 )* noise(rad*20) * 200);
      line (x, y, lastX, lastY);
      y=height/2+ (customRandom() * 200); //raise to the power of 3 (aka cube)
      line (x, y, lastX, lastY);

      lastX=x;
      lastY=y;
      angle++;
    }
    timerT++;
  }
}
// custom random function
float customRandom() {  //now use this in the sinLine function
  float retValue = 1 - pow(random(1), 2);
  return retValue;
}
//7
void trigCircle() {
  strokeCap(ROUND);
  while (timerT<1) {
    stroke(255, 255, 0);
    noFill();
    float x,y;
    float radius = 200;
    for (float ang = 0; ang <=360; ang +=5) {
      float rad = radians(ang);
      x = centX + (radius * cos(rad));
      y = centY + (radius * sin(rad));
      point (x, y);
    }
    timerT++;
  }
  println(timerT);
}
//_________________________________
void keyPressed() {
  if (key == '1') {
    lastKeyPressed = 1;
    varStrokeWeight =3;
    fill(0,25);
  }
  else if (key == '2') {
    lastKeyPressed = 2;
    varStrokeWeight = 4;
  }
  else if (key == '3') {
    lastKeyPressed = 3;
    varStrokeWeight = 2;
  }
  else if (key == '4') {
    lastKeyPressed = 4;
    varStrokeWeight = 2;
    timerT=0;
  }
  else if (key == '5') {
    lastKeyPressed = 5;
    varStrokeWeight = 2;
    timerT=0;//resets the loop everytime so the function runs once
  }
  else if (key == '6') {
    lastKeyPressed = 6;
    varStrokeWeight = 2;
    timerT=0;
  }
  else if (key == '7') {
    lastKeyPressed = 7;
    varStrokeWeight = 2;
    timerT=0;
  }
  else if (key == '9') {
    lastKeyPressed = 9;
  }

  if (keyCode == ENTER) {
    saveFrame ("screen-####.jpg");
  }
  if (keyCode == ' ') {
    background(0);
  }
}
//_________________________________
void printControls() {
  println("'1'=pulsatingPoint");
  println("'2'=pulsatingAura");
  println("'3'=randomLine");
  println("'9'=ALL");
  println("'ENTER'=saveFrame");
}

