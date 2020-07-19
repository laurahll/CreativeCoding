/* 
 *
 * Creative Coding
 * Day 2
 * Exercise: Algorithmic Thinking
 * RULES:
 *   - define grid with a random no. of columns and rows
 *   - randomly define start column in first row and start path in that cell
 *   - find adjacent cell in next row
 *   - allow random split if not in first x rows and more than z paths exits
 *   - allow ending of path if more than x paths exist and path longer than y rows
 *   - fill paths with predefined colors
 *
 * BUG? sometimes no response but no error
 */

float gridRows;
float gridColumns;

float cellWidth;
float cellHeight;

float maxSplits=3.1;
float pathOffset=2.1;

// ArrayList of Paths made out of Arraylist of Points
int startedPaths=1;
ArrayList <ArrayList<Point>> paths= new ArrayList<ArrayList<Point>>();

color colors[] = new color[18];

void setup() {
  size(500, 800);
  setColors();
  initGrid();
  //reset
  paths.clear();
  startedPaths=1;
  startPaths();
  background(0);
}

void draw() {
  background(0);
  drawGrid();
  displayPaths();
}


void startPaths() {
  // random column in first row
  int columnFirstRow= int(random(1, gridColumns));
  Point firstPoint= new Point(columnFirstRow, 1);
  // start path from first cell
  ArrayList <Point> firstPath= new ArrayList<Point>();
  firstPath.add(firstPoint);
  generatePath(firstPoint, firstPath);
}

void initGrid() {
  gridRows=int(random(10, 40));
  gridColumns=int(random(10, 40));
  cellWidth=width/gridColumns;
  cellHeight=height/gridRows;
  //  println("grid:", gridRows, "x", gridColumns, "& cell:", cellWidth, "x", cellHeight);
}

void drawGrid() {
  strokeWeight(2);
  stroke(140, 140, 140, 30);
  for (int y=0; y<height; y+=cellHeight) line(0, y, width, y);
  for (int x=0; x<width; x+=cellWidth) line(x, 0, x, height);
}

void displayPaths() {
  strokeWeight(3);
  int cIndex=0; //iterate through colors
  for (int i = 0; i < paths.size(); i++) {
    // iterate vertex of path
    stroke(colors[cIndex]);
    ArrayList<Point> currentPath = paths.get(i);
    beginShape();
    for (Point p : currentPath) {
      float x=p.column*cellWidth-cellWidth/2;
      float y=p.row*cellHeight-cellHeight/2;
      //float opacityX= map(abs(mouseX-x), 0, width, 0, 255);
      //float opacityY= map(abs(mouseY-x), 0, height, 0, 255);
      //float o= (opacityX+opacityY)/2;
      stroke(colors[cIndex], 255);
      noFill();
      vertex(x, y);
      //  print(" {", p.column, "|", p.row, "},  ");
    }
    endShape();
    if (cIndex+1 == colors.length) cIndex=0;
    else cIndex++;
  }
}

Point findNextPoint(Point startPoint) {    
  int offset= int(random(-pathOffset, pathOffset));
  while (startPoint.column-offset <0 || startPoint.column+offset>gridColumns) {
    offset= int(random(-pathOffset, pathOffset));
  }
  Point singlePoint= new Point(startPoint.column+offset, startPoint.row+1);
  return singlePoint;
}

void generatePath(Point startPoint, ArrayList <Point> currentPath) {
  if (startPoint.row==gridRows) {
    //last row -> end/save path
    paths.add(currentPath);
  } else if (startPoint.row<gridRows) {
    int fork=1;
    int minRandom=1;
    if (startPoint.row>4) {
      // probility of split based on existing paths
      if (startedPaths >2 && currentPath.size()>=3) minRandom=0;
      fork=int(random(minRandom, maxSplits));
      if (startedPaths >30) fork=0;
    }
    //  println("Row: ", startPoint.row, "splits in: ", fork, ", startedPaths ", startedPaths);
    // how many splits?
    if (fork==0) {
      // path ends
      paths.add(currentPath);
    } else if (fork==1) {
      //path continues, no splitting
      Point newPoint = findNextPoint(startPoint);
      currentPath.add(newPoint);
      generatePath(newPoint, currentPath);
    } else if (fork>1) { 
      // path splits
      for (int i=0; i<fork; i++) {
        Point newPoint = findNextPoint(startPoint);
        if (i==0) {
          //first fork continue path
          currentPath.add(newPoint);
          generatePath(newPoint, currentPath);
        } else {
          //start new path with last point of current path as first point of new path
          ArrayList <Point> forkedPath= new ArrayList<Point>();
          startedPaths++;
          forkedPath.add(startPoint);
          forkedPath.add(newPoint);
          generatePath(newPoint, forkedPath);
        }
      }
    }
  }
}


void setColors() {
  colors[0] = color(252, 247, 127);
  colors[1] = color(60, 151, 163);
  colors[2] = color(142, 203, 190);
  colors[3] = color(64, 67, 153);
  colors[4] = color(72, 139, 194);
  colors[5] = color(107, 178, 140);
  colors[6] = color(159, 190, 87);
  colors[7] = color(210, 179, 63); 
  colors[8] = color(231, 126, 49);
  colors[9] = color(217, 33, 32);
  colors[10] = color(218, 247, 166);
  colors[11] = color(199, 0, 57 );
  colors[12] = color(88, 214, 141 );
  colors[13] = color(204, 51, 255 );
  colors[14] = color(0, 255, 102 );
  colors[15] = color(255, 51, 204 ); 
  colors[16] = color(255, 255, 204 );
  colors[17] = color(128, 222, 234);
}

void keyPressed() {
  if ( key == 'r' || key == 'R' ) setup();
  if (key=='s') saveFrame("output/#####_"+millis()+".jpg");
}
