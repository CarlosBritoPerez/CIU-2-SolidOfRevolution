import gifAnimation.*;

Figure figure;
PShape shape;
ArrayList<PVector> points;
int strips;

int indexPalette;


String state = "MENU";

GifMaker gif;
int gifCount = 0;



void setup(){
  size(1200,800,P3D);
  strips = 10;
  points = new ArrayList<PVector>();
  figure = null;
  
  frameRate(70);
  state = "MENU";
  //gif = new GifMaker(this, ".gif");
  //gif.setRepeat(0);
  
}

void gif(){ //May add a gif to the readme
  if(gifCount % 5 == 0 ){
    gif.addFrame();    
  }
  if(gifCount > 1000){
     gif.finish(); 
  }
  gifCount++;
}

void draw(){
  switch(state){
    case "MENU":
      menu();
      break;
    case "GAME":
      game();
      break;
    case "VISUAL":
      visual();
      break;
  }
  //gif();
}

void menu(){
  background(0);
  textSize(60);
  text("SOLID OF REVOLUTION DESIGNER", width/2-500, height/2-100);
  textSize(50);
  text("Press ENTER to start", width/2-250, height/2+300);
}

void game(){
  background(0);  
  stroke(255);
  textSize(31);
  text("- PRESS ENTER to transform", 50, height-200);
  text("- CLICK to ADD a point", 50, height-150);
  text("- PRESS C to clean all", 50, height-100);
  text("- PRESS D to remove the last point", 50, height-50);
  
  stroke(200,0,0);
  line(width/2,0,width/2,height);
  points();
}

void visual(){
  background(0);
  shape.translate(width/2, height/2);
  shape(shape);
  shape.translate(-width/2, -height/2);
  stroke(255);
  textSize(31);
  text("- PRESS ENTER to restart", 50, height-150);
  text("- DRAG to move", 50, height-100);
  text("- Use the WHEEL to zoom", 50, height-50);
}

void keyReleased(){
  switch(state){
    case "MENU":
      keyMenu();
      break;
    case "GAME":
      keyGame();
      break;
    case "VISUAL":
      keyVisual();
      break;
  }
}

void mouseClicked(){
  switch(state){
    case "MENU":
      break;
    case "GAME":
      clickGame();
      break;
    case "VISUAL":
      break; 
  }
}

void mouseDragged(){
  switch(state){
    case "MENU":
      break;
    case "GAME":
      break;
    case "VISUAL": 
      dragVisual();
      break; 
  }
}

void mouseWheel(MouseEvent event){
  switch(state){
    case "MENU":
      break;
    case "GAME":
      break;
    case "VISUAL": 
      wheelVisual(event);
      break; 
  }
}

void keyMenu(){
  if (key == ENTER){
   state = "GAME";
  }
}

void keyGame(){
  switch(key){
    case ENTER:
      if (3 <= points.size()){
        figure = new Figure(points, new PVector(width/2, height/2, 0) , strips);
        startShape();
        state = "VISUAL";
      }
      break;
    case 'd':
    case 'D':
      if (1 <= points.size()){
        points.remove(points.size()-1);
        break;
      }
    case 'c':
    case 'C':
      points = new ArrayList<PVector>();
      break;
  }
}

void keyVisual(){
  switch(key){
    case ENTER:
      points = new ArrayList<PVector>();
      state = "GAME";
      break;
  } 
}

void clickGame(){
  if (mouseButton == LEFT){
    float x = mouseX;
    if (mouseX < width/2){
      x = width/2;
    }
    points.add(new PVector(x, mouseY));
  }
}

void dragVisual(){
  float v = 0.5;
  float addX = (mouseX - pmouseX)*v;
  float addY = (mouseY - pmouseY)*v*(-1);
  shape.rotateY(radians(addX));
  shape.rotateX(radians(addY));
}

void wheelVisual(MouseEvent wheel){
  float size = 1;
  if (wheel.getCount() < 0){
    size = size + 0.05;
  }else if (0 < wheel.getCount()){
    size = size - 0.05;
  }
  shape.scale(size, size, size);
}

void points(){
  stroke(200,0,0);
  fill(255);
  if (1 <= points.size()){
    PVector previousPoint = points.get(0);
    for (PVector nextPoint : points){
      line(previousPoint.x, previousPoint.y, nextPoint.x, nextPoint.y);
      circle(previousPoint.x, previousPoint.y, 5);
      previousPoint = nextPoint;
    }
    circle(previousPoint.x, previousPoint.y, 5);
  }
}

void startShape(){
  shape = createShape();
  shape.beginShape(TRIANGLE_STRIP);
  shape.fill(255);
  shape.stroke(200,0,0);
  shape.strokeWeight(2);
  ArrayList<PVector> previousLine = figure.meridians.get(0);
  ArrayList<PVector> currentLine;
  for (int i = 1; i < figure.meridians.size(); i++){
    currentLine = figure.meridians.get(i);
    for (int j = 0; j < previousLine.size(); j++){
      shape.vertex(previousLine.get(j).x,previousLine.get(j).y,previousLine.get(j).z);
      shape.vertex(currentLine.get(j).x,currentLine.get(j).y,currentLine.get(j).z);
    }
    shape.vertex(previousLine.get(0).x,previousLine.get(0).y,previousLine.get(0).z);
    shape.vertex(currentLine.get(0).x,currentLine.get(0).y,currentLine.get(0).z);
    
    previousLine = currentLine;
  }
  shape.endShape();
}
