ImgProc imgProc = new ImgProc();   // Class ImgProc (from [Noise Particle 06] by Marcin Ignac )
int[] currFrame;                   // Frame data current
int[] prevFrame;                   // Frame data previous
int[] tempFrame;                   // Frame data temp
int particlesDensity = 14;         // Particles density
int particleMargin = 64;           // Particles margin
 
Particle[] particles;
  
int startingRadius = 90, radius = 150;
int centerX = width/2, centerY = height/2;
 
int moveMode = 1;
float speed = 0.8;
 
void setup() {
   
  size(400, 400, P3D);
   
  frameRate(24);
   
  currFrame = new int[width*height];      // create frame data of current
  prevFrame = new int[width*height];      // create frame data of previous
  tempFrame = new int[width*height];      // create frame data of temp
   
  // set begining color of frames
  for(int i=0; i<width*height; i++) {    
    currFrame[i] = color(0, 0, 0);
    prevFrame[i] = color(0, 0, 0);
    tempFrame[i] = color(0, 0, 0);
  }
   
  // create array of particles
  particles = new Particle[(width + particleMargin * 2) / particlesDensity *
                           (height + particleMargin * 2) / particlesDensity ];
   
  // Create particles
  // -------------------------------------
  int i = 0;
  for(int y=-particleMargin; y<height+particleMargin; y+=particlesDensity) {
    for(int x=-particleMargin; x<width+particleMargin; x+=particlesDensity) {
       if (i == particles.length) {
         break;
       }
        
       float theta = random(0,TWO_PI);
       float u = random(-1,1);
       int c = color(50+50*sin(PI*x/width), 127, 255*sin(PI*y/width));
       particles[i++] = new Particle(c, (int)random(64), (int)random(64), (int)random(64), theta, u);
    }
  }
}
 
void draw() {
   
  background(0);
    
  // Blur effects.
  imgProc.blur(prevFrame, tempFrame, width, height);   
   
  // Scale Brightness effects.
  //if(pixMode == 1 && moveMode == 1 && fileName != "start.txt") imgProc.scaleBrightness(tempFrame, tempFrame, width, height, 0.2);
   
  arraycopy(tempFrame, currFrame);
  radius = startingRadius + centerX-mouseX;
   
  for(int i=0; i<particles.length; i++) {
    particles[i].update();
    particles[i].render();
  }
   
  // draw the pixels in frame
  imgProc.drawPixelArray(currFrame, 0, 0, width, height);
  arraycopy(currFrame, prevFrame);
 
}
 
void mousePressed()
{ 
  switch(moveMode) {
    case 0:
      moveMode = 1;
      speed = 0.2;
      break; 
       
    case 1:
      moveMode = 0;
      speed = 0.01;
       
  }
}

