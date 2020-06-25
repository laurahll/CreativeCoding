
int size;
float rotation= -(PI/4);

// var for probability
float probability = 0.1; // change this value to increase or decrease the probability of rotating clock or counter-clock wise
float diffColor=0.02;
float colorStroke=10;

void setup() {
  size(1000, 900);
  background(0);
  generatePattern();
  //noLoop();
}

void mouseReleased() {
  // generate new pattern
  fill(0, 0, 0, 255);
  noStroke();
  colorStroke=10;
  rect(0, 0, width, height);
  generatePattern();
  // save current frame to project folder
  saveFrame("savedImgs/line-######"+second()+".png");
}

void draw() {
}


void gradiendProgress() {
  float f= map(1, 0, 255, 0, width*2);
  // println(colorStroke);
  colorStroke+=0.2;
}

void generatePattern() {
  size = floor(random(15, 22));
  // nested for-loop for each X and Y value for evey cell
  for (int x = 0; x < width; x+=size) {
    for (int y = 0; y < height; y+=size) {
      pushMatrix();
      translate(x+size/2, y+size/2);
      noFill();
      strokeWeight(1);
      strokeWeight(random(1, 4));
      noStroke();
      // decide on the rotation by random value
      // rotate the canvas by either PI/4 or -PI/4
      if (random(1) < probability) {
        rotate(PI/random(1, 6));
        stroke(4, 184, 255, colorStroke);
        if (random(1) < diffColor) {
          stroke(229, 44, 116, colorStroke);
        }
      } else {
        rotate(rotation);
        stroke(colorStroke, colorStroke, colorStroke);
      }
      // draw horizontal line 
      line(-size/1.5, 0, size/1.5, 0);
      popMatrix();
       gradiendProgress();
    }
  }
}
