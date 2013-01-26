float thold = 15;//5 original
float spifac = 1.05;//1.05//easing variable
int outnum;
float drag = 0.01;//.01
int big = 500;
ball bodies[] = new ball[big];
float mX;
float mY;
float easingX = .03;//.03
float easingY = .03;//.03
int screenX = 1024;
int screenY = 768;

void setup() {
  size(screenX, screenY);
  strokeWeight(1);
  fill(255, 255, 255);
  stroke(255, 255, 255);
  background(0, 0, 0);
  smooth();
  for (int i = 0; i < big; i++) {
    bodies[i] = new ball();
  }
}

void draw() {
  fill(0, 2);
  rect(0, 0, screenX, screenY);

  if (keyPressed) {
    saveFrame("Focus " + outnum);
    outnum++;
  }
  if (mousePressed) {
    background(0, 0, 0);

//easing convergence
    mX += easingX * (mouseX - mX);
    mY += easingY * (mouseY - mY);
  }
  mX += easingX * (mouseX - mX);
  mY += easingY* (mouseY - mY);
  for (int i = 0; i < big; i++) {
    bodies[i].render();
  }
}

