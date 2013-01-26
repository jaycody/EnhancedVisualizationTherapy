/*************************************************************
 ********************Flocking Class***************************
 **************Created by Andrew Lazarow**********************
 *******Using elements of: Dan Shiffman's Flocking example****
 **************Managers the Array List of Boids***************
 ************************FINAL Draft 1************************
 ************************************************************/


class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

    Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run(float mxForcePass, float mxSpeed, float skStrnthPas, float SepStrngthPass, float AllignmentStrngthPass, float CohesionStrngthPass, float Directness) {
    for (Boid b : boids) {
      b.run(boids, mxForcePass, mxSpeed, skStrnthPas, SepStrngthPass, AllignmentStrngthPass, CohesionStrngthPass, Directness);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
}

