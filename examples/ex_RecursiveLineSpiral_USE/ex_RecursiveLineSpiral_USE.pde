float a = radians(58);
float k = sin(PI-3*a)/sin(a);
 
void setup(){
  size(1024,768);
  background(0);
  smooth();
  strokeWeight(2);
}
 
void draw(){
  background(0);
  translate(mouseX-width/2, mouseY-height/2);
  for (float l=300; l>2; l = l/(k+0.95)){
    if (l==300){
      noStroke();
    }else{stroke(0,0,255);strokeWeight(l/100);}
    a=radians(120*mouseX/width);
    line(0,0,0,l);
    translate(0,l);
    rotate(-PI+a);
  }
  if (mousePressed == true){saveFrame("spirals.jpg");}
}

