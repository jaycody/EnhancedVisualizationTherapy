void unlock() {



  for (int y=0; y<DIM-1; y++) {
    for (int x=0; x<DIM-1; x++) {
      int i=y*DIM+x;
      if (i>0 && i<DIM-1) {
        VerletParticle a=physics.particles.get(i);
        if (dropLeft==false && dropRight==false) {
          a.lock();
        }
        if (middle==true) {
          //removeBoxConstraint(tower); 
          if (i>1 && i<DIM-2) {
            VerletParticle middle = physics.particles.get(i);
            middle.unlock();
          }
        }

        if (dropLeft==true) {
          if (i<2) {
            VerletParticle topLeft = physics.particles.get(i);
            topLeft.unlock();
          }
        }
        if (dropRight==true) {
          if (i>DIM-3) {
            VerletParticle topRight = physics.particles.get(i);
            topRight.unlock();
          }
        }
      }
    }
  }
}

