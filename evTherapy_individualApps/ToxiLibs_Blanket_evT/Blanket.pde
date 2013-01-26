class Blanket {
  ArrayList<Particle> particles;
  ArrayList<Connection> springs;

  Blanket() {
    particles = new ArrayList<Particle>();
    springs = new ArrayList<Connection>();

    int w = 15;
    int h = 30;

    float len = 28;
    float strength = 0.125;

    for(int y=0; y< h; y++) {
      for(int x=0; x < w; x++) {

        Particle p = new Particle(new Vec2D(100+x*len,y*len));
        physics.addParticle(p);
        particles.add(p);

        if (x > 0) {
          Particle previous = particles.get(particles.size()-2);
          Connection c = new Connection(p,previous,len,strength);
          physics.addSpring(c);
          springs.add(c);
        }

        if (y > 0) {
          Particle above = particles.get(particles.size()-w-1);
          Connection c=new Connection(p,above,len,strength);
          physics.addSpring(c);
          springs.add(c);
        }
      }
    }

    Particle topleft= particles.get(0);
    topleft.lock();

    Particle topright = particles.get(w-1);
    topright.lock();
  }

  void display() {
    for (Connection c : springs) {
      c.display();
    }
  }
}

