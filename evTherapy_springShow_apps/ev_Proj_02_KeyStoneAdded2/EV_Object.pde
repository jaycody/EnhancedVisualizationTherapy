//--------------Basic EV Objects
/*


class EV_Objects {
  
  PVector loc;
  float edge; //width/radius,triangle length;
  float theta;
  int type;
  color c;
 
  
 
 
 EV_Objects (int _type) {
   loc = new PVector (width/2,height/2);
   size = 50;
   type = _type; //1-3
   color c = color(255,255,255);
 }

*/


//-------------------------------------------------------------
void drawRVLtestImage() {
  fill (255*mouseX/width, 0, 255*mouseY/height, 150);
  tint(255, 255, 0, 175);
  imageMode(CENTER);
  image(rvl, mouseX, mouseY,50,50);
  imageMode(CORNER);
  tint(255, 255, 255, 255);//return the tint
}

/*
void drawAcuNeticTestImage() {
  //------------------------------------Accunetic Fucntions
  PVector wind = new PVector (.04, 0);
  PVector gravity = new PVector (0, .19);
  //acuNetic.applyForce(wind);
  //acuNetic.applyForce(gravity);
  acuNetic.update();
  acuNetic.display();
  acuNetic.checkEdges();
}*/
