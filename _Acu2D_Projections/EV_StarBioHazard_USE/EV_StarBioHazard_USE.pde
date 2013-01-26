float x1 = 0;
float y1 =0;
float x2 =0;
float y2 =0;
float d1 = 35;//original15
float vy1 = random(2);
float vx1 = random(2);
float vy2 = random(2);
float vx2 = random(2);
float alp = random(0, -6*PI);//duration!!float alp = random(0, PI / 3);
float rot = random(0.000, 0.05);
int num = 4;

void setup()
{
  size(1024, 768);
  x1 = 0;
  y1 = 0;
  smooth();
  noStroke();
  // strokeWeight(2);
  //frameRate(120);
  background(0);
  //fill(235, 12, 0, 28);
}

void draw()
{
  fill(0, 3);
  rect(0, 0, width, height);
  stroke(1, 1, 1, 25);
  translate(width /2, height /2);
  for (int i = 0; i < num;i++)
  {
    fill(0, 0, 0, 80);
    ellipse(x1+0.5, y1+0.5, d1+2.5, d1+2.5+(y2*.7));
    fill(255*(width/2)/((width/2) - abs(x2)), (200-x1)/x1,  255-255*(width/2)/((width/2) - abs(x1*7)), 208);
    ellipse(x1, y1, d1, d1 +y2);

    fill(0, 0, 0, 80);
    ellipse(x2+0.5, y2+0.5, d1+2.5, d1+2.5+(y2*.7));
    fill(255*((width/2)/((width/2) - abs(x2))), (200-x1)/x1*200, 255-255*(width/2)/((width/2) - abs(x1*7)), 208);
    ellipse(x2, y2, d1, d1 +x2);// original::ellipse(x2, y2, d1, d1 + abs((width/2) - x2));

    rotate(PI *2/ num);//rotate(PI *2/ num);
  }

  x1 += vx1 ;
  y1 +=  vy1;
  x2 -= vx2 ;
  y2 -=  vy2;
  alp += rot;
  vx1 = cos(alp);
  vy1 = sin(alp);
  vx2 = cos(-alp);
  vy2 = sin(-alp);

  d1 -= 0.1;
  if (d1 < 0.01)
  {
    x1 = 0;
    y1 = 0;
    x2 = 0;
    y2 = 0;
    vy1 = random(2);
    vx1 = random(2);
    vy2 = random(2);
    vx2= random(2);
    d1 = random(15, 26);
    alp = 4*PI;// orginal = random(0, PI * 2);
    rot = random(0.000, 0.01);//was (0.000, 0.05);  rotational velocity
    if (random(2) > 1)
      rot *= -1;
  }
}

void keyPressed()
{
  background(0);
  d1 = 0;
  if (key == 'c')
    num ++;
  if (key == 'v')
    num--;
  if (num == 1)
    num = 2;
}

void stop()
{
}

