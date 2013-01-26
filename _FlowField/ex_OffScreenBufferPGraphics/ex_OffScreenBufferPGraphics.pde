/**
 * offscreenComplex.pde
 *
 * Demonstrates how off-screen buffers can be used to maintain a
 * high frame-rate even while drawing complex imagery that normally
 * causes the frame rate to plummet significantly.
 *
 * @author Matt Patey
 */
PGraphics buffer;
PImage img;
PFont font;
boolean mode;
int targetFrameRate;
 
void setup() {
  size(500, 500);
  targetFrameRate = 30;
  frameRate(targetFrameRate);
 
  // Create an off-screen buffer.
  buffer = createGraphics(500, 500, JAVA2D);
 
  // Draw something complex in the off-screen buffer.
  renderComplexImage(buffer);
 
  //font = loadFont("CourierNew36.vlw");
 
  // Copy some pixels from the off-screen buffer to display
  // them on the screen.
  updateBuffer();
}
 
/**
 * Populates the off-screen buffer with a complex image then copies
 * the buffer contents to an image that we will display on screen.
 */
void updateBuffer() {
  renderComplexImage(buffer);
  img = buffer.get(0, 0, buffer.width, buffer.height);
}
 
void keyPressed() {
  mode = !mode;
}
 
void mousePressed() {
  updateBuffer();
}
 
void draw() {
  background(255);
 
  if(!mode) {
    image(img, 0, 0);
  } 
  else {
    renderComplexImage(buffer);
    image(img, 0, 0);
  }
 
  // We can still animate things on the main canvas.
  noStroke();
  fill(255, 0, 0, 128);
  ellipse(random(width), random(height), 20, 20);
 
  drawInfo();
}
 
/**
 * Draws a complex drawing into an off-screen buffer.
 */
void renderComplexImage(PGraphics buffer) {
  buffer.beginDraw();
  buffer.background(255);
  buffer.smooth();
  buffer.noFill();
 
  for(int i = 0; i < buffer.width; i++) {
    for(int j = 0; j < buffer.height; j++) {
      if(i % 8 == 0 && j % 8 == 0) {
        buffer.stroke(random(30) + 80, random(30) + 40, 0, random(60) + 24);
        float x = width / 2 + (random(60) - 30);
        float y = 0;
        float x2 = x + (random(160) - 80);
        float y2 = random(height / 2) + height / 2;
 
        buffer.bezier(x, y, 
                      x + (random(x/2) - x/2), y + (random(y/2) - y/2),
                      x2 + (random(x2/2) - x2/2), y2 + (random(y2/2) - y2/2), 
                      x2, y2);
      }
    }
  }
 
  buffer.endDraw();
}
 
/**
 * Draws information about the frame rate and mode.
 */
void drawInfo() {
  fill(0);
  //textFont(font);
  textSize(18);
  text("are we re-drawing every frame: " + mode, 5, height - 40);
  text("target frame rate: " + targetFrameRate, 5, height - 25);
  text("current frame rate: " + round(frameRate), 5, height - 10);
}

