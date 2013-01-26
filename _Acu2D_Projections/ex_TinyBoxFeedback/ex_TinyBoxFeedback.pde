int i,x,y,w=1024;
int h=768;
void setup(){
size(w,h);
}
void draw(){
  x=mouseX;
  y=mouseY;
  fill(x);
  strokeWeight(y>>5);
  stroke(0);
translate(w/2,h/2);
for(i=0;i<y;i++,rotate(y*PI/w),scale(.9))rect(-w/2,-h/2,w,h);}

