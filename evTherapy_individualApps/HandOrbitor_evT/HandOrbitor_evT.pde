// jason stephens
// processing kung fu
// nature of code _ PVector Practice

// going to create an object that follows the mouse
// 1. creat a class Healer.
// 2. create the main program


// call on the Healer

Healer jay;

//setup

void setup(){
  size (400,400);
  background(0);
  
  jay = new Healer ();
}

void draw(){
  //fill (255,10);
  jay.update();
  jay.render();
  jay.checkedges();
}
