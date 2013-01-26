import java.util.LinkedList;

class ParticleEmitter {
  float x,y;
  int intensity = 2;      //how many particles are added per frame
  float charge = 1;
  float radius = 1;        
  int pHue = 0;
  
  ParticleEmitter(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void addParticles(LinkedList<Particle> parts){
    for (int i = 0; i < intensity; i++){
      float ang = random(2*PI);
      // add a random offset to avoid drawing artifacts from the line segments
      parts.add(new Particle(x + cos(ang)*radius + random(2), y + sin(ang)*radius + random(2), pHue));
    }
  }
}
