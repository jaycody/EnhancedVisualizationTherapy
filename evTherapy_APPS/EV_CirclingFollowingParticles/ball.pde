class ball {
  float X;
  float Y;
  float Xv;
  float Yv;
  float pX;
  float pY;
  float w;
  float r;
  ball() {
    X = random(screen.width);
    Y = random(screen.height);
    w = random(1 / thold, thold);
  }
  void render() {
    if(!mousePressed) {
      Xv /= spifac;
      Yv /= spifac;
    }
    Xv += drag * (mX - X) * w;
    Yv += drag * (mY - Y) * w;
    X += Xv;
    Y += Yv;
    //r = mag(X,pX);
   // stroke(distance(0,0,mouseX, mouseY),5);
        stroke(distance(width,height/2,mouseX, mouseY),distance(mouseX, mouseY,0,height),255-distance(width,height,mouseX,mouseY));//distance(width,height,mouseX,mouseY));
 //   println (mag(X,pX));
    //stroke (255,0,0);
    line(X, Y, pX, pY);
   
    pX = X;
    pY = Y;
  }
}
/*
/top left square
fill(distance(0,0,mouseX,mouseY));
rect(0,0,width/2-1,height/2-1);

// top right square
fill(distance(width,0,mouseX,mouseY));
rect(width/2,0,width/2-1,height/2-1);

// bottom left square
fill(distance(0,height,mouseX,mouseY));
rect(0,height/2,width/2-1,height/2-1);

// bottom right square
fill(distance(width,height,mouseX,mouseY));
rect(width/2,height/2,width/2-1,height/2-1);

*/

