/* 
 *
 * Creative Coding SS20
 * Day 2
 * Exercise: Algorithmic Thinking
 * - define two or more rules/ instructions
 * - programm a sketch following said rules
 * - make use of sin() and cos() for animtion or interaction
 * 
 * rules:
 * - define a grid with a random no. of columns and rows
 * - create a random path through the grid from top to bottom
 * - path -> define start in random column in first row
 *          find next cell in next row and connected to last cell (+-1 column)
 *          in first x rows continue single path
 *          after x rows split path in 1 to 2 other paths
 *          if more than y paths exist and path more than 2 cells, split or end path
 *          fill paths with different predefined colors
 *         
 * more to implememt: 
 * - set random origin of path by mouse click
 * - find next cell in column +-1 and row +-1 
 * - animate spread from center
 *
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
  size(1000, 800);
  background(0);


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

  initGrid();
  startPaths();
}

void draw() {
  //// random column in first row
  //int columnFirstRow= int(random(1, gridColumns));
  //Point firstPoint= new Point(columnFirstRow, 1);
  //ArrayList <Point> firstPath= new ArrayList<Point>();
  //firstPath.add(firstPoint);

  ////circle(firstPoint.column*cellWidth-cellWidth/2, firstPoint.row*cellHeight-cellHeight/2, 40);
  //generatePath(firstPoint, firstPath);
  background(0);
  stroke(255);
  circle(mouseX, mouseY, 5);  
  drawGrid();

  displayPaths();
}

void keyPressed() {
  if ( key == 'r' || key == 'R' ) setup();
}

void startPaths() {
  // random column in first row
  int columnFirstRow= int(random(1, gridColumns));
  Point firstPoint= new Point(columnFirstRow, 1);
  ArrayList <Point> firstPath= new ArrayList<Point>();
  firstPath.add(firstPoint);

  //circle(firstPoint.column*cellWidth-cellWidth/2, firstPoint.row*cellHeight-cellHeight/2, 40);
  generatePath(firstPoint, firstPath);
}

void initGrid() {
  // init grid
  gridRows=int(random(10, 40));
  gridColumns=int(random(10, 40));
  cellWidth=width/gridColumns;
  cellHeight=height/gridRows;
  println("grid:", gridRows, "x", gridColumns, "& cell:", cellWidth, "x", cellHeight);
  drawGrid();
}

void drawGrid() {
  strokeWeight(1);
  stroke(140, 140, 140, 50);
  //columns
  for (int i=0; i<gridColumns; i++) line(cellWidth*i, 0, cellWidth*i, width);
  //rows
  for (int i=0; i<=gridRows; i++) line(0, cellHeight*i, width, cellHeight*i);
}

void displayPaths() {
  strokeWeight(3);
  int cIndex=0;
  for (int i = 0; i < paths.size(); i++) {
    stroke(colors[cIndex]);
    // stroke(255);
    ArrayList<Point> currentPath = paths.get(i);
    beginShape();
   // print("path ", i, ": ");
    for (Point p : currentPath) {

      float x=p.column*cellWidth-cellWidth/2;
      float y=p.row*cellHeight-cellHeight/2;
      float opacityX= map(abs(mouseX-x), 0, width, 0, 255);
      float opacityY= map(abs(mouseY-x), 0, height, 0, 255);
      float o= (opacityX+opacityY)/2;
     // println(colors[cIndex],o);
      stroke(colors[cIndex],o);
      noFill();
      vertex(x, y);
      //  print(" {", p.column, "|", p.row, "},  ");
    }
    Point start=currentPath.get(0);
    //  circle(start.column*cellWidth-cellWidth/2, start.row*cellHeight-cellHeight/2, 10);
    Point end=currentPath.get(currentPath.size()-1);
    // circle(end.column*cellWidth-cellWidth/2, end.row*cellHeight-cellHeight/2, 10);
    endShape();
    println(" ");
    cIndex++;
    if (cIndex== colors.length) cIndex=0;
  }
}


Point findNextPoint(Point startPoint) {    
  int offset= int(random(-pathOffset, pathOffset));
  while (startPoint.column-offset <0 || startPoint.column+offset>gridColumns) {
    offset= int(random(-pathOffset, pathOffset));
  }
  Point singlePoint= new Point(startPoint.column+offset, startPoint.row+1);
  //circle(singlePoint.column*cellWidth-cellWidth/2, singlePoint.row*cellHeight-cellHeight/2, 40);
  return singlePoint;
}

void generatePath(Point startPoint, ArrayList <Point> currentPath) {
  if (startPoint.row==gridRows) {
    //last row - save path
    paths.add(currentPath);
  } else if (startPoint.row<gridRows) {
    int fork=1;
    int minRandom=1;
    if (startPoint.row>4) {
      if (startedPaths >2 && currentPath.size()>=3) minRandom=0;
      fork=int(random(minRandom, maxSplits));
      if (startedPaths >30) fork=0;
    }
    println("Row: ", startPoint.row, "splits in: ", fork, ", startedPaths ", startedPaths);
    // how many splits?
    if (fork==0) {
      // path ends
      paths.add(currentPath);
    } else if (fork==1) {
      //path continous, no splitting
      Point newPoint = findNextPoint(startPoint);
      currentPath.add(newPoint);
      generatePath(newPoint, currentPath);
    } else if (fork>1) {    
      for (int i=0; i<fork; i++) {
        Point newPoint = findNextPoint(startPoint);
        if (i==0) {
          //first fork continue path
          currentPath.add(newPoint);
          generatePath(newPoint, currentPath);
        } else {
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




/* rekursion
 überlapping no problem
 function create path
 
 
 in draw 
 first point
 first path
 cases:
 last row - save path
 not last row - beginning no split -- int split =1
 - no split (1)                    - save new point - call function (continue)
 - multiple splits - first split - save new point  - call function (continue)
 - 2+ splits - new path + new point - call function (new)
 
 
 if (start.row==gridRows){
 //last row- end path
 paths.add(currentPath);
 else if(start.row<gridRows){
 int fork=1;
 if(start.row>3){
 // no splits at first
 int fork= int(random(-1,maxSplits));
 }
 // how many splits?
 if (fork>1){
 for (int i=0; i<fork; i++){
 //first split continue path
 Point newPoint = findNextPoint()
 if(i==0){
 currentPath.add(newPoint);
 generatePath(newPoint, currentPath);
 else{
 //start new path
 Path newPath= new Path (newPoint, newPath);
 }
 }
 }else if (fork==1){
 Point newPoint = findNextPoint();
 currentPath.add(newPoint);
 generatePath(newPoint, currentPath);
 }
 if (fork==0){
 // path ends
 paths.add(currentPath);
 }
 }*/

/*
 function continue path
 gets startpoint with .row, .column AND array of path to add to
 find next point row+1, column +-1
 add to arraylist/ draw
 
 if(this row!=rows-1 // not last row
 if row > 3
 random split 0-3
 if random >1 
 for splits 
 if i==0
 first continue array continue path x
 else
 new path
 continue path (point,path)
 if random ==0
 end path
 this path add 
 
 else uf row <=3 
 continue old path, old array
 
 --
 lst row 
 add path
 
 
 returns complete path
 for adding
 
 
 
 */
















//  Path createSinglePath(ArrayList <Point> toContinue, Point firstPoint) {

//    Path p= new Path (, allPoints);
//    return p;
//  }
