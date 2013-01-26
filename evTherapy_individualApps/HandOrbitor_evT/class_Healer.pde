// create the Healer class

class Healer {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  
  //PVector mouse;
 // PVector direction;  // why don't we call these here?
  
  Healer () {
    location = new PVector (width/2, height/2);
    velocity = new PVector (0,0);
    topspeed = 9;
  }
  
  void update () {
    PVector mouse = new PVector (mouseX, mouseY);
    PVector direction = PVector.sub(mouse, location);  //static version 
    direction.normalize();
    direction.mult(.5);
    acceleration = direction;
    
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
  }
  
  void render () {
    fill (255);
    ellipse (location.x, location.y, 20,20);
  }
  
  void checkedges () {
    if (location.x >width) {
      location.x = 0;
    }
   else if (location.x < 0 ) {
      location.x= width;
   }
   
   if (location.y > height) {
     location.y = 0;
   }
   else if (location.y<0){
     location.y = height;
   }
      
}
}
