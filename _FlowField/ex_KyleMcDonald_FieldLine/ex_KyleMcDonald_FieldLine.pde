Vector field = new Vector();
Vector control = new Vector();
int n = 255;
 
void setup() {
  size(512, 512, P2D);
  for(int i = 0; i < n; i++) {
    for(int j = 0; j < n; j++) {
      float x = map(i, -1, n, 0, width);
      float y = map(j, -1, n, 0, height);
      FieldLine cur = new FieldLine(x, y);
      cur.xm = random(-10, 10);
      cur.ym = random(-10, 10);
      field.add(cur);
    }
  }
}
 
void draw() {
  FieldLine cur;
  for(int i = 0; i < field.size(); i++) {
    cur = (FieldLine) (field.get(i));
    cur.update(control);
  }
   
  background(255);
   
  fill(0);
  stroke(0, 16);
  for(int i = 0; i < field.size(); i++) {
    cur = (FieldLine) (field.get(i));
    cur.draw();
  }
   
  fill(255, 0, 0);
  stroke(255, 0, 0);
  for(int i = 0; i < control.size(); i++) {
    cur = (FieldLine) (control.get(i));
    cur.draw();
  }
}
 
void keyPressed() {
  control.clear();
}
 
void mousePressed() {
  control.add(new FieldLine(mouseX, mouseY));
}
 
void mouseDragged() {
  FieldLine cur = (FieldLine) control.lastElement();
  cur.xm = mouseX - cur.x;
  cur.ym = mouseY - cur.y;
}
