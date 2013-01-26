class Particle {
   
  float theta, u;
  float vTheta, vU;
  float x, y, z;
   
  color theColor;
  
  float xDiff, yDiff, zDiff;    
  float nextX, nextY, nextZ;  
   
  Particle(int c, int nx, int ny, int nz, float Theta, float U){
     
    x = width/2;
    y = height/2;
     
    nextX = width/2;
    nextY = height/2;
    nextZ = width % height;
     
    theColor = c;  
    theta = Theta;
    u = U;
    vTheta = 0;
    vU = 0;
  }
   
  void update() {
     
    vTheta = random(-0.001, 0.001);
    theta += vTheta;
     
    if(theta < 0 || theta > TWO_PI) {
      theta *= -1;
    }
     
    vU += random(-0.001, 0.001);
    u += vU;
    if(u < -1 || u > 1) {
      vU *= -1;
    }
     
    vU*=0.95;
    vTheta*=0.95;
 
     
    // switch with moving mode.
    switch(moveMode) {
      case 0:  // 0.=> Spreading
        nextX += random(-width/4, width/4);
        nextY += random(-height/4, height/4);
        nextZ += random(-height/4, height/4);
        break;
      
      case 1:  // 1. => Gathering
        nextX = (radius * cos(theta) * sqrt(1 - (u * u)));
        nextY = (radius * sin(theta) * sqrt(1 - (u * u)));
        nextZ = u*radius;
         
        // calcurate rotated positions 
        float radX = 45;
        float radY = 45;
        float radZ = 180;
         
        float x1,y1,z1,x2,y2;
         
        x1=nextX*cos(radY)+nextZ*sin(radY);
        y1=nextY;
        z1=-nextX*sin(radY)+nextZ*cos(radY);
   
        x2=x1;
        y2=y1*cos(radX)-z1*sin(radX);
        nextX=x2*cos(radZ)-y2*sin(radZ) + width/2;
        nextY=x2*sin(radZ)+y2*cos(radZ) + height/2;
        
    }
     
    // calculate the move position
    yDiff = (y - nextY) * speed;
    xDiff = (x - nextX) * speed; 
    zDiff = (z - nextZ) * speed;
      
    x -= xDiff--;
    y -= yDiff--; 
    z -= zDiff--;
        
  }
   
  void render() {
     
    if ((x >= 0) && (x < width-1) && (y >= 0) && (y < height-1)) {
      int currC = currFrame[(int)x + ((int)y)*width];
      currFrame[(int)x + ((int)y)*width] = blendColor(theColor, currC, ADD);
    }
    
  }
}

