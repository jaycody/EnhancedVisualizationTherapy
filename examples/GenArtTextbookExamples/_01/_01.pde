/*jason stephens
 thesis - ITP - Spring 2012
 generativeArt practice
 from GenArt Practical Guide by Matt Pearson
 */


int dia = 10;
float centX, centY;

void setup () {
  size (1024, 768);
  smooth ();
  noFill();
  background (0);
  centX = width/2;
  centY = height/2;
  stroke(255);
}

void draw () {
  
  background(0);
  
  drawCircle();

}

void drawCircle() {
   for (int i = 0; i < 500; i += 10) {

    //ellipse ( centX, centY, dia +i, dia+i);
    // ellipse ( mouseX, mouseY, dia +i, dia+i);
  }
  
  
  
}

