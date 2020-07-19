/*
 * D3 Creative Coding
 * Displacement & Animation by Noise
 */

import processing.pdf.*;
import controlP5.*;
ControlP5 cp5;


///// Set Vars
int minRadius=30;
color startColor=color(255, 70, 171); // pink
color endColor= color(12, 255, 246); // neon turquoise
color background=color(14, 16, 17);

///// Adjustable Vars
int circleCount=12;
int circlePoints=50;
int circleSpacing=10;
float vertexCurve=0.9;

float maxNoise=5; // max warping of points
float maxDisplacement=6;  //  max displacement of points from orginal position on circle
float noiseFalloff=0.1;

float zSpeed=0.003; // default speed through 3d noise
float baseSpeed=0.002;

///// Incrementing Vars   !dont change
float noiseAngle=0; // change displacement of points by rotating in 2D noise
float circleAngle=0; // rotates points on circle
float noiseZ=0; // move in noise depth

boolean recording=false;
boolean recordVec=false;

void setup() {
  circleCount=int(random(5, 20));
  size(1000, 800);
  background(0);
  noiseSeed(int(random(0, 500)));

  cp5 = new ControlP5(this);
  createGUI();
}

void draw() {
  // set vars from gui
  noiseDetail(5, noiseFalloff);
  curveTightness(vertexCurve);
  if (recordVec)   beginRecord(PDF, "output_vector/frame-####.pdf"); 

  // new blank canvas
  fill(background);
  noStroke();
  rect(0, 0, width, height);

  drawCircle();
  //drawNoise();
  noiseAngle+=baseSpeed*1.8;
  circleAngle+=baseSpeed;
  noiseZ+=zSpeed; 

  if (recordVec) {
    endRecord();
    recordVec = false;
  }
  if (recording && frameCount%4==0) saveFrame("output_sequence/frame_"+frameCount+".jpg");
}

void drawCircle() {
  noFill();
  strokeWeight(3);
  for (int i=0; i<circleCount; i++) {
    float firstX=0;
    float firstY=0;

    // create gradient by mapping color to no of circles
    float incr=map(i, 0, circleCount, 0, 1);
    color blended=lerpColor(startColor, endColor, incr);
    float opacNoise=map(cos(radians(50)), -1, 1, 0, 5);
    float opacLine=map(noise(4, 1^i/2), 0, .5, 0, 255);
    stroke(blended, opacLine+10);
    // stroke(blended, 255);

    beginShape();
    // iterate through vertex of circle
    for (int j=0; j<circlePoints+3; j++) {
      float angle=radians(360/circlePoints*(j+1));

      float noiseX= map(cos(angle+noiseAngle), -1, 1, 0, maxNoise);
      float noiseY=map(sin(angle+noiseAngle), -1, 1, 0, maxNoise);
      
      float n= map(noise(noiseX, noiseY, noiseZ), 0, 1, 1, maxDisplacement);

      float x= width/2 + (circleSpacing*i)*n*cos(angle+circleAngle); 
      float y= height/2 + (circleSpacing*i)*n*sin(angle+circleAngle); 
      curveVertex(x, y);

      if (j==0) {
        // save first point for closing shape
        firstX=x; 
        firstY=y;
      }
    }
    curveVertex(firstX, firstY);
    endShape(CLOSE);
  }
}



void keyPressed() {
  if (key == 's' || key == 'S') noLoop();
  else if (key == 'c' || key == 'C') {
    loop(); 
    recording=false;
  } else if (key == 'r' || key == 'R') recording = recording ? false:true;
  else if (key == 'f' || key == 'F')    saveFrame("output_frames/frame_"+frameCount+".jpg");
  else if (key == 'v' || key == 'V')    recordVec=true;
}

void drawNoise() {
  float increment = 0.02;
  loadPixels();
  float xoff = 0.0; 

  for (int x = 0; x < width; x++) {
    xoff += increment;   // Increment xoff 
    float yoff = 0.0;   // For every xoff, start yoff at 0
    for (int y = 0; y < height; y++) {
      yoff += increment; // Increment yoff
      // Calculate noise and scale by 255
      float bright = noise(xoff, yoff) * 255;
      // Set each pixel onscreen to a grayscale value
      pixels[x+y*width] = color(bright);
    }
  }
  updatePixels();
}

void toogleGUI() {
  // cp5.getController("slider").hide();
}


