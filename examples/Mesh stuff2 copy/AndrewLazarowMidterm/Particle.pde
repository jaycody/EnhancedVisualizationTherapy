

// class Spore extends the class "VerletParticle2D"
class Particle extends VerletParticle2D {

  float r;
  int d;
  float rr;
  float g;
  float b;
  float a;

  Particle (Vec2D loc, int L) {
    super(loc);
    r = 20;
    d = L;

    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior(this, 20, -1.2f, 0.01f));
    //physics.addBehavior(new GravityBehavior(new Vec2D(0, 0)));
    rr=random (100, 255);
    g=random (20, 70);
    b=random (20, 70);
    a=random(0, 255);
  }

  void display () {


    if (noGrav==true) {
      //physics.addBehavior(new GravityBehavior(new Vec2D(.01, 0)));
      //particle.addForce(wind);
      //physics.addBehavior(new ConstantForceBehavior(new Vec2D(.15, -.05)));
      physics.addBehavior(new ConstantForceBehavior(new Vec2D(0, -0.5f)));
      noGrav=false;
    }
    if (addGrav==true) {
      //physics.removeBehavior(ConstantForceBehavior);
      //physics.addBehavior(new ConstantForceBehavior(new Vec2D(-.15, .05)));
      physics.addBehavior(new ConstantForceBehavior(new Vec2D(0, 0.5f)));
      addGrav=false;
    }

    if (rightWind==true) {
      physics.addBehavior(new ConstantForceBehavior(new Vec2D(.15, -.05)));
      rightWind=false;
    }

    if (leftWind==true) {
      physics.addBehavior(new ConstantForceBehavior(new Vec2D(-.15, .05)));
      leftWind=false;
    }
    projectorDraw.noStroke();
    projectorDraw.fill(rr, g, b, a);
    projectorDraw.ellipse (x, y, 10, 10);
    projectorDraw.noFill();



    // imageMode(CENTER);
    //    image(movies[d], x,y-250, movies[d].width/(3), movies[d].height/(3));
  }
}

