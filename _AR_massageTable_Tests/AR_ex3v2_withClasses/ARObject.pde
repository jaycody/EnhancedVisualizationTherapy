// class that defines the AROBject, both the AR detection and display are handled inside this class

class ARObject {

  int ID; // keep track of the current the ID of the object (corresponds with the ID i of the marker)

  PVector rot, speed; // in this example the cube has a certain rotation and rotates at a certain speed

  

  ARObject(int ID) {

    this.ID = ID; // set the ID

    rot = new PVector(random(TWO_PI), random(TWO_PI), random(TWO_PI)); // random x, y, z rotation

    speed = new PVector(random(-mS, mS), random(-mS, mS), random(-mS, mS)); // random x, y, z speed (within maxSpeed boundaries)

  }



  void run() {

    // always keep rotating (even when the marker is NOT detected)

    rot.add(speed);

    // checks the object's corresponding marker through the ID

    // if the marker is found, display the cube

    if (nya.isExistMarker(ID)) { display(); }

  }



  // the display in this example shows a colored, rotating RGBCube

  void display () {

    // get the Matrix for this marker and use it (through setMatrix)

    setMatrix(nya.getMarkerMatrix(ID));

    scale(1, -1); // turn things upside down to work intuitively for Processing users



    // hover the cube a little above the real-world marker image

    translate(0, 0, 30);



    // rotate the cube in 3 dimensions

   // rotateX(rot.x);

   // rotateY(rot.y);

    rotateZ(rot.z);



    // scale - as with the the color range - to save typing with the coordinates (and make it much easier to change the size)

    scale(20);



    // a cube made out of 6 quads

    // the 1 range can be used for both the color and the coordinates as a result of color range and scale (see earlier)

    beginShape(QUADS);



//    fill(0, 1, 1); vertex(-1,  1,  1);
//
//    fill(1, 1, 1); vertex( 1,  1,  1);
//
//    fill(1, 0, 1); vertex( 1, -1,  1);
//
//    fill(0, 0, 1); vertex(-1, -1,  1);
//
//  
//
//    fill(1, 1, 1); vertex( 1,  1,  1);
//
//    fill(1, 1, 0); vertex( 1,  1, -1);
//
//    fill(1, 0, 0); vertex( 1, -1, -1);
//
//    fill(1, 0, 1); vertex( 1, -1,  1);
//
//
//
//    fill(1, 1, 0); vertex( 1,  1, -1);
//
//    fill(0, 1, 0); vertex(-1,  1, -1);
//
//    fill(0, 0, 0); vertex(-1, -1, -1);
//
//    fill(1, 0, 0); vertex( 1, -1, -1);
//
//
//
//    fill(0, 1, 0); vertex(-1,  1, -1);
//
//    fill(0, 1, 1); vertex(-1,  1,  1);
//
//    fill(0, 0, 1); vertex(-1, -1,  1);
//
//    fill(0, 0, 0); vertex(-1, -1, -1);
//
//
//
//    fill(0, 1, 0); vertex(-1,  1, -1);
//
//    fill(1, 1, 0); vertex( 1,  1, -1);
//
//    fill(1, 1, 1); vertex( 1,  1,  1);
//
//    fill(0, 1, 1); vertex(-1,  1,  1);
//
//
//
//    fill(0, 0, 0); vertex(-1, -1, -1);
//
//    fill(1, 0, 0); vertex( 1, -1, -1);
//
//    fill(1, 0, 1); vertex( 1, -1,  1);
//
//    fill(0, 0, 1); vertex(-1, -1,  1);

 
  fill(0, 0, 1); vertex(-1,  1,  1);

    fill(1, 0, 1); vertex( 1,  1,  1);

    fill(1, 0, 1); vertex( 1, -1,  1);

    fill(1, 0, 1); vertex(-1, -1,  1);

  

    fill(0, 0, 1); vertex( 1,  1,  1);

    fill(1, 0, 1); vertex( 1,  1, -1);

    fill(1, 0, 1); vertex( 1, -1, -1);

    fill(1, 0, 1); vertex( 1, -1,  1);



    fill(0, 0, 1); vertex( 1,  1, -1);

    fill(1, 0, 1); vertex(-1,  1, -1);

    fill(1, 0, 1); vertex(-1, -1, -1);

    fill(1, 0, 1); vertex( 1, -1, -1);



    fill(0, 0, 1); vertex(-1,  1, -1);

    fill(1, 0, 1); vertex(-1,  1,  1);

    fill(1, 0, 1); vertex(-1, -1,  1);

    fill(1, 0, 1); vertex(-1, -1, -1);



    fill(0, 0, 1); vertex(-1,  1, -1);

    fill(1, 0, 1); vertex( 1,  1, -1);

    fill(1, 0, 1); vertex( 1,  1,  1);

    fill(1, 0, 1); vertex(-1,  1,  1);



    fill(0, 0, 1); vertex(-1, -1, -1);

    fill(1, 0, 1); vertex( 1, -1, -1);

    fill(1, 0, 1); vertex( 1, -1,  1);

    fill(1, 0, 1); vertex(-1, -1,  1);



    endShape();

  }

}
