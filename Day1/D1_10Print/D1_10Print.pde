int size=400;
int lineDensity=10;

void setup () {
  size(400, 400);
  background(0);
  stroke(255);
  strokeWeight(2);
  noLoop();
}
void draw() {
  fill(0);
  rect(0, 0, width, height);
  int step = size/lineDensity;
  //increment by step
  for (int x = 0; x < size; x+= step) {
    for (int y = 0; y < size; y+= step) {
      drawLine(x, y, step, step);
    }
  }
}

void drawLine(float x, float y, float w, float h) {
  boolean leftToRight  = round(random(1.1)) >= 0.5;
 // println(leftToRight );
  if (leftToRight) line(x, y, x+w, y+h);
  else line(x+w, y, x, h+y);
}

void mouseReleased() {
  redraw();
}
