class Attractor extends VerletParticle2D {

  float r;

  Attractor (Vec2D loc) {
    super (loc);
    r = 24;
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior(this, 550, 0.9f));
  }

void changeBehavior () {
    if (deleteAttraction==true) {
      println("deleting attraction");
      physics.addBehavior(new AttractionBehavior(this, 550, -0.9f));
      deleteAttraction=false;
    }

    if (addAttraction==true) {
      println("adding attraction");
      physics.addBehavior(new AttractionBehavior(this, 550, 0.9f));
      addAttraction=false;
    }
  }

  void display () {
    projectorDraw.fill(255);
    projectorDraw.ellipse (x, y, r*2, r*2);
  }
}

