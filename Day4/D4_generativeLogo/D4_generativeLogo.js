/*
 *   Creative Coding
 *   Day 4 - Exercise
 *   topic: generative logo design
 *     - come up with a concept
 *     - make use of object-oriented programming
 *     - implement a form of interaction / manipulation in realtime
 *     - use some of folowing techniques: displacement or animation using noise, texturizing the sketch, trail effect, gradients
 *
 *   idea:
 *     - visualize daily workload during covid 19 pandemic
 *     - staying home all day long and working on projects
 *
 *   concept:
 *    - load Data and initialize main object of class Session
 *    - Session has a date and an array of all ongoing projects
 *    - initialize objects of class Project with data and push in Session‘s array
 *    - a Project has a name, color, number of total work hours, a status and an array of tasks
 *    - objects of class Task have a name and type
 *    - inactive projects are randomly placed and can be activated by radio button
 *    - when activated, a projects status changes to Work in Progress and all its single tasks are displayed
 *    - tasks are placed on right or left part of the brain outline depending on their type
 *
 */


let data = {};
let session;
let radioProject;

function preload() {  
  data = loadJSON('data.json');
}

function setup() {
  smooth(8);
  createCanvas(900, 600);
  background(0);

  session = new Session();
  radioProject=createRadio();

  if (data) {
    for (let k=0; k<data.workload.length; k++) {
      radioProject.option(data.workload[k].name);
      let p= new Project(data.workload[k].name, data.workload[k].color, data.workload[k].deadline, data.workload[k].totalHours, false);
      for (let j=0; j<data.workload[k].tasks.length; j++) {
        const t= new Task(data.workload[k].tasks[j].name, data.workload[k].tasks[j].type);
        p.addTask(t);
      }
      session.addProject(p);
    }
  } else {
    alert("no data yet");
  }

  savButton = createButton("Save Image"); 
  savButton.position(5, height+50);
  savButton.mousePressed(saveToFile);
}


function draw() {
  //map backgr to time - ? not visible on white because blendmode
  let timeDay= hour()>10 && hour()<20 ? 0 :0;
  background(timeDay);
  stroke(255);
  noFill();
  if (data) {
    for (let i=0; i<session.workload.length; i++) {
      session.workload[i].display();
    }
    blendMode(BLEND);
    drawBrain();
    checkRadio();
  }
}

function drawBrain() {
  let startX=0;
  let startY=0;
  let scale=12;
  translate(width/2+10, height/2);
  noFill();
  stroke(255);
  strokeWeight(6);
  //right
  curveTightness(0.8);
  beginShape();
  curveVertex(0, 0);
  curveVertex(0*scale, 7*scale);
  curveVertex(3*scale, 8*scale);
  curveVertex(6*scale, 6*scale);
  curveVertex(8*scale, 0*scale);
  curveVertex(6*scale, (-6)*scale);
  curveVertex(3*scale, (-8)*scale);
  curveVertex(0*scale, (-7)*scale);
  endShape(CLOSE);
  //left
  translate(-10, 0);
  scale=scale*(-1);
  beginShape();
  curveVertex(0, 0);
  curveVertex(0*scale, 7*scale);
  curveVertex(3*scale, 8*scale);
  curveVertex(6*scale, 6*scale);
  curveVertex(8*scale, 0*scale);
  curveVertex(6*scale, (-6)*scale);
  curveVertex(3*scale, (-8)*scale);
  curveVertex(0*scale, (-7)*scale);
  endShape(CLOSE);
  resetMatrix();
}

function keyPressed() {
  if (key === " ") {
    alert("sapce");
  } else if (key==="s") {
    saveToFile();
  }
}


function checkRadio() {
  const index = session.workload.findIndex(project => project.name == radioProject.value());
  //alert(index);
  if (index==-1) {
    return;
  } else if (session.workload[index].inProgress==true) {
    return;
  } else {
    session.workload.forEach(project => project.inProgress=false);
    session.workload[index].inProgress=true;
    //console.log(session.workload);
  }
}


function saveToFile() { 
  // Save the current canvas to file as png 
  saveCanvas("canvas", 'png');
} 
