class Terrain {
  int rows, cols;
  int cellS;
  int tWidth, tHeight;  
  float rotation;
  color _color;


  Terrain(int w, int h, int s, color c) {
    tWidth=w;
    tHeight=h;
    cellS=s;
    rows= tWidth/cellS;
    cols =tHeight/cellS;
    _color=c;
  }

  void displayMesh(int startX, int startY, int startZ, color c2) {
    pushMatrix();
    translate(startX, startY, startZ);
    rotateX(PI/3);
     rotateZ(.3);

    strokeWeight(1);
    stroke(_color);
    noFill();

    for (int y=0; y<rows; y++) {
      beginShape(TRIANGLE_STRIP);
      float incr=map(y, 0, rows, 0, 1);
      color blended=lerpColor(_color, c2, incr);
      stroke(blended);
      for (int x=0; x<cols; x++) {
        vertex(x*cellS, y*cellS, 60*noise(x*cellS, y*cellS, frameCount/6));
        vertex(x*cellS, (y+1)*cellS, 60*noise(x*cellS, (y+1)*cellS, frameCount/6));
      }
      endShape();
    }
    popMatrix();
  }
  
  void displayDots(int startX, int startY, int startZ) {
    pushMatrix();
    translate(startX, startY, startZ);
    rotateX(PI/3);
    //rotateZ(PI/3);
    noStroke();
    fill(_color);
    for (int y=0; y<rows; y++) {
      for (int x=0; x<cols; x++) {
        circle(x*cellS, y*cellS, 3);
      }
      endShape();
    }
    popMatrix();
  }
} 

class Grid {
  int rows, cols;
  int cellS;
  int _width, _height;  
  color _color;

  Grid(int w, int h, int size, color c) {
    _width=w;
    _height=h;
    cellS=size;
    _color=c;
    rows= _width/cellS;
    cols =_height/cellS;
  }
  void displayLines(int startX, int startY) {
    pushMatrix();
    translate(startX, startY);
    stroke(_color);
    strokeWeight(2);
    for (int y=0; y<=_width; y+=cellS) line(y, 0, y, _height);
    for (int x=0; x<=_height; x+=cellS) line(0, x, _width, x);
    popMatrix();
  }
  void displayDots(int startX, int startY) {
    pushMatrix();
    translate(startX, startY);
    noStroke();
    fill(_color);
    for (int y=0; y<cols; y++) {
      for (int x=0; x<=rows; x++) {
        circle(x*cellS, y*cellS, 3);
      }
    }
    popMatrix();
  }
}
