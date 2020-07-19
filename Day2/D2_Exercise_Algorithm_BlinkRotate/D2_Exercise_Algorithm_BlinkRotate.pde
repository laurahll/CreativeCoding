/* 
 * Creative Coding SS20
 * Day 2
 * Exercise: Algorithmic Thinking
 * 
 * Rules:
 *  - choose random color from colors array
 *  - create grid with square cells and random amount of columns/ rows
 *  - fill each cell with a circle/rectangle
 *  - height and width depend on the distance to center point (form with largest radius in center)
 *  - randomly give some forms the chosen color
 *  - make colored in forms blink slowly
 *  - forms rotate clockwise
 *  - on key stroke, forms change direction
 */


color colors[] = new color[4];
ArrayList <Float> rotations= new ArrayList<Float>();
ArrayList <Boolean> formsColor=new ArrayList<Boolean>();
int cells;
float cellSize;
float rDir=1;
color c;

void setup() {
  colors[0] = color(69, 87, 191);
  colors[1] = color(109, 204, 242);
  colors[2] = color(242, 231, 75);
  colors[3] = color(242, 82, 46);

  size(600, 600);
  background(0);
  smooth();
  c=colors[int(random(-.5, 3.5))];

  cells=int(random(12, 21));  
  cellSize=width/cells;
 // println(cellSize, cells);
  rectMode(CENTER);
  for (int i=0; i<cells*cells*10; i++) {
    rotations.add(0.0);
  }
  for (int i=0; i<cells*cells*10; i++) {
    if (random(1)<.1) formsColor.add(true);
    else formsColor.add(false);
  }
}
void draw() {
  fill(28, 28, 28, 25);
  noStroke();
  rect(width/2,height/2,width,height);
  //strokeWeight(1);
  //stroke(140, 140, 140, 50);
  // for (int i=0; i<cells; i++) line(cellSize*i, 0, cellSize*i, width);
  //for (int i=0; i<=cells; i++) line(0, cellSize*i, width, cellSize*i);

  int index=0;
  for (float x=1; x<width; x=x+cellSize) {
    for (float y=1; y<height; y=y+cellSize) {
      float xFromCenter= abs((x+cellSize/2)-width/2);
      float yFromCenter= abs((y+cellSize/2)-height/2);
      float w= map(xFromCenter, 0, width/2, cellSize-6, .5);
      float h= map(yFromCenter, 0, height/2, cellSize-6, .5);
      rotations.set(index, rotations.get(index) + rDir/35);
      pushMatrix();
      translate(x+cellSize/2, y+cellSize/2);
     // fill(38, 38, 38,50);
     // rect(0, 0, cellSize, cellSize);
      if (formsColor.get(index)) fill(lerpColor(color(255), c, sin(frameCount*.08)));
      else fill(255);
      rotate(rotations.get(index));
      rect(0, 0, w, h, cellSize);
      popMatrix();
      index++;
    }
  }
}

void keyPressed() {
  if (key==' ') rDir = rDir==1 ? -1 : 1;
  if (key=='s') saveFrame("output/#####"+millis()+".jpg");
}
