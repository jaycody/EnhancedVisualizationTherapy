// create the physical world by constructing all
// obstacles/constraints, particles and connecting them
// in the correct order using springs
void initPhysics() {
  physics=new VerletPhysics();
  physics.addBehavior(new GravityBehavior(new Vec3D(0, 0.5, 0)));
  //spheres.add(new SphereConstraint(new Sphere(new Vec3D(0, -100, 100), 100), false));
  spheres.add(new SphereConstraint(new Sphere(new Vec3D(-200, 0, -380), 150), false));
  //spheres.add(new SphereConstraint(new Sphere(new Vec3D(-250, 200, -150), 100), false));
  spheres.add(new SphereConstraint(new Sphere(new Vec3D(200, 50, -350), 170), false));
  spheres.add(new SphereConstraint(new Sphere(new Vec3D(0, 300, -350), 200), false));
  spheres.add(new SphereConstraint(new Sphere(new Vec3D(0, 300, -500), 200), false));
  for (int y=0,idx=0; y<DIM; y++) {
    for (int x=0; x<DIM; x++) {
      VerletParticle p=new VerletParticle(x*REST_LENGTH-(DIM*REST_LENGTH)/2, -500, -400);
      physics.addParticle(p);

      if (x>0) {
        VerletSpring s=new VerletSpring(p, physics.particles.get(idx-1), REST_LENGTH, STRENGTH);
        physics.addSpring(s);
      }
      if (y>0) {
        VerletSpring s=new VerletSpring(p, physics.particles.get(idx-DIM), REST_LENGTH, STRENGTH);
        physics.addSpring(s);
      }

      idx++;
    }
  }
  // add spheres as constraint to all particles

  /*
  for(Iterator i=spheres.iterator(); i.hasNext();) {
   SphereConstraint s=(SphereConstraint)i.next();
   VerletPhysics.addConstraintToAll(s,physics.particles);
   }
   */
  // add ground as constraint to all particles
  //VerletPhysics.addConstraintToAll(ground,physics.particles);
  //VerletPhysics.addConstraintToAll(tower,physics.particles);
}



void constraints() {
  //VerletPhysics.addConstraintToAll(tower, physics.particles);
  for (Iterator i=spheres.iterator(); i.hasNext();) {
    SphereConstraint s=(SphereConstraint)i.next();
    VerletPhysics.addConstraintToAll(s, physics.particles);
    constraint=false;
  }
}

