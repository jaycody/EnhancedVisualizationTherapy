
/**
 * This class manages the creation and calibration of keystoned surfaces.
 * 
 * To move and warp surfaces, place the Keystone object in calibrate mode. It catch mouse events and 
 * allow you to drag surfaces and control points with the mouse.
 *
 * 
 */
public class Keystone {

  public final String VERSION = "001";

  PApplet parent;

  ArrayList<CornerPinSurface> surfaces;

  Draggable dragged;

  // calibration mode is application-wide, so I made this flag static
  // there should only be one Keystone object around anyway 

  /**
   	 * @param parent applet
   	 */
  public Keystone(PApplet parent) {
    this.parent = parent;
    this.parent.registerMouseEvent(this);

    surfaces = new ArrayList<CornerPinSurface>();
    dragged = null;

    // check the renderer type
    // issue a warning if its PGraphics2D
    PGraphics pg = (PGraphics)parent.g;
  }

  /**
   	 * Creates and registers a new corner pin keystone surface. 
   	 * 
   	 * @param w width
   	 * @param h height
   	 * @param res resolution (number of tiles per axis)
   	 * @return
   	 */
  public CornerPinSurface createCornerPinSurface(int w, int h, int res) {
    CornerPinSurface s = new CornerPinSurface(parent, w, h, res);
    surfaces.add(s);
    return s;
  }

  /**
   	 * Starts the calibration mode. Mouse events will be intercepted to drag surfaces 
   	 * and move control points around.
   	 */
  public void startCalibration() {
    calibrate = true;
  }

  /**
   	 * Stops the calibration mode
   	 */
  public void stopCalibration() {
    calibrate = false;
  }

  /**
   	 * Toggles the calibration mode
   	 */
  public void toggleCalibration() {
    calibrate = !calibrate;
  }




  /**
   	 * Saves the layout to an text file.
   	 */
  public void save(String filename) {

    output = createWriter(filename);


    for (CornerPinSurface s : surfaces) {
      String fmt = "%d, %f, %f";
      String fmted = String.format(fmt, s.getRes(), s.x, s.y); 
      output.println(fmted);

      for (int i=0; i < s.mesh.length; i++) {
        if (s.mesh[i].isControlPoint()) {
          fmt = "%d, %f, %f, %f, %f";
          fmted = String.format(fmt, i, s.mesh[i].x, s.mesh[i].y, s.mesh[i].u, s.mesh[i].v);
          output.println(fmted);
        }
      }
    }
    output.flush();
    output.close();
  }


  /**
   	 * Saves the current layout into a text file, name below
   	 */
  public void save() {
    save("../calibrate.txt");
  }

  /**
   	 * Loads a saved layout from a given XML file
   	 */


