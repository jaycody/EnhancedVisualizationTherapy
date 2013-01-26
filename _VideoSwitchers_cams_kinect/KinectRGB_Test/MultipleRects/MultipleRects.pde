import java.awt.Rectangle; import java.util.ArrayList;
import org.openkinect.processing.Kinect;
import processing.core.PApplet; import processing.core.PVector;
public class MultipleRects extends PApplet {
	// Dan O'Sullivan based on
	// Daniel Shiffman
	// Kinect Point Cloud example
	// http://www.shiffman.net
	// https://github.com/shiffman/libfreenect/tree/master/wrappers/java/processing

	// Kinect Library object
	Kinect kinect;

	// Size of kinect image
	int w = 640;

	int h = 480;

	int threshold = 550;

	public void setup() {
		size(w, h);
		kinect = new Kinect(this);
		kinect.start();
		kinect.enableDepth(true);

		// We don't need the grayscale image in this example
		// so this makes it more efficient
		kinect.processDepthImage(false);

	}

	public void draw() {

		background(0);
		fill(255);
		textMode(SCREEN);
		text("Kinect FR: " + (int) kinect.getDepthFPS() + "\nProcessing FR: " + (int) frameRate, 10, 16);

		// Get the raw depth as array of integers

		int[] depth = kinect.getRawDepth();

		int skip = 1;
		int reach = 5;

		ArrayList myRects = new ArrayList();
		for (int x = 0; x < w; x += skip) {
			for (int y = 0; y < h; y += skip) {
				int offset = x + y * w;

				int rawDepth = depth[offset];

				if (rawDepth < threshold) {

					boolean foundAHome = false;
					for (int i = 0; i < myRects.size(); i++) {
						Rectangle thisRect = (Rectangle) myRects.get(i);
						Rectangle bigger = new Rectangle(thisRect);
						bigger.grow(reach, reach);
						if (bigger.contains(x, y)) {
							thisRect.add(x, y);
							foundAHome = true;
							break;
						}

					}
					if (foundAHome == false) {
						myRects.add(new Rectangle(x, y, 1, 1));
					}
				}
			}

		}
		fill(0, 0, 0, 0);
		stroke(255, 0, 0);
		for (int i = 0; i < myRects.size(); i++) {
			Rectangle thisBox = (Rectangle) myRects.get(i);
			if (thisBox.width * thisBox.height < 400) continue;
			rect(thisBox.x, thisBox.y, thisBox.width, thisBox.height);
		}

	}

	public void keyPressed() {
		if (key == '-') {
			threshold--;
		} else if (key == '=') {
			threshold++;
		}
		println("Threshold:" + threshold);
	}

	public void stop() {
		kinect.quit();
		super.stop();
	}
}

