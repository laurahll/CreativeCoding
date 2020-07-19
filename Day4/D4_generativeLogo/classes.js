class Session {
  constructor() {
    this.date = day()+"/"+month()+"/"+year();
    this.workload= [];
  }

  addProject(p) {
    this.workload.push(p);
  }
}


class Project {
  constructor(n, c, d, h, p) {
    this.name=n;
    this.colorFill= color(c);
    this.toDeadline = d;
    this.tasks= [];
    this.totalHours=h;
    this.inProgress=p;
    this.x=random(-80, 80);
    this.y=random(-80, 80);
  }

  addTask(t) {
    this.tasks.push(t);
  }
  setStatus(b) {
    this.inProgress=b;
  }

  display() {
    // if project active, show tasks
    if (this.inProgress==true) {
      for (let i=0; i<this.tasks.length; i++) {
        this.tasks[i].display(this.colorFill.levels);
      }
    } else {
      // if not active show blob
      blendMode(ADD);
      translate(width/2, height/2);
      noStroke();
      fill(this.colorFill.levels);  

      let size= this.totalHours > 200 ? 200 : this.totalHours;      
      let radius= map(size, 0, 200, 10, 45); 
      let firstX=0;
      let firstY=0;

      // iterate through vertex of circle
      let angleStep= 360/8;
      curveTightness(-0.8);
      beginShape();
      //filter( BLUR, 6 );
      for (let angle = 0; angle < 360; angle += angleStep) {
        // calc points on circle
        let circX = this.x + radius*cos(angle);
        let circY = this.y + radius*sin(angle);
        // n displaces originals point diagonally from center by increasing radius
        let n= map(noise(circX, circY), 0, 1, 1, 3);
        let x = this.x + radius*n*cos(angle);
        let y = this.y + radius*n*sin(angle);
        //circle(x, y, 5);
        curveVertex(x, y);
        if (angle==0) {
          // save first point for closing shape
          firstX=x; 
          firstY=y;
        }
      }   
      curveVertex(firstX, firstY);
      endShape();
      resetMatrix();
    }
  }
}



class Task {
  constructor(n, t) {
    this.name=n;
    this.type=t;
    let offSetType= this.type=="creative" ? -50 : 50;
    this.x=random(-25, 25)+offSetType;
    this.y=random(-50, 50);
  }
  display(c) {
    blendMode(BLEND);
    translate(width/2, height/2);
    noStroke();
    fill(c);
    circle(this.x, this.y, 20);
    resetMatrix();
  }
}
