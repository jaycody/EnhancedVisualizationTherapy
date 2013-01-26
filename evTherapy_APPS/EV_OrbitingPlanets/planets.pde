class planet {
  public float M;
  public float x;
  public float y;
  private float dx;
  private float dy;
  private int ix;
  int sizeLimit = 10;
  float scaleSize=5;
   
  public planet(int index) {
    x=random(200,300);
   //  x=random(600,800);
    y=random(200,300);
    M=random(50,256);
    ix=index;
  }
   
  public void draw() {
    
    stroke(0);
    if (!doStroke) noStroke();
    float r=(mag(dx,dy)*scaleSize);
    float velCol =abs (r);
    if (r>sizeLimit) r=sizeLimit;  //20 orignial
    float col=M;
    //fill(col,col,col,255);
     //fill(255*(r/sizeLimit),  col*1-(r/sizeLimit),col*(width-x)/width,255);
     fill(255*(1/1/velCol),  col*1-(r/sizeLimit),col*(height-y)/height,255);
//     fill(col*(width-x)/width,255 *(x/width),col*1-(height-y)/height,255);
    ellipseMode(CENTER);
    ellipse(x,y,r,r);
  }
   
  public void exert() {
    float G=-0.00000009; // speed constant//was float G=-0.000005; // speed constant
    for (int i=0;i<NUM_PLANETS;i++) {
      float xoff=x-solarsystem[i].x;
      float yoff=y-solarsystem[i].y;
      float distance=mag(xoff,yoff);
      if (i!=ix ) {
        float magn=G*((M*solarsystem[i].M)/(float)Math.pow((double)distance,1.3));//originally 2, 1.4works great
        dx += (magn*xoff);
        dy += (magn*yoff);
      }
    }
     
  }
   
  public void move() {
    x=x+dx;
    y=y+dy;
//    if (x>512.0) x-=512;
//    if (x<0.0) x+=512;
//    if (y>512.0) y-=512;
//    if (y<0.0) y+=512;   
 if (x>width) x-=width;
    if (x<0.0) x+=width;
    if (y>height) y-=height;
    if (y<0.0) y+=height;   
  }
}