  public void load(String filename) {

    String[] lines = loadStrings(filename);

    //----------Line One
    String[] lineOne = split(lines[0], ",");
    float loadedRes = float(lineOne[0]);
    float loadedX = float(lineOne[1]);
    float loadedY = float(lineOne[2]);
    println ("res=  " + loadedRes + "   x= " + loadedX + "   y= " + loadedY);

    //----------Line Two
    String[] lineTwo = split(lines[1], ",");
    int loadedPoinOneI = int(lineTwo[0]);
    float loadedPoinOneX = float(lineTwo[1]);
    float loadedPoinOneY = float(lineTwo[2]);
    float loadedPoinOneU = float(lineTwo[3]);
    float loadedPoinOneV = float(lineTwo[4]);

    //----------Line Three
    String[] lineThree = split(lines[2], ",");
    int loadedPoinTwoI = int(lineThree[0]);
    float loadedPoinTwoX = float(lineThree[1]);
    float loadedPoinTwoY = float(lineThree[2]);
    float loadedPoinTwoU = float(lineThree[3]);
    float loadedPoinTwoV = float(lineThree[4]);

    //----------Line Four
    String[] lineFour = split(lines[3], ",");
    int loadedPoinThreeI = int(lineFour[0]);
    float loadedPoinThreeX = float(lineFour[1]);
    float loadedPoinThreeY = float(lineFour[2]);
    float loadedPoinThreeU = float(lineFour[3]);
    float loadedPoinThreeV = float(lineFour[4]);

    //----------Line Five
    String[] lineFive = split(lines[4], ",");
    int loadedPoinFourI = int(lineFive[0]);
    float loadedPoinFourX = float(lineFive[1]);
    float loadedPoinFourY = float(lineFive[2]);
    float loadedPoinFourU = float(lineFive[3]);
    float loadedPoinFourV = float(lineFive[4]);

    //----------------------Image Cropping
    //----Point One
    imageVertexOneX=int(loadedX+loadedPoinOneX);
    imageVertexOneY=int(loadedY+loadedPoinOneY);
    //----Point Two
    imageVertexTwoX=int(loadedX+loadedPoinTwoX);
    imageVertexTwoY=int(loadedY+loadedPoinTwoY);
    //----Point Three
    imageVertexFourX=int(loadedX+loadedPoinThreeX);
    imageVertexFourY=int(loadedY+loadedPoinThreeY);
    //----Point Four
    imageVertexThreeX=int(loadedX+loadedPoinFourX);
    imageVertexThreeY=int(loadedY+loadedPoinFourY);


    //---------------Prints the points
    println ("Point 1  i=  " + loadedPoinOneI + "   x= " + loadedPoinOneX + "   y= " + loadedPoinOneY + "   u= " + loadedPoinOneU + "   v= " + loadedPoinOneV);
    println ("Point 2  i=  " + loadedPoinTwoI + "   x= " + loadedPoinTwoX + "   y= " + loadedPoinTwoY + "   u= " + loadedPoinTwoU + "   v= " + loadedPoinTwoV);
    println ("Point 3  i=  " + loadedPoinThreeI + "   x= " + loadedPoinThreeX + "   y= " + loadedPoinThreeY + "   u= " + loadedPoinThreeU + "   v= " + loadedPoinThreeV);
    println ("Point 4  i=  " + loadedPoinFourI + "   x= " + loadedPoinFourX + "   y= " + loadedPoinFourY + "   u= " + loadedPoinFourU + "   v= " + loadedPoinFourV);


    for (CornerPinSurface s : surfaces) {

      s.load(loadedX, loadedY, 
      loadedPoinOneI, loadedPoinOneX, loadedPoinOneY, loadedPoinOneU, loadedPoinOneV, 
      loadedPoinTwoI, loadedPoinTwoX, loadedPoinTwoY, loadedPoinTwoU, loadedPoinTwoV, 
      loadedPoinThreeI, loadedPoinThreeX, loadedPoinThreeY, loadedPoinThreeU, loadedPoinThreeV, 
      loadedPoinFourI, loadedPoinFourX, loadedPoinFourY, loadedPoinFourU, loadedPoinFourV);
    }


    PApplet.println("Calibration: layout loaded from " + filename);
  }



  //----------------Loads a saved layout from the specified text file input.

  public void load() {
    load("../calibrate.txt");
  }





  public void mouseEvent(MouseEvent e) {

    // ignore input events if the calibrate flag is not set
    if (!calibrate)
      return;

    int x = e.getX();
    int y = e.getY();

    switch (e.getID()) {

    case MouseEvent.MOUSE_PRESSED:
      CornerPinSurface top = null;
      // navigate the list backwards, as to select 
      for (int i=surfaces.size()-1; i >= 0; i--) {
        CornerPinSurface s = (CornerPinSurface)surfaces.get(i);
        dragged = s.select(x, y);
        if (dragged != null) {
          top = s;
          break;
        }
      }

      if (top != null) {
        // moved the dragged surface to the beginning of the list
        // this actually breaks the load/save order.
        // in the new version, add IDs to surfaces so we can just 
        // re-load in the right order (or create a separate list 
        // for selection/rendering)
        //int i = surfaces.indexOf(top);
        //surfaces.remove(i);
        //surfaces.add(0, top);
      }
      break;

    case MouseEvent.MOUSE_DRAGGED:
      if (dragged != null)
        dragged.moveTo(x, y);
      break;

    case MouseEvent.MOUSE_RELEASED:
      dragged = null;
      break;
    }
  }
}

interface Draggable {
  void moveTo(float x, float y);
}

