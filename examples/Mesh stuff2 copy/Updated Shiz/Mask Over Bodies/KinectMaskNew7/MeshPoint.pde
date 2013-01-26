
//Represents a single point in the mesh, along with its precomputed (u,v) 
// textur coordinates. 

class MeshPoint implements Draggable {

  public float x;
  public float y;
  public float u;
  public float v;

  boolean isControlPoint;

  CornerPinSurface parent;

  MeshPoint(CornerPinSurface parent, float x, float y, float u, float v) {
    this.x = x;
    this.y = y;
    this.u = u;
    this.v = v;
    this.isControlPoint = false;
    this.parent = parent;
  }

  public boolean isControlPoint() {
    return isControlPoint;
  }

  public void moveTo(float x, float y) {
    this.x = x - parent.x;
    this.y = y - parent.y;
    parent.calculateMesh();
  }

  protected void setControlPoint(boolean value) {
    isControlPoint = value;
  }

  /**
   	 * This creates a new MeshPoint with (u,v) = (0,0) and does
   	 * not modify the current MeshPoint. Its used to generate 
   	 * temporary points for the interpolation.
   	 */
  MeshPoint interpolateTo(MeshPoint p, float f) {
    float nX = this.x + (p.x - this.x) * f;
    float nY = this.y + (p.y - this.y) * f;
    return new MeshPoint(parent, nX, nY, 0, 0);
  }

  void interpolateBetween(MeshPoint start, MeshPoint end, float f) {
    this.x = start.x + (end.x - start.x) * f;
    this.y = start.y + (end.y - start.y) * f;
  }
}

