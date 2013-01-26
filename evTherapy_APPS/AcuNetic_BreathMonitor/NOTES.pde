/*How do we resize a Kinect image, without lossing the relationship between
   the clickable (x,y) cordinate point on the draw screen and the depth info
   associated with that point and its given index in the array of 620x480?
   ANS:  We create a PGraphics screen with its own coordinate system
   that is equal to the resolution of the camera image we are writing into it,
   then we establish the boundary condtions or we read the realitime measurements from the
   mouseOver areas, all the while remaining inside of the PGraphics specific dot syntax.
   Then we .endDraw();
   Followed by an image call to the PGraphic screen that we had just ended.  
   Image calls take 4 arguments, the last two we use to resize.  
   Meanwhile the coordinate system inside the PGraphics begin / endDraw functions
   reamian intact as if we had called a push or popMatrix.  From the outside, the
   image looks bigger.   But if the surface of the moon looked bigger, it wouldn't be because
   it expanded, it would be because the moon got closer and now takes up my entire field of view.
   */
