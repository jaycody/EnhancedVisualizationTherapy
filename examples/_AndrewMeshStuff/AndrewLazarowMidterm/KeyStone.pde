
/**
 * This class manages the creation and calibration of keystoned surfaces.
 * 
 * To move and warp surfaces, place the Keystone object in calibrate mode. It catch mouse events and 
 * allow you to drag surfaces and control points with the mouse.
 *
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
	 * Returns the version of the library.
	 * 
	 * @return String
	 */
	public String version() {
		return VERSION;
	}
	
	/**
	 * Saves the layout to an XML file.
	 */
	

	/**
	 * @invisible
	 */
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

