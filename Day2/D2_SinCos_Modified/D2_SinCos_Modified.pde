int circR = 100;
int numLines = 20;
int radius=350;
float buffer=3;
float speed=3;

void setup() {
  size(1000, 1000);
  rectMode(RADIUS);
  blendMode(LIGHTEST);
  // 2nd version
}

void draw() {
  background(0);
  //println(frameCount);
  for (int n = 0; n < numLines; n++) {

    float posX1= width/2  +(radius* cos(radians((frameCount*speed+n*buffer))));
    float posY1= height/2 +(radius* sin(radians((frameCount*speed+n*buffer))));
    float posX2= width/2  +(radius* -cos(radians((-frameCount*speed+n*buffer))));
    float posY2= height/2 +(radius* -sin(radians((-frameCount*speed+n*buffer))));

    float fillColor= map(n, 0, numLines-1, 0, 255);
    fill (255, 255, 255, fillColor);
    stroke(255, fillColor);
    circle(posX1, posY1, circR);

    fill (140, 140, 140, fillColor/2);
    stroke(140, 140, 140, fillColor/2);
    circle(posX2, posY2, circR);
    line(posX1, posY1, posX2, posY2);
  }
}
