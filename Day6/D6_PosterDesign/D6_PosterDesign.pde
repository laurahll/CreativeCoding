/*
 *  Creative Coding
 *  Day 6 - Poster Design
 *
 *  Idea:
 *  - Mix of Neon Wave, Landscapes
 *  - originally supposed to be inspired by Memphis Design
 *  
 *  Concept:
 *  - geometric terrain as lower base element with animation through noise
 *  - additive color blending
 *  - radio buttons for changing preset color themes
 *  - main form class and specific classes like circle, triangle and grids inhereit attributes such as position, color
 *  - ability to drag forms around
 *
 *
 *
 *   BUG - cant export as PDF because of P3D -> elements split into multiple pdfs
 */

import controlP5.*;
import processing.pdf.*;
import controlP5.*;
ControlP5 cp5;

boolean recordVec=false;
int posterWidth=600;

color red=color(242, 56, 39); 
color lila= color(124, 6, 242); 
color pink=color(241, 37, 203);
color blue=color(19, 138, 242);
PFont MontserratBlack;
Terrain t1;
Grid g1;
Grid g2;

void settings() {
  size(posterWidth, int(posterWidth*1.414), P3D);
}


void setup() {
  background(0);
  MontserratBlack = createFont("Montserrat-Black.ttf", 128);
  textFont(MontserratBlack);
}


void draw() {
  if (recordVec)       beginRaw(PDF, "output_vector/frame-####.pdf"); 
  background(0);
  blendMode(BLEND);
  fill(blue,100);
  rect(400, 00, width, 100);
  fill(255);
  blendMode(BLEND);
  textFont(MontserratBlack);
  textSize(128);
  float textHeight=map(mouseY, 0, height, 250, 350);
  text("Wave  ", width/2, textHeight);  
  fill(pink);
  text(" Landscapes ", width/2-100, textHeight+50);  
  fill(255);
  text(" Neon ", width/2-100, textHeight+80);

  g1= new Grid(width, int(height/1.5), 10, color(255, 255, 255, 10));
  g1.displayLines(50, 0);
  // g1.displayDots(100, 100);
  t1= new Terrain (400, 650, 25, blue);
  t1.displayMesh(width/2-250, height/2, 100, pink);

  g2= new Grid(200, 250, 15, blue);
  g2.displayDots(00, 50);

  blendMode(MULTIPLY);
  fill(pink);
  noStroke();
  circle(mouseY, mouseX, 100);

  fill(pink, 100);
  blendMode(SCREEN);
  circle(mouseX, mouseY, 200);

  if (recordVec) {
      endRaw();
    recordVec = false;
  }
}


void keyPressed() {
  if (key == 'f' || key == 'F') saveFrame("output_frames/frame_"+frameCount+".jpg");
  else if (key == 'v' || key == 'V')  recordVec=true;
}
