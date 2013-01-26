// iterates over all particles in the grid order
// they were created and constructs triangles
void updateMesh() {

  Vec2D scaleUV=new Vec2D(DIM-1, DIM-1).reciprocal();


  mesh=new TriangleMesh();
  for (int y=0; y<DIM-1; y++) {
    for (int x=0; x<DIM-1; x++) {
      int i=y*DIM+x;
      VerletParticle a=physics.particles.get(i);
      VerletParticle b=physics.particles.get(i+1);
      VerletParticle c=physics.particles.get(i+1+DIM);
      VerletParticle d=physics.particles.get(i+DIM);
      // compute UV coords for all 4 vertices...
      Vec2D uva=new Vec2D(x, y).scaleSelf(scaleUV);
      Vec2D uvb=new Vec2D(x+1, y).scaleSelf(scaleUV);
      Vec2D uvc=new Vec2D(x+1, y+1).scaleSelf(scaleUV);
      Vec2D uvd=new Vec2D(x, y+1).scaleSelf(scaleUV);


      mesh.addFace(a, d, c, uva, uvd, uvc);
      mesh.addFace(a, c, b, uva, uvc, uvb);
    }
  }
}
