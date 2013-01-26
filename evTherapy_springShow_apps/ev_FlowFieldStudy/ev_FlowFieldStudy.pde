// Vector Field Study #2
// open processing
// Loren Schmidt

//orignial res
//int resolutionX = 192;//original =192
//int resolutionY = resolutionX / 2;

int resolutionX = 200;//original =192
int resolutionY = 150;

PVector flow[][] = new PVector[resolutionX][resolutionY];
float density[][] = new float[resolutionX][resolutionY];
float wind[] = new float[resolutionY]; // horizontal bands
int particleCount = 8192;
Particle particle[] = new Particle[particleCount];
int currentParticle;
int oldMouseX;
int oldMouseY;
 
 
void setup() {
  size(1024, 768);
  frameRate(60);
  for (int y = 0; y < resolutionY; y ++) {
    wind[y] = 1 * sin(4 * PI * y / resolutionY);
    for (int x = 0; x < resolutionX; x ++) {
     // flow[x][y] = new PVector();
      flow[x][y] = new PVector(0.2 - random(0.4), 0.2 - random(0.4));
    }
  }
  for (int i = 0; i < particleCount; i ++) {
    particle[i] = new Particle(random(resolutionX),
      random(resolutionY));
  }
}
 
void draw() {
  fill(0);
  rect(0, 0, width, height);
  int zoom = min(width / resolutionX, height / resolutionY);
   
  for (int y = 0; y < resolutionY; y ++) {
    for (int x = 0; x < resolutionX; x ++) {
      density[x][y] = 0;
    }
  }
   
  // Particles?
  stroke(255);
  for (int i = 0; i < particleCount; i ++) {
    particle[i].Update();
    particle[i].Draw(zoom);
  }
   
  noStroke();
  for (int y = 0; y < resolutionY; y ++) {
    for (int x = 0; x < resolutionX; x ++) {
      fill(
        /*min(255, int(255 * abs(flow[x][y].x) / 0.2)),
        min(255, int(255 * abs(flow[x][y].y / 0.2))),*/
        int(max(0, min(255, 255 * density[x][y]))));
      rect(x * zoom, y * zoom, zoom, zoom);
    }
  }
   
  // Randomization of flow
  //flow[int(random(resolutionX))][int(random(resolutionY))]
    //= new PVector(-1 + random(2), -1 + random(2));
     
  // Painting
  int cellX = mouseX / zoom;
  int cellY = mouseY / zoom;
  if (mousePressed) {
    for (int i = 0; i < 32; i ++) {
      particle[currentParticle] = new Particle(cellX, cellY);
      currentParticle = (currentParticle + 1) % particleCount;
    }
  }
   
  // Make mouse movement affect flow
  float dX = cellX - oldMouseX;
  float dY = cellY - oldMouseY;
  for (int y = -8; y < 8; y ++) {
    for (int x = -8; x < 8; x ++) {
      flow[max(0, min(resolutionX - 1, cellX + x))]
        [max(0, min(resolutionY - 1, cellY + y))].add
        (new PVector(dX, dY));
    }
  }
  oldMouseX = cellX;
  oldMouseY = cellY;
}
 
 
void keyPressed() {
  setup();
}

