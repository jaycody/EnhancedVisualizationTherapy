void onNewUser(int uID) {
  userID = uID;
  tracking = true;
  println("tracking");
}



//---------------------RGB Magic - the work gets 'er done here.
void RGBViewFunction() {

  rgbImage = context.rgbImage();
  rgbImage.loadPixels();
  //clouds.loadPixels();
  //userMap = context.getUsersPixels(SimpleOpenNI.USERS_ALL);
  for (int y=0;y < 480;y+=1) {
    for (int x=0;x < 630 ;x+=1) {
      int i = x + y * 640;
      float r = red (emptyImage.pixels[i]);
      if (r!=0) {
        RGBViewer.pixels[i] = rgbImage.pixels[i];
      } 
      else {
        RGBViewer.pixels[i] = rgbImage.pixels[i];
      }
    }
  }

  RGBViewer.updatePixels();
  image(RGBViewer, 0, 0);
}
