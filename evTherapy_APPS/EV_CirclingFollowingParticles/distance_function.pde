
float distance (float x1, float y1, float x2, float y2){
  float dx = x1-x2;
  float dy = y1-y2;
  float d = sqrt(dx*dx + dy*dy);
  float mapD = map(d,0,width,0,255);

  return mapD;
}
