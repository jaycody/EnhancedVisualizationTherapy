PImage img;

void setup() {
  size(1024, 768, P3D);
  img = loadImage("01.png");
  noStroke();
}

void draw() {
  background(0);
  translate(width / 2, height / 2);
  rotateY(map(mouseX, 0, width, -PI, PI));
  rotateZ(PI/6);
  beginShape();
  texture(img);
  vertex(-100, -100, 0, 0, 0);
  vertex(100, -100, 0, 400, 0);
  vertex(100, 100, 0, 400, 400);
  vertex(-100, 100, 0, 0, 400);
  endShape();
}

