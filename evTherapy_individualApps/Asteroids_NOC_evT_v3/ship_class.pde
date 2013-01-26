//// create the class for the ship
//
//class Ship {
//   PVector loc;
//  PVector vel;
//  PVector acc;
//  float theta;
//  float topspeed;
//  
//  Ship () {
//   loc = new PVector (width/2, height/2);
//   vel = new PVector (0,0);
//   topspeed =4;
//  theta = 0;
//  }
// 
// void renderShip () {
//  
//   
//   pushMatrix();
//   stroke(0);
//   fill(0,255,0);
//   rectMode(CENTER);
//   translate(loc.x,loc.y);
//   rotate(theta);
//  triangle(0,0,100,0,50,150);
//  popMatrix();
//  
//  theta = theta +1;
// }
//}
