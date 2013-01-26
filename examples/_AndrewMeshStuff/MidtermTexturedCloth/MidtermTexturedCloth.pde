

/*************************************************************
 **********Controlled/Textured Banner Drop********************
 **************Created by Andrew Lazarow**********************
 *******Using elements of: the Toxic Libs Library*************
 ********Karsten Schmidt's 2010 3D Cloth xample***************
 ********and Max Rheiner's SimpleOpenNI library***************
 *********For ITP, Nature of Code, Spring 2012.***************
 ************************MIDTERM******************************
 ************************************************************/

/*

 To Use: 
 
 
 KeyPressed Commands:
 
 -'p' restarts the simulation 
 -'d' drops the banner
 -'m' drops the middle section of the banner
 -'r' drops the right corner of the banner
 -'l' drops the left corner of the banner
 -'s' shows the constraints
 -'c' toggles on and off the constraints
 -'x' saves the cloth as an stl
 
 */

import processing.opengl.*;


import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.math.*;
import toxi.physics.*;
import toxi.physics.behaviors.*;
import toxi.physics.constraints.*;
import toxi.processing.*;
int DIM=40;
int REST_LENGTH=20;
float STRENGTH=1;

VerletPhysics physics;
ToxiclibsSupport gfx;
TriangleMesh mesh;
BoxConstraint ground;
BoxConstraint tower;
ArrayList spheres=new ArrayList();

boolean isGouraudShaded=true;
boolean showSpheres=false;
boolean constraint=true;

boolean unlock=false;
boolean middle=false;
boolean dropRight=false;
boolean dropLeft=false;
boolean startLock=true;
boolean rotateCam=false;

PImage cityStreet;
int rotater;



void setup() {
  size(1024, 768, OPENGL);//680x382
  //size(screen.width, screen.height, OPENGL);
  gfx=new ToxiclibsSupport(this);
  sphereDetail(8);

  cityStreet = loadImage ("fabric0.png");
  initPhysics();
}

void draw() {
  background(0);
  lights();
  directionalLight(255, 255, 255, -500, 200, 300);
  specular(255);
  shininess(82);
  translate(width/2, height/2, 0);
  if (rotateCam==true) {
    rotateY(PI+rotater*0.01);
    rotater++;
  }
  if (rotateCam==false) {
    rotateY(PI);
  }
  scale(0.7);//.3


  // update simulation
  if (constraint==true) {
    constraints();
  }
  unlock();

  if (unlock==true) {
    physics.update();
  }

  //-------

  // update cloth mesh
  updateMesh();
  // draw mesh either flat shaded or smooth
  //fill(0, 255, 0);
  //noFill();
  noStroke();

  textureMode(NORMAL);
  gfx.texturedMesh(mesh, cityStreet, isGouraudShaded);


  if (showSpheres) {
    fill(255);
    for (Iterator<SphereConstraint> i=spheres.iterator(); i.hasNext();) {
      // create a copy of the sphere and reduce its radius
      // in order to avoid rendering artifacts
      Sphere s=new Sphere(i.next().sphere);
      s.radius*=0.99;
      gfx.sphere(s, 12);
    }
  }
}

void keyPressed() {
  if (key=='x') {
    mesh.saveAsSTL(sketchPath("cloth.stl"));
  }
  if (key=='s') {
    showSpheres=!showSpheres;
  }
  if (key=='p') {
    initPhysics();
    constraint=true;
  }

  if (key=='d') {
    unlock=!unlock;
  }

  if (key=='c') {
    constraint=!constraint;
  }

  if (key=='m') {
    middle=!middle;
  }

  if (key=='r') {
    dropRight=!dropRight;
  }

  if (key=='l') {
    dropLeft=!dropLeft;
  }

  if (key=='t') {
    rotateCam=!rotateCam;
    rotater=0;
  }
}