void createGUI() {
  int sliderCount=0;
  int sliderMargin=10;
  ///// SLIDERS
  int sliderHeight=15;
  int sliderWidth=100;
  int sliderX=width-sliderWidth-sliderMargin;
  color sliderColorBg = color(130);
  color varLabel=color(40);
  // Circle Sliders
  color sliderColor = color(200);
  color sliderHover = color(220);
  // Noise Sliders
  color sliderColor2 = color(139, 190, 215);
  color sliderHover2 = color(168, 203, 237);

  color sliderColor3 = color(144, 178, 158);
  color sliderHover3 = color(199, 234, 213);

  color sliderColor4 = color(244, 199, 210);
  color sliderHover4 = color(193, 164, 177);

  textAlign(RIGHT);
  cp5.addTextlabel("title")
    .setText("Keyboard Controls")
    .setPosition(10, 10)
    .setColorLabel(244)
    .setFont(createFont("Lucida Console", 16))
    ;

  cp5.addTextlabel("controls")
    .setText("s to stop\nc to continue\nr to toggle recording\nf to save frame\nv to save vector")
    .setPosition(10, 30)
    .setValue(0)
    .setFont(createFont("Consolas", 13))
    ;

  /// CIRCLES
  cp5.addSlider("circleCount")
    .setPosition(sliderX, sliderMargin)
    .setSize(sliderWidth, sliderHeight)
    .setRange(4, 15)
    .setDefaultValue(12)
    .setLabel("Circles")
    .setColorForeground(10) 
    .setColorActive(10)
    .setColorBackground(sliderColorBg)
    .setColorForeground(sliderColor)
    .setColorActive(sliderHover)
    .setColorValueLabel(varLabel) 
    .setDecimalPrecision(1)
    .align(ControlP5.LEFT, ControlP5.CENTER, 10, 10)
    ;

  sliderCount++;
  cp5.addSlider("circlePoints")
    .setPosition(sliderX, sliderHeight*sliderCount+sliderMargin*2)
    .setSize(sliderWidth, sliderHeight)
    .setRange(20, 90)
    .setDefaultValue(50)
    .setLabel("Points on Circle")
    .setColorBackground(sliderColorBg)
    .setColorForeground(sliderColor)
    .setColorActive(sliderHover)
    .setColorValueLabel(varLabel) 
    .setNumberOfTickMarks(15)
    .showTickMarks(false)
    .setDecimalPrecision(0)
    .align(ControlP5.LEFT, ControlP5.CENTER, 10, 10)
    ;

  sliderCount++;
  cp5.addSlider("circleSpacing")
    .setPosition(sliderX, sliderHeight*sliderCount+sliderMargin*(sliderCount+1))
    .setSize(sliderWidth, sliderHeight)
    .setRange(4, 50)
    .setDefaultValue(10)
    .setLabel("Spacing")
    .setColorBackground(sliderColorBg)
    .setColorForeground(sliderColor)
    .setColorActive(sliderHover)
    .setColorValueLabel(varLabel) 
    .setDecimalPrecision(0)
    .align(ControlP5.LEFT, ControlP5.CENTER, 10, 10)
    ;

  sliderCount++;
  cp5.addSlider("vertexCurve")
    .setPosition(sliderX, sliderHeight*sliderCount+sliderMargin*(sliderCount+1))
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 1)
    .setDefaultValue(0.9)
    .setLabel("Circle Smoothness")
    .setColorBackground(sliderColorBg)
    .setColorForeground(sliderColor)
    .setColorValueLabel(varLabel) 
    .setColorActive(sliderHover)
    .setDecimalPrecision(2)
    .align(ControlP5.TOP, ControlP5.TOP, 10, ControlP5.LEFT)
    ;

  sliderCount++;
  /// NOISE
  cp5.addSlider("maxNoise")
    .setPosition(sliderX, sliderHeight*sliderCount+sliderMargin*(sliderCount+2))
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 7)
    .setDefaultValue(5)
    .setLabel("Max Noise")
    .setColorValueLabel(varLabel) 
    .setColorBackground(sliderColorBg)
    .setColorForeground(sliderColor2)
    .setColorActive(sliderHover2)
    .setDecimalPrecision(0)
    .align(ControlP5.LEFT, ControlP5.CENTER, 10, 10)
    ;

  sliderCount++;
  cp5.addSlider("maxDisplacement")
    .setPosition(sliderX, sliderHeight*sliderCount+sliderMargin*(sliderCount+2))
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 9)
    .setDefaultValue(6)
    .setLabel("Max Displacem of Points")
    .setColorValueLabel(varLabel) 
    .setColorBackground(sliderColorBg)
    .setColorForeground(sliderColor2)
    .setColorActive(sliderHover2)
    .setDecimalPrecision(0)
    .align(ControlP5.LEFT, ControlP5.CENTER, 10, 10)
    ;

  sliderCount++;
  cp5.addSlider("noiseFalloff")
    .setPosition(sliderX, sliderHeight*sliderCount+sliderMargin*(sliderCount+2))
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, .9)
    .setDefaultValue(0.1)
    .setLabel("Noise Falloff")
    .setColorValueLabel(varLabel) 
    .setColorBackground(sliderColorBg)
    .setColorForeground(sliderColor2)
    .setColorActive(sliderHover2)
    .setDecimalPrecision(1)
    .align(ControlP5.LEFT, ControlP5.CENTER, 10, 10)
    ;

  sliderCount++;
  cp5.addSlider("zSpeed")
    .setPosition(sliderX, sliderHeight*sliderCount+sliderMargin*(sliderCount+2))
    .setSize(sliderWidth, sliderHeight)
    .setRange(0.000, 0.009)
    .setDefaultValue(0.001)
    .setLabel("Z-Depth Speed")
    .setColorValueLabel(varLabel) 
    .setColorBackground(sliderColorBg)
    .setColorForeground(sliderColor3)
    .setColorActive(sliderHover3)
    .setDecimalPrecision(3)
    .align(ControlP5.LEFT, ControlP5.CENTER, 10, 10)
    ;

  sliderCount++;
  cp5.addSlider("baseSpeed")
    .setPosition(sliderX, sliderHeight*sliderCount+sliderMargin*(sliderCount+2))
    .setSize(sliderWidth, sliderHeight)
    .setRange(0.002, 0.007)
    .setDefaultValue(0.001)
    .setLabel("Speed")
    .setColorValueLabel(varLabel) 
    .setColorBackground(sliderColorBg)
    .setColorForeground(sliderColor3)
    .setColorActive(sliderHover3)
    .setDecimalPrecision(5)
    .setNumberOfTickMarks(5)
    .showTickMarks(false)
    .align(ControlP5.LEFT, ControlP5.CENTER, 10, 10)
    ;
}
