class Particle {
  float x,y;
  float vx = 0, vy = 0;
  float s = 2;
  float speedSq = 0;
     
  Particle(float xx, float yy) {
    x = xx;
    y = yy;
  }
   
  Particle(float xx, float yy, float vxx, float vyy) {
    x = xx;
    y = yy;
    vx = vxx;
    vy = vyy;
  }
   
  void update() {
    x += vx;
    y += vy;
    vx *= damping;
    vy *= damping;
    speedSq = vx*vx + vy*vy;
     
    if (x < 0) {
      x = 0;
      vx = -vx;
    } else if (x > width) {
      x=width;
      vx = -vx;
    }
     
    if (y < 0) {
      y = 0;
      vy = -vy;
    } else if (y > height) {
      y=height;
      vy = -vy;
    }  
  }
   
  void draw() { 
    pushMatrix();   
    translate(x,y);
    rotate(atan2(vy,vx));
    float blink = random(0,1);
    blink *= blink*blink;
    fill(0,
         0,
         speedSq*70*blink+100,
         180+speedSq*40);
     
    ellipse(0,0,s+speedSq/5,s+speedSq/15*blink + blink * 2);
    popMatrix();
  }
}

